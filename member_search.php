<?php
session_start();
if (!isset($_SESSION['admin_loggedin']) || $_SESSION['admin_loggedin'] !== true) {
    header("Location: admin_login.php");
    exit;
}
include 'db.php';

// Helper function to sanitize output
function h($s){ return htmlspecialchars($s, ENT_QUOTES|ENT_SUBSTITUTE, 'UTF-8'); }

// ---------------------- AJAX handler: fetch children for a given parent ----------------------
if (isset($_GET['action']) && $_GET['action'] === 'fetch_children' && isset($_GET['parent_id'])) {
    $parent = trim($_GET['parent_id']);

    // prepare query to fetch children
    $stmt = $mysqli->prepare("SELECT mlm_id, full_name, phone, status FROM members WHERE ref_id = ?");
    $stmt->bind_param("s", $parent);
    $stmt->execute();
    $res = $stmt->get_result();

   $rows_html = '';
$any_children_has_children = false;
while ($r = $res->fetch_assoc()) {
    // check if this child has its own children (to show arrow and count)
    $chk = $mysqli->prepare("SELECT COUNT(*) AS c FROM members WHERE ref_id = ?");
    $chk->bind_param("s", $r['mlm_id']);
    $chk->execute();
    $chk_res = $chk->get_result();

    $has_child = false;
    $children_count = 0;
    if ($chk_row = $chk_res->fetch_assoc()) {
        $children_count = intval($chk_row['c']);
        $has_child = $children_count > 0;
        if ($has_child) $any_children_has_children = true;
    }

    $statusClass = ($r['status'] === 'prime1') ? 'status-prime1' : (($r['status'] === 'prime') ? 'status-prime' : 'status-red');

    // Each child row will have a data-parent attribute and a unique id to allow insertion of its own children later.
    $rows_html .= '<tr class="child-row" data-parent="'.h($parent).'" id="row-'.h($r['mlm_id']).'">';
    $rows_html .= '<td style="white-space:nowrap;">';
    if ($has_child) {
        // button to toggle deeper children + child count badge
        $rows_html .= '<button class="toggle-btn" data-mlm="'.h($r['mlm_id']).'" data-level="1" title="Show children"><i class="fa-solid fa-caret-right"></i></button>';
        $rows_html .= '<span class="badge bg-secondary ms-1">'.h($children_count).'</span>';
    } else {
        $rows_html .= '<span style="display:inline-block;width:28px;"></span>';
    }
    $rows_html .= '<span class="ms-1">'.h($r['mlm_id']).'</span></td>';
    $rows_html .= '<td>'.h($r['full_name']).'</td>';
    $rows_html .= '<td>'.h($r['phone']).'</td>';
    $rows_html .= '<td><span class="'.h($statusClass).'">'.h($r['status']).'</span></td>';
    $rows_html .= '</tr>';

    // placeholder row for nested children to be inserted (hidden by default). It spans full width.
    $rows_html .= '<tr class="nested-placeholder" id="placeholder-'.h($r['mlm_id']).'" style="display:none;"><td colspan="4" class="p-0 border-0"><div class="nested-container" id="children-'.h($r['mlm_id']).'"></div></td></tr>';
}


    header('Content-Type: application/json; charset=utf-8');
    echo json_encode([
        'html' => $rows_html,
        'has_deeper' => $any_children_has_children
    ]);
    exit;
}
// ----------------------------------------------------------------------------------------

// If we reach here, this is a normal page request (no action=fetch_children). Continue rendering page...
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Search Member & View Downline</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
 <style>
/* (your styles unchanged) */
.status-prime {
    background: #1fa750;
    color: #fff;
    padding: 4px 10px;
    border-radius: 6px;
    font-weight: 600;
    display: inline-block;
}
.status-red {
    background: #e63946;
    color: #fff;
    padding: 4px 10px;
    border-radius: 6px;
    font-weight: 600;
    display: inline-block;
}
.status-prime1 {
    background: #f7b731;
    color: #000;
    padding: 4px 10px;
    border-radius: 6px;
    font-weight: 600;
    display: inline-block;
}
/* Arrow toggle */
.toggle-btn {
  cursor: pointer;
  border: none;
  background: transparent;
  font-size: 16px;
  width: 28px;
  height: 28px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}
.toggle-btn:focus { outline: none; }
.level-indent {
  display: inline-block;
  width: 12px;
}
.downline-row {
  background: #fff;
}
/* small subtle nesting visual */
.child-row td {
  background: #fbfbfd;
}
  </style>

</head>

<body>

<div class="container">
<br>
<a href="admin_main.php" style="display: inline-flex;
  align-items: center;
  gap: 6px;
  text-decoration: none;
  color: #ffffffff;
  font-weight: 500;
  background: rgba(231, 198, 9, 0.98);
  padding: 8px 14px;
  border-radius: 8px;
  transition: 0.3s;" >
  <i class="fa fa-arrow-left"></i> Back
</a>
<hr>

  <h2> <i class="fa-solid fa-search"></i> Search Member </h2>
<br>
  <div class="search-box">
    <form method="GET" class="d-flex justify-content-center">
      <input type="text" name="mlm_id" class="form-control w-50 me-2" placeholder="Enter Member ID" required>
      <button type="submit" class="btn-search btn btn-warning">Search</button>
    </form>
  </div>
<br>

<?php
// --- Normal page rendering when searching mlm_id ---
if(isset($_GET['mlm_id'])){
    $mlm_id = trim($_GET['mlm_id']);
    $memberQuery = $mysqli->prepare("SELECT * FROM members WHERE mlm_id = ?");
    $memberQuery->bind_param("s", $mlm_id);
    $memberQuery->execute();
    $memberResult = $memberQuery->get_result();

    if($memberResult->num_rows > 0){
        $member = $memberResult->fetch_assoc();

        // Determine status color
        if($member['status'] == 'prime1'){
            $statusClass = 'status-prime1';
        } elseif($member['status'] == 'prime'){
            $statusClass = 'status-prime';
        } else {
            $statusClass = 'status-red';
        }

        echo "
        <div class='member-info'>
          <h5>👤 Member Details</h5>
          <table class='table mb-0'>
            <tr><th>Member ID</th><td>".h($member['mlm_id'])."</td></tr>
            <tr><th>Full Name</th><td>".h($member['full_name'])."</td></tr>
            <tr><th>Phone</th><td>".h($member['phone'])."</td></tr>
            <tr><th>Email</th><td>".h($member['email'])."</td></tr>
            <tr><th>Status</th><td><span class='{$statusClass}'>".h($member['status'])."</span></td></tr>
          </table>
        </div><br><br>";
        
        // Fetch direct referrals
        $referrals = $mysqli->prepare("SELECT mlm_id, full_name, phone, status FROM members WHERE ref_id = ?");
        $referrals->bind_param("s", $mlm_id);
        $referrals->execute();
        $downline = $referrals->get_result();
        $downline_count = $downline->num_rows;

        echo "<br><h5 class='text-center mb-3'>
🌿 Direct Joinings (View Affiliate Members) 
<span class='badge bg-primary px-3 py-2' style='font-size:16px;'>$downline_count</span>
</h5>";

        echo "<table class='table table-bordered table-hover align-middle'>
                <thead>
                  <tr>
                    <th style='width:28%;'>Member ID</th>
                    <th>Full Name</th>
                    <th>Phone</th>
                    <th>Status</th>
                  </tr>
                </thead>
                <tbody>";

        if($downline->num_rows > 0){

while($row = $downline->fetch_assoc()){
    // check if this direct child has children (so we can show an arrow)
    $chk = $mysqli->prepare("SELECT COUNT(*) AS c FROM members WHERE ref_id = ?");
    $chk->bind_param("s", $row['mlm_id']);
    $chk->execute();
    $chk_res = $chk->get_result();

    $has_child = false;
    $children_count = 0; // default
    if($chk_row = $chk_res->fetch_assoc()){
        $children_count = intval($chk_row['c']);
        $has_child = $children_count > 0;
    }

    if($row['status'] == 'prime1'){
        $sClass = 'status-prime1';
    } elseif($row['status'] == 'prime'){
        $sClass = 'status-prime';
    } else {
        $sClass = 'status-red';
    }

    echo "<tr class='downline-row' id='row-".h($row['mlm_id'])."'>";
    echo "<td style='white-space:nowrap;'>";
    if ($has_child) {
        // toggle button + child count badge (use $children_count)
        echo "<button class='toggle-btn' data-mlm='".h($row['mlm_id'])."' data-level='0' title='Show children'><i class='fa-solid fa-caret-right'></i></button>";
        echo "<span class='badge bg-secondary ms-1'>".h($children_count)."</span>";
    } else {
        echo "<span style='display:inline-block;width:28px;'></span>";
    }
    echo "<span class='ms-1'>".h($row['mlm_id'])."</span></td>";
    echo "<td>".h($row['full_name'])."</td>";
    echo "<td>".h($row['phone'])."</td>";
    echo "<td><span class='{$sClass}'>".h($row['status'])."</span></td>";
    echo "</tr>";

    // placeholder for nested children (hidden by default)
    echo "<tr class='nested-placeholder' id='placeholder-".h($row['mlm_id'])."' style='display:none;'><td colspan='4' class='p-0 border-0'><div class='nested-container' id='children-".h($row['mlm_id'])."'></div></td></tr>";
}
        } else {
            echo "<tr><td colspan='4' class='text-center text-muted'>No direct joinings found.</td></tr>";
        }

        echo "</tbody></table>";

    } else {
        echo "<div class='alert alert-danger text-center w-75 mx-auto'>❌ No member found with ID <b>".h($mlm_id)."</b>.</div>";
    }
}
?>

</div>

<script>
// Helper to toggle caret icon rotation
function rotateCaret(btn, open){
    const icon = btn.querySelector('i');
    if(!icon) return;
    if(open){
        icon.classList.remove('fa-caret-right');
        icon.classList.add('fa-caret-down');
    } else {
        icon.classList.remove('fa-caret-down');
        icon.classList.add('fa-caret-right');
    }
}

// Attach event listener using event delegation
document.addEventListener('click', function(e){
    const toggle = e.target.closest('.toggle-btn');
    if(!toggle) return;

    const mlm = toggle.getAttribute('data-mlm');
    if(!mlm) return;

    const placeholderId = 'placeholder-' + mlm;
    const placeholderRow = document.getElementById(placeholderId);

    // If placeholder currently hidden -> fetch & show children
    if(placeholderRow && placeholderRow.style.display === 'none'){
        // If children already loaded inside container, just show them
        const container = document.getElementById('children-' + mlm);
        if(container && container.dataset.loaded === '1'){
            placeholderRow.style.display = '';
            rotateCaret(toggle, true);
            return;
        }

        // fetch via AJAX the children rows (HTML fragment)
        fetch(window.location.pathname + '?action=fetch_children&parent_id=' + encodeURIComponent(mlm))
            .then(resp => resp.json())
            .then(data => {
                if(!container) return;
                container.innerHTML = '<table class="table mb-0"><tbody>' + data.html + '</tbody></table>';
                // mark as loaded
                container.dataset.loaded = '1';
                // show placeholder row
                placeholderRow.style.display = '';
                rotateCaret(toggle, true);
            })
            .catch(err => {
                console.error(err);
                // show a simple message in container
                const container = document.getElementById('children-' + mlm);
                if(container){
                    container.innerHTML = '<div class="p-2 text-muted">Failed to load children.</div>';
                    placeholderRow.style.display = '';
                }
                rotateCaret(toggle, true);
            });
    } else {
        // collapse: hide placeholder
        if(placeholderRow){
            placeholderRow.style.display = 'none';
        }
        rotateCaret(toggle, false);
    }
});
</script>

</body>
</html>
