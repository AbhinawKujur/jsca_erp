<?php // app/Views/admin/user_form.php
$isEdit = !empty($user);
?>

<div class="mb-4">
  <a href="<?= base_url('admin/users') ?>" class="text-decoration-none text-muted small">
    <i class="bi bi-arrow-left me-1"></i> Back to Users
  </a>
  <h4 class="mt-1"><?= $isEdit ? 'Edit User' : 'Create User' ?></h4>
</div>

<div class="row">
  <div class="col-lg-8">
    <div class="card">
      <div class="card-body">
        <form method="post" action="<?= base_url($isEdit ? 'admin/users/update/' . $user['id'] : 'admin/users/store') ?>">
          <?= csrf_field() ?>

          <div class="row g-3 mb-4">
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
              <label class="form-label fw-semibold">Role <span class="text-danger">*</span></label>
              <select name="role_id" class="form-select" required id="roleSelect">
                <option value="">-- Select Role --</option>
                <?php foreach ($roles as $r): ?>
                  <option value="<?= $r['id'] ?>"
                    <?= (old('role_id', $user['role_id'] ?? '') == $r['id']) ? 'selected' : '' ?>>
                    <?= esc($r['name']) ?>
                  </option>
                <?php endforeach; ?>
              </select>
            </div>
            <div class="col-md-6">
              <label class="form-label fw-semibold"><?= $isEdit ? 'New Password' : 'Password' ?> <?= !$isEdit ? '<span class="text-danger">*</span>' : '' ?></label>
              <input type="password" name="password" class="form-control" <?= !$isEdit ? 'required' : '' ?>
                placeholder="<?= $isEdit ? 'Leave blank to keep current' : 'Min 8 characters' ?>">
            </div>
          </div>

          <!-- District Access -->
          <div id="districtSection">
            <hr>
            <div class="d-flex justify-content-between align-items-center mb-3">
              <div>
                <h6 class="mb-0">District Access</h6>
                <small class="text-muted">Select which districts this user can view/manage. Leave empty = no district access.</small>
              </div>
              <div>
                <button type="button" class="btn btn-sm btn-outline-secondary me-1" onclick="selectAllDistricts()">Select All</button>
                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="clearAllDistricts()">Clear All</button>
              </div>
            </div>

            <?php
              // Group districts by zone
              $byZone = [];
              foreach ($districts as $d) {
                  $byZone[$d['zone']][] = $d;
              }
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

          <div class="mt-4 d-flex gap-2">
            <button type="submit" class="btn btn-jsca-primary">
              <i class="bi bi-check-lg me-1"></i> <?= $isEdit ? 'Update User' : 'Create User' ?>
            </button>
            <a href="<?= base_url('admin/users') ?>" class="btn btn-outline-secondary">Cancel</a>
          </div>
        </form>
      </div>
    </div>
  </div>

  <div class="col-lg-4">
    <div class="card">
      <div class="card-header">Role Permissions Reference</div>
      <div class="card-body p-0">
        <table class="table table-sm mb-0">
          <thead><tr><th>Role</th><th>Permissions</th></tr></thead>
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
      <div class="card-header">District Access Note</div>
      <div class="card-body small text-muted">
        <ul class="mb-0 ps-3">
          <li><strong>superadmin</strong> always sees all districts regardless of selection.</li>
          <li>Other roles only see players, coaches, etc. from their assigned districts.</li>
          <li>If no districts are assigned, the user will see no records.</li>
        </ul>
      </div>
    </div>
  </div>
</div>

<script>
  const roleSelect = document.getElementById('roleSelect');
  const districtSection = document.getElementById('districtSection');

  function toggleDistrictSection() {
    const selected = roleSelect.options[roleSelect.selectedIndex]?.text ?? '';
    districtSection.style.display = selected === 'superadmin' ? 'none' : 'block';
  }

  roleSelect.addEventListener('change', toggleDistrictSection);
  toggleDistrictSection();

  function selectAllDistricts() {
    document.querySelectorAll('.district-cb').forEach(cb => cb.checked = true);
  }

  function clearAllDistricts() {
    document.querySelectorAll('.district-cb').forEach(cb => cb.checked = false);
  }
</script>
