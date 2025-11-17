<?php 
session_start();
if (!isset($_SESSION['admin_loggedin']) || $_SESSION['admin_loggedin'] !== true) {
    header("Location: admin_login.php");
    exit;
}
require 'db.php';

// --- CONFIG ---
$limit = 25; // rows per page
$page = isset($_GET['page']) ? max(1, intval($_GET['page'])) : 1;
$offset = ($page - 1) * $limit;

$search = isset($_GET['search']) ? $mysqli->real_escape_string($_GET['search']) : '';
$status_filter = isset($_GET['status']) ? $_GET['status'] : '';
$sort = isset($_GET['sort']) ? $_GET['sort'] : 'joining_date';
$order = isset($_GET['order']) && strtolower($_GET['order']) === 'asc' ? 'ASC' : 'DESC';

// --- QUERY ---
$query = "FROM members WHERE 1=1";
if (!empty($search)) {
    $query .= " AND (mlm_id LIKE '%$search%' OR full_name LIKE '%$search%' OR email LIKE '%$search%')";
}
if (!empty($status_filter)) {
    $query .= " AND status = '$status_filter'";
}

$total_result = $mysqli->query("SELECT COUNT(*) as total $query")->fetch_assoc()['total'];
$total_pages = ceil($total_result / $limit);

$result = $mysqli->query("SELECT * $query ORDER BY $sort $order LIMIT $limit OFFSET $offset");

// --- FETCH REFERRAL COUNTS FOR ALL MEMBERS ---
$refCounts = [];
$refQuery = $mysqli->query("SELECT ref_id, COUNT(*) AS total FROM members GROUP BY ref_id");
while($rc = $refQuery->fetch_assoc()) {
    if ($rc['ref_id']) {
        $refCounts[$rc['ref_id']] = $rc['total'];
    }
}

?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Registered Members | NPMLM</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
body { background: #f8f9fc; font-family: 'Poppins', sans-serif; }
h2 { font-weight: 600; color: #343a40; }
.table thead th { cursor: pointer; }
.table-hover tbody tr:hover { background-color: #f1f5ff; transition: 0.2s; }
.badge-prime { background: linear-gradient(45deg, #ffd43b, #fab005); color: #000; }
.badge-red { background: #e03131; color:#fff; }
.card { border: none; box-shadow: 0 2px 10px rgba(0,0,0,0.05); border-radius: 12px; }
.search-btn { background: #4c6ef5; border: none; }
.search-btn:hover { background: #3b5bdb; }
.reset-btn { background: #adb5bd; border: none; }
.reset-btn:hover { background: #868e96; }
.pagination .page-link { border-radius: 6px; color: #4c6ef5; }
.pagination .active .page-link { background-color: #4c6ef5; border-color: #4c6ef5; }
select.status-dropdown { padding:4px 6px; border-radius:6px; border:1px solid #ccc; }
.ref-box {
    background: #eef2ff;
    padding: 6px 10px;
    border-radius: 8px;
    border: 1px solid #d0d7ff;
    display: flex;
    gap: 8px;
}

.ref-link-text {
    font-size: 13px;
    color: #3b5bdb;
    font-weight: 500;
    overflow-wrap: anywhere;
}

.copy-btn {
    background: #4c6ef5;
    border: none;
    padding: 4px 8px;
    border-radius: 6px;
}

.copy-btn:hover {
    background: #364fc7;
}

</style>
</head>
<body>
<div class="container py-4">

<a href="admin_main.php" style="display: inline-flex; align-items: center; gap: 6px; text-decoration: none; color: #ffffffff; font-weight: 500; background: rgba(231, 198, 9, 0.98); padding: 8px 14px; border-radius: 8px; transition: 0.3s;">
        <i class="fa fa-arrow-left"></i> Back to Dashboard
</a>
<br><br>
      
<div class="card p-4 mb-4">
    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
        <h2 class="mb-0"><i class="fas fa-users me-2 text-primary"></i>Registered Members</h2>
        <form method="GET" class="d-flex flex-wrap gap-2">
            <input type="text" name="search" class="form-control" placeholder="🔍 Search by Member ID, Name, Email" value="<?= htmlspecialchars($search) ?>" style="min-width:230px;">
            <select name="status" class="form-select" style="min-width:150px;">
                <option value="">All Status</option>
                <option value="prime" <?= $status_filter=='prime'?'selected':''; ?>>Prime</option>
                <option value="red" <?= $status_filter=='red'?'selected':''; ?>>Red</option>
            </select>
            <button type="submit" class="btn btn-primary search-btn px-4"><i class="fa fa-search me-1"></i>Search</button>
            <a href="view_referral.php" class="btn reset-btn px-4"><i class="fa fa-rotate-left me-1"></i>Reset</a>
        </form>
    </div>
</div>

<div class="card">
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover align-middle text-center">
                <thead class="table-light">
                    <tr>
                        <th> Member Id </th>
                        <th> Referred Id </th>
                        <th> Full Name </th>
                        <th> Direct Joinings </th>
                        <th> Phone </th>
                        <th> Status </th>
                        <th> Referral Link </th>
                    </tr>
                </thead>
                <tbody>
                <?php if ($result && $result->num_rows > 0): ?>
                    <?php while($row = $result->fetch_assoc()): ?>
                    <tr>
                        <td><strong><?= htmlspecialchars($row['mlm_id']) ?></strong></td>
                        <td><?= htmlspecialchars($row['ref_id'] ?: 'Direct') ?></td>
                        <td><?= htmlspecialchars($row['full_name']) ?></td>   
                        <td><?= isset($refCounts[$row['mlm_id']]) ? $refCounts[$row['mlm_id']] : 0 ?></td>                     
                        <td><?= htmlspecialchars($row['phone']) ?></td>
                        <td><?= htmlspecialchars($row['status']) ?></td>
                       <?php 
$referral_link = "http://localhost/duzeeeduzone/registration_ref.php?ref_id=" . urlencode($row['mlm_id']); 
?>
<td>
    <div class="ref-box d-flex align-items-center justify-content-between">
        <span class="ref-link-text"><?= $referral_link ?></span>
        <button class="btn btn-sm btn-primary copy-btn" data-link="<?= $referral_link ?>">
            <i class="fa-solid fa-copy"></i>
        </button>
    </div>
</td>

                    </tr>
                    <?php endwhile; ?>
                <?php else: ?>
                    <tr><td colspan="10" class="text-center text-muted py-4">No members found</td></tr>
                <?php endif; ?>
                </tbody>
            </table>
        </div>

        <?php if ($total_pages > 1): ?>
        <nav>
            <ul class="pagination justify-content-center mt-3">
                <?php for ($i = 1; $i <= $total_pages; $i++): ?>
                    <li class="page-item <?= $i == $page ? 'active' : '' ?>">
                        <a class="page-link" href="?page=<?= $i ?>&search=<?= $search ?>&status=<?= $status_filter ?>&sort=<?= $sort ?>&order=<?= strtolower($order) ?>">
                            <?= $i ?>
                        </a>
                    </li>
                <?php endfor; ?>
            </ul>
        </nav>
        <?php endif; ?>
    </div>
</div>
</div>

<script>
$(document).on("click", ".copy-btn", function() {
    let text = $(this).data("link");
    navigator.clipboard.writeText(text);

    $(this).html('<i class="fa-solid fa-check"></i>');
    let btn = $(this);

    setTimeout(() => {
        btn.html('<i class="fa-solid fa-copy"></i>');
    }, 1200);
});
</script>

</body>
</html>
<?php $mysqli->close(); ?>
