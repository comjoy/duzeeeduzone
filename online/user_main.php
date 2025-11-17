<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Joining Instructions</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

  <style>
    body {
      background: linear-gradient(135deg, #4e54c8, #8f94fb);
      font-family: 'Poppins', sans-serif;
      min-height: 100vh;
      padding: 30px 10px;
    }
    .glass-card {
      background: rgba(255, 255, 255, 0.15);
      backdrop-filter: blur(15px);
      border-radius: 20px;
      border: 1px solid rgba(255, 255, 255, 0.2);
      padding: 30px;
      color: #fff;
      box-shadow: 0 10px 25px rgba(0,0,0,0.2);
    }
    .heading {
      font-size: 28px;
      font-weight: 700;
      text-align: center;
      margin-bottom: 20px;
      text-shadow: 0 2px 8px rgba(0, 0, 0, 0.4);
    }
    .join-link-box {
      background: rgba(255,255,255,0.2);
      border-radius: 15px;
      padding: 15px;
      text-align: center;
      font-weight: 600;
      font-size: 18px;
      overflow-wrap: break-word;
      color: #fff;
    }
    .join-link-box a {
      color: #00ffee;
      text-decoration: underline;
      font-weight: 700;
      font-size: 18px;
    }
    .btn-copy {
      margin-top: 10px;
      width: 100%;
      background: #00ffcc;
      border: none;
      color: #000;
      font-weight: 600;
      border-radius: 12px;
    }
    .btn-open {
      margin-top: 10px;
      width: 100%;
      background: #ffffff;
      border: none;
      color: #000;
      font-weight: 600;
      border-radius: 12px;
    }
    .instruction-title {
      font-size: 22px;
      font-weight: 600;
      margin-top: 25px;
    }
    ul li {
      margin-bottom: 10px;
      font-size: 16px;
    }
  </style>
</head>

<body>

  <div class="container">
    <div class="glass-card mx-auto col-lg-7 col-md-10 col-12">

      <div class="heading">
        <i class="fa-solid fa-user-plus"></i> Joining Instructions
      </div>

      <p class="text-center">Please follow the steps carefully to complete your joining process.</p>

     <!-- JOINING LINK SECTION -->
<div class="instruction-title">
  <i class="fa-solid fa-link"></i> Your Joining Link
</div>

<p style="font-size:18px; font-weight:600; margin-top:10px;">
  <a href="https://www.dujeeeduzonenepal.org/registration_users.php" 
     target="_blank" 
     id="joinLink"
     style="color:#00ffea; text-decoration:underline;">
     Welcome Partner! Click here to Join →
  </a>
</p>

      <!-- INSTRUCTIONS -->
      <div class="instruction-title"><i class="fa-solid fa-list-check"></i> Steps to Join</div>

      <ul>
        <li>Click the joining link button above.</li>
        <li>Fill all the required personal details correctly.</li>
        <li>Set a strong and secure password.</li>
        <li>Review and submit the joining form.</li>
        <li>You will receive a confirmation message once completed.</li>
      </ul>

    </div>
  </div>

  <script>
    function copyLink() {
      let link = document.getElementById("joinLink").innerText;
      navigator.clipboard.writeText(link);
      alert("Joining link copied!");
    }

    function openLink() {
      let link = document.getElementById("joinLink").href;
      window.open(link, "_blank");
    }
  </script>

</body>
</html>
