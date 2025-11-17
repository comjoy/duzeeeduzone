


<?php
include 'db.php';

header('Content-Type: application/json');

if (isset($_GET['ref_id'])) {
    $ref_id = trim($_GET['ref_id']);
    
    // ⭐ Added full_name in SELECT – nothing else changed
    $check = $mysqli->prepare("SELECT mlm_id, full_name, status, joining_date FROM members WHERE mlm_id = ?");
    if ($check === false) {
        echo json_encode(['valid' => false, 'message' => 'Database error']);
        exit;
    }
    
    $check->bind_param("s", $ref_id);
    $check->execute();
    $result = $check->get_result();
    
    if ($result->num_rows == 0) {
        echo json_encode(['valid' => false, 'message' => 'Invalid Referred ID']);
    } else {
        $member = $result->fetch_assoc();
        
        // Save name separately
        $referrer_name = $member['full_name'];

        if ($member['status'] === 'prime') {

            echo json_encode([
                'valid' => true, 
                'message' => 'Valid Prime Member - Can refer unlimited members',
                'status' => 'prime',
                'days_remaining' => 'unlimited',
                'referrer_name' => $referrer_name   // ⭐ Added
            ]);

        } else if ($member['status'] === 'red') {

            $joining_date = new DateTime($member['joining_date']);
            $current_date = new DateTime();
            $days_difference = $current_date->diff($joining_date)->days;
            $days_remaining = 15 - $days_difference;
            
            if ($days_difference <= 15) {
                echo json_encode([
                    'valid' => true, 
                    'message' => "Valid Red Member - {$days_remaining} days remaining in grace period",
                    'status' => 'red',
                    'days_remaining' => $days_remaining,
                    'referrer_name' => $referrer_name   // ⭐ Added
                ]);
            } else {
                echo json_encode([
                    'valid' => false, 
                    'message' => 'Red member has exceeded 15 days grace period',
                    'status' => 'red',
                    'days_remaining' => 0,
                    'referrer_name' => $referrer_name   // ⭐ Added (still allowed to show)
                ]);
            }
        } else {
            echo json_encode(['valid' => false, 'message' => 'Member has invalid status']);
        }
    }
    $check->close();
} else {
    echo json_encode(['valid' => false, 'message' => 'No referral ID provided']);
}

$mysqli->close();
?>
