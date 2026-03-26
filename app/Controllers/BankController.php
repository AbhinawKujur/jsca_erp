<?php

namespace App\Controllers;

use App\Models\BankModel;

class BankController extends BaseController
{
    public function index()
    {

        $this->requirePermission('finance.view');

        $model = new BankModel();
        $data['banks'] = $model->findAll();
        $data['pageTitle'] = "Bank Accounts Master";
        return $this->render('bank_master/index', $data);
    }

    public function save()
    {
        $this->requirePermission('finance.view');

        $model = new BankModel();
        $id = $this->request->getPost('id');

        $data = [
            'bank_name' => $this->request->getPost('bank_name'),
            'acc_no'    => $this->request->getPost('acc_no'),
            'ifsc_code' => $this->request->getPost('ifsc_code'),
            'acc_type'  => $this->request->getPost('acc_type'),
            'branch'          => $this->request->getPost('branch'),
            'opening_bal' => $this->request->getPost('opening_bal'),
            'status'    => $this->request->getPost('status') ?? 'Active',
        ];

        if ($id) {
            $model->update($id, $data);
            return redirect()->to('/finance/bank-master')->with('success', 'Account updated successfully');
        } else {
            $model->insert($data);
            return redirect()->to('/finance/bank-master')->with('success', 'New account added');
        }
    }

    public function delete($id)
    {
        $model = new BankModel();
        $model->delete($id);
        return redirect()->to('finance/bank-master')->with('success', 'Account deleted');
    }
}
