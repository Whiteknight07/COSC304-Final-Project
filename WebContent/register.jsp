<!DOCTYPE html>
<html>
<head>
    <title>Create Account - YOUR NAME Grocery</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        :root {
            --primary-color: #28a745;
            --primary-dark: #218838;
            --secondary-color: #6c757d;
            --background-color: #f8f9fa;
            --text-color: #333;
            --error-color: #dc3545;
            --border-color: #dee2e6;
            --shadow-color: rgba(0, 0, 0, 0.1);
        }

        body {
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            margin: 0;
            padding: 0;
            min-height: 100vh;
            color: var(--text-color);
            line-height: 1.6;
        }

        .register-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 8px 24px var(--shadow-color);
            padding: 2.5rem;
            width: 90%;
            max-width: 800px;
            margin: 2rem auto;
            animation: fadeIn 0.5s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .register-header {
            text-align: center;
            margin-bottom: 2.5rem;
            padding-bottom: 1.5rem;
            border-bottom: 2px solid var(--border-color);
        }

        .register-header h1 {
            color: var(--text-color);
            font-size: 2.2rem;
            margin-bottom: 0.5rem;
            font-weight: 600;
        }

        .register-header p {
            color: var(--secondary-color);
            font-size: 1.1rem;
            margin: 0;
        }

        .error-message {
            background-color: #fff5f5;
            color: var(--error-color);
            padding: 1rem;
            border-radius: 8px;
            border-left: 4px solid var(--error-color);
            margin-bottom: 1.5rem;
            font-size: 0.95rem;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 2rem;
        }

        .form-section {
            background-color: #f8f9fa;
            padding: 2rem;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            margin-bottom: 2rem;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }

        .form-section h3 {
            margin: 0 0 1.5rem 0;
            color: var(--primary-color);
            font-size: 1.3rem;
            font-weight: 600;
            padding-bottom: 1rem;
            border-bottom: 2px solid var(--border-color);
            text-align: center;
        }

        .form-group {
            margin-bottom: 1.2rem;
            position: relative;
            text-align: center;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.6rem;
            color: var(--text-color);
            font-weight: 500;
            font-size: 0.95rem;
            text-align: center;
        }

        .form-control {
            width: 80%;
            padding: 0.8rem 1rem;
            border: 2px solid var(--border-color);
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background-color: white;
            color: var(--text-color);
            display: block;
            margin: 0 auto;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(40, 167, 69, 0.15);
            outline: none;
        }

        .form-control::placeholder {
            color: #adb5bd;
        }

        .text-danger {
            color: var(--error-color);
            font-size: 0.85rem;
            margin-top: 0.4rem;
            display: block;
            text-align: center;
        }

        .address-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1.5rem;
        }

        .btn-register {
            width: 50%;
            padding: 1rem;
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin: 2rem auto 0;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: block;
        }

        .btn-register:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.2);
        }

        .btn-register:active {
            transform: translateY(0);
        }

        .additional-links {
            text-align: center;
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--border-color);
        }

        .additional-links a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .additional-links a:hover {
            color: var(--primary-dark);
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            .register-container {
                padding: 1.5rem;
                margin: 1rem auto;
                width: 95%;
            }

            .form-grid,
            .address-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .form-section {
                padding: 1.5rem;
                margin-bottom: 1.5rem;
            }

            .register-header h1 {
                font-size: 1.8rem;
            }

            .form-group.full-width {
                grid-column: auto;
            }

            .form-control {
                width: 90%;
            }
            
            .btn-register {
                width: 80%;
            }
        }

        /* Input specific styles */
        input[type="tel"],
        input[type="email"] {
            font-family: monospace;
            letter-spacing: 0.5px;
        }

        /* Autofill styles */
        input:-webkit-autofill {
            -webkit-box-shadow: 0 0 0 30px white inset;
            -webkit-text-fill-color: var(--text-color);
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="register-container">
    <div class="register-header">
        <h1>Create Your Account</h1>
        <p>Join us to start shopping</p>
    </div>

    <% 
    String message = (String) session.getAttribute("registerMessage");
    if (message != null) {
        out.println("<div class='error-message'>" + message + "</div>");
        session.removeAttribute("registerMessage");
    }
    %>

    <form name="RegisterForm" method="post" action="validateRegister.jsp" onsubmit="return validateForm()">
        <div class="form-grid">
            <div class="form-section">
                <h3>Account Information</h3>
                <div class="form-group">
                    <label for="userid">Username</label>
                    <input type="text" class="form-control" id="userid" name="userid" required>
                    <div id="useridError" class="text-danger"></div>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" class="form-control" id="password" name="password" required>
                    <div id="passwordError" class="text-danger"></div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                    <div id="confirmPasswordError" class="text-danger"></div>
                </div>
            </div>

            <div class="form-section">
                <h3>Personal Information</h3>
                <div class="form-group">
                    <label for="firstName">First Name</label>
                    <input type="text" class="form-control" id="firstName" name="firstName" required>
                    <div id="firstNameError" class="text-danger"></div>
                </div>

                <div class="form-group">
                    <label for="lastName">Last Name</label>
                    <input type="text" class="form-control" id="lastName" name="lastName" required>
                    <div id="lastNameError" class="text-danger"></div>
                </div>

                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" class="form-control" id="email" name="email" required>
                    <div id="emailError" class="text-danger"></div>
                </div>

                <div class="form-group">
                    <label for="phonenum">Phone Number</label>
                    <input type="tel" class="form-control" id="phonenum" name="phonenum" required>
                    <div id="phonenumError" class="text-danger"></div>
                </div>
            </div>

            <div class="form-section full-width">
                <h3>Address Information</h3>
                <div class="address-grid">
                    <div class="form-group full-width">
                        <label for="address">Address</label>
                        <input type="text" class="form-control" id="address" name="address" required>
                        <div id="addressError" class="text-danger"></div>
                    </div>

                    <div class="form-group">
                        <label for="city">City</label>
                        <input type="text" class="form-control" id="city" name="city" required>
                        <div id="cityError" class="text-danger"></div>
                    </div>

                    <div class="form-group">
                        <label for="state">State/Province</label>
                        <input type="text" class="form-control" id="state" name="state" required>
                        <div id="stateError" class="text-danger"></div>
                    </div>

                    <div class="form-group">
                        <label for="postalCode">Postal Code</label>
                        <input type="text" class="form-control" id="postalCode" name="postalCode" required>
                        <div id="postalCodeError" class="text-danger"></div>
                    </div>

                    <div class="form-group">
                        <label for="country">Country</label>
                        <input type="text" class="form-control" id="country" name="country" required>
                        <div id="countryError" class="text-danger"></div>
                    </div>
                </div>
            </div>
        </div>

        <button type="submit" class="btn-register">Create Account</button>
    </form>

    <div class="additional-links">
        <a href="login.jsp">Already have an account? Log in</a>
    </div>
</div>

<script>
function validateForm() {
    let isValid = true;
    // Reset all error messages
    document.querySelectorAll('.text-danger').forEach(el => el.textContent = '');

    // Username validation
    const userid = document.getElementById('userid').value;
    if (userid.length < 3) {
        document.getElementById('useridError').textContent = 'Username must be at least 3 characters long';
        isValid = false;
    }

    // Password validation
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    if (password.length < 6) {
        document.getElementById('passwordError').textContent = 'Password must be at least 6 characters long';
        isValid = false;
    }
    if (password !== confirmPassword) {
        document.getElementById('confirmPasswordError').textContent = 'Passwords do not match';
        isValid = false;
    }

    // Email validation
    const email = document.getElementById('email').value;
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        document.getElementById('emailError').textContent = 'Please enter a valid email address';
        isValid = false;
    }

    // Phone number validation
    const phone = document.getElementById('phonenum').value;
    const phoneRegex = /^\d{3}[-.]?\d{3}[-.]?\d{4}$/;
    if (!phoneRegex.test(phone)) {
        document.getElementById('phonenumError').textContent = 'Please enter a valid phone number (e.g., 123-456-7890)';
        isValid = false;
    }

    // Postal code validation
    const postalCode = document.getElementById('postalCode').value;
    if (postalCode.length < 5) {
        document.getElementById('postalCodeError').textContent = 'Please enter a valid postal code';
        isValid = false;
    }

    return isValid;
}

// Real-time validation
document.addEventListener('DOMContentLoaded', function() {
    const inputs = [
        'userid', 'password', 'confirmPassword', 'firstName', 'lastName',
        'email', 'phonenum', 'address', 'city', 'state', 'postalCode', 'country'
    ];

    inputs.forEach(id => {
        const input = document.getElementById(id);
        if (input) {
            input.addEventListener('blur', function() {
                validateForm();
            });
        }
    });
});
</script>

</body>
</html>
