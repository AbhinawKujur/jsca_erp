<?php
// app/Filters/AuthFilter.php
namespace App\Filters;

use CodeIgniter\Filters\FilterInterface;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;

class AuthFilter implements FilterInterface
{
    public function before(RequestInterface $request, $arguments = null)
    {
        if (!session()->get('user_id')) {
            session()->set('redirect_url', current_url());
           return redirect()->to(site_url('login'))->with('error', 'Please log in to continue.');
        }

        // Check account is still active
        $db   = \Config\Database::connect();
        $user = $db->table('users')->where('id', session('user_id'))->get()->getRowArray();

        if (!$user || !$user['is_active']) {
            session()->destroy();
            return redirect()->to(base_url('login'))->with('error', 'Your account has been disabled.');
        }
    }

    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null) {}
}
