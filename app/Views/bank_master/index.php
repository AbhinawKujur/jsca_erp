<div class="card shadow-sm">
    <div class="card-header bg-white d-flex justify-content-between align-items-center">
        <h6 class="mb-0 fw-bold">Bank Accounts Master</h6>
        <button type="button" class="btn btn-primary btn-sm" onclick="addNewBank()">
            <i class="bi bi-plus-lg"></i> Add New Bank
        </button>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover align-middle" id="bankTable">
                <thead class="table-light">
                    <tr>
                        <th>Bank Name</th>
                        <th>Account No</th>
                        <th>IFSC</th>
                        <th>Type</th>
                        <th>Branch</th>
                        <th>Opening Balance</th>
                        <th>Status</th>
                        <th class="text-center">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($banks as $b): ?>
                        <tr>
                            <td class="fw-bold"><?= esc($b['bank_name']) ?></td>
                            <td><code><?= esc($b['acc_no']) ?></code></td>
                            <td><?= esc($b['ifsc_code']) ?></td>
                            <td><?= esc($b['acc_type']) ?></td>
                            <td><?= esc($b['branch']) ?></td>
                            <td><?= esc($b['opening_bal']) ?></td>
                            <td>
                                <span class="badge <?= $b['status'] == '1' ? 'bg-success' : 'bg-danger' ?>">
                                    <?= $b['status'] == 1 ? 'Active' : 'Inactive' ?>
                                </span>
                            </td>
                            <td class="text-center">
                                <button class="btn btn-outline-warning btn-sm" onclick='editBank(<?= json_encode($b) ?>)'>
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <a href="<?= base_url('finance/bank-master/delete/' . $b['id']) ?>"
                                    class="btn btn-outline-danger btn-sm"
                                    onclick="return confirm('Are you sure?')">
                                    <i class="bi bi-trash"></i>
                                </a>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="modal fade" id="bankModal" tabindex="-1">
    <div class="modal-dialog">
        <form action="<?= base_url('finance/bank-master/save') ?>" method="POST" class="modal-content">
            <?= csrf_field() ?>
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">Add Bank Account</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="id" id="bank_id">

                <div class="row g-3">
                    <div class="col-12">
                        <label class="form-label">Bank Name</label>
                        <input type="text" name="bank_name" id="bank_name" class="form-control" placeholder="e.g. State Bank of India" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Account No</label>
                        <input type="text" name="acc_no" id="acc_no" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">IFSC Code</label>
                        <input type="text" name="ifsc_code" id="ifsc_code" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Branch</label>
                        <input type="text" name="branch" id="branch" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Opening Balance</label>
                        <input type="text" name="opening_bal" id="opening_bal" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Account Type</label>
                        <select name="acc_type" id="acc_type" class="form-select">
                            <option value="Savings">Savings</option>
                            <option value="Current">Current</option>
                            <option value="Overdraft">Overdraft</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Status</label>
                        <select name="status" id="status" class="form-select">
                            <option value="1">Active</option>
                            <option value="0">Inactive</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="submit" class="btn btn-primary">Save Account</button>
            </div>
        </form>
    </div>
</div>

<script>
    function addNewBank() {
        $('#bank_id').val('');
        $('#modalTitle').text('Add Bank Account');
        $('form')[0].reset();
        $('#bankModal').modal('show');
    }

    function editBank(data) {
        $('#bank_id').val(data.id);
        $('#modalTitle').text('Edit Bank Account');
        $('#bank_name').val(data.bank_name);
        $('#acc_no').val(data.acc_no);
        $('#ifsc_code').val(data.ifsc_code);
        $('#acc_type').val(data.acc_type);
        $('#branch').val(data.branch);
        $('#opening_bal').val(data.opening_bal);
        $('#status').val(data.status);
        $('#bankModal').modal('show');
    }
</script>