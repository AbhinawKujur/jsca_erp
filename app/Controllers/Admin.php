<?php
// app/Controllers/Admin.php
namespace App\Controllers;

class Admin extends BaseController
{
    // ── GET /admin/users ─────────────────────────────────────
    private function requireAdmin(): void
    {
        $role = $this->currentUser['role_name'] ?? '';
        if (!in_array($role, ['superadmin', 'admin'])) {
            throw \CodeIgniter\Exceptions\PageNotFoundException::forPageNotFound();
        }
    }

    public function users()
    {
        $this->requireAdmin();

        $users = $this->db->table('users u')
            ->select('u.*, r.name as role_name')
            ->join('roles r', 'r.id = u.role_id')
            ->orderBy('u.created_at', 'DESC')
            ->get()->getResultArray();

        return $this->render('admin/users', [
            'pageTitle' => 'Users & Access — JSCA ERP',
            'users'     => $users,
        ]);
    }

    // ── GET /admin/users/create ──────────────────────────────
    public function createUser()
    {
        $this->requireAdmin();

        $isSuperadmin = ($this->currentUser['role_name'] ?? '') === 'superadmin';
        $rolesQuery   = $this->db->table('roles');
        if (!$isSuperadmin) $rolesQuery->where('name !=', 'superadmin');
        $roles = $rolesQuery->orderBy('name')->get()->getResultArray();

        return $this->render('admin/user_form', [
            'pageTitle'   => 'Create User — JSCA ERP',
            'roles'       => $roles,
            'rolePermsMap'=> $this->buildRolePermsMap($roles),
            'districts'   => $this->db->table('districts')->where('is_active', 1)->orderBy('name')->get()->getResultArray(),
            'user'        => null,
            'assigned'    => [],
            'userPerms'   => [],
        ]);
    }

    // ── POST /admin/users/store ──────────────────────────────
    public function storeUser()
    {
        $this->requireAdmin();

        $rules = [
            'full_name' => 'required|min_length[2]',
            'email'     => 'required|valid_email|is_unique[users.email]',
            'password'  => 'required|min_length[8]',
            'role_id'   => 'required|is_natural_no_zero',
        ];

        if (!$this->validate($rules)) {
            return redirect()->back()->with('errors', $this->validator->getErrors())->withInput();
        }

        // custom_permissions = only the extras beyond role defaults
        $customPerms = $this->extractCustomPerms(
            (int) $this->request->getPost('role_id'),
            $this->request->getPost('permissions') ?? []
        );

        $this->db->table('users')->insert([
            'full_name'          => $this->request->getPost('full_name'),
            'email'              => $this->request->getPost('email'),
            'phone'              => $this->request->getPost('phone'),
            'password_hash'      => password_hash($this->request->getPost('password'), PASSWORD_BCRYPT),
            'role_id'            => $this->request->getPost('role_id'),
            'custom_permissions' => empty($customPerms) ? null : json_encode(array_values($customPerms)),
            'is_active'          => 1,
            'created_at'         => date('Y-m-d H:i:s'),
        ]);

        $userId = $this->db->insertID();
        $this->syncDistricts($userId, $this->request->getPost('district_ids') ?? []);

        $this->audit('CREATE', 'users', $userId);
        return redirect()->to('/admin/users')->with('success', 'User created successfully.');
    }

    // ── GET /admin/users/edit/:id ────────────────────────────
    public function editUser(int $id)
    {
        $this->requireAdmin();

        $user = $this->db->table('users')->where('id', $id)->get()->getRowArray();
        if (!$user) return redirect()->to('/admin/users')->with('error', 'User not found.');

        $isSuperadmin = ($this->currentUser['role_name'] ?? '') === 'superadmin';
        $rolesQuery   = $this->db->table('roles');
        if (!$isSuperadmin) $rolesQuery->where('name !=', 'superadmin');
        $roles = $rolesQuery->orderBy('name')->get()->getResultArray();

        $assigned = $this->db->table('user_districts')
            ->select('district_id')
            ->where('user_id', $id)
            ->get()->getResultArray();

        // Effective permissions = role defaults + custom
        $rolePerms   = $this->getRolePerms((int) $user['role_id']);
        $customPerms = json_decode($user['custom_permissions'] ?? '[]', true) ?? [];
        $userPerms   = array_values(array_unique(array_merge($rolePerms, $customPerms)));

        return $this->render('admin/user_form', [
            'pageTitle'   => 'Edit User — JSCA ERP',
            'roles'       => $roles,
            'rolePermsMap'=> $this->buildRolePermsMap($roles),
            'districts'   => $this->db->table('districts')->where('is_active', 1)->orderBy('name')->get()->getResultArray(),
            'user'        => $user,
            'assigned'    => array_column($assigned, 'district_id'),
            'userPerms'   => $userPerms,
        ]);
    }

    // ── POST /admin/users/update/:id ─────────────────────────
    public function updateUser(int $id)
    {
        $this->requireAdmin();

        $rules = [
            'full_name' => 'required|min_length[2]',
            'email'     => "required|valid_email|is_unique[users.email,id,{$id}]",
            'role_id'   => 'required|is_natural_no_zero',
        ];

        if (!$this->validate($rules)) {
            return redirect()->back()->with('errors', $this->validator->getErrors())->withInput();
        }

        $customPerms = $this->extractCustomPerms(
            (int) $this->request->getPost('role_id'),
            $this->request->getPost('permissions') ?? []
        );

        $data = [
            'full_name'          => $this->request->getPost('full_name'),
            'email'              => $this->request->getPost('email'),
            'phone'              => $this->request->getPost('phone'),
            'role_id'            => $this->request->getPost('role_id'),
            'custom_permissions' => empty($customPerms) ? null : json_encode(array_values($customPerms)),
            'updated_at'         => date('Y-m-d H:i:s'),
        ];

        if ($pw = $this->request->getPost('password')) {
            $data['password_hash'] = password_hash($pw, PASSWORD_BCRYPT);
        }

        $this->db->table('users')->where('id', $id)->update($data);
        $this->syncDistricts($id, $this->request->getPost('district_ids') ?? []);

        if ($id === (int) session('user_id')) {
            session()->remove('allowed_district_ids');
        }

        $this->audit('UPDATE', 'users', $id);
        return redirect()->to('/admin/users')->with('success', 'User updated successfully.');
    }

    // ── POST /admin/users/toggle/:id ─────────────────────────
    public function toggleUser(int $id)
    {
        $this->requireAdmin();

        // Prevent deactivating yourself or another superadmin
        $user = $this->db->table('users u')->select('u.*, r.name as role_name')->join('roles r','r.id=u.role_id')->where('u.id', $id)->get()->getRowArray();
        if (!$user) return redirect()->back()->with('error', 'User not found.');
        if ($user['role_name'] === 'superadmin') return redirect()->back()->with('error', 'Cannot deactivate a superadmin account.');

        $this->db->table('users')->where('id', $id)->update(['is_active' => !$user['is_active']]);
        $this->audit('TOGGLE', 'users', $id);

        return redirect()->to('/admin/users')
            ->with('success', 'User ' . ($user['is_active'] ? 'deactivated' : 'activated') . '.');
    }

    // ── GET /admin/audit-log ─────────────────────────────────
    public function auditLog()
    {
        $this->requireAdmin();

        $logs = $this->db->table('audit_logs a')
            ->select('a.*, u.full_name')
            ->join('users u', 'u.id = a.user_id', 'left')
            ->orderBy('a.created_at', 'DESC')
            ->limit(500)
            ->get()->getResultArray();

        return $this->render('admin/audit_log', [
            'pageTitle' => 'Audit Log',
            'logs'      => $logs,
        ]);
    }

    // ── Private: sync user_districts ────────────────────────
    private function syncDistricts(int $userId, array $districtIds): void
    {
        $this->db->table('user_districts')->where('user_id', $userId)->delete();
        if (empty($districtIds)) return;
        $rows = [];
        foreach ($districtIds as $did) {
            if ((int) $did > 0)
                $rows[] = ['user_id' => $userId, 'district_id' => (int) $did, 'created_at' => date('Y-m-d H:i:s')];
        }
        if ($rows) $this->db->table('user_districts')->insertBatch($rows);
    }

    // ── Private: get role permissions array by role_id ───────
    private function getRolePerms(int $roleId): array
    {
        $role = $this->db->table('roles')->where('id', $roleId)->get()->getRowArray();
        return json_decode($role['permissions'] ?? '[]', true) ?? [];
    }

    // ── Private: build {roleId: [perms]} map for JS ──────────
    private function buildRolePermsMap(array $roles): array
    {
        $map = [];
        foreach ($roles as $r) {
            $map[$r['id']] = json_decode($r['permissions'] ?? '[]', true) ?? [];
        }
        return $map;
    }

    // ── Private: extract only extras beyond role defaults ────
    private function extractCustomPerms(int $roleId, array $submitted): array
    {
        $roleDefaults = $this->getRolePerms($roleId);
        if (in_array('all', $roleDefaults)) return []; // superadmin needs no extras
        return array_values(array_diff($submitted, $roleDefaults));
    }
}
