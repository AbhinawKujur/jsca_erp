<?php // app/Views/admin/users.php ?>

<div class="d-flex justify-content-between align-items-center mb-4">
  <div>
    <h4 class="mb-0">Users & Roles</h4>
    <small class="text-muted">Manage system users and their district access</small>
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
          <th>Districts</th>
          <th>Status</th>
          <th>Last Login</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <?php foreach ($users as $u): ?>
          <?php
            $districts = \Config\Database::connect()
              ->table('user_districts ud')
              ->select('d.name')
              ->join('districts d', 'd.id = ud.district_id')
              ->where('ud.user_id', $u['id'])
              ->get()->getResultArray();
            $districtNames = array_column($districts, 'name');
          ?>
          <tr>
            <td>
              <div class="d-flex align-items-center gap-2">
                <div class="avatar-circle"><?= strtoupper(substr($u['full_name'], 0, 1)) ?></div>
                <?= esc($u['full_name']) ?>
              </div>
            </td>
            <td><?= esc($u['email']) ?></td>
            <td><span class="badge bg-secondary"><?= esc($u['role_name']) ?></span></td>
            <td>
              <?php if ($u['role_name'] === 'superadmin'): ?>
                <span class="badge bg-success">All Districts</span>
              <?php elseif (empty($districtNames)): ?>
                <span class="text-muted small">None assigned</span>
              <?php else: ?>
                <?php foreach (array_slice($districtNames, 0, 3) as $dn): ?>
                  <span class="badge bg-light text-dark border me-1"><?= esc($dn) ?></span>
                <?php endforeach; ?>
                <?php if (count($districtNames) > 3): ?>
                  <span class="text-muted small">+<?= count($districtNames) - 3 ?> more</span>
                <?php endif; ?>
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
              <a href="<?= base_url('admin/users/edit/' . $u['id']) ?>" class="btn btn-sm btn-outline-primary me-1">
                <i class="bi bi-pencil"></i>
              </a>
              <?php if ($u['id'] !== ($currentUser['id'] ?? 0)): ?>
                <form method="post" action="<?= base_url('admin/users/toggle/' . $u['id']) ?>" class="d-inline">
                  <?= csrf_field() ?>
                  <button class="btn btn-sm <?= $u['is_active'] ? 'btn-outline-danger' : 'btn-outline-success' ?>"
                    onclick="return confirm('<?= $u['is_active'] ? 'Deactivate' : 'Activate' ?> this user?')">
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
