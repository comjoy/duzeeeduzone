<?php
session_start();
if(!isset($_SESSION['member_loggedin'])){
    header("Location: user_login.php");
    exit;
}
require 'db.php';

$id = $_SESSION['member_id'];

$success = "";
$error = "";

// Fetch existing bank details
$stmt = $mysqli->prepare("SELECT account_holder, bank_name, account_number, ifsc_code, branch_name FROM members WHERE id=?");
$stmt->bind_param("i", $id);
$stmt->execute();
$data = $stmt->get_result()->fetch_assoc();

// Handle Update
if(isset($_POST['update_bank'])){
    $account_holder = trim($_POST['account_holder']);
    $bank_name      = trim($_POST['bank_name']);
    $account_number = trim($_POST['account_number']);
    $ifsc_code      = trim($_POST['ifsc_code']);
    $branch_name    = trim($_POST['branch_name']);

    $stmt2 = $mysqli->prepare("UPDATE members SET account_holder=?, bank_name=?, account_number=?, ifsc_code=?, branch_name=? WHERE id=?");
    $stmt2->bind_param("sssssi", $account_holder, $bank_name, $account_number, $ifsc_code, $branch_name, $id);

    if($stmt2->execute()){
        $success = "Bank details updated successfully!";
          echo "<script>
            setTimeout(function(){
                window.location.href = 'user_dashboard.php';
            }, 1800);
        </script>";
    } else {
        $error = "Something went wrong!";
    }
}
?>
<!doctype html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Bank Details</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

<style>
body{
    background:#f5f5f5;
}
.card{
    border-radius:12px;
}
</style>

</head>

<body>

<div class="container py-4">

    <a href="user_dashboard.php" class="btn btn-warning mb-3"><i class="fa fa-arrow-left"></i> Back</a>

    <div class="card shadow p-4">
        <h4 class="mb-3"><i class="fa fa-bank"></i> Bank Details</h4>

        <?php if($success): ?>
            <div class="alert alert-success"><?php echo $success; ?></div>
        <?php endif; ?>

        <?php if($error): ?>
            <div class="alert alert-danger"><?php echo $error; ?></div>
        <?php endif; ?>

        <form method="POST">
            <div class="mb-3">
                <label class="form-label">Account Holder Name</label>
                <input type="text" name="account_holder" class="form-control"
                     value="<?php echo htmlspecialchars($data['account_holder']); ?>">
            </div>
            <div class="mb-3">
                <label class="form-label">Bank Name</label>
                <input type="text" name="bank_name" class="form-control"
                       value="<?php echo htmlspecialchars($data['bank_name']); ?>">
            </div>
            <div class="mb-3">
                <label class="form-label">Account Number</label>
                <input type="text" name="account_number" class="form-control"
                       value="<?php echo htmlspecialchars($data['account_number']); ?>">
            </div>
            <div class="mb-3">
                <label class="form-label">IFSC Code</label>
                <input type="text" name="ifsc_code" class="form-control"
                       value="<?php echo htmlspecialchars($data['ifsc_code']); ?>">
            </div>
            <div class="mb-3">
                <label class="form-label">Branch Name</label>
                <input type="text" name="branch_name" class="form-control"
                       value="<?php echo htmlspecialchars($data['branch_name']); ?>">
            </div>
            <button type="submit" name="update_bank" class="btn btn-primary w-100">
                <i class="fa fa-save"></i> Update Details
            </button>
        </form>

    </div>
</div>

</body>
</html>
