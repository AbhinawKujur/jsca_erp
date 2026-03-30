<?php
// app/Controllers/Finance.php
namespace App\Controllers;

class Finance extends BaseController
{
    // ── GET /finance ──────────────────────────────────────────
    public function index()
    {
        $this->requirePermission('finance.view');

        // 1. Summary Statistics
        $summary = [
            'total_paid'      => $this->getSum('Paid'),
            'total_draft'     => $this->getSum('Draft'),
            'total_pending'   => $this->getSum('Pending Approval'),
            'total_approved'  => $this->getSum('Approved'),
            'total_rejected'  => $this->getSum('Cancelled'),
            'voucher_count'   => $this->db->table('vouchers')->countAllResults(),
            'pending_count'   => $this->db->table('vouchers')->where('status', 'Pending Approval')->countAllResults(),
        ];

        // 2. Monthly Trend (Updated to use total_amount)
        $monthlyTrend = $this->db->query("
        SELECT DATE_FORMAT(created_at, '%Y-%m') as month,
               SUM(CASE WHEN status = 'Paid' THEN total_amount ELSE 0 END) as paid,
               COUNT(*) as total_vouchers
        FROM vouchers
        WHERE created_at >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
        GROUP BY month 
        ORDER BY month ASC
        ")->getResultArray();

        // 3. Distribution by Payee Type (Updated to use total_amount)
        $byPayeeType = $this->db->table('vouchers')
            ->select('payee_type, SUM(total_amount) as total, COUNT(*) as count')
            ->where('status', 'Paid')
            ->groupBy('payee_type')
            ->get()
            ->getResultArray();

        // 4. Bank Account Overview
        $bankAccounts = $this->db->table('bank_acc_master')
            ->select('id, bank_name, acc_no, opening_bal, acc_type, updated_at')
            ->get()
            ->getResultArray();

        return $this->render('finance/index', [
            'pageTitle'    => 'Finance — JSCA ERP',
            'summary'      => $summary,
            'monthlyTrend' => $monthlyTrend,
            'byPayeeType'  => $byPayeeType,
            'bankAccounts' => $bankAccounts,
        ]);
    }

    // ── GET /finance/vouchers ─────────────────────────────────
    public function vouchers()
    {
        $db = \Config\Database::connect();

        // This query gets the voucher AND a comma-separated list of all ledger names in it
        $builder = $db->table('vouchers v');
        $builder->select('v.*, GROUP_CONCAT(l.name SEPARATOR ", ") as all_ledgers');
        $builder->join('voucher_items vi', 'vi.voucher_id = v.id', 'left');
        $builder->join('ledger_heads l', 'l.id = vi.ledger_id', 'left'); // Adjust 'ledgers' to your actual table name
        $builder->groupBy('v.id');
        $builder->orderBy('v.created_at', 'DESC');

        // Separate them for your two tables in the view
        $data['receipts'] = (clone $builder)->where('voucher_type', 'Receipt')->get()->getResultArray();

        $data['payments'] = (clone $builder)->where('voucher_type', 'Payment')->get()->getResultArray();

        return $this->render('finance/vouchers', $data);
    }

    // ── GET /finance/voucher/create ───────────────────────────
    public function createVoucher()
    {
        $this->requirePermission('finance.view');

        return $this->render('finance/voucher_form', [
            'pageTitle'   => 'Create Voucher — JSCA ERP',
            'voucher'     => $this->generateVoucherNumber(),
            'officials'   => $this->db->table('officials')->where('status', 1)->orderBy('full_name')->get()->getResultArray(),
            'tournaments' => $this->db->table('tournaments')->orderBy('name')->get()->getResultArray(),
            'fixtures'    => $this->db->table('fixtures f')
                ->select('f.id, f.match_number, f.match_date, ta.name as team_a, tb.name as team_b')
                ->join('teams ta', 'ta.id = f.team_a_id')
                ->join('teams tb', 'tb.id = f.team_b_id')
                ->where('f.status', 'Completed')
                ->orderBy('f.match_date', 'DESC')
                ->limit(100)
                ->get()->getResultArray(),
            'ledger_heads' => $this->db->table('ledger_heads')->select('id,group_id,name,opening_balance,balance_type')->get()->getresultArray(),
            'bank_acc' => $this->db->table('bank_acc_master')->select('*')->get()->getresultArray()
        ]);
    }

    // ── POST /finance/voucher/store ───────────────────────────
    public function storeVoucher()
    {
        $this->requirePermission('finance.view');

        $rules = [
            'payee_name'  => 'required|min_length[3]',
            'payee_type'  => 'required',
            'amount'      => 'required|decimal|greater_than[0]',
            'bank_account' => 'permit_empty|min_length[9]',
            'bank_ifsc'   => 'permit_empty|min_length[11]|max_length[11]',
        ];

        if (!$this->validate($rules)) {
            return redirect()->back()->with('errors', $this->validator->getErrors())->withInput();
        }

        $post = $this->request->getPost();

        $data = [
            'voucher_number' => $this->generateVoucherNumber(),
            'fixture_id'    => $post['fixture_id']    ?: null,
            'tournament_id' => $post['tournament_id'] ?: null,
            'official_id'   => $post['official_id']   ?: null,
            'payee_name'    => $post['payee_name'],
            'payee_type'    => $post['payee_type'],
            'amount'        => $post['amount'],
            'description'   => $post['description']   ?? null,
            'bank_account'  => $post['bank_account']  ?? null,
            'bank_ifsc'     => $post['bank_ifsc']      ?? null,
            'bank_name'     => $post['bank_name']      ?? null,
            'payment_mode'  => $post['payment_mode']   ?? 'NEFT',
            'status'        => 'Pending Approval',
            'created_by'    => session('user_id'),
            'created_at'    => date('Y-m-d H:i:s'),
        ];

        $this->db->table('vouchers')->insert($data);
        $id = $this->db->insertID();

        $this->audit('CREATE_VOUCHER', 'finance', $id, null, $data);

        return redirect()->to('/finance/voucher/view/' . $id)
            ->with('success', 'Voucher ' . $data['voucher_number'] . ' created and sent for approval.');
    }

    // ── GET /finance/voucher/view/:id ─────────────────────────
    public function viewVoucher(int $id)
    {
        $this->requirePermission('finance.view');

        helper('number');

        $voucher = $this->db->table('vouchers v')
            ->select('v.*, b.bank_name, b.acc_no, u.full_name as creator_name')
            ->join('bank_acc_master b', 'b.id = v.bank_account_id', 'left')
            ->join('users u', 'u.id = v.created_by', 'left')
            ->where('v.id', $id)
            ->get()->getRowArray();

        if (!$voucher) {
            return redirect()->back()->with('error', 'Voucher not found.');
        }

        // 2. Fetch all line items (the "Add to List" data)
        $items = $this->db->table('voucher_items vi')
            ->select('vi.*, lh.name as ledger_name')
            ->join('ledger_heads lh', 'lh.id = vi.ledger_id', 'left')
            ->where('vi.voucher_id', $id)
            ->get()->getResultArray();

        return $this->render('finance/voucher_view', [
            'pageTitle' => 'Voucher Details — ' . $voucher['voucher_number'],
            'v'         => $voucher,
            'items'     => $items,
            'amountWords' => $this->amountInWords($voucher['total_amount'])
        ]);
    }

    public function print_voucher($id)
    {

        $this->requirePermission('finance.view');

        $voucher = $this->db->table('vouchers v')
            ->select('v.*, b.bank_name, b.acc_no, u.full_name as creator_name')
            ->join('bank_acc_master b', 'b.id = v.bank_account_id', 'left')
            ->join('users u', 'u.id = v.created_by', 'left')
            ->where('v.id', $id)
            ->get()->getRowArray();

        if (!$voucher) {
            return redirect()->back()->with('error', 'Voucher not found.');
        }

        // 2. Fetch all line items (the "Add to List" data)
        $items = $this->db->table('voucher_items vi')
            ->select('vi.*, lh.name as ledger_name')
            ->join('ledger_heads lh', 'lh.id = vi.ledger_id', 'left')
            ->where('vi.voucher_id', $id)
            ->get()->getResultArray();

        $data = [
            'pageTitle' => 'Voucher Details — ' . $voucher['voucher_number'],
            'v'         => $voucher,
            'items'     => $items,
            'amountWords' => $this->amountInWords($voucher['total_amount'])
        ];

        return view('finance/voucher_print', $data);
    }

    // ── POST /finance/voucher/approve/:id ────────────────────
    public function approveVoucher(int $id)
    {
        $this->requirePermission('finance.approve');

        $voucher = $this->db->table('vouchers')->where('id', $id)->get()->getRowArray();
        if (!$voucher || $voucher['status'] !== 'Pending Approval') {
            return redirect()->back()->with('error', 'Voucher not found or not pending approval.');
        }

        $this->db->table('vouchers')->where('id', $id)->update([
            'status'      => 'Approved',
            'approved_by' => session('user_id'),
            'approved_at' => date('Y-m-d H:i:s'),
            'remarks'     => $this->request->getPost('remarks'),
            'updated_at'  => date('Y-m-d H:i:s'),
        ]);

        $this->audit('APPROVE_VOUCHER', 'finance', $id, $voucher);

        // TODO: Trigger bank transfer API here
        // $this->initiateBankTransfer($voucher);

        return redirect()->back()->with('success', 'Voucher approved. Bank transfer will be initiated shortly.');
    }

    // ── POST /finance/voucher/reject/:id ─────────────────────
    public function rejectVoucher(int $id)
    {
        $this->requirePermission('finance.approve');

        $voucher = $this->db->table('vouchers')->where('id', $id)->get()->getRowArray();
        if (!$voucher) return redirect()->back()->with('error', 'Voucher not found.');

        $this->db->table('vouchers')->where('id', $id)->update([
            'status'      => 'Rejected',
            'approved_by' => session('user_id'),
            'approved_at' => date('Y-m-d H:i:s'),
            'remarks'     => $this->request->getPost('remarks'),
            'updated_at'  => date('Y-m-d H:i:s'),
        ]);

        $this->audit('REJECT_VOUCHER', 'finance', $id, $voucher);

        return redirect()->back()->with('success', 'Voucher rejected.');
    }

    // ── POST /finance/voucher/mark-paid/:id ──────────────────
    public function markPaid(int $id)
    {
        $this->requirePermission('finance.approve');

        $this->db->table('vouchers')->where('id', $id)->update([
            'status'      => 'Paid',
            'paid_at'     => date('Y-m-d H:i:s'),
            'payment_ref' => $this->request->getPost('payment_ref'),
            'updated_at'  => date('Y-m-d H:i:s'),
        ]);

        $this->audit('MARK_PAID', 'finance', $id);

        return redirect()->back()->with('success', 'Payment marked as completed.');
    }

    // ── GET /finance/auto-generate/:fixtureId ────────────────
    // Auto-creates vouchers for all officials of a completed match
    public function autoGenerate(int $fixtureId)
    {
        $this->requirePermission('finance.view');

        $fixture = $this->db->table('fixtures f')
            ->select('f.*, o1.full_name as u1_name, o1.fee_per_match as u1_fee, o1.bank_account as u1_acct, o1.bank_ifsc as u1_ifsc, o1.bank_name as u1_bank,
                      o2.full_name as u2_name, o2.fee_per_match as u2_fee, o2.bank_account as u2_acct, o2.bank_ifsc as u2_ifsc, o2.bank_name as u2_bank,
                      sc.full_name as sc_name, sc.fee_per_match as sc_fee, sc.bank_account as sc_acct, sc.bank_ifsc as sc_ifsc, sc.bank_name as sc_bank,
                      rf.full_name as rf_name, rf.fee_per_match as rf_fee, rf.bank_account as rf_acct, rf.bank_ifsc as rf_ifsc, rf.bank_name as rf_bank,
                      t.name as tournament_name')
            ->join('officials o1', 'o1.id = f.umpire1_id', 'left')
            ->join('officials o2', 'o2.id = f.umpire2_id', 'left')
            ->join('officials sc', 'sc.id = f.scorer_id',  'left')
            ->join('officials rf', 'rf.id = f.referee_id', 'left')
            ->join('tournaments t', 't.id = f.tournament_id')
            ->where('f.id', $fixtureId)
            ->get()->getRowArray();

        if (!$fixture) {
            return redirect()->back()->with('error', 'Fixture not found.');
        }

        $created = 0;
        $officials = [
            ['name' => $fixture['u1_name'], 'fee' => $fixture['u1_fee'], 'acct' => $fixture['u1_acct'], 'ifsc' => $fixture['u1_ifsc'], 'bank' => $fixture['u1_bank'], 'type' => 'Umpire'],
            ['name' => $fixture['u2_name'], 'fee' => $fixture['u2_fee'], 'acct' => $fixture['u2_acct'], 'ifsc' => $fixture['u2_ifsc'], 'bank' => $fixture['u2_bank'], 'type' => 'Umpire'],
            ['name' => $fixture['sc_name'], 'fee' => $fixture['sc_fee'], 'acct' => $fixture['sc_acct'], 'ifsc' => $fixture['sc_ifsc'], 'bank' => $fixture['sc_bank'], 'type' => 'Scorer'],
            ['name' => $fixture['rf_name'], 'fee' => $fixture['rf_fee'], 'acct' => $fixture['rf_acct'], 'ifsc' => $fixture['rf_ifsc'], 'bank' => $fixture['rf_bank'], 'type' => 'Referee'],
        ];

        foreach ($officials as $off) {
            if (empty($off['name'])) continue;

            // Don't duplicate if voucher already exists for this fixture+official
            $existing = $this->db->table('vouchers')
                ->where('fixture_id', $fixtureId)
                ->where('payee_name', $off['name'])
                ->countAllResults();

            if ($existing > 0) continue;

            $this->db->table('vouchers')->insert([
                'voucher_number' => $this->generateVoucherNumber(),
                'fixture_id'     => $fixtureId,
                'tournament_id'  => $fixture['tournament_id'],
                'payee_name'     => $off['name'],
                'payee_type'     => $off['type'],
                'amount'         => $off['fee'] ?? 500,
                'description'    => "Match " . ($fixture['match_number'] ?? $fixtureId) . " — " . $fixture['tournament_name'],
                'bank_account'   => $off['acct'] ?? null,
                'bank_ifsc'      => $off['ifsc'] ?? null,
                'bank_name'      => $off['bank'] ?? null,
                'payment_mode'   => 'NEFT',
                'status'         => 'Pending Approval',
                'created_by'     => session('user_id'),
                'created_at'     => date('Y-m-d H:i:s'),
            ]);
            $created++;
        }

        $this->audit('AUTO_VOUCHERS', 'finance', $fixtureId, null, ['vouchers_created' => $created]);

        return redirect()->to('/finance/vouchers')
            ->with('success', "{$created} payment voucher(s) auto-generated for match officials.");
    }

    // ── GET /finance/reports ──────────────────────────────────
    public function reports()
    {
        $this->requirePermission('finance.view');

        $byTournament = $this->db->table('vouchers pv')
            ->select('t.name as tournament, SUM(pv.amount) as total, COUNT(*) as voucher_count,
                      SUM(CASE WHEN pv.status = "Paid" THEN pv.amount ELSE 0 END) as paid,
                      SUM(CASE WHEN pv.status = "Pending Approval" THEN pv.amount ELSE 0 END) as pending')
            ->join('tournaments t', 't.id = pv.tournament_id', 'left')
            ->groupBy('pv.tournament_id')
            ->orderBy('total', 'DESC')
            ->get()->getResultArray();

        return $this->render('finance/reports', [
            'pageTitle'    => 'Finance Reports — JSCA ERP',
            'byTournament' => $byTournament,
        ]);
    }

    // ── GET /finance/export ───────────────────────────────────
    public function export()
    {
        $this->requirePermission('reports.finance');

        $vouchers = $this->db->table('vouchers pv')
            ->select('pv.voucher_number, pv.payee_name, pv.payee_type, pv.amount, pv.status, pv.payment_mode,
                      pv.bank_account, pv.bank_ifsc, pv.bank_name, pv.description,
                      pv.created_at, pv.approved_at, pv.paid_at, pv.payment_ref,
                      u1.full_name as created_by, u2.full_name as approved_by, t.name as tournament')
            ->join('users u1', 'u1.id = pv.created_by', 'left')
            ->join('users u2', 'u2.id = pv.approved_by', 'left')
            ->join('tournaments t', 't.id = pv.tournament_id', 'left')
            ->orderBy('pv.created_at', 'DESC')
            ->get()->getResultArray();

        $filename = 'JSCA_Finance_' . date('Ymd_His') . '.csv';
        header('Content-Type: text/csv');
        header('Content-Disposition: attachment; filename="' . $filename . '"');

        $out = fopen('php://output', 'w');
        fputcsv($out, array_keys($vouchers[0] ?? []));
        foreach ($vouchers as $v) fputcsv($out, array_values($v));
        fclose($out);
        exit;
    }

    // ─── Private helpers ──────────────────────────────────────
    private function getSum(string $status): float
    {
        // Use selectSum with an explicit alias 'total' for reliability
        $result = $this->db->table('vouchers')
            ->selectSum('total_amount', 'total')
            ->where('status', $status)
            ->get()
            ->getRowArray();

        return (float)($result['total'] ?? 0);
    }


    public function accgroups()
    {
        $groups = $this->db->table('account_groups')
            ->select('*')
            ->orderby('(CAST(SUBSTRING(G_Name, 2) AS UNSIGNED)) ASC')
            ->get()
            ->getResultArray();

        return $this->render('finance/accgroups', [
            'groups' => $groups
        ]);
    }

    public function storeaccGroup()
    {
        $row = $this->db->table('account_groups')
            ->select('(MAX(CAST(SUBSTRING(G_Name, 2) AS UNSIGNED)) + 1) AS new_id')
            ->get()
            ->getRow();

        $gpid = 'G' . ($row->new_id ?? 1);

        $this->db->table('account_groups')->insert([
            'G_Name' => $gpid,
            'Acc_Name' => $this->request->getPost('name'),
            'Acc_Type' => $this->request->getPost('acc_type'),
            'YesNo' => 'No'
        ]);

        return redirect()->back()->with('success', 'Group created');
    }

    public function deleteaccGroup($G_Name)
    {
        $this->db->table('account_groups')->delete(['G_Name' => $G_Name]);
        return redirect()->back()->with('success', 'Deleted');
    }

    public function ledgerHeads()
    {
        $ledgers = $this->db->table('ledger_heads l')
            ->select('l.*, g.Acc_Name as group_name')
            ->join('account_groups g', 'g.G_Name = l.group_id')
            ->get()->getResultArray();

        $groups = $this->db->table('account_groups')->get()->getResultArray();

        return $this->render('finance/ledger_heads', [
            'ledgers' => $ledgers,
            'groups'  => $groups
        ]);
    }

    public function storeLedger()
    {
        $this->db->table('ledger_heads')->insert([
            'group_id' => $this->request->getPost('group_id'),
            'name' => $this->request->getPost('name'),
            'opening_balance' => $this->request->getPost('opening_balance'),
            'balance_type' => $this->request->getPost('balance_type'),
            'created_at' => date('Y-m-d H:i:s')
        ]);

        return redirect()->back()->with('success', 'Ledger created');
    }

    public function deleteLedger($id)
    {
        $this->db->table('ledger_heads')->delete(['id' => $id]);
        return redirect()->back()->with('success', 'Deleted');
    }

    // ── GET /finance/voucher/receipt voucher create ───────────────────────────
    public function rcpt_create()
    {

        $this->requirePermission('finance.view');

        return $this->render('finance/voucher_form_rcpt', [
            'pageTitle'   => 'Create Voucher — JSCA ERP',
            'voucher'     => $this->generateVoucherNumber(),
            'officials'   => $this->db->table('officials')->where('status', 1)->orderBy('full_name')->get()->getResultArray(),
            'official_types'   => $this->db->table('official_types')->where('is_active', 1)->orderBy('name')->get()->getResultArray(),
            'tournaments' => $this->db->table('tournaments')->orderBy('name')->get()->getResultArray(),
            'fixtures'    => $this->db->table('fixtures f')
                ->select('f.tournament_id, f.match_number, f.match_date, ta.name as team_a, tb.name as team_b,f.team_a_id,f.team_b_id')
                ->join('teams ta', 'ta.id = f.team_a_id')
                ->join('teams tb', 'tb.id = f.team_b_id')
                ->where('f.status', 'Completed')
                ->orderBy('f.match_date', 'DESC')
                ->limit(100)
                ->get()->getResultArray(),
            'ledger_heads' => $this->db->table('ledger_heads')->select('id,group_id,name,opening_balance,balance_type')->get()->getresultArray(),
            'bank_acc' => $this->db->table('bank_acc_master')->select('*')->get()->getresultArray()
        ]);
    }

    public function getMatchesByTournament()
    {
        $tournamentId = $this->request->getPost('tournament_id');

        if (empty($tournamentId)) {
            return $this->response->setJSON([]);
        }

        $matches = $this->db->table('fixtures f')
            ->select('f.id, ta.name as team_a, tb.name as team_b, f.team_a_id, f.team_b_id')
            ->join('teams ta', 'ta.id = f.team_a_id')
            ->join('teams tb', 'tb.id = f.team_b_id')
            ->where('f.tournament_id', $tournamentId)
            ->where('f.status', 'Completed')
            ->get()->getResultArray();

        return $this->response->setJSON($matches);
    }

    public function getOfficialsByType()
    {
        $typeId = $this->request->getPost('type_id');
        $matchId = $this->request->getPost('match_id');

        if (empty($typeId)) {
            return $this->response->setJSON([]);
        }

        // Adjust table name and column names to match your database
        $officials = $this->db->table('match_officials')
            ->select('id, name')
            ->where('official_type_id', $typeId)
            ->where('status', 'Active')
            ->where('match_id', $matchId)
            ->where('official_type_id', $typeId)
            ->where('PAmt', 0.00)
            ->orderBy('name', 'ASC')
            ->get()->getResultArray();

        return $this->response->setJSON($officials);
    }

    public function final_save()
    {
        $voucherType = $this->request->getPost('voucher_type') ?? 'Payment';

        $headerData = [
            'voucher_number' => $this->request->getPost('voucher_no'),
            'voucher_type'   => $voucherType,
            'voucher_date'   => date('Y-m-d', strtotime($this->request->getPost('voucher_date'))),
            'tournament_id'  => $this->request->getPost('tournament') ?: null,
            'fixture_id'     => $this->request->getPost('match') ?: null,
            'official_id'    => $this->request->getPost('official_name') ?: null,
            'payee_name'     => $this->request->getPost('payee_name') ?: $this->request->getPost('official_name'),
            'payee_type'     => $this->request->getPost('pay_to') ?: 'Other',
            'payment_mode'   => $this->request->getPost('payment_mode'),
            'bank_account_id' => $this->request->getPost('bank_account') ?: null,
            'bank_ifsc'      => $this->request->getPost('bank_ifsc') ?: null,
            'payment_ref'    => $this->request->getPost('reference_no') ?: null,
            'status'         => 'Pending Approval', // Default status for ERP workflow
            'created_by'     => session()->get('user_id'), // Assuming session management is active
            'created_at'     => date('Y-m-d H:i:s')
        ];

        // 2. Collect Table Items (From the "Add to List" jQuery table)
        $items = $this->request->getPost('items');

        if (empty($items['ledger_id'])) {
            return redirect()->back()->with('error', 'Voucher must contain at least one ledger entry.');
        }

        // 3. Start Database Transaction
        $this->db->transStart();

        try {
            // Insert Header
            $this->db->table('vouchers')->insert($headerData);
            $voucherId = $this->db->insertID();

            // Prepare Items for Batch Insert
            $insertItems = [];
            $totalAmount = 0;

            foreach ($items['ledger_id'] as $key => $ledgerId) {
                $dr = (float)$items['dr'][$key];
                $cr = (float)$items['cr'][$key];

                $insertItems[] = [
                    'voucher_id' => $voucherId,
                    'ledger_id'  => $ledgerId,
                    'narration'  => $items['narr'][$key],
                    'dr_amount'  => $dr,
                    'cr_amount'  => $cr,
                ];

                // Calculate Total Amount (Sum of Debits or Credits since they are equal)
                $totalAmount += $dr;
            }

            // Insert All Items at once
            $this->db->table('voucher_items')->insertBatch($insertItems);

            // Update Total Amount in Header
            $this->db->table('vouchers')
                ->where('id', $voucherId)
                ->update(['total_amount' => $totalAmount]);

            $this->db->transComplete();

            if ($this->db->transStatus() === FALSE) {
                return redirect()->back()->with('error', 'Transaction Failed: Database error.');
            }

            return redirect()->to('/finance/vouchers')->with('success', "Voucher {$headerData['voucher_number']} saved successfully.");
        } catch (\Exception $e) {
            $this->db->transRollback();
            return redirect()->back()->with('error', 'Error: ' . $e->getMessage());
        }
    }

    private function amountInWords($number)
    {
        $decimal = round($number - ($no = floor($number)), 2) * 100;
        $hundred = null;
        $digits_length = strlen($no);
        $i = 0;
        $str = array();
        $words = array(
            0 => '',
            1 => 'one',
            2 => 'two',
            3 => 'three',
            4 => 'four',
            5 => 'five',
            6 => 'six',
            7 => 'seven',
            8 => 'eight',
            9 => 'nine',
            10 => 'ten',
            11 => 'eleven',
            12 => 'twelve',
            13 => 'thirteen',
            14 => 'fourteen',
            15 => 'fifteen',
            16 => 'sixteen',
            17 => 'seventeen',
            18 => 'eighteen',
            19 => 'nineteen',
            20 => 'twenty',
            30 => 'thirty',
            40 => 'forty',
            50 => 'fifty',
            60 => 'sixty',
            70 => 'seventy',
            80 => 'eighty',
            90 => 'ninety'
        );
        $digits = array('', 'hundred', 'thousand', 'lakh', 'crore');
        while ($i < $digits_length) {
            $divider = ($i == 2) ? 10 : 100;
            $number = floor($no % $divider);
            $no = floor($no / $divider);
            $i += $divider == 10 ? 1 : 2;
            if ($number) {
                $plural = (($counter = count($str)) && $number > 9) ? 's' : null;
                $hundred = ($counter == 1 && $str[0]) ? ' and ' : null;
                $str[] = ($number < 21) ? $words[$number] . ' ' . $digits[$counter] . $plural . ' ' . $hundred : $words[floor($number / 10) * 10] . ' ' . $words[$number % 10] . ' ' . $digits[$counter] . $plural . ' ' . $hundred;
            } else $str[] = null;
        }
        $Rupees = implode('', array_reverse($str));
        $paise = ($decimal > 0) ? "." . ($words[$decimal / 10] . " " . $words[$decimal % 10]) . ' Paise' : '';
        return ($Rupees ? $Rupees . 'Rupees ' : '') . $paise;
    }

    public function update_status(int $id, string $status)
    {
        // 1. Security Check: Only allow specific status changes
        $allowedStatuses = ['Approved', 'Paid', 'Cancelled', 'Rejected'];
        if (!in_array($status, $allowedStatuses)) {
            return redirect()->back()->with('error', 'Invalid status transition.');
        }

        // 2. Permission Check (Optional but recommended)
        // $this->requirePermission('finance.approve');

        $db = \Config\Database::connect();

        // 3. Update the Voucher
        $updated = $db->table('vouchers')
            ->where('id', $id)
            ->update([
                'status'     => $status,
                'updated_by' => $this->currentUser['id'], // Tracking who took action
                'updated_at' => date('Y-m-d H:i:s')
            ]);

        if ($updated) {
            $msg = ($status === 'Cancelled' || $status === 'Rejected')
                ? "Voucher has been $status."
                : "Voucher successfully $status!";

            return redirect()->to(base_url('finance/voucher/view/' . $id))->with('success', $msg);
        } else {
            return redirect()->back()->with('error', 'Failed to update voucher status.');
        }
    }
}
