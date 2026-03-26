<?php

namespace App\Models;

use CodeIgniter\Model;

class BankModel extends Model
{
    protected $table            = 'bank_acc_master';
    protected $primaryKey       = 'id';
    protected $allowedFields = ['bank_name', 'acc_no', 'ifsc_code', 'acc_type', 'branch', 'opening_bal', 'status'];
    
    protected $useTimestamps    = true; 
    protected $dateFormat       = 'datetime'; // Ensures it uses Y-m-d H:i:s
    protected $createdField     = 'created_at';
    protected $updatedField     = 'updated_at';
}
