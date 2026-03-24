<?php // app/Views/admin/audit_log.php ?>

<div class="d-flex justify-content-between align-items-center mb-4">
  <div>
    <h4 class="mb-0">Audit Log</h4>
    <small class="text-muted">Last 500 system events</small>
  </div>
</div>

<div class="card">
  <div class="card-body p-0">
    <table class="table table-hover mb-0 data-table">
      <thead>
        <tr>
          <th>Time</th>
          <th>User</th>
          <th>Action</th>
          <th>Module</th>
          <th>Record ID</th>
          <th>IP</th>
        </tr>
      </thead>
      <tbody>
        <?php foreach ($logs as $log): ?>
          <tr>
            <td class="small text-muted"><?= date('d M Y H:i:s', strtotime($log['created_at'])) ?></td>
            <td><?= esc($log['full_name'] ?? 'System') ?></td>
            <td>
              <?php
                $badgeClass = match($log['action']) {
                  'LOGIN'  => 'bg-success',
                  'LOGOUT' => 'bg-secondary',
                  'CREATE' => 'bg-primary',
                  'UPDATE' => 'bg-warning text-dark',
                  'DELETE' => 'bg-danger',
                  default  => 'bg-light text-dark',
                };
              ?>
              <span class="badge <?= $badgeClass ?>"><?= esc($log['action']) ?></span>
            </td>
            <td><?= esc($log['module']) ?></td>
            <td><?= $log['record_id'] ?? '-' ?></td>
            <td class="small text-muted"><?= esc($log['ip_address']) ?></td>
          </tr>
        <?php endforeach; ?>
      </tbody>
    </table>
  </div>
</div>
