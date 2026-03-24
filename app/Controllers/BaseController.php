<?php
// app/Controllers/BaseController.php
namespace App\Controllers;

use CodeIgniter\Controller;
use CodeIgniter\HTTP\CLIRequest;
use CodeIgniter\HTTP\IncomingRequest;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use Psr\Log\LoggerInterface;

abstract class BaseController extends Controller
{
    protected $request;
    protected $helpers = ['url', 'form', 'text', 'date'];
    protected $db;
    protected $session;
    protected $currentUser;

    public function initController(
        RequestInterface $request,
        ResponseInterface $response,
        LoggerInterface $logger
    ) {
        parent::initController($request, $response, $logger);

        $this->db      = \Config\Database::connect();
        $this->session = \Config\Services::session();

        // Load current user into every controller
        if ($this->session->get('user_id')) {
            $this->currentUser = $this->db->table('users u')
                ->select('u.*, r.name as role_name, r.permissions')
                ->join('roles r', 'r.id = u.role_id')
                ->where('u.id', $this->session->get('user_id'))
                ->get()->getRowArray();

            if ($this->currentUser) {
                $this->currentUser['permissions'] = json_decode($this->currentUser['permissions'], true);
            }
        }
    }

    // ── District access helpers ───────────────────────────────

    /**
     * Returns array of district IDs the current user can access.
     * superadmin gets ALL districts. Others get only assigned ones.
     */
    protected function getAllowedDistrictIds(): array
    {
        if (!$this->currentUser) return [];

        // superadmin sees everything
        if (($this->currentUser['role_name'] ?? '') === 'superadmin') {
            return $this->db->table('districts')
                ->select('id')->where('is_active', 1)
                ->get()->getResultArray();
            // return flat array of ids
        }

        // Use session cache to avoid repeated queries
        $cached = $this->session->get('allowed_district_ids');
        if ($cached !== null) return $cached;

        $rows = $this->db->table('user_districts')
            ->select('district_id')
            ->where('user_id', $this->currentUser['id'])
            ->get()->getResultArray();

        $ids = array_column($rows, 'district_id');
        $this->session->set('allowed_district_ids', $ids);
        return $ids;
    }

    /**
     * Flat array of district IDs (ints). superadmin = all.
     */
    protected function getAllowedDistrictIdsFlat(): array
    {
        if (!$this->currentUser) return [];

        if (($this->currentUser['role_name'] ?? '') === 'superadmin') {
            $rows = $this->db->table('districts')
                ->select('id')->where('is_active', 1)
                ->get()->getResultArray();
            return array_column($rows, 'id');
        }

        $cached = $this->session->get('allowed_district_ids');
        if ($cached !== null) return $cached;

        $rows = $this->db->table('user_districts')
            ->select('district_id')
            ->where('user_id', $this->currentUser['id'])
            ->get()->getResultArray();

        $ids = array_column($rows, 'district_id');
        $this->session->set('allowed_district_ids', $ids);
        return $ids;
    }

    /**
     * Check if current user can access a specific district.
     */
    protected function canAccessDistrict(int $districtId): bool
    {
        if (!$this->currentUser) return false;
        if (($this->currentUser['role_name'] ?? '') === 'superadmin') return true;
        return in_array($districtId, $this->getAllowedDistrictIdsFlat());
    }

    // ── Render view with layout ──────────────────────────────
    protected function render(string $view, array $data = []): string
    {
        $data['currentUser'] = $this->currentUser;
        $data['pageTitle']   = $data['pageTitle'] ?? 'JSCA ERP';

        $data['content'] = view($view, $data);
        return view('layouts/main', $data);
    }

    // ── Permission check ─────────────────────────────────────
    protected function can(string $permission): bool
    {
        if (!$this->currentUser) return false;
        $perms = $this->currentUser['permissions'] ?? [];
        return in_array('all', $perms) || in_array($permission, $perms);
    }

    protected function requirePermission(string $permission): void
    {
        if (!$this->can($permission)) {
            throw \CodeIgniter\Exceptions\PageNotFoundException::forPageNotFound(
                'You do not have permission to access this page.'
            );
        }
    }

    // ── Audit log ────────────────────────────────────────────
    protected function audit(string $action, string $module, ?int $recordId = null, $oldData = null, $newData = null): void
    {
        $this->db->table('audit_logs')->insert([
            'user_id'    => $this->session->get('user_id'),
            'action'     => $action,
            'module'     => $module,
            'record_id'  => $recordId,
            'old_data'   => $oldData ? json_encode($oldData) : null,
            'new_data'   => $newData ? json_encode($newData) : null,
            'ip_address' => $this->request->getIPAddress(),
            'user_agent' => $this->request->getUserAgent()->getAgentString(),
            'created_at' => date('Y-m-d H:i:s'),
        ]);
    }

    // ── Generate unique IDs ──────────────────────────────────
    protected function generatePlayerId(): string
    {
        $year  = date('Y');
        $count = $this->db->table('players')->countAllResults() + 1;
        return 'JSCA-P-' . $year . '-' . str_pad($count, 5, '0', STR_PAD_LEFT);
    }

    protected function generateOfficialId(): string
    {
        $year  = date('Y');
        $count = $this->db->table('officials')->countAllResults() + 1;
        return 'JSCA-O-' . $year . '-' . str_pad($count, 4, '0', STR_PAD_LEFT);
    }

    protected function generateVoucherNumber(): string
    {
        $prefix = 'VCH-' . date('Ym') . '-';
        $count  = $this->db->table('payment_vouchers')
            ->like('voucher_number', $prefix)
            ->countAllResults() + 1;
        return $prefix . str_pad($count, 4, '0', STR_PAD_LEFT);
    }
}
