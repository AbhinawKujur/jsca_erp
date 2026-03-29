<?php // app/Views/admin/users.php ?>

<div class="d-flex justify-content-between align-items-center mb-4">
  <div>
    <h4 class="mb-0">Users & Access</h4>
    <small class="text-muted">All system users — players, officials, admins, staff</small>
  </div>
  <a href="<?= base_url('admin/users/create') ?>" class="btn btn-jsca-primary">
    <i class="bi bi-person-plus me-1"></i> Add User
  </a>
</div>

<div class="card">
  <div class="card-body p-0">
    <table class="table table-hover mb-0 data-table">
      <thead>
        <tr>
          <th>Name</th>
          <th>Email</th>
          <th>Role</th>
          <th>JSCA ID</th>
          <th>Status</th>
          <th>Last Login</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <?php foreach ($users as $u): ?>
          <tr>
            <td>
              <div class="d-flex align-items-center gap-2">
                <div class="avatar-circle"><?= strtoupper(substr($u['full_name'], 0, 1)) ?></div>
                <div>
                  <div><?= esc($u['full_name']) ?></div>
                  <?php if (empty($u['email'])): ?>
                    <small class="text-warning"><i class="bi bi-exclamation-circle me-1"></i>No email set</small>
                  <?php endif; ?>
                </div>
              </div>
            </td>
            <td><?= $u['email'] ? esc($u['email']) : '<span class="text-muted">—</span>' ?></td>
            <td><span class="badge bg-secondary"><?= esc($u['role_name']) ?></span></td>
            <td class="small text-muted">
              <?php if (!empty($u['jsca_official_id'])): ?>
                <span class="badge bg-info text-dark"><?= esc($u['jsca_official_id']) ?></span>
              <?php elseif (!empty($u['jsca_player_id'])): ?>
                <span class="badge bg-light text-dark border"><?= esc($u['jsca_player_id']) ?></span>
              <?php else: ?>
                —
              <?php endif; ?>
            </td>
            <td>
              <?php if ($u['is_active']): ?>
                <span class="badge bg-success">Active</span>
              <?php else: ?>
                <span class="badge bg-danger">Inactive</span>
              <?php endif; ?>
            </td>
            <td class="text-muted small"><?= $u['last_login'] ? date('d M Y H:i', strtotime($u['last_login'])) : 'Never' ?></td>
            <td>
              <a href="<?= base_url('admin/users/edit/' . $u['id']) ?>" class="btn btn-sm btn-outline-primary me-1"
                title="Edit — set email & password to send credentials">
                <i class="bi bi-pencil"></i>
              </a>
              <?php if ($u['id'] !== ($currentUser['id'] ?? 0)): ?>
                <form method="post" action="<?= base_url('admin/users/toggle/' . $u['id']) ?>" class="d-inline">
                  <?= csrf_field() ?>
                  <button class="btn btn-sm <?= $u['is_active'] ? 'btn-outline-danger' : 'btn-outline-success' ?>"
                    onclick="return confirm('<?= $u['is_active'] ? 'Deactivate' : 'Activate' ?> this user?')"
                    title="<?= $u['is_active'] ? 'Deactivate' : 'Activate' ?>">
                    <i class="bi bi-<?= $u['is_active'] ? 'person-x' : 'person-check' ?>"></i>
                  </button>
                </form>
              <?php endif; ?>
            </td>
          </tr>
        <?php endforeach; ?>
      </tbody>
    </table>
  </div>
</div>

<div class="mt-3 small text-muted">
  <i class="bi bi-info-circle me-1"></i>
  To send login credentials to an official or player — click Edit, set their email and a new password, then save. Credentials will be emailed automatically.
</div>
