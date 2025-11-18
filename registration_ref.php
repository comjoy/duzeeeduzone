<?php include 'db.php'; ?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dujeeeduzone Nepal</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
    body { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 20px; }
    .registration-wrapper { width: 100%; max-width: 500px; }
    .registration-card { background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px); border-radius: 20px; padding: 30px; box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1); border: 1px solid rgba(255, 255, 255, 0.2); }
    .title { text-align: center; color: #333; font-size: 24px; font-weight: 700; margin-bottom: 8px; }
    .input-group { margin-bottom: 20px; }
    .input-group label { display: block; margin-bottom: 8px; font-weight: 600; color: #444; font-size: 14px; }
    .input-group input, .input-group select { width: 100%; padding: 12px 15px; border: 2px solid #e1e5ee; border-radius: 10px; font-size: 14px; transition: all 0.3s; background: #fff; }
    .input-group input:focus, .input-group select:focus { outline: none; border-color: #667eea; box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1); }
    .input-group input.error, .input-group select.error { border-color: #e74c3c; }
    .error-msg { color: #e74c3c; font-size: 12px; margin-top: 5px; display: none; }
    .btn-register { width: 100%; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border: none; padding: 14px; border-radius: 10px; font-size: 16px; font-weight: 600; cursor: pointer; transition: all 0.3s; }
    .btn-register:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4); }
    .password-strength { margin-top: 5px; font-size: 12px; }
    .strength-weak { color: #e74c3c; }
    .strength-medium { color: #f39c12; }
    .strength-strong { color: #27ae60; }
  </style>
</head>
<body>
  <div class="registration-wrapper">
    <div class="registration-card">
     
      <h2 class="title"><i class="fa-solid fa-users-line"></i> Dujee Eduzone </h2>
      <p class="subtitle" style="text-align: center; color: #666; margin-bottom: 30px; font-size: 14px;">Join our company  and start your journey today</p>
      
      <form id="mlmForm" novalidate method="POST" action="submit.php">
        <!-- Referred ID Field with Error Message - NOW MANDATORY -->
        <div class="input-group">
          <label><i class="fa-solid fa-link"></i> Referred ID <span style="color: red;">*</span></label>
          <input type="text" name="ref_id" id="ref_id" 
  placeholder="e.g. DE000000" 
  readonly
  value="<?php echo isset($_GET['ref_id']) ? htmlspecialchars($_GET['ref_id']) : ''; ?>">
  <small id="ref_error" class="error-msg"></small>
        </div>

        <!-- Full Name Field -->
        <div class="input-group">
          <label><i class="fa-solid fa-user"></i> Full Name <span style="color: red;">*</span></label>
          <input type="text" name="full_name" placeholder="Enter your full name" required>
          <small class="error-msg">Please enter your full name</small>
        </div>

        <!-- Phone Field -->
        <div class="input-group">
    <label><i class="fa-solid fa-phone"></i> Phone <span style="color: red;">*</span></label>

    <div style="display: flex; gap: 8px;">
        <select name="country_code" id="country_code" required style="width: 40%; padding: 7px;">
            <option value="+977">Nepal (+977)</option>
            <option value="+91">India (+91)</option>
            <option value="+975">Bhutan (+975)</option>
            <option value="+94">Sri Lanka (+94)</option>
            <option value="+880">Bangladesh (+880)</option>
            <option value="+95">Myanmar (+95)</option>
            <option value="+93">Afghanistan (+93)</option>
            <option value="+86">China (+86)</option>
        </select>

        <input type="tel" id="plain_phone" maxlength="10" pattern="[0-9]{10}" 
               placeholder="10-digit number" required style="width: 60%;">
    </div>

    <!-- HIDDEN FIELD THAT WILL STORE +CODE + NUMBER -->
    <input type="hidden" name="phone" id="phone">

    <small class="error-msg">Please enter a valid 10-digit number</small>
</div>

        <!-- Email Field - NOW OPTIONAL -->
        <div class="input-group">
          <label><i class="fa-solid fa-envelope"></i> Email (Optional)</label>
          <input type="email" name="email" placeholder="example@domain.com">
          <small class="error-msg">Please enter a valid email</small>
        </div>


        <!-- Password Field with Strength Indicator -->
        <div class="input-group">
          <label><i class="fa-solid fa-lock"></i> Password <span style="color: red;">*</span></label>
          <input type="password" name="password" id="password" placeholder="Enter password" required>
          <small class="error-msg">Please enter a password</small>
          <div class="password-strength" id="passwordStrength"></div>
        </div>

        <!-- Confirm Password Field with Error Message -->
        <div class="input-group">
          <label><i class="fa-solid fa-lock"></i> Confirm Password <span style="color: red;">*</span></label>
          <input type="password" name="confirm_password" id="confirm_password" placeholder="Confirm password" required>
          <small class="error-msg" id="confirm_error">Passwords do not match</small>
        </div>

        <!-- Country Field -->
        <div class="input-group">
          <label><i class="fa-solid fa-globe"></i> Country <span style="color: red;">*</span></label>
          <select name="country" required>
            <option value="">Select Country</option>
            <option value="Nepal">Nepal</option>
            <option value="India">India</option>
            <option value="Bhutan">Bhutan</option>
            <option value="SriLanka">SriLanka</option>
            <option value="Bangladesh">Bangladesh</option>
            <option value="Myanmar">Myanmar</option>
            
            <option value="Afganistan">Afganistan</option>
            <option value="China">China</option>
          </select>
          <small class="error-msg">Please select your country</small>
        </div>

        <!-- Blood Group Field -->
        <div class="input-group">
          <label><i class="fa-solid fa-tint"></i> Blood Group <span style="color: red;">*</span></label>
          <select name="blood_group" required>
            <option value="">Select Blood Group</option>
            <option value="A+">A+</option>
            <option value="A-">A-</option>
            <option value="B+">B+</option>
            <option value="B-">B-</option>
            <option value="AB+">AB+</option>
            <option value="AB-">AB-</option>
            <option value="O+">O+</option>
            <option value="O-">O-</option>
          </select>
          <small class="error-msg">Please select your blood group</small>
        </div>

        <button type="submit" class="btn-register"><i class="fa-solid fa-paper-plane"></i> Register</button>
      </form>
    </div>
  </div>

 <script>
document.getElementById('mlmForm').addEventListener('submit', function(e) {
    e.preventDefault();

    // -------------------------------------------
    // ⭐ ADDING COUNTRY CODE + PHONE MERGE HERE ⭐
    // -------------------------------------------
    let code  = document.getElementById("country_code").value;
    let num   = document.getElementById("plain_phone").value;
    document.getElementById("phone").value = code + num;
    // -------------------------------------------

    // Reset messages
    document.querySelectorAll('.error-msg').forEach(msg => {
        msg.style.display = 'none';
    });

    let isValid = true;

    // FIXED REQUIRED FIELD VALIDATION
    const requiredFields = this.querySelectorAll(
        '.input-group input[required], .input-group select[required]'
    );

    requiredFields.forEach(field => {
        const errorMsg = field.parentElement.querySelector('.error-msg');

        if (!field.value.trim()) {
            if (errorMsg) errorMsg.style.display = 'block';
            field.classList.add("error");
            isValid = false;
        } else {
            if (errorMsg) errorMsg.style.display = 'none';
            field.classList.remove("error");
        }
    });

    // Password match check
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirm_password').value;

    if (password !== confirmPassword) {
        document.getElementById('confirm_error').style.display = 'block';
        document.getElementById('confirm_password').style.borderColor = '#e74c3c';
        isValid = false;
    }

    // Referral ID check
    const refId = document.getElementById('ref_id').value.trim();

    if (!refId) {
        document.getElementById('ref_error').textContent = 'Referral ID is required';
        document.getElementById('ref_error').style.display = 'block';
        document.getElementById('ref_id').style.borderColor = '#e74c3c';
        return;
    }

    // Validate referral
    const submitBtn = this.querySelector('button[type="submit"]');
    const originalText = submitBtn.innerHTML;

    submitBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Validating...';
    submitBtn.disabled = true;

    validateReferral(refId).then(result => {
        submitBtn.innerHTML = originalText;
        submitBtn.disabled = false;

        if (result.valid) {
            if (isValid) this.submit();
        } else {
            document.getElementById('ref_error').textContent = result.message;
            document.getElementById('ref_error').style.display = 'block';
            document.getElementById('ref_id').style.borderColor = '#e74c3c';
        }
    });
});

// REAL-TIME FIELD VALIDATION FIXED
document.querySelectorAll('.input-group input[required], .input-group select[required]')
    .forEach(field => {
        field.addEventListener('blur', function() {
            const errorMsg = this.parentElement.querySelector('.error-msg');

            if (!this.value.trim()) {
                if (errorMsg) errorMsg.style.display = 'block';
                this.classList.add("error");
            } else {
                if (errorMsg) errorMsg.style.display = 'none';
                this.classList.remove("error");
            }
        });
    });

// Password strength meter
document.getElementById('password').addEventListener('input', function() {
    const password = this.value;
    const strengthText = document.getElementById('passwordStrength');

    if (password.length === 0) {
        strengthText.textContent = '';
        return;
    }

    let strength = '';
    if (password.length < 6) {
        strength = 'Weak';
        strengthText.className = 'password-strength strength-weak';
    } else if (password.length < 8) {
        strength = 'Medium';
        strengthText.className = 'password-strength strength-medium';
    } else {
        const upper = /[A-Z]/.test(password);
        const lower = /[a-z]/.test(password);
        const num = /\d/.test(password);
        const special = /[!@#$%^&*(),.?":{}|<>]/.test(password);

        if (upper && lower && num && special) {
            strength = 'Very Strong';
        } else {
            strength = 'Strong';
        }

        strengthText.className = 'password-strength strength-strong';
    }

    strengthText.textContent = `Password strength: ${strength}`;
});

// Referral ID live check
document.getElementById('ref_id').addEventListener('blur', function() {
    const refId = this.value.trim();
    const refError = document.getElementById('ref_error');

    if (!refId) {
        refError.textContent = 'Referral ID is required';
        refError.style.display = 'block';
        this.style.borderColor = '#e74c3c';
        return;
    }

    this.style.borderColor = '#ffc107';

    validateReferral(refId).then(result => {
        if (!result.valid) {
            refError.textContent = result.message;
            refError.style.display = 'block';
            this.style.borderColor = '#e74c3c';

            const statusDiv = document.getElementById('referralStatus');
            if (statusDiv) statusDiv.remove();

        } else {
            refError.style.display = 'none';
            this.style.borderColor = '#27ae60';

            let statusDiv = document.getElementById('referralStatus');
            if (!statusDiv) {
                statusDiv = document.createElement('div');
                statusDiv.id = 'referralStatus';
                statusDiv.style.padding = '8px';
                statusDiv.style.borderRadius = '5px';
                statusDiv.style.marginTop = '5px';
                statusDiv.style.fontSize = '12px';
                this.parentNode.appendChild(statusDiv);
            }

            if (result.status === 'prime') {
                statusDiv.innerHTML = `✅ <strong>${result.referrer_name}</strong> is a Prime Member – Can refer unlimited members`;
                statusDiv.style.background = '#d4edda';
                statusDiv.style.color = '#155724';
                statusDiv.style.border = '1px solid #c3e6cb';

            } else if (result.status === 'red') {
                statusDiv.innerHTML = `🟡 <strong>${result.referrer_name}</strong> is a Red Member – ${result.days_remaining} days remaining`;
                statusDiv.style.background = '#fff3cd';
                statusDiv.style.color = '#856404';
                statusDiv.style.border = '1px solid #ffeaa7';
            }
        }
    });
});

// AJAX referral check
function validateReferral(refId) {
    return fetch('check_referral.php?ref_id=' + encodeURIComponent(refId))
        .then(r => r.json())
        .catch(() => ({ valid: false, message: 'Error validating referral' }));
}
</script>
</body>
</html>