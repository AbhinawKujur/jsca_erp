<?php // app/Views/admin/user_form.php
$isEdit = !empty($user);

// All available permissions with labels
$allPerms = [
    'players'     => ['label' => 'Players',     'icon' => 'bi-people'],
    'coaches'     => ['label' => 'Coaches',     'icon' => 'bi-person-video3'],
    'venues'      => ['label' => 'Venues',      'icon' => 'bi-building'],
    'teams'       => ['label' => 'Teams',       'icon' => 'bi-shield-fill'],
    'tournaments' => ['label' => 'Tournaments', 'icon' => 'bi-trophy'],
    'fixtures'    => ['label' => 'Fixtures',    'icon' => 'bi-calendar3'],
    'officials'   => ['label' => 'Officials',   'icon' => 'bi-patch-check'],
    'finance'     => ['label' => 'Finance',     'icon' => 'bi-currency-rupee'],
    'analytics'   => ['label' => 'Analytics',   'icon' => 'bi-bar-chart-line'],
    'reports'     => ['label' => 'Reports',     'icon' => 'bi-file-earmark-text'],
];
?>

<div class="mb-4">
  <a href="<?= base_url('admin/users') ?>" class="text-decoration-none text-muted small">
    <i class="bi bi-arrow-left me-1"></i> Back to Users
  </a>
  <h4 class="mt-1"><?= $isEdit ? 'Edit User' : 'Create User' ?></h4>
</div>

<form method="post" action="<?= base_url($isEdit ? 'admin/users/update/' . $user['id'] : 'admin/users/store') ?>">
  <?= csrf_field() ?>

  <div class="row g-4">
    <!-- Left column -->
    <div class="col-lg-8">

      <!-- Basic Info -->
      <div class="card mb-4">
        <div class="card-header">Account Details</div>
        <div class="card-body">
          <div class="row g-3">
            <div class="col-md-6">
              <label class="form-label fw-semibold">Full Name <span class="text-danger">*</span></label>
              <input type="text" name="full_name" class="form-control"
                value="<?= esc(old('full_name', $user['full_name'] ?? '')) ?>" required>
            </div>
            <div class="col-md-6">
              <label class="form-label fw-semibold">Email <span class="text-danger">*</span></label>
              <input type="email" name="email" class="form-control"
                value="<?= esc(old('email', $user['email'] ?? '')) ?>" required>
            </div>
            <div class="col-md-6">
              <label class="form-label fw-semibold">Phone</label>
              <input type="text" name="phone" class="form-control"
                value="<?= esc(old('phone', $user['phone'] ?? '')) ?>">
            </div>
            <div class="col-md-6">
              <label class="form-label fw-semibold"><?= $isEdit ? 'New Password' : 'Password' ?> <?= !$isEdit ? '<span class="text-danger">*</span>' : '' ?></label>
              <input type="password" name="password" class="form-control" <?= !$isEdit ? 'required' : '' ?>
                placeholder="<?= $isEdit ? 'Leave blank to keep current' : 'Min 8 characters' ?>">
            </div>
            <div class="col-md-6">
              <label class="form-label fw-semibold">Role <span class="text-danger">*</span></label>
              <select name="role_id" class="form-select" required id="roleSelect">
                <option value="">-- Select Role --</option>
                <?php foreach ($roles as $r): ?>
                  <option value="<?= $r['id'] ?>"
                    data-perms="<?= esc(json_encode(json_decode($r['permissions'] ?? '[]', true))) ?>"
                    <?= (old('role_id', $user['role_id'] ?? '') == $r['id']) ? 'selected' : '' ?>>
                    <?= esc($r['name']) ?>
                  </option>
                <?php endforeach; ?>
              </select>
            </div>
          </div>
        </div>
      </div>

      <!-- Module Permissions -->
      <div class="card mb-4" id="permissionsCard">
        <div class="card-header d-flex justify-content-between align-items-center">
          <span>Module Permissions</span>
          <div>
            <button type="button" class="btn btn-sm btn-outline-secondary me-1" onclick="selectAllPerms()">Select All</button>
            <button type="button" class="btn btn-sm btn-outline-secondary" onclick="clearAllPerms()">Clear All</button>
          </div>
        </div>
        <div class="card-body">
          <p class="text-muted small mb-3">
            Checked items marked <span class="badge bg-primary" style="font-size:10px;">role default</span> come from the selected role.
            You can grant additional modules or remove role defaults for this specific user.
          </p>
          <div class="row g-2" id="permCheckboxes">
            <?php
              $currentPerms = old('permissions', $userPerms ?? []);
            ?>
            <?php foreach ($allPerms as $key => $meta): ?>
              <div class="col-md-4 col-6">
                <div class="border rounded p-2 perm-item" data-perm="<?= $key ?>">
                  <div class="form-check mb-0">
                    <input class="form-check-input perm-cb" type="checkbox"
                      name="permissions[]"
                      value="<?= $key ?>"
                      id="perm_<?= $key ?>"
                      <?= in_array($key, (array)$currentPerms) ? 'checked' : '' ?>>
                    <label class="form-check-label d-flex align-items-center gap-1" for="perm_<?= $key ?>">
                      <i class="bi <?= $meta['icon'] ?> text-muted" style="font-size:13px;"></i>
                      <?= $meta['label'] ?>
                    </label>
                  </div>
                  <div class="mt-1 role-badge-wrap" style="min-height:18px;"></div>
                </div>
              </div>
            <?php endforeach; ?>
          </div>
          <div id="superadminNote" class="alert alert-info mt-3 mb-0 d-none small">
            <i class="bi bi-info-circle me-1"></i> Superadmin has access to <strong>all modules</strong> — individual permissions don't apply.
          </div>
        </div>
      </div>

      <!-- District Access -->
      <div class="card mb-4" id="districtSection">
        <div class="card-header d-flex justify-content-between align-items-center">
          <span>District Access</span>
          <div>
            <button type="button" class="btn btn-sm btn-outline-secondary me-1" onclick="selectAllDistricts()">Select All</button>
            <button type="button" class="btn btn-sm btn-outline-secondary" onclick="clearAllDistricts()">Clear All</button>
          </div>
        </div>
        <div class="card-body">
          <p class="text-muted small mb-3">Select which districts this user can view/manage.</p>
          <?php
            $byZone = [];
            foreach ($districts as $d) $byZone[$d['zone']][] = $d;
          ?>
          <div class="row g-2">
            <?php foreach ($byZone as $zone => $zoneDists): ?>
              <div class="col-md-4">
                <div class="border rounded p-3">
                  <div class="fw-semibold text-muted small mb-2 text-uppercase"><?= esc($zone) ?> Zone</div>
                  <?php foreach ($zoneDists as $d): ?>
                    <div class="form-check">
                      <input class="form-check-input district-cb" type="checkbox"
                        name="district_ids[]"
                        value="<?= $d['id'] ?>"
                        id="d<?= $d['id'] ?>"
                        <?= in_array($d['id'], $assigned) ? 'checked' : '' ?>>
                      <label class="form-check-label" for="d<?= $d['id'] ?>">
                        <?= esc($d['name']) ?>
                        <span class="text-muted small">(<?= esc($d['code']) ?>)</span>
                      </label>
                    </div>
                  <?php endforeach; ?>
                </div>
              </div>
            <?php endforeach; ?>
          </div>
        </div>
      </div>

      <div class="d-flex gap-2">
        <button type="submit" class="btn btn-jsca-primary">
          <i class="bi bi-check-lg me-1"></i> <?= $isEdit ? 'Update User' : 'Create User' ?>
        </button>
        <a href="<?= base_url('admin/users') ?>" class="btn btn-outline-secondary">Cancel</a>
      </div>
    </div>

    <!-- Right column: role reference -->
    <div class="col-lg-4">
      <div class="card">
        <div class="card-header">Role Defaults Reference</div>
        <div class="card-body p-0">
          <table class="table table-sm mb-0">
            <thead><tr><th>Role</th><th>Default Permissions</th></tr></thead>
            <tbody>
              <?php foreach ($roles as $r): ?>
                <tr>
                  <td><span class="badge bg-secondary"><?= esc($r['name']) ?></span></td>
                  <td class="small text-muted">
                    <?php
                      $perms = json_decode($r['permissions'], true) ?? [];
                      echo esc(implode(', ', $perms));
                    ?>
                  </td>
                </tr>
              <?php endforeach; ?>
            </tbody>
          </table>
        </div>
      </div>
      <div class="card mt-3">
        <div class="card-header">Notes</div>
        <div class="card-body small text-muted">
          <ul class="mb-0 ps-3">
            <li><strong>Role defaults</strong> are always granted — you can add extras on top.</li>
            <li>Unchecking a role default will still be overridden by the role itself unless you change the role.</li>
            <li><strong>superadmin</strong> always has full access regardless of checkboxes.</li>
            <li>District access limits which records the user can see.</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</form>

<script>
const roleSelect      = document.getElementById('roleSelect');
const districtSection = document.getElementById('districtSection');
const superadminNote  = document.getElementById('superadminNote');
const isEdit          = <?= $isEdit ? 'true' : 'false' ?>;

// Just updates badges and superadmin UI — never touches checkboxes
function updateRoleBadges(perms, isSuper) {
  superadminNote.classList.toggle('d-none', !isSuper);
  document.querySelectorAll('.perm-cb').forEach(cb => cb.disabled = isSuper);
  districtSection.style.display = isSuper ? 'none' : 'block';

  document.querySelectorAll('.perm-item').forEach(item => {
    const key       = item.dataset.perm;
    const badgeWrap = item.querySelector('.role-badge-wrap');
    const isDefault = perms.includes('all') || perms.includes(key);
    badgeWrap.innerHTML = isDefault
      ? '<span class="badge bg-primary" style="font-size:10px;">role default</span>'
      : '';
  });
}

// On role CHANGE: update badges AND auto-check role defaults (user is picking a new role)
function onRoleChange() {
  const opt    = roleSelect.options[roleSelect.selectedIndex];
  const perms  = JSON.parse(opt?.dataset?.perms ?? '[]');
  const isSuper = opt?.text?.trim() === 'superadmin';

  updateRoleBadges(perms, isSuper);

  // Auto-check defaults for the newly selected role
  document.querySelectorAll('.perm-item').forEach(item => {
    const key       = item.dataset.perm;
    const cb        = item.querySelector('.perm-cb');
    const isDefault = perms.includes('all') || perms.includes(key);
    if (isDefault) cb.checked = true;
  });
}

// On page load: only update badges, never touch checkbox state
// (checkboxes already reflect saved state from PHP)
function initPage() {
  const opt    = roleSelect.options[roleSelect.selectedIndex];
  const perms  = JSON.parse(opt?.dataset?.perms ?? '[]');
  const isSuper = opt?.text?.trim() === 'superadmin';
  updateRoleBadges(perms, isSuper);
}

roleSelect.addEventListener('change', onRoleChange);
initPage();

function selectAllPerms()    { document.querySelectorAll('.perm-cb:not(:disabled)').forEach(cb => cb.checked = true); }
function clearAllPerms()     { document.querySelectorAll('.perm-cb:not(:disabled)').forEach(cb => cb.checked = false); }
function selectAllDistricts(){ document.querySelectorAll('.district-cb').forEach(cb => cb.checked = true); }
function clearAllDistricts() { document.querySelectorAll('.district-cb').forEach(cb => cb.checked = false); }
</script>
