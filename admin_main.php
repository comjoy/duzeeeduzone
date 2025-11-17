<?php
session_start();
if (!isset($_SESSION['admin_loggedin']) || $_SESSION['admin_loggedin'] !== true) {
    header("Location: admin_login.php");
    exit;
}

require 'db.php';

$total_result = $mysqli->query("SELECT COUNT(*) AS total FROM members");
$total = $total_result ? $total_result->fetch_assoc()['total'] : 0;

$red_result = $mysqli->query("SELECT COUNT(*) AS c FROM members WHERE status='red'");
$red = $red_result ? $red_result->fetch_assoc()['c'] : 0;

$prime_result = $mysqli->query("SELECT COUNT(*) AS c FROM members WHERE status='prime'");
$prime = $prime_result ? $prime_result->fetch_assoc()['c'] : 0;

$today = date('Y-m-d');
$today_result = $mysqli->query("SELECT COUNT(*) AS c FROM members WHERE DATE(joining_date)='$today'");
$today_count = $today_result ? $today_result->fetch_assoc()['c'] : 0;

$current_month = date('Y-m');
$month_result = $mysqli->query("SELECT COUNT(*) AS c FROM members WHERE DATE_FORMAT(joining_date, '%Y-%m')='$current_month'");
$month_count = $month_result ? $month_result->fetch_assoc()['c'] : 0;

$old_result = $mysqli->query("
    SELECT COUNT(*) AS c 
    FROM members 
    WHERE joining_date < DATE_SUB(CURDATE(), INTERVAL 15 DAY)
");
$old_count = $old_result ? $old_result->fetch_assoc()['c'] : 0;


$mysqli->close();
?>



<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin Dashboard | NPMLM System</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
  <style>
    body { background-color: #f8f9fa; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
    .sidebar { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; min-height: 100vh; padding: 20px 0; box-shadow: 2px 0 10px rgba(0,0,0,0.1); }
    .sidebar a { display: block; color: white; padding: 12px 20px; text-decoration: none; transition: all 0.3s; border-left: 4px solid transparent; }
    .sidebar a:hover, .sidebar a.active { background: rgba(255,255,255,0.1); border-left: 4px solid #ffd700; color: #ffd700; }
    .card { border: none; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); transition: transform 0.3s; }
    .card:hover { transform: translateY(-5px); }
    .bg-primary { background: linear-gradient(135deg, #667eea, #764ba2) !important; }
    .bg-danger { background: linear-gradient(135deg, #f093fb, #f5576c) !important; }
    .bg-warning { background: linear-gradient(135deg, #ffd89b, #19547b) !important; }
    .bg-success { background: linear-gradient(135deg, #4facfe, #00f2fe) !important; }
  </style>
</head>
<body>
<div class="container-fluid">
  <div class="row">
    <div class="col-md-2 sidebar">
      <h4 class="text-center mb-4"><i class="bi bi-diagram-3"></i> Admin Panel</h4>
      <a href="admin_main.php" class="active"><i class="bi bi-speedometer2"></i> Dashboard</a>
      <a href="registration.php"><i class="bi bi-people"></i> Registration</a>
      <a href="view_members.php"><i class="bi bi-graph-up"></i> All Members</a>  
      <a href="view_referral.php"><i class="bi bi-graph-up"></i> View Referrals</a>  
<style>
.submenu {
    display: none;
    margin-left: 25px;
}
.submenu a {
    display: block;
    padding: 4px 0;
}
</style>

<!-- Normal Link (as it is) -->
<a href="view_tree_bubble.php">
    <i class="bi bi-search"></i> Search Member (Bubble)
</a>

<!-- Toggle Link (DO NOT OPEN PAGE) -->
<a href="#" class="toggle" data-target="#submenu1">
    <i class="bi bi-search"></i> Search Member
</a>
<!-- Submenu for Table -->
<div id="submenu1" class="submenu">
    <a href="member_search.php">➤ View Table</a>
    <a href="view_tree.php">➤ View Tree</a>
</div>

      <a href="logout.php"><i class="bi bi-box-arrow-right"></i> Logout</a>
    </div>
    <div class="col-md-10 p-4">
      <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold"><i class="bi bi-speedometer2 text-primary"></i> Dashboard Overview</h2>
        <div class="text-end"><span class="text-muted">Welcome, Admin</span><div class="badge bg-success">Online</div></div>
      </div>
      <div class="row g-3 mb-4">
        <div class="col-md-3"><div class="card text-center p-3 bg-primary text-white"><h5><i class="bi bi-people-fill"></i> Total Members</h5><h2><?= $total ?></h2></div></div>
        <div class="col-md-3"><div class="card text-center p-3 bg-danger text-white"><h5><i class="bi bi-circle-fill"></i> Red Members</h5><h2><?= $red ?></h2></div></div>
        <div class="col-md-3"><div class="card text-center p-3 bg-warning text-white"><h5><i class="bi bi-star-fill"></i> Prime Members</h5><h2><?= $prime ?></h2></div></div>
        <div class="col-md-3"><div class="card text-center p-3 bg-success text-white"><h5><i class="bi bi-graph-up-arrow"></i> Today's Registrations</h5><h2><?= $today_count ?></h2></div></div>
      </div>
      <div class="row g-3 mb-5">
  <div class="col-md-4">
  <div class="card text-center p-3 border-info">
    <h5> <span style="color:blue;" > Today Registered </span> <br>
      <?= date("d M, Y") ?> 
    </h5>
    <h2 class="text-info"><?= $today_count ?></h2>
  </div>
</div>

 <div class="col-md-4">
  <div class="card text-center p-3 border-primary">
    <h5> <span style="color:blue;" > This month Registered </span> <br>
      <?= date("F, Y") ?>
    </h5>
    <h2 class="text-primary"><?= $month_count ?></h2>
  </div>
</div>

  <div class="col-md-4">
    <a href="old_members.php" style="text-decoration:none;">
      <div class="card text-center p-3 border-danger" style="cursor:pointer;">
        <h5><i class="bi bi-clock-history text-danger"></i> 15+ Days Old Members</h5>
        <h2 class="text-danger"><?= $old_count ?></h2>
      </div>
    </a>
  </div>
</div>

      <footer class="text-center mt-5 text-secondary"><small>© <?= date('Y') ?> Dujee Eduzone | All rights reserved.</small></footer>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.querySelectorAll('.toggle').forEach(link => {
    link.addEventListener('click', function(e) {
        e.preventDefault();

        // Close all other menus
        document.querySelectorAll('.submenu').forEach(menu => {
            if (menu.id !== this.dataset.target.substring(1)) {
                menu.style.display = "none";
            }
        });

        // Toggle current submenu
        let menu = document.querySelector(this.dataset.target);
        menu.style.display = (menu.style.display === "block") ? "none" : "block";
    });
});
</script>

</body>
</html>