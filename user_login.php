<?php
session_start();
require 'db.php';

$error = "";

// When login form submitted
if(isset($_POST['phone'], $_POST['password'])){
    $phone = trim($_POST['phone']);
    $pass = trim($_POST['password']);

    $stmt = $mysqli->prepare("SELECT * FROM members WHERE phone = ?");
    $stmt->bind_param("s", $phone);
    $stmt->execute();
    $result = $stmt->get_result();

    if($result->num_rows == 1){
        $row = $result->fetch_assoc();

        if(password_verify($pass, $row['password'])){
            $_SESSION['member_loggedin'] = true;
            $_SESSION['member_id'] = $row['id'];
            header("Location: user_dashboard.php");
            exit;
        } else {
            $error = "Wrong password!";
        }
    } else {
        $error = "Phone number not found!";
    }
}
?>
<!DOCTYPE html>
<html>
<head>
<title>Member Login</title>
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

.login-box{
    width: 420px;
    background: rgba(255,255,255,0.1);
    backdrop-filter: blur(12px);
    padding:35px;
    border-radius:20px;
    box-shadow:0px 10px 40px rgba(0,0,0,0.5);
    animation: fadeIn .6s ease-in-out;
}

@keyframes fadeIn {
    from { opacity:0; transform: translateY(20px); }
    to { opacity:1; transform: translateY(0); }
}

.form-control{
    background: rgba(255,255,255,0.2);
    color:white;
    border:none;
}
.form-control:focus{
    background: rgba(255,255,255,0.3);
    color:white;
}

.eye-btn{
    position:absolute;
    top:9px;
    right:15px;
    cursor:pointer;
    color:white;
}

.btn-theme{
    background: linear-gradient(135deg,#6a11cb,#2575fc);
    color:white;
    font-weight:600;
    border:none;
    border-radius:10px;
}
.btn-theme:hover{
    opacity:0.9;
}

a{
    color:#ffe;
    text-decoration:none;
}
a:hover{
    text-decoration:underline;
}
</style>
</head>

<body>

<div class="login-box">

    <h3 class="text-center mb-4 fw-bold">🔐 Member Login</h3>

    <?php if($error!=""): ?>
    <div class="alert alert-danger"><?= $error ?></div>
    <?php endif; ?>

    <form method="POST">
        <label class="fw-semibold">Phone Number</label>
        <input type="text" name="phone" class="form-control mb-3" placeholder="Enter phone number" required>

        <label class="fw-semibold">Password</label>
        <div class="position-relative">
            <input type="password" id="passField" name="password" class="form-control mb-4" placeholder="Enter password" required>
            <span class="eye-btn" onclick="togglePass()">👁️</span>
        </div>

        <button class="btn btn-theme w-100 mt-2">Login</button>
    </form>

    <div class="text-center mt-4">
        <a href="index.php">⬅ Back to Home</a><br>
        <a href="registration_users.php" class="mt-2 d-inline-block">➕ New User? Register Now</a>
    </div>
<div class="text-center mt-3">
    <a href="forgot_password.php">Forgot Password?</a>
</div>

</div>

<script>
function togglePass(){
    let field = document.getElementById("passField");
    field.type = field.type === "password" ? "text" : "password";
}
</script>

</body>
</html>
