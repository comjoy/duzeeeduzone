<?php
session_start();
if(!isset($_SESSION['member_loggedin'])){
    header("Location: user_login.php");
    exit;
}
require 'db.php';

$id = $_SESSION['member_id'];

$stmt = $mysqli->prepare("SELECT * FROM members WHERE id=?");
$stmt->bind_param("i", $id);
$stmt->execute();
$data = $stmt->get_result()->fetch_assoc();

$success = "";
$error = "";

if(isset($_POST['full_name'], $_POST['phone'], $_POST['email'])){

    $full_name = trim($_POST['full_name']);
    $phone = trim($_POST['phone']);
    $email = trim($_POST['email']);
    $country = trim($_POST['country']);
    $blood_group = trim($_POST['blood_group']);

    // If password entered → update with new hash
    if(!empty($_POST['password'])){
        $newpass = password_hash($_POST['password'], PASSWORD_BCRYPT);

        $stmt = $mysqli->prepare("UPDATE members 
            SET full_name=?, phone=?, email=?, country=?, blood_group=?, password=? 
            WHERE id=?");

        $stmt->bind_param("ssssssi", $full_name, $phone, $email, $country, $blood_group, $newpass, $id);

    } else {
        // Update without password
        $stmt = $mysqli->prepare("UPDATE members 
            SET full_name=?, phone=?, email=?, country=?, blood_group=? 
            WHERE id=?");

        $stmt->bind_param("sssssi", $full_name, $phone, $email, $country, $blood_group, $id);
    }

    if($stmt->execute()){
        $success = "Profile Updated Successfully!";

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


<!DOCTYPE html>
<html>
<head>
<title>Update Profile</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

<style>
body {
    background: linear-gradient(135deg, #1e3c72, #2a5298);
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    font-family: 'Poppins', sans-serif;
}

/* Glass Card */
.glass-card {
    background: rgba(255, 255, 255, 0.15);
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    border-radius: 22px;
    padding: 40px;
    width: 450px;
    color: white;
    box-shadow: 0 8px 32px rgba(0,0,0,0.3);
    animation: fadeIn 0.8s ease;
}

/* Labels */
.form-label {
    font-weight: 600;
    color: #ffffff;
    margin-bottom: 6px;
    font-size: 15px;
}

/* Input Box */
.form-control {
    height: 48px;
    border-radius: 14px;
    border: none;
    padding-left: 45px;
    background: rgba(255,255,255,0.2);
    color: #fff;
}
.form-control::placeholder {
    color: rgba(255,255,255,0.7);
}
.form-control:focus {
    box-shadow: none;
    border: 2px solid #fff;
    background: rgba(255,255,255,0.25);
}

/* Icons */
.input-icon {
    position: absolute;
    left: 15px;
    top: 40px;
    font-size: 18px;
    color: #fff;
}

/* Save Button */
.btn-save {
    background: linear-gradient(135deg, #00d4ff, #007bff);
    border: none;
    color: white;
    height: 50px;
    font-size: 17px;
    border-radius: 14px;
    transition: 0.3s;
}
.btn-save:hover {
    opacity: 0.8;
}

/* Back Button */
.back-btn {
    background: rgba(255,255,255,0.2);
    border: none;
    color: white;
    height: 48px;
    border-radius: 12px;
}
.back-btn:hover {
    background: rgba(255,255,255,0.35);
}

/* Title */
.title {
    font-weight: 700;
    font-size: 28px;
    margin-bottom: 25px;
    text-align: center;
}

/* Fade Effect */
@keyframes fadeIn {
    from { opacity: 0; transform: translateY(15px); }
    to { opacity: 1; transform: translateY(0); }
}

.toggle-eye {
    position: absolute;
    right: 5px;
    top: 17px;
    font-size: 18px;
    color: #fff;
    cursor: pointer;
}

</style>
</head>

<body>

<div class="glass-card">

    <div class="title"><i class="fa-solid fa-user-pen"></i> Update Profile</div>

    <?php if(!empty($success)): ?>
        <div class="alert alert-success text-dark"><?= $success ?></div>
    <?php endif; ?>

    <?php if(!empty($error)): ?>
        <div class="alert alert-danger text-dark"><?= $error ?></div>
    <?php endif; ?>

    <form method="POST">

        <!-- FULL NAME -->
        <label class="form-label">Full Name</label> <br>
       
        <div class="mb-3 position-relative">
            
            <input type="text" name="full_name" class="form-control"
                value="<?= $data['full_name'] ?>" placeholder="Enter your full name" required>
        </div>

        <!-- PHONE -->
        <label class="form-label">Phone Number</label>
        <div class="mb-3 position-relative">
            
            <input type="text" name="phone" class="form-control"
                value="<?= $data['phone'] ?>" placeholder="Enter your phone number" required>
        </div>

        <!-- EMAIL -->
        <label class="form-label">Email Address</label>
        <div class="mb-3 position-relative">
          
            <input type="email" name="email" class="form-control"
                value="<?= $data['email'] ?>" placeholder="Enter your email">
        </div>

         <!-- country -->
        <label class="form-label">Country</label>
<div class="mb-3 position-relative">
    <select name="country" class="form-control" required>
        <option value="">Select Country</option>
        <option value="Nepal" <?= ($data['country']=="Nepal")?"selected":"" ?>>Nepal</option>
        <option value="India" <?= ($data['country']=="India")?"selected":"" ?>>India</option>
        <option value="Bhutan" <?= ($data['country']=="Bhutan")?"selected":"" ?>>Bhutan</option>
        <option value="SriLanka" <?= ($data['country']=="SriLanka")?"selected":"" ?>>SriLanka</option>
        <option value="Bangladesh" <?= ($data['country']=="Bangladesh")?"selected":"" ?>>Bangladesh</option>
        <option value="Myanmar" <?= ($data['country']=="Myanmar")?"selected":"" ?>>Myanmar</option>
        <option value="Afganistan" <?= ($data['country']=="Afganistan")?"selected":"" ?>>Afganistan</option>
        <option value="China" <?= ($data['country']=="China")?"selected":"" ?>>China</option>
    </select>
</div>

         <!-- blood group -->
       <label class="form-label">Blood Group</label>
<div class="mb-3 position-relative">
    <select name="blood_group" class="form-control" required>
        <option value="">Select Blood Group</option>
        <option value="A+" <?= ($data['blood_group']=="A+")?"selected":"" ?>>A+</option>
        <option value="A-" <?= ($data['blood_group']=="A-")?"selected":"" ?>>A-</option>
        <option value="B+" <?= ($data['blood_group']=="B+")?"selected":"" ?>>B+</option>
        <option value="B-" <?= ($data['blood_group']=="B-")?"selected":"" ?>>B-</option>
        <option value="AB+" <?= ($data['blood_group']=="AB+")?"selected":"" ?>>AB+</option>
        <option value="AB-" <?= ($data['blood_group']=="AB-")?"selected":"" ?>>AB-</option>
        <option value="O+" <?= ($data['blood_group']=="O+")?"selected":"" ?>>O+</option>
        <option value="O-" <?= ($data['blood_group']=="O-")?"selected":"" ?>>O-</option>
    </select>
</div>

        <!-- PASSWORD -->
<label class="form-label">Password (leave blank to keep same)</label>
<div class="mb-3 position-relative">
    
    <input type="password" name="password" id="passwordField" class="form-control"
        placeholder="Enter new password">

    <!-- Eye Icon -->
    <i class="fa-solid fa-eye toggle-eye" id="togglePassword"></i>
</div>


        <button class="btn btn-save w-100 mt-2">Save Changes</button>

    </form>

    <a href="user_dashboard.php">
        <button class="back-btn w-100 mt-3">
            <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
        </button>
    </a>

</div>

<script>
document.getElementById("togglePassword").addEventListener("click", function () {
    const pwd = document.getElementById("passwordField");
    const type = pwd.getAttribute("type") === "password" ? "text" : "password";
    pwd.setAttribute("type", type);

    // Toggle icon eye <-> eye-slash
    this.classList.toggle("fa-eye-slash");
});
</script>

</body>
</html>
