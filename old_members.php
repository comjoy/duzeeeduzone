<?php
session_start();
if (!isset($_SESSION['admin_loggedin']) || $_SESSION['admin_loggedin'] !== true) {
    header("Location: admin_login.php");
    exit;
}

require 'db.php';

// Handle delete
if (isset($_GET['delete'])) {
    $id = intval($_GET['delete']);

    // Step 1: Fetch the member being deleted
    $member = $mysqli->query("SELECT mlm_id, ref_id FROM members WHERE id=$id")->fetch_assoc();

    if ($member) {
        $member_mlm_id = $member['mlm_id']; // the member who is getting deleted
        $member_ref_id = $member['ref_id']; // who referred him

        // Step 2: Update children → move them under deleted member’s sponsor
        $stmt = $mysqli->prepare("UPDATE members SET ref_id=? WHERE ref_id=?");
        $stmt->bind_param("ss", $member_ref_id, $member_mlm_id);
        $stmt->execute();
        $stmt->close();

        // Step 3: Now delete the member
        $mysqli->query("DELETE FROM members WHERE id=$id");
    }

    header("Location: old_members.php");
    exit;
}


$result = $mysqli->query("
    SELECT * FROM members
    WHERE joining_date < DATE_SUB(CURDATE(), INTERVAL 15 DAY)
    ORDER BY joining_date ASC
");
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Old Members (15+ Days) | Admin Panel</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-5">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h3><i class="bi bi-clock-history text-danger"></i> Members Joined Over 15 Days Ago</h3>
    <a href="admin_main.php" class="btn btn-secondary"><i class="bi bi-arrow-left"></i> Back to Dashboard</a>
  </div>

  <div class="card shadow-sm">
    <div class="card-body">
      <table class="table table-striped align-middle">
        <thead class="table-dark">
          <tr>
            <th>Roll No</th>
            <th>Member ID</th>
            <th>Referred By</th>
            <th>Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Status</th>
            <th>Joining Date</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
        <?php if ($result->num_rows > 0): ?>
          <?php while ($row = $result->fetch_assoc()): ?>
          <tr>
            <td><?= $row['id'] ?></td>
            <td><?= $row['mlm_id'] ?></td>
            <td><?= $row['ref_id'] ?></td>
            <td><?= htmlspecialchars($row['full_name']) ?></td>
            <td><?= htmlspecialchars($row['email']) ?></td>
            <td><?= htmlspecialchars($row['phone']) ?></td>
            <td><span class="badge bg-<?= $row['status'] == 'prime' ? 'warning' : 'danger' ?>"><?= ucfirst($row['status']) ?></span></td>
            <td><?= date('d M Y', strtotime($row['joining_date'])) ?></td>    
            <td>
              <a href="?delete=<?= $row['id'] ?>" class="btn btn-sm btn-outline-danger" onclick="return confirm('Delete this member?');"><i class="bi bi-trash"></i></a>
            </td>
          </tr>
          <?php endwhile; ?>
        <?php else: ?>
          <tr><td colspan="7" class="text-center text-muted">No members found older than 15 days.</td></tr>
        <?php endif; ?>
        </tbody>
      </table>
    </div>
  </div>
</div>
</body>
</html>
