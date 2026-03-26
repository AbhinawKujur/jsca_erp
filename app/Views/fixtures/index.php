<?php // app/Views/fixtures/index.php ?>

<div class="d-flex justify-content-between align-items-center mb-4">
  <h4 class="mb-0 fw-bold">Fixtures</h4>
  <?php if ($canManage): ?>
    <a href="<?= base_url('fixtures/create' . ($tournamentId ? '?tournament_id=' . $tournamentId : '')) ?>" class="btn btn-jsca-primary btn-sm">
      <i class="bi bi-plus-circle me-1"></i> Create Fixture
    </a>
  <?php endif; ?>
</div>

<!-- Filters -->
<div class="card mb-4">
  <div class="card-body">
    <form method="get" class="row g-3">
      <div class="col-md-4">
        <label class="form-label small">Tournament</label>
        <select name="tournament_id" class="form-select form-select-sm">
          <option value="">— All Tournaments —</option>
          <?php foreach ($tournaments as $t): ?>
            <option value="<?= $t['id'] ?>" <?= $tournamentId == $t['id'] ? 'selected' : '' ?>>
              <?= esc($t['name']) ?>
            </option>
          <?php endforeach; ?>
        </select>
      </div>
      <div class="col-md-3">
        <label class="form-label small">Status</label>
        <select name="status" class="form-select form-select-sm">
          <option value="">— All —</option>
          <?php foreach (['Scheduled', 'Live', 'Completed', 'Abandoned', 'Postponed'] as $s): ?>
            <option value="<?= $s ?>" <?= $status === $s ? 'selected' : '' ?>><?= $s ?></option>
          <?php endforeach; ?>
        </select>
      </div>
      <div class="col-md-3">
        <label class="form-label small">Date</label>
        <input type="date" name="date" class="form-control form-control-sm" value="<?= esc($date ?? '') ?>">
      </div>
      <div class="col-md-2 d-flex align-items-end">
        <button type="submit" class="btn btn-sm btn-secondary w-100">Filter</button>
      </div>
    </form>
  </div>
</div>

<!-- Fixtures List -->
<?php if (empty($fixtures)): ?>
  <div class="alert alert-info">
    <i class="bi bi-info-circle me-2"></i>
    No fixtures found. <?= $canManage ? '<a href="' . base_url('fixtures/create') . '">Create one</a>' : '' ?>
  </div>
<?php else: ?>
  <div class="card">
    <div class="card-body p-0">
      <div class="table-responsive">
        <table class="table table-hover mb-0">
          <thead>
            <tr>
              <th>Match</th>
              <th>Teams</th>
              <th>Date & Time</th>
              <th>Venue</th>
              <th>Status</th>
              <th>Result</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <?php foreach ($fixtures as $f): ?>
              <tr>
                <td>
                  <div class="fw-semibold"><?= esc($f['match_number']) ?></div>
                  <div class="small text-muted"><?= esc($f['tournament_name']) ?></div>
                </td>
                <td>
                  <div><?= esc($f['team_a_name']) ?></div>
                  <div class="text-muted small">vs</div>
                  <div><?= esc($f['team_b_name']) ?></div>
                </td>
                <td>
                  <div><?= date('d M Y', strtotime($f['match_date'])) ?></div>
                  <div class="small text-muted"><?= date('h:i A', strtotime($f['match_time'])) ?></div>
                </td>
                <td class="small"><?= esc($f['venue_name'] ?? '—') ?></td>
                <td>
                  <?php
                    $badge = match($f['status']) {
                      'Scheduled' => 'bg-primary',
                      'Live'      => 'bg-success',
                      'Completed' => 'bg-secondary',
                      'Abandoned' => 'bg-warning text-dark',
                      'Postponed' => 'bg-danger',
                      default     => 'bg-light text-dark'
                    };
                  ?>
                  <span class="badge <?= $badge ?>"><?= esc($f['status']) ?></span>
                </td>
                <td class="small"><?= esc($f['result_summary'] ?? '—') ?></td>
                <td class="text-end">
                  <a href="<?= base_url('fixtures/view/' . $f['id']) ?>" class="btn btn-sm btn-outline-primary">
                    <i class="bi bi-eye"></i>
                  </a>
                </td>
              </tr>
            <?php endforeach; ?>
          </tbody>
        </table>
      </div>
    </div>
  </div>
<?php endif; ?>
