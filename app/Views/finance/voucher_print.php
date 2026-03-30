<style>
    @media print {
        .no-print { display: none !important; }
        @page { size: A4; margin: 1cm; }
        body { font-family: 'Times New Roman', serif; color: #000; background: #fff; }
    }

    .print-wrapper {
        max-width: 900px;
        margin: auto;
        padding: 20px;
        border: 1px solid #eee; /* Light border for screen view */
    }

    /* Official Letterhead Style */
    .voucher-header {
        border-bottom: 3px solid #1a3a5c;
        margin-bottom: 20px;
        padding-bottom: 10px;
    }

    .jsca-title {
        font-size: 24px;
        font-weight: bold;
        color: #1a3a5c;
        text-transform: uppercase;
        margin: 0;
    }

    .voucher-type-label {
        background: #1a3a5c;
        color: #fff;
        padding: 5px 15px;
        display: inline-block;
        margin-top: 10px;
        font-weight: bold;
        border-radius: 4px;
    }

    .info-table {
        width: 100%;
        margin-bottom: 20px;
    }

    .info-table td {
        padding: 5px;
        vertical-align: top;
        font-size: 14px;
    }

    /* The Main Transaction Table */
    .items-table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 20px;
    }

    .items-table th {
        background: #f2f2f2 !important;
        border: 1px solid #000;
        padding: 10px;
        text-align: left;
        font-size: 13px;
        text-transform: uppercase;
    }

    .items-table td {
        border: 1px solid #000;
        padding: 10px;
        font-size: 14px;
    }

    .total-row {
        font-weight: bold;
        background: #f9f9f9;
    }

    .signature-section {
        margin-top: 80px;
        display: flex;
        justify-content: space-between;
    }

    .sig-box {
        width: 200px;
        text-align: center;
        border-top: 1px solid #000;
        padding-top: 5px;
        font-weight: bold;
        font-size: 13px;
    }
    .logo{
        float: right;
    }
</style>

<div class="print-wrapper">
     <div class="logo">
            <img src="<?= base_url('jsca-logo.png') ?>" style="height: 80px;">
        </div>
    <div class="voucher-header d-flex justify-content-between align-items-center">
        <div>
            <h1 class="jsca-title">Jharkhand State Cricket Association</h1>
            <p class="mb-0">JSCA International Stadium Complex, Dhurwa, Ranchi - 834004</p>
            <div class="voucher-type-label"><?= strtoupper($v['voucher_type']) ?> VOUCHER</div>
        </div>
       
    </div>

    <table class="info-table">
        <tr>
            <td width="15%"><strong>Voucher No:</strong></td>
            <td width="35%"><?= $v['voucher_number'] ?></td>
            <td width="15%"><strong>Date:</strong></td>
            <td width="35%"><?= date('d-M-Y', strtotime($v['voucher_date'])) ?></td>
        </tr>
        <tr>
            <td><strong>Payee:</strong></td>
            <td><?= $v['payee_name'] ?></td>
            <td><strong>Payment Mode:</strong></td>
            <td><?= $v['payment_mode'] ?> <?= $v['payment_ref'] ? '('.$v['payment_ref'].')' : '' ?></td>
        </tr>
    </table>

    <table class="items-table">
        <thead>
            <tr>
                <th width="5%">SL</th>
                <th width="65%">Particulars / Ledger Account & Narration</th>
                <th width="30%" class="text-end">Amount (₹)</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($items as $idx => $item): ?>
            <tr>
                <td class="text-center"><?= $idx + 1 ?></td>
                <td>
                    <strong><?= $item['ledger_name'] ?></strong><br>
                    <small style="font-style: italic; color: #555;"><?= $item['narration'] ?></small>
                </td>
                <td class="text-end"><?= number_format(max($item['dr_amount'], $item['cr_amount']), 2) ?></td>
            </tr>
            <?php endforeach; ?>
            <tr class="total-row">
                <td colspan="2" class="text-end">TOTAL</td>
                <td class="text-end">₹ <?= number_format($v['total_amount'], 2) ?></td>
            </tr>
        </tbody>
    </table>

    <div style="border: 1px solid #000; padding: 10px; margin-bottom: 40px;">
        <strong>Amount in words:</strong> Rupees <?= ucwords($amountWords) ?> Only
    </div>

    <div class="signature-section">
        <div class="sig-box">Prepared By</div>
        <div class="sig-box">Checked By</div>
        <div class="sig-box">Authorized Signatory</div>
    </div>
</div>