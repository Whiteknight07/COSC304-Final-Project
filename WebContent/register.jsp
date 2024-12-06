<!DOCTYPE html>
<html>
<head>
    <title>Create Account</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        .error-message {
            color: #dc3545;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 4px;
            padding: 10px;
            margin: 10px 0;
            text-align: center;
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<!-- Error Message Display -->
<% 
String message = (String) session.getAttribute("registerMessage");
if (message != null) { 
    System.out.println("Register Error: " + message); // This will show in Tomcat logs
%>
    <div class="error-message">
        <%= message %>
    </div>
<% 
    session.removeAttribute("registerMessage");
} 
%>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card mt-5">
                <div class="card-body">
                    <h3 class="card-title text-center">Create Account</h3>

                    <form name="RegisterForm" method="post" action="validateRegister.jsp" onsubmit="return validateForm()">
                        <div class="mb-3">
                            <label for="userid" class="form-label">Username:</label>
                            <input type="text" class="form-control" id="userid" name="userid" required>
                            <div id="useridError" class="text-danger"></div>
                        </div>

                        <div class="mb-3">
                            <label for="password" class="form-label">Password:</label>
                            <input type="password" class="form-control" id="password" name="password" required>
                            <div id="passwordError" class="text-danger"></div>
                        </div>

                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label">Confirm Password:</label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                            <div id="confirmPasswordError" class="text-danger"></div>
                        </div>

                        <div class="mb-3">
                            <label for="firstName" class="form-label">First Name:</label>
                            <input type="text" class="form-control" id="firstName" name="firstName" required>
                            <div class="text-danger"></div>
                        </div>

                        <div class="mb-3">
                            <label for="lastName" class="form-label">Last Name:</label>
                            <input type="text" class="form-control" id="lastName" name="lastName" required>
                            <div class="text-danger"></div>
                        </div>

                        <div class="mb-3">
                            <label for="email" class="form-label">Email:</label>
                            <input type="email" class="form-control" id="email" name="email" required>
                            <div id="emailError" class="text-danger"></div>
                        </div>

                        <div class="mb-3">
                            <label for="phonenum" class="form-label">Phone Number:</label>
                            <input type="tel" class="form-control" id="phonenum" name="phonenum" required>
                            <div id="phoneError" class="text-danger"></div>
                        </div>

                        <div class="mb-3">
                            <label for="address" class="form-label">Address:</label>
                            <input type="text" class="form-control" id="address" name="address" required>
                            <div class="text-danger"></div>
                        </div>

                        <div class="mb-3">
                            <label for="city" class="form-label">City:</label>
                            <input type="text" class="form-control" id="city" name="city" required>
                            <div class="text-danger"></div>
                        </div>

                        <div class="mb-3">
                            <label for="state" class="form-label">State/Province:</label>
                            <input type="text" class="form-control" id="state" name="state" required>
                            <div class="text-danger"></div>
                        </div>

                        <div class="mb-3">
                            <label for="postalCode" class="form-label">Postal Code:</label>
                            <input type="text" class="form-control" id="postalCode" name="postalCode" required>
                            <div class="text-danger"></div>
                        </div>

                        <div class="mb-3">
                            <label for="country" class="form-label">Country:</label>
                            <input type="text" class="form-control" id="country" name="country" required>
                            <div class="text-danger"></div>
                        </div>

                        <div class="text-center">
                            <input type="submit" class="btn btn-primary" value="Create Account">
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function validateForm() {
    let isValid = true;
    // Reset all error messages
    document.querySelectorAll('.text-danger').forEach(el => el.textContent = '');

    // Username validation
    const userid = document.getElementById('userid').value;
    if (userid.length < 3 || userid.length > 20) {
        document.getElementById('useridError').textContent = 'Username must be between 3 and 20 characters';
        console.log('Username validation failed:', userid);
        isValid = false;
    }

    // Password validation
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    if (password.length < 6) {
        document.getElementById('passwordError').textContent = 'Password must be at least 6 characters long';
        console.log('Password length validation failed');
        isValid = false;
    }
    if (password !== confirmPassword) {
        document.getElementById('confirmPasswordError').textContent = 'Passwords do not match';
        console.log('Password match validation failed');
        isValid = false;
    }

    // Name validation
    const firstName = document.getElementById('firstName').value;
    const lastName = document.getElementById('lastName').value;
    if (firstName.length < 1 || firstName.length > 40) {
        document.getElementById('firstName').nextElementSibling.textContent = 'First name must be between 1 and 40 characters';
        console.log('First name validation failed:', firstName);
        isValid = false;
    }
    if (lastName.length < 1 || lastName.length > 40) {
        document.getElementById('lastName').nextElementSibling.textContent = 'Last name must be between 1 and 40 characters';
        console.log('Last name validation failed:', lastName);
        isValid = false;
    }

    // Email validation
    const email = document.getElementById('email').value;
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email) || email.length > 50) {
        document.getElementById('emailError').textContent = 'Please enter a valid email address (max 50 characters)';
        console.log('Email validation failed:', email);
        isValid = false;
    }

    // Phone validation
    const phone = document.getElementById('phonenum').value;
    const phoneRegex = /^\d{3}-\d{3}-\d{4}$/;
    if (!phoneRegex.test(phone)) {
        document.getElementById('phoneError').textContent = 'Please enter phone number in format: 123-456-7890';
        console.log('Phone validation failed:', phone);
        isValid = false;
    }

    // Address validation
    const address = document.getElementById('address').value;
    if (address.length < 1 || address.length > 50) {
        document.getElementById('address').nextElementSibling.textContent = 'Address must be between 1 and 50 characters';
        console.log('Address validation failed:', address);
        isValid = false;
    }

    // City validation
    const city = document.getElementById('city').value;
    if (city.length < 1 || city.length > 40) {
        document.getElementById('city').nextElementSibling.textContent = 'City must be between 1 and 40 characters';
        console.log('City validation failed:', city);
        isValid = false;
    }

    // State/Province validation
    const state = document.getElementById('state').value;
    if (state.length < 1 || state.length > 20) {
        document.getElementById('state').nextElementSibling.textContent = 'State/Province must be between 1 and 20 characters';
        console.log('State validation failed:', state);
        isValid = false;
    }

    // Postal Code validation
    const postalCode = document.getElementById('postalCode').value;
    if (postalCode.length < 1 || postalCode.length > 20) {
        document.getElementById('postalCode').nextElementSibling.textContent = 'Postal code must be between 1 and 20 characters';
        console.log('Postal code validation failed:', postalCode);
        isValid = false;
    }

    // Country validation
    const country = document.getElementById('country').value;
    if (country.length < 1 || country.length > 40) {
        document.getElementById('country').nextElementSibling.textContent = 'Country must be between 1 and 40 characters';
        console.log('Country validation failed:', country);
        isValid = false;
    }

    console.log('Form validation result:', isValid);
    return isValid;
}

// Add event listeners for real-time validation
document.addEventListener('DOMContentLoaded', function() {
    const inputs = [
        'userid', 'password', 'confirmPassword', 'firstName', 'lastName',
        'email', 'phonenum', 'address', 'city', 'state', 'postalCode', 'country'
    ];
    inputs.forEach(id => {
        const element = document.getElementById(id);
        if (element) {
            // Add error div if not exists
            if (!element.nextElementSibling || !element.nextElementSibling.classList.contains('text-danger')) {
                const errorDiv = document.createElement('div');
                errorDiv.className = 'text-danger';
                element.parentNode.insertBefore(errorDiv, element.nextSibling);
            }
            element.addEventListener('blur', function() {
                validateForm();
            });
        }
    });
});
</script>

</body>
</html>
