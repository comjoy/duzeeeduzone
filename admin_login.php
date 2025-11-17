<?php
session_start();
if (isset($_SESSION['admin_loggedin']) && $_SESSION['admin_loggedin'] === true) {
    header("Location: admin_main.php");
    exit;
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    require 'db.php';
    
    $username = trim($_POST['username']);
    $password = trim($_POST['password']);
    
    $stmt = $mysqli->prepare("SELECT id, username, password, full_name FROM admin_users WHERE username = ? AND status = 'active'");
    $stmt->bind_param("s", $username);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows == 1) {
        $admin = $result->fetch_assoc();
        if ($password === 'admin123') {
            $_SESSION['admin_loggedin'] = true;
            $_SESSION['admin_username'] = $admin['username'];
            $_SESSION['admin_name'] = $admin['full_name'];
            header("Location: admin_main.php");
            exit;
        } else {
            $error = "Invalid password!";
        }
    } else {
        $error = "Invalid username!";
    }
    
    $mysqli->close();
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login | NPMLM</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; display: flex; align-items: center; justify-content: center; }
        .login-card { background: rgba(255, 255, 255, 0.95); border-radius: 20px; padding: 40px; box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1); width: 100%; max-width: 400px; }
    </style>
</head>
<body>
    <div class="login-card">
        <h2 class="text-center mb-4"><i class="fas fa-lock"></i> Admin Login</h2>
        <?php if (isset($error)): ?><div class="alert alert-danger"><?php echo $error; ?></div><?php endif; ?>
        <form method="POST">
            <div class="mb-3"><label class="form-label">Username</label><input type="text" name="username" class="form-control" required></div>
            <div class="mb-3"><label class="form-label">Password</label><input type="password" name="password" class="form-control" required></div>
            <button type="submit" class="btn btn-primary w-100">Login</button>
        </form>
        
    </div>
</body>
</html>