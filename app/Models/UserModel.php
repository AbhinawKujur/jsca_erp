<?php
// app/Models/UserModel.php
namespace App\Models;

use CodeIgniter\Model;

class UserModel extends Model
{
    protected $table      = 'users';
    protected $primaryKey = 'id';
    protected $allowedFields = [
        'role_id', 'full_name', 'email', 'phone', 'password_hash', 
        'is_active', 'last_login', 'reset_token', 'reset_expires'
    ];

    protected $useTimestamps = true; // uses created_at & updated_at
    protected $createdField  = 'created_at';
    protected $updatedField  = 'updated_at';

    // Return user by email
    public function getByEmail(string $email)
    {
        return $this->where('email', $email)->first();
    }

    // Verify password
    public function verifyPassword(string $email, string $password)
    {
        $user = $this->getByEmail($email);
        if (!$user) return false;

        return password_verify($password, $user['password_hash']) ? $user : false;
    }

    // Set reset token
    public function setResetToken(int $userId, string $token, string $expires)
    {
        return $this->update($userId, [
            'reset_token'   => $token,
            'reset_expires' => $expires
        ]);
    }

    // Reset password
    public function resetPassword(int $userId, string $password)
    {
        return $this->update($userId, [
            'password_hash' => password_hash($password, PASSWORD_BCRYPT),
            'reset_token'   => null,
            'reset_expires' => null
        ]);
    }

    // Update last login timestamp
    public function updateLastLogin(int $userId)
    {
        return $this->update($userId, ['last_login' => date('Y-m-d H:i:s')]);
    }
}