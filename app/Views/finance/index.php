<style>
  .quick-card {
    transition: all 0.2s ease;
    cursor: pointer;
  }

  .quick-card:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
  }

  .bank-card {
    border: none;
    border-radius: 10px;
    background: #fff;
    transition: all 0.3s ease;
    border: 4px solid #2ecc71;
    /* Matches your 'Total Paid' green */
  }

  .bank-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.08) !important;
  }

  .bank-name {
    font-size: 0.75rem;
    font-weight: 700;
    color: #95a5a6;
    text-transform: uppercase;
    letter-spacing: 0.5px;
  }

  .bank-balance {
    font-size: 1.4rem;
    font-weight: 800;
    color: #2c3e50;
    margin: 5px 0;
  }
</style>
<div class="row g-3 mb-4">

  <div class="col-sm-6 col-xl-3">
    <div class="stat-card" style="border-left-color:#2ecc71;">
      <div class="stat-val">₹<?= number_format($summary['total_paid']) ?></div>
      <div class="stat-label">Total Paid</div>
    </div>
  </div>

  <div class="col-sm-6 col-xl-3">
    <div class="stat-card" style="border-left-color:#f39c12;">
      <div class="stat-val">₹<?= number_format($summary['total_pending']) ?></div>
      <div class="stat-label">Pending Approval</div>
    </div>
  </div>

  <div class="col-sm-6 col-xl-3">
    <div class="stat-card" style="border-left-color:#3498db;">
      <div class="stat-val">₹<?= number_format($summary['total_approved']) ?></div>
      <div class="stat-label">Approved</div>
    </div>
  </div>

  <div class="col-sm-6 col-xl-3">
    <div class="stat-card" style="border-left-color:#e74c3c;">
      <div class="stat-val">₹<?= number_format($summary['total_rejected']) ?></div>
      <div class="stat-label">Rejected</div>
    </div>
  </div>

</div>

<div class="container-fluid px-0 mb-4">
  <h5 class="mb-3">Bank Account Overview</h5>
  <div class="row g-3">
    <?php foreach ($bankAccounts as $acc): ?>
      <div class="col-md-3">
        <div class="card bank-card shadow-sm h-100 p-3">
          <div class="d-flex justify-content-between align-items-start">
            <div class="bank-name"><?= $acc['bank_name'] ?></div>
            <i class="bi bi-bank2 text-muted"></i>
          </div>
          
          <div class="bank-balance">
            ₹<?= number_format($acc['opening_bal'], 2) ?>
          </div>
          
          <div class="d-flex justify-content-between align-items-center mt-2">
            <small class="text-muted" style="font-size: 11px;">
              A/c: ****<?= substr($acc['acc_no'], -4) ?>
            </small>
            <span class="badge bg-soft-success text-success" style="font-size: 10px; background: #e8f8f0;">Active</span>
          </div>
        </div>
      </div>
    <?php endforeach; ?>
  </div>
</div>

<div class="row g-3 mb-4">
  <h5 class="mb-3">Quick Actions</h5>

  <div class="col-md-3">
    <a href="/finance/accgroups" class="text-decoration-none">
      <div class="card shadow-sm h-100 quick-card border-start border-success border-4">
        <div class="card-body d-flex align-items-center">
          <i class="bi bi-diagram-3 fs-3 text-primary me-3"></i>
          <div>
            <h6 class="mb-0">Group Master</h6>
            <small class="text-muted">Manage account groups</small>
          </div>
        </div>
      </div>
    </a>
  </div>

  <div class="col-md-3">
    <a href="/finance/ledger-heads" class="text-decoration-none">
      <div class="card shadow-sm h-100 quick-card border-start border-warning border-4">
        <div class="card-body d-flex align-items-center">
          <i class="bi bi-journal-text fs-3 text-success me-3"></i>
          <div>
            <h6 class="mb-0">Ledger Heads</h6>
            <small class="text-muted">Manage ledger accounts</small>
          </div>
        </div>
      </div>
    </a>
  </div>

  <div class="col-md-3">
    <a href="/finance/vouchers" class="text-decoration-none">
      <div class="card shadow-sm h-100 quick-card border-start border-primary border-4">
        <div class="card-body d-flex align-items-center">
          <i class="bi bi-journal-text fs-3 text-success me-3"></i>
          <div>
            <h6 class="mb-0">Voucher</h6>
            <small class="text-muted">Manage Vouchers</small>
          </div>
        </div>
      </div>
    </a>
  </div>


  <div class="col-md-3">
    <a href="/finance/bank-master" class="text-decoration-none">
      <div class="card shadow-sm h-100 quick-card border-start border-danger border-4">
        <div class="card-body d-flex align-items-center">
          <i class="bi bi-journal-text fs-3 text-success me-3"></i>
          <div>
            <h6 class="mb-0">Bank Accounts</h6>
            <small class="text-muted">Manage Bank Accounts</small>
          </div>
        </div>
      </div>
    </a>
  </div>


</div>


<div class="row g-3">

  <!-- Recent Vouchers -->
  <div class="col-xl-8">
    <div class="card">
      <div class="card-header">
        <i class="bi bi-receipt me-2 text-primary"></i>Recent Vouchers
      </div>

      <div class="table-responsive">
        <table class="table mb-0">
          <thead>
            <tr>
              <th>No</th>
              <th>Payee</th>
              <th>Amount</th>
              <th>Status</th>
              <th></th>
            </tr>
          </thead>

          <tbody>
            <?php foreach ($recentVouchers ?? [] as $v): ?>
              <tr>
                <td><?= $v['voucher_number'] ?></td>
                <td><?= $v['payee_name'] ?></td>
                <td>₹<?= number_format($v['amount']) ?></td>
                <td>
                  <span class="badge badge-status bg-light text-dark">
                    <?= $v['status'] ?>
                  </span>
                </td>
                <td>
                  <a href="/finance/voucher/view/<?= $v['id'] ?>" class="btn btn-xs btn-outline-primary">View</a>
                </td>
              </tr>
            <?php endforeach; ?>
          </tbody>

        </table>
      </div>
    </div>
  </div>

  <!-- Pending Approvals -->
  <div class="col-xl-4">
    <div class="card">
      <div class="card-header">
        <i class="bi bi-exclamation-circle text-danger me-2"></i>Pending Approvals
      </div>

      <?php foreach ($pendingList ?? [] as $v): ?>
        <div class="d-flex justify-content-between px-3 py-2 border-bottom">
          <div>
            <div style="font-size:13px;" class="fw-semibold"><?= $v['voucher_number'] ?></div>
            <div style="font-size:11px;color:#888;"><?= $v['payee_name'] ?></div>
          </div>
          <div class="text-end">
            <div class="fw-bold">₹<?= number_format($v['amount']) ?></div>
            <a href="/finance/voucher/view/<?= $v['id'] ?>" class="btn btn-xs btn-outline-success">Review</a>
          </div>
        </div>
      <?php endforeach; ?>

    </div>
  </div>

</div>