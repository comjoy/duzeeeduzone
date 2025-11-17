<?php
include 'db.php';

$mlm_id = isset($_GET['mlm_id']) ? trim($_GET['mlm_id']) : '';

if (empty($mlm_id)) {
    die("Invalid MLM ID");
}

$stmt = $mysqli->prepare("SELECT * FROM members WHERE mlm_id = ?");
$stmt->bind_param("s", $mlm_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows == 0) {
    die("Member not found");
}

$member = $result->fetch_assoc();
$current_date = date('F j, Y');
$joining_date = date('Y-m-d');
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>wellcome - NPMLM</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 20px; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .letter-container { max-width: 800px; margin: 0 auto; background: white; border-radius: 15px; box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1); overflow: hidden; }
        .letter-header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; }
        .letter-body { padding: 40px; }
    </style>
</head>
<body>
    <div class="letter-container">
        <div class="letter-header">
            <div class="company-logo"><i class="fa-solid fa-users-line"></i></div>
            <div class="company-name">Dujee Eduzone </div>
            <div class="company-tagline">OFFICIAL WELCOME LETTER</div>
        </div>
        <div class="letter-body">
           
            <div class="member-details" style="background: #f8f9fa; border-radius: 10px; padding: 25px; margin-bottom: 30px;">
                <div style="display: flex; margin-bottom: 10px; padding: 8px 0; border-bottom: 1px solid #e9ecef;">
                    <div style="font-weight: bold; width: 200px; color: #495057;">Member ID:</div>
                    <div style="color: #333; flex: 1;"><?php echo htmlspecialchars($member['mlm_id']); ?></div>
                </div>
                <div style="display: flex; margin-bottom: 10px; padding: 8px 0; border-bottom: 1px solid #e9ecef;">
                    <div style="font-weight: bold; width: 200px; color: #495057;">Full Name:</div>
                    <div style="color: #333; flex: 1;"><?php echo htmlspecialchars($member['full_name']); ?></div>
                </div>
                <div style="display: flex; margin-bottom: 10px; padding: 8px 0; border-bottom: 1px solid #e9ecef;">
                    <div style="font-weight: bold; width: 200px; color: #495057;">Email:</div>
                    <div style="color: #333; flex: 1;"><?php echo htmlspecialchars($member['email']); ?></div>
                </div>
                <div style="display: flex; margin-bottom: 10px; padding: 8px 0; border-bottom: 1px solid #e9ecef;">
                    <div style="font-weight: bold; width: 200px; color: #495057;">Phone:</div>
                    <div style="color: #333; flex: 1;"><?php echo htmlspecialchars($member['phone']); ?></div>
                </div>
                <div style="display: flex; margin-bottom: 10px; padding: 8px 0; border-bottom: 1px solid #e9ecef;">
                    <div style="font-weight: bold; width: 200px; color: #495057;">Status:</div>
                    <div style="color: #333; flex: 1;">
                        <span class="badge bg-<?php echo $member['status'] == 'prime' ? 'success' : 'danger'; ?>">
                            <?php echo ucfirst($member['status']); ?> Member
                        </span>
                    </div>
                </div>
                
<div style="display: flex; flex-direction: column; padding: 10px 0;">
    <div style="font-weight: bold; color: #495057;">Your Referral Link:</div>
    <div style="background: #f1f3f5; padding: 10px; border-radius: 8px; margin-top: 8px; font-weight: 500; color: #333;">
        <?php 
        $referral_link = "https://www.dujeeeduzonenepal.org/registration_ref.php?ref_id=" . urlencode($member['mlm_id']); 
        echo $referral_link; 
        ?>
    </div>
    <button 
      onclick="navigator.clipboard.writeText('<?php echo $referral_link; ?>'); alert('Referral link copied!');"
      style="margin-top:10px; background:linear-gradient(135deg,#667eea,#764ba2); color:white; border:none; padding:10px 18px; border-radius:8px; cursor:pointer;">
      <i class="fa fa-copy"></i> Copy Referral Link
    </button>
</div>


            </div>
            <div class="letter-content">
                <p>Dear <strong><?php echo htmlspecialchars($member['full_name']); ?></strong>,</p>
                <p>We are delighted to welcome you to Dujeeeduzone Nepal as an official member of our social family. Your unique Member ID has been assigned to you.</p>
                <p>Your unique Member ID <strong><?php echo htmlspecialchars($member['mlm_id']); ?></strong> has been assigned to you.</p>
                <p>Welcome aboard!</p>
            </div>
        </div>
        <div class="action-buttons" style="text-align: center; padding: 20px; background: #f8f9fa; border-top: 1px solid #dee2e6;">
            <button onClick="window.print()" class="btn-print" style="background: linear-gradient(135deg, #28a745 0%, #20c997 100%); color: white; border: none; padding: 12px 30px; border-radius: 8px; font-weight: bold; margin-right: 10px;">
                <i class="fa-solid fa-print"></i> Print Letter
            </button>
        </div>
    </div>
</body>
</html>
<?php
$stmt->close();
$mysqli->close();
?>