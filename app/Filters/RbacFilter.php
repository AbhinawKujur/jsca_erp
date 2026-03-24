<?php
// app/Filters/RbacFilter.php
namespace App\Filters;

use CodeIgniter\Filters\FilterInterface;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;

/**
 * Usage in Routes.php:  ['filter' => 'rbac:players,coaches']
 * Arguments = module permissions required (any one match = pass).
 * superadmin always passes.
 */
class RbacFilter implements FilterInterface
{
    public function before(RequestInterface $request, $arguments = null)
    {
        $session = session();

        if (!$session->get('user_id')) {
            return redirect()->to(site_url('login'));
        }

        $role = $session->get('user_role');

        // superadmin bypasses all checks
        if ($role === 'superadmin') return;

        if (empty($arguments)) return;

        // Load permissions from DB (already decoded in BaseController, but filter runs before controller)
        $db   = \Config\Database::connect();
        $user = $db->table('users u')
            ->select('r.permissions, r.name as role_name')
            ->join('roles r', 'r.id = u.role_id')
            ->where('u.id', $session->get('user_id'))
            ->get()->getRowArray();

        if (!$user) {
            session()->destroy();
            return redirect()->to(site_url('login'));
        }

        $perms = json_decode($user['permissions'], true) ?? [];

        if (in_array('all', $perms)) return;

        // Check if user has at least one of the required permissions
        foreach ($arguments as $required) {
            if (in_array($required, $perms)) return;
        }

        return redirect()->to(site_url('dashboard'))
            ->with('error', 'You do not have permission to access that page.');
    }

    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null) {}
}
