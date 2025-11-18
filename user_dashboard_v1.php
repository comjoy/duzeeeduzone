<?php
session_start();
if(!isset($_SESSION['member_loggedin'])){
    header("Location: user_login.php");
    exit;
}
require 'db.php';

$id = $_SESSION['member_id'];

// Fetch logged-in user
$stmt = $mysqli->prepare("SELECT * FROM members WHERE id=?");
$stmt->bind_param("i", $id);
$stmt->execute();
$member = $stmt->get_result()->fetch_assoc();

// -------- Fetch Referral Person -------- //
$ref_name = "Not Available";
$ref_mlm = "N/A";

if (!empty($member['ref_id'])) {
    $stmt2 = $mysqli->prepare("SELECT full_name, mlm_id FROM members WHERE mlm_id=? LIMIT 1");
    $stmt2->bind_param("s", $member['ref_id']);
    $stmt2->execute();
    $refData = $stmt2->get_result()->fetch_assoc();

    if ($refData) {
        $ref_name = $refData['full_name'];
        $ref_mlm  = $refData['mlm_id'];
    }
}
?>
<!DOCTYPE html>
<html>
<head>
<title>User Dashboard</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>

body {
    background: linear-gradient(135deg,#0f172a,#1e293b,#334155);
    font-family: Poppins, sans-serif;
    min-height:100vh;
    padding:40px 0;
}

.dashboard {
    width: 900px;
    margin:auto;
    background: rgba(255,255,255,0.1);
    border-radius:20px;
    padding:40px;
    backdrop-filter: blur(12px);
    color:white;
    box-shadow:0 12px 45px rgba(0,0,0,0.45);
    animation: fade .7s ease;
}

@keyframes fade {
    from { opacity:0; transform:translateY(25px); }
    to { opacity:1; transform:translateY(0); }
}

.profile-header {
    text-align:center;
    padding-bottom:20px;
    border-bottom:1px solid rgba(255,255,255,0.15);
}

.profile-header h2 {
    font-weight:700;
    margin-bottom:5px;
}

.status-badge {
    padding:5px 15px;
    border-radius:20px;
    font-size:14px;
    font-weight:600;
}

.status-red {
    background:#ff4757;
}

.status-prime {
    background:#00c851;
}

.info-grid {
    margin-top:30px;
    display:grid;
    grid-template-columns: repeat(2, 1fr);
    gap:18px;
}

.info-box {
    background: rgba(255,255,255,0.15);
    padding:15px 20px;
    border-radius:12px;
    display:flex;
    flex-direction:column;
    font-size:15px;
}

.info-label {
    opacity:0.8;
    font-size:13px;
}

.buttons {
    margin-top:35px;
    display:flex;
    justify-content:space-between;
}

.btn-edit {
    background:#3b82f6;
    border:none;
    color:white;
    padding:10px 22px;
    border-radius:10px;
    font-weight:600;
}

.btn-edit:hover {
    opacity:0.9;
}

.btn-logout {
    background:#ef4444;
    border:none;
    color:white;
    padding:10px 22px;
    border-radius:10px;
    font-weight:600;
}

.btn-logout:hover {
    opacity:0.9;
}

</style>
</head>

<body>

<div class="dashboard">

    <div class="profile-header">
        <h2>👋 Welcome, <?= $member['full_name'] ?></h2>
        <p>Member ID: <strong><?= $member['mlm_id'] ?></strong></p>

        <?php 
        $statusClass = $member['status']=="prime" ? "status-prime" : "status-red";
        ?>
        <span class="status-badge <?= $statusClass ?>">
            <?= strtoupper($member['status']) ?>
        </span>
    </div>

    <div class="info-grid">

        <div class="info-box">
            <span class="info-label">Phone</span>
            <strong><?= $member['phone'] ?></strong>
        </div>

        <div class="info-box">
            <span class="info-label">Email</span>
            <strong><?= $member['email'] ?></strong>
        </div>

        <div class="info-box">
            <span class="info-label">Country</span>
            <strong><?= $member['country'] ?></strong>
        </div>

        <div class="info-box">
            <span class="info-label">Blood Group</span>
            <strong><?= $member['blood_group'] ?></strong>
        </div>

        <div class="info-box">
            <span class="info-label">Joining Date</span>
            <strong><?= date("d M Y", strtotime($member['joining_date'])) ?></strong>
        </div>

        <div class="info-box">
            <span class="info-label">Recharge Point</span>
            <strong><?= $member['rp'] ?></strong>
        </div>

        <div class="info-box">
            <span class="info-label">Shoping Point</span>
            <strong><?= $member['sp'] ?></strong>
        </div>

        <div class="info-box">
            <span class="info-label">Your Referrer</span>
            <strong><?= $ref_name ?> (<?= $ref_mlm ?>)</strong>
        </div>

    </div>

    <div class="buttons">
        <a href="update_profile.php" class="btn-edit">✏ Edit Profile</a>
        <a href="#" class="btn-edit">Bank Details </a>
         <a href="view_children.php" class="btn-edit"> View Downline</a>
        <a href="user_logout.php" class="btn-logout">🚪 Logout</a>
    </div>

</div>

</body>
</html>
