<?php
// app/Controllers/Admin.php
namespace App\Controllers;

class Admin extends BaseController
{
    // ── GET /admin/users ─────────────────────────────────────
    public function users()
    {
        $this->requirePermission('all');

        $users = $this->db->table('users u')
            ->select('u.*, r.name as role_name')
            ->join('roles r', 'r.id = u.role_id')
            ->orderBy('u.created_at', 'DESC')
            ->get()->getResultArray();

        return $this->render('admin/users', [
            'pageTitle' => 'Users & Roles',
            'users'     => $users,
        ]);
    }

    // ── GET /admin/users/create ──────────────────────────────
    public function createUser()
    {
        $this->requirePermission('all');

        return $this->render('admin/user_form', [
            'pageTitle' => 'Create User',
            'roles'     => $this->db->table('roles')->get()->getResultArray(),
            'districts' => $this->db->table('districts')->where('is_active', 1)->orderBy('name')->get()->getResultArray(),
            'user'      => null,
            'assigned'  => [],
        ]);
    }

    // ── POST /admin/users/store ──────────────────────────────
    public function storeUser()
    {
        $this->requirePermission('all');

        $rules = [
            'full_name' => 'required|min_length[2]',
            'email'     => 'required|valid_email|is_unique[users.email]',
            'password'  => 'required|min_length[8]',
            'role_id'   => 'required|is_natural_no_zero',
        ];

        if (!$this->validate($rules)) {
            return redirect()->back()->with('errors', $this->validator->getErrors())->withInput();
        }

        $userId = $this->db->table('users')->insert([
            'full_name'     => $this->request->getPost('full_name'),
            'email'         => $this->request->getPost('email'),
            'phone'         => $this->request->getPost('phone'),
            'password_hash' => password_hash($this->request->getPost('password'), PASSWORD_BCRYPT),
            'role_id'       => $this->request->getPost('role_id'),
            'is_active'     => 1,
            'created_at'    => date('Y-m-d H:i:s'),
        ]);

        $userId = $this->db->insertID();
        $this->syncDistricts($userId, $this->request->getPost('district_ids') ?? []);

        $this->audit('CREATE', 'users', $userId);
        return redirect()->to('/admin/users')->with('success', 'User created successfully.');
    }

    // ── GET /admin/users/edit/:id ────────────────────────────
    public function editUser(int $id)
    {
        $this->requirePermission('all');

        $user = $this->db->table('users')->where('id', $id)->get()->getRowArray();
        if (!$user) return redirect()->to('/admin/users')->with('error', 'User not found.');

        $assigned = $this->db->table('user_districts')
            ->select('district_id')
            ->where('user_id', $id)
            ->get()->getResultArray();

        return $this->render('admin/user_form', [
            'pageTitle' => 'Edit User',
            'roles'     => $this->db->table('roles')->get()->getResultArray(),
            'districts' => $this->db->table('districts')->where('is_active', 1)->orderBy('name')->get()->getResultArray(),
            'user'      => $user,
            'assigned'  => array_column($assigned, 'district_id'),
        ]);
    }

    // ── POST /admin/users/update/:id ─────────────────────────
    public function updateUser(int $id)
    {
        $this->requirePermission('all');

        $rules = [
            'full_name' => 'required|min_length[2]',
            'email'     => "required|valid_email|is_unique[users.email,id,{$id}]",
            'role_id'   => 'required|is_natural_no_zero',
        ];

        if (!$this->validate($rules)) {
            return redirect()->back()->with('errors', $this->validator->getErrors())->withInput();
        }

        $data = [
            'full_name'  => $this->request->getPost('full_name'),
            'email'      => $this->request->getPost('email'),
            'phone'      => $this->request->getPost('phone'),
            'role_id'    => $this->request->getPost('role_id'),
            'updated_at' => date('Y-m-d H:i:s'),
        ];

        if ($pw = $this->request->getPost('password')) {
            $data['password_hash'] = password_hash($pw, PASSWORD_BCRYPT);
        }

        $this->db->table('users')->where('id', $id)->update($data);
        $this->syncDistricts($id, $this->request->getPost('district_ids') ?? []);

        // Invalidate district cache if editing self
        if ($id === (int) session('user_id')) {
            session()->remove('allowed_district_ids');
        }

        $this->audit('UPDATE', 'users', $id);
        return redirect()->to('/admin/users')->with('success', 'User updated successfully.');
    }

    // ── POST /admin/users/toggle/:id ─────────────────────────
    public function toggleUser(int $id)
    {
        $this->requirePermission('all');

        $user = $this->db->table('users')->where('id', $id)->get()->getRowArray();
        if (!$user) return redirect()->back()->with('error', 'User not found.');

        $this->db->table('users')->where('id', $id)->update(['is_active' => !$user['is_active']]);
        $this->audit('TOGGLE', 'users', $id);

        return redirect()->to('/admin/users')
            ->with('success', 'User ' . ($user['is_active'] ? 'deactivated' : 'activated') . '.');
    }

    // ── GET /admin/audit-log ─────────────────────────────────
    public function auditLog()
    {
        $this->requirePermission('all');

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
            if ((int) $did > 0) {
                $rows[] = ['user_id' => $userId, 'district_id' => (int) $did, 'created_at' => date('Y-m-d H:i:s')];
            }
        }

        if ($rows) $this->db->table('user_districts')->insertBatch($rows);
    }
}
