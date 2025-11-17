<?php
include 'db.php';

// Get form data safely
$ref_id = trim($_POST['ref_id']);
$full_name = trim($_POST['full_name']);
$phone = trim($_POST['phone']);
$email = trim($_POST['email']);
$password = trim($_POST['password']);
$country = trim($_POST['country']);
$blood_group = trim($_POST['blood_group']);

// Validate passwords match
if ($_POST['password'] !== $_POST['confirm_password']) {
    echo "<script>alert('❌ Passwords do not match!'); window.history.back();</script>";
    exit;
}

// Validate referred ID if provided
if (!empty($ref_id)) {
    $check = $mysqli->prepare("SELECT mlm_id, status, joining_date FROM members WHERE mlm_id = ?");
    if ($check === false) {
        echo "<script>alert('❌ Database error!'); window.history.back();</script>";
        exit;
    }

    $check->bind_param("s", $ref_id);
    $check->execute();
    $result = $check->get_result();

    if ($result->num_rows == 0) {
        echo "<script>alert('❌ Invalid Referred ID! Please check and try again.'); window.history.back();</script>";
        exit;
    } else {
        $member = $result->fetch_assoc();

        if ($member['status'] === 'prime') {
            $can_refer = true;
        } elseif ($member['status'] === 'red') {
            $joining_date = new DateTime($member['joining_date']);
            $current_date = new DateTime();
            $days_difference = $current_date->diff($joining_date)->days;

            if ($days_difference <= 15) {
                $can_refer = true;
            } else {
                echo "<script>alert('❌ Referred member status is red and has exceeded 15 days grace period! Cannot register under this referral.'); window.history.back();</script>";
                exit;
            }
        } else {
            echo "<script>alert('❌ Referred member has invalid status! Cannot register under this referral.'); window.history.back();</script>";
            exit;
        }
    }
    $check->close();
}

// ✅ Handle optional email properly (insert empty string if not provided)
if (empty($email)) {
    $email = "";
}

// Check if phone already exists
$phone_check = $mysqli->prepare("SELECT id FROM members WHERE phone = ?");
if ($phone_check === false) {
    echo "<script>alert('❌ Database error!'); window.history.back();</script>";
    exit;
}
$phone_check->bind_param("s", $phone);
$phone_check->execute();
if ($phone_check->get_result()->num_rows > 0) {
    echo "<script>alert('❌ Phone number already exists! Please use a different phone number.'); window.history.back();</script>";
    exit;
}
$phone_check->close();

// Generate unique MLM ID
$last = $mysqli->query("SELECT mlm_id FROM members ORDER BY id DESC LIMIT 1");
if ($last && $last->num_rows > 0) {
    $row = $last->fetch_assoc();
    $lastNumber = intval(substr($row['mlm_id'], 2)); // "DE" prefix
    $newNumber = str_pad($lastNumber + 1, 6, '0', STR_PAD_LEFT);
} else {
    $newNumber = "000001";
}
$newMLMID = "DE" . $newNumber;

// Hash password
$hashed_password = password_hash($password, PASSWORD_DEFAULT);

// Default status for new member
$status = "red";

// ✅ Handle NULL email properly
if ($email === "") {
    $email = null;
}

// Prepare insert
$stmt = $mysqli->prepare("INSERT INTO members 
    (mlm_id, ref_id, full_name, phone, email, password, country, blood_group, status, rp, sp)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 800, 1000)");
if ($stmt === false) {
    echo "<script>alert('❌ Database prepare error!'); window.history.back();</script>";
    exit;
}

// Bind parameters safely
$stmt->bind_param(
    "sssssssss",
    $newMLMID,
    $ref_id,
    $full_name,
    $phone,
    $email,
    $hashed_password,
    $country,
    $blood_group,
    $status,
);

if ($stmt->execute()) {
    header("Location: joining_letter.php?mlm_id=" . urlencode($newMLMID));
    exit();
} else {
    $error_message = $mysqli->error;
    echo "<script>alert('❌ Database Error: $error_message'); window.history.back();</script>";
    exit;
}

$stmt->close();
$mysqli->close();
?>
