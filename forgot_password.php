<?php
require 'db.php';
session_start();

$msg = "";
$show_reset_form = false;
$member_id = "";

// Step 1: verify email + phone
if(isset($_POST['check'])){
    $email = trim($_POST['email']);
    $phone = trim($_POST['phone']);

    $stmt = $mysqli->prepare("SELECT id FROM members WHERE email=? AND phone=?");
    $stmt->bind_param("ss", $email, $phone);
    $stmt->execute();
    $res = $stmt->get_result();

    if($res->num_rows == 1){
        $row = $res->fetch_assoc();
        $member_id = $row['id'];
        $show_reset_form = true;
    } else {
        $msg = "No account found with this Email + Phone!";
    }
}

// Step 2: Update password
if(isset($_POST['reset_password'])){
    $id = $_POST['member_id'];
    $newpass = password_hash($_POST['password'], PASSWORD_DEFAULT);

    $stmt = $mysqli->prepare("UPDATE members SET password=? WHERE id=?");
    $stmt->bind_param("si", $newpass, $id);

    if($stmt->execute()){
        $msg = "Password updated successfully! <a href='user_login.php' class='text-light fw-bold'>Login Now</a>";
    } else {
        $msg = "Something went wrong!";
    }
}
?>
<!DOCTYPE html>
<html>
<head>
<title>Forgot Password</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body{
    background: linear-gradient(120deg,#0f2027,#203a43,#2c5364);
    height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    font-family:poppins, sans-serif;
    color:white;
}

.card-box{
    width: 450px;
    background: rgba(255,255,255,0.12);
    backdrop-filter: blur(14px);
    border-radius:22px;
    padding:35px;
    box-shadow:0 10px 45px rgba(0,0,0,0.55);
    animation: fadeIn .7s ease-in-out;
}

@keyframes fadeIn {
    from{ opacity:0; transform: translateY(20px); }
    to{ opacity:1; transform: translateY(0); }
}

.form-control{
    background: rgba(255,255,255,0.2);
    color:white;
    border:none;
}
.form-control::placeholder{
    color:#eee;
}
.form-control:focus{
    background: rgba(255,255,255,0.3);
    color:white;
}

.btn-theme{
    background: linear-gradient(135deg,#6a11cb,#2575fc);
    color:white;
    font-weight:600;
    border:none;
    padding:10px;
    border-radius:12px;
    transition: 0.3s;
}
.btn-theme:hover{
    transform: scale(1.04);
    opacity:0.9;
}

a{
    color:#d5e9ff;
}
a:hover{
    text-decoration:underline;
}
</style>
</head>

<body>

<div class="card-box">

    <h3 class="text-center fw-bold mb-4">🔑 Forgot Password</h3>

    <?php if($msg!=""): ?>
    <div class="alert alert-info"><?php echo $msg; ?></div>
    <?php endif; ?>

    <?php if(!$show_reset_form): ?>
    <!-- STEP 1: Verify Email + Phone -->
    <form method="POST">

        <label class="fw-semibold">Registered Email</label>
        <input type="email" name="email" class="form-control mb-3" placeholder="Enter your email" required>

        <label class="fw-semibold">Registered Phone</label>
        <input type="text" name="phone" class="form-control mb-4" placeholder="Enter your phone number" required>

        <button name="check" class="btn btn-theme w-100">Verify Account</button>
    </form>

    <?php else: ?>
    <!-- STEP 2: Reset Password -->
    <form method="POST">

        <input type="hidden" name="member_id" value="<?= $member_id ?>">

        <label class="fw-semibold">New Password</label>
        <input type="password" name="password" class="form-control mb-4" placeholder="Enter new password" required>

        <button name="reset_password" class="btn btn-theme w-100">Update Password</button>
    </form>
    <?php endif; ?>

    <div class="text-center mt-4">
        <a href="user_login.php">⬅ Back to Login</a>
    </div>

</div>

</body>
</html>
