
<?php 
require 'db.php';

if(isset($_POST['id']) && isset($_POST['status'])){
    $id = intval($_POST['id']);

    // clean status
    $status = ($_POST['status'] === 'prime') ? 'prime' : 'red';

    // Assign RP & SP based on status
    if($status === 'prime'){
        $rp = 1600;
        $sp = 2000;
    } else {
        $rp = 800;
        $sp = 1000;
    }

    // Update all 3 values
    $stmt = $mysqli->prepare("
        UPDATE members 
        SET status = ?, rp = ?, sp = ? 
        WHERE id = ?
    ");

    $stmt->bind_param('siii', $status, $rp, $sp, $id);

    echo $stmt->execute() ? 'success' : 'error';

    $stmt->close();
}

$mysqli->close();
?>
