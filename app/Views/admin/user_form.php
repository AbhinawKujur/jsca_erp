<?php // app/Views/admin/user_form.php
$isEdit = !empty($user);

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
  <input type="hidden" name="entity_type" id="entityType" value="">
  <input type="hidden" name="entity_id"   id="entityId"   value="">

  <div class="row g-4">
    <div class="col-lg-8">

      <!-- STEP 1: Role selection (create only) -->
      <?php if (!$isEdit): ?>
      <div class="card mb-4">
        <div class="card-header">Step 1 — Select Role</div>
        <div class="card-body">
          <div class="row g-3">
            <div class="col-md-6">
              <label class="form-label fw-semibold">Role <span class="text-danger">*</span></label>
              <select name="role_id" class="form-select" required id="roleSelect">
                <option value="">— Select Role —</option>
                <?php foreach ($roles as $r): ?>
                  <option value="<?= $r['id'] ?>"
                    data-perms="<?= esc(json_encode(json_decode($r['permissions'] ?? '[]', true))) ?>"
                    data-name="<?= esc($r['name']) ?>">
                    <?= esc($r['name']) ?>
                  </option>
                <?php endforeach; ?>
              </select>
            </div>
            <div class="col-md-6" id="personSelectWrap" style="display:none;">
              <label class="form-label fw-semibold">Select Person <span class="text-muted fw-normal small">(optional — or fill manually)</span></label>
              <select id="personSelect" class="form-select">
                <option value="">— Loading... —</option>
              </select>
              <div class="form-text">Only shows people with no login account yet.</div>
            </div>
          </div>
        </div>
      </div>
      <?php endif; ?>

      <!-- STEP 2: Account Details -->
      <div class="card mb-4" id="accountCard" <?= !$isEdit ? 'style="display:none;"' : '' ?>>
        <div class="card-header"><?= $isEdit ? 'Account Details' : 'Step 2 — Set Email & Password' ?></div>
        <div class="card-body">
          <div class="row g-3">
            <?php if ($isEdit): ?>
            <div class="col-md-6">
              <label class="form-label fw-semibold">Role <span class="text-danger">*</span></label>
              <select name="role_id" class="form-select" required id="roleSelect">
                <option value="">— Select Role —</option>
                <?php foreach ($roles as $r): ?>
                  <option value="<?= $r['id'] ?>"
                    data-perms="<?= esc(json_encode(json_decode($r['permissions'] ?? '[]', true))) ?>"
                    data-name="<?= esc($r['name']) ?>"
                    <?= (old('role_id', $user['role_id'] ?? '') == $r['id']) ? 'selected' : '' ?>>
                    <?= esc($r['name']) ?>
                  </option>
                <?php endforeach; ?>
              </select>
            </div>
            <?php endif; ?>
            <div class="col-md-6">
              <label class="form-label fw-semibold">Full Name <span class="text-danger">*</span></label>
              <input type="text" name="full_name" id="fullName" class="form-control"
                value="<?= esc(old('full_name', $user['full_name'] ?? '')) ?>" required>
            </div>
            <div class="col-md-6">
              <label class="form-label fw-semibold">Phone</label>
              <input type="text" name="phone" id="phone" class="form-control"
                value="<?= esc(old('phone', $user['phone'] ?? '')) ?>">
            </div>
            <div class="col-md-6">
              <label class="form-label fw-semibold">Email <?= !$isEdit ? '<span class="text-danger">*</span>' : '' ?></label>
              <input type="email" name="email" id="email" class="form-control"
                value="<?= esc(old('email', $user['email'] ?? '')) ?>" <?= !$isEdit ? 'required' : '' ?>>
              <?php if ($isEdit): ?>
                <div class="form-text">Changing email + setting a new password will send credentials to the new email.</div>
              <?php endif; ?>
            </div>
            <div class="col-md-6">
              <label class="form-label fw-semibold"><?= $isEdit ? 'New Password' : 'Password' ?> <span class="text-danger">*</span></label>
              <input type="password" name="password" class="form-control" <?= !$isEdit ? 'required' : '' ?>
                placeholder="<?= $isEdit ? 'Leave blank to keep current' : 'Min 8 characters' ?>" minlength="8">
              <?php if (!$isEdit): ?>
                <div class="form-text text-success small"><i class="bi bi-send me-1"></i>Credentials will be emailed on save.</div>
              <?php endif; ?>
            </div>
          </div>
        </div>
      </div>

      <!-- Module Permissions -->
      <div class="card mb-4" id="permissionsCard" <?= !$isEdit ? 'style="display:none;"' : '' ?>>
        <div class="card-header d-flex justify-content-between align-items-center">
          <span>Module Permissions</span>
          <div>
            <button type="button" class="btn btn-sm btn-outline-secondary me-1" onclick="selectAllPerms()">Select All</button>
            <button type="button" class="btn btn-sm btn-outline-secondary" onclick="clearAllPerms()">Clear All</button>
          </div>
        </div>
        <div class="card-body">
          <p class="text-muted small mb-3">
            Items marked <span class="badge bg-primary" style="font-size:10px;">role default</span> come from the selected role. You can grant extras on top.
          </p>
          <div class="row g-2" id="permCheckboxes">
            <?php $currentPerms = old('permissions', $userPerms ?? []); ?>
            <?php foreach ($allPerms as $key => $meta): ?>
              <div class="col-md-4 col-6">
                <div class="border rounded p-2 perm-item" data-perm="<?= $key ?>">
                  <div class="form-check mb-0">
                    <input class="form-check-input perm-cb" type="checkbox"
                      name="permissions[]" value="<?= $key ?>" id="perm_<?= $key ?>"
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
            <i class="bi bi-info-circle me-1"></i> Superadmin has access to <strong>all modules</strong>.
          </div>
        </div>
      </div>

      <!-- District Access -->
      <div class="card mb-4" id="districtSection" <?= !$isEdit ? 'style="display:none;"' : '' ?>>
        <div class="card-header d-flex justify-content-between align-items-center">
          <span>District Access</span>
          <div>
            <button type="button" class="btn btn-sm btn-outline-secondary me-1" onclick="selectAllDistricts()">Select All</button>
            <button type="button" class="btn btn-sm btn-outline-secondary" onclick="clearAllDistricts()">Clear All</button>
          </div>
        </div>
        <div class="card-body">
          <?php $byZone = []; foreach ($districts as $d) $byZone[$d['zone']][] = $d; ?>
          <div class="row g-2">
            <?php foreach ($byZone as $zone => $zoneDists): ?>
              <div class="col-md-4">
                <div class="border rounded p-3">
                  <div class="fw-semibold text-muted small mb-2 text-uppercase"><?= esc($zone) ?> Zone</div>
                  <?php foreach ($zoneDists as $d): ?>
                    <div class="form-check">
                      <input class="form-check-input district-cb" type="checkbox"
                        name="district_ids[]" value="<?= $d['id'] ?>" id="d<?= $d['id'] ?>"
                        <?= in_array($d['id'], $assigned) ? 'checked' : '' ?>>
                      <label class="form-check-label" for="d<?= $d['id'] ?>">
                        <?= esc($d['name']) ?> <span class="text-muted small">(<?= esc($d['code']) ?>)</span>
                      </label>
                    </div>
                  <?php endforeach; ?>
                </div>
              </div>
            <?php endforeach; ?>
          </div>
        </div>
      </div>

      <div class="d-flex gap-2" id="submitWrap" <?= !$isEdit ? 'style="display:none;"' : '' ?>>
        <button type="submit" class="btn btn-jsca-primary">
          <i class="bi bi-check-lg me-1"></i> <?= $isEdit ? 'Update User' : 'Create User & Send Credentials' ?>
        </button>
        <a href="<?= base_url('admin/users') ?>" class="btn btn-outline-secondary">Cancel</a>
      </div>

    </div>

    <!-- Right sidebar -->
    <div class="col-lg-4">
      <div class="card">
        <div class="card-header">Role Defaults</div>
        <div class="card-body p-0">
          <table class="table table-sm mb-0">
            <thead><tr><th>Role</th><th>Permissions</th></tr></thead>
            <tbody>
              <?php foreach ($roles as $r): ?>
                <tr>
                  <td><span class="badge bg-secondary"><?= esc($r['name']) ?></span></td>
                  <td class="small text-muted"><?= esc(implode(', ', json_decode($r['permissions'], true) ?? [])) ?></td>
                </tr>
              <?php endforeach; ?>
            </tbody>
          </table>
        </div>
      </div>
      <?php if (!$isEdit): ?>
      <div class="card mt-3">
        <div class="card-header">How it works</div>
        <div class="card-body small text-muted">
          <ol class="ps-3 mb-0">
            <li>Select a <strong>role</strong></li>
            <li>Pick a person from the dropdown <em>(or skip to fill manually)</em></li>
            <li>Their details auto-fill</li>
            <li>Set email + password</li>
            <li>Save — credentials emailed automatically</li>
          </ol>
        </div>
      </div>
      <?php endif; ?>
    </div>
  </div>
</form>

<script>
const roleSelect      = document.getElementById('roleSelect');
const districtSection = document.getElementById('districtSection');
const superadminNote  = document.getElementById('superadminNote');
const isEdit          = <?= $isEdit ? 'true' : 'false' ?>;

// Roles that have linked people in officials/players tables
const linkedRoles = ['umpire','scorer','referee','match_referee','selector','data_entry'];

function updateRoleBadges(perms, isSuper) {
  superadminNote.classList.toggle('d-none', !isSuper);
  document.querySelectorAll('.perm-cb').forEach(cb => cb.disabled = isSuper);
  districtSection.style.display = isSuper ? 'none' : 'block';
  document.querySelectorAll('.perm-item').forEach(item => {
    const key = item.dataset.perm;
    const badgeWrap = item.querySelector('.role-badge-wrap');
    const isDefault = perms.includes('all') || perms.includes(key);
    badgeWrap.innerHTML = isDefault ? '<span class="badge bg-primary" style="font-size:10px;">role default</span>' : '';
  });
}

function onRoleChange() {
  const opt     = roleSelect.options[roleSelect.selectedIndex];
  const perms   = JSON.parse(opt?.dataset?.perms ?? '[]');
  const isSuper = opt?.dataset?.name === 'superadmin';
  const roleName = opt?.dataset?.name ?? '';

  updateRoleBadges(perms, isSuper);

  if (!isEdit) {
    // Show/hide person picker
    const personWrap = document.getElementById('personSelectWrap');
    if (linkedRoles.includes(roleName) && opt.value) {
      personWrap.style.display = 'block';
      loadPeople(roleName);
    } else {
      personWrap.style.display = 'none';
      // Show form directly for admin/accounts roles
      if (opt.value) showAccountForm();
    }

    // Auto-check permissions
    document.querySelectorAll('.perm-item').forEach(item => {
      const cb = item.querySelector('.perm-cb');
      const isDefault = perms.includes('all') || perms.includes(item.dataset.perm);
      if (isDefault) cb.checked = true;
    });
  }
}

function loadPeople(roleName) {
  const select = document.getElementById('personSelect');
  select.innerHTML = '<option value="">— Loading... —</option>';

  fetch(`<?= base_url('admin/users/people-by-role') ?>?role=${roleName}`)
    .then(r => r.json())
    .then(people => {
      select.innerHTML = '<option value="">— Select person (or fill manually below) —</option>';
      people.forEach(p => {
        const opt = document.createElement('option');
        opt.value = p.id;
        opt.dataset.name  = p.full_name;
        opt.dataset.phone = p.phone ?? '';
        opt.dataset.email = p.email ?? '';
        opt.dataset.entity = p.entity_type;
        opt.textContent = `${p.full_name} (${p.jsca_id})`;
        select.appendChild(opt);
      });
      if (people.length === 0) {
        select.innerHTML = '<option value="">— No unlinked people found for this role —</option>';
      }
      showAccountForm();
    });

  select.addEventListener('change', function() {
    const opt = this.options[this.selectedIndex];
    if (opt.value) {
      document.getElementById('fullName').value  = opt.dataset.name  ?? '';
      document.getElementById('phone').value     = opt.dataset.phone ?? '';
      document.getElementById('email').value     = opt.dataset.email ?? '';
      document.getElementById('entityType').value = opt.dataset.entity ?? '';
      document.getElementById('entityId').value   = opt.value;
    } else {
      document.getElementById('entityType').value = '';
      document.getElementById('entityId').value   = '';
    }
  });
}

function showAccountForm() {
  document.getElementById('accountCard').style.display    = 'block';
  document.getElementById('permissionsCard').style.display = 'block';
  document.getElementById('districtSection').style.display = 'block';
  document.getElementById('submitWrap').style.display      = 'flex';
}

function initPage() {
  const opt   = roleSelect.options[roleSelect.selectedIndex];
  const perms = JSON.parse(opt?.dataset?.perms ?? '[]');
  const isSuper = opt?.dataset?.name === 'superadmin';
  updateRoleBadges(perms, isSuper);
}

roleSelect.addEventListener('change', onRoleChange);
initPage();

function selectAllPerms()    { document.querySelectorAll('.perm-cb:not(:disabled)').forEach(cb => cb.checked = true); }
function clearAllPerms()     { document.querySelectorAll('.perm-cb:not(:disabled)').forEach(cb => cb.checked = false); }
function selectAllDistricts(){ document.querySelectorAll('.district-cb').forEach(cb => cb.checked = true); }
function clearAllDistricts() { document.querySelectorAll('.district-cb').forEach(cb => cb.checked = false); }
</script>
