<!DOCTYPE html>
<html>
<head>
    <title>Edit Account</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card mt-5">
                <div class="card-body">
                    <h3 class="card-title text-center">Edit Account Information</h3>

                    <%
                    // Print edit message if present
                    if (session.getAttribute("editMessage") != null) {
                        out.println("<p class='text-center " + 
                            (session.getAttribute("editMessage").toString().contains("success") ? "text-success" : "text-danger") + 
                            "'>" + session.getAttribute("editMessage").toString() + "</p>");
                        session.removeAttribute("editMessage");
                    }

                    String userid = (String) session.getAttribute("authenticatedUser");
                    try {
                        getConnection();
                        String sql = "SELECT * FROM customer WHERE userid = ?";
                        PreparedStatement pstmt = con.prepareStatement(sql);
                        pstmt.setString(1, userid);
                        ResultSet rs = pstmt.executeQuery();
                        
                        if (rs.next()) {
                    %>

                    <form name="EditForm" method="post" action="validateEdit.jsp" onsubmit="return validateForm()">
                        <div class="mb-3">
                            <label for="currentPassword" class="form-label">Current Password:</label>
                            <input type="password" class="form-control" id="currentPassword" name="currentPassword">
                            <div id="currentPasswordError" class="text-danger"></div>
                        </div>

                        <div class="mb-3">
                            <label for="newPassword" class="form-label">New Password (leave blank to keep current):</label>
                            <input type="password" class="form-control" id="newPassword" name="newPassword">
                            <div id="newPasswordError" class="text-danger"></div>
                        </div>

                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label">Confirm New Password:</label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword">
                            <div id="confirmPasswordError" class="text-danger"></div>
                        </div>

                        <div class="mb-3">
                            <label for="email" class="form-label">Email:</label>
                            <input type="email" class="form-control" id="email" name="email" value="<%= rs.getString("email") %>" required>
                            <div id="emailError" class="text-danger"></div>
                        </div>

                        <div class="mb-3">
                            <label for="phonenum" class="form-label">Phone Number:</label>
                            <input type="tel" class="form-control" id="phonenum" name="phonenum" value="<%= rs.getString("phonenum") %>" required>
                            <div id="phoneError" class="text-danger"></div>
                        </div>

                        <div class="mb-3">
                            <label for="address" class="form-label">Address:</label>
                            <input type="text" class="form-control" id="address" name="address" value="<%= rs.getString("address") %>" required>
                        </div>

                        <div class="mb-3">
                            <label for="city" class="form-label">City:</label>
                            <input type="text" class="form-control" id="city" name="city" value="<%= rs.getString("city") %>" required>
                        </div>

                        <div class="mb-3">
                            <label for="state" class="form-label">State/Province:</label>
                            <input type="text" class="form-control" id="state" name="state" value="<%= rs.getString("state") %>" required>
                        </div>

                        <div class="mb-3">
                            <label for="postalCode" class="form-label">Postal Code:</label>
                            <input type="text" class="form-control" id="postalCode" name="postalCode" value="<%= rs.getString("postalCode") %>" required>
                        </div>

                        <div class="mb-3">
                            <label for="country" class="form-label">Country:</label>
                            <input type="text" class="form-control" id="country" name="country" value="<%= rs.getString("country") %>" required>
                        </div>

                        <div class="text-center">
                            <input type="submit" class="btn btn-primary" value="Save Changes">
                        </div>
                    </form>

                    <%
                        }
                    } catch (SQLException ex) {
                        out.println("<p class='text-danger'>Error: " + ex.getMessage() + "</p>");
                    } finally {
                        closeConnection();
                    }
                    %>
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

    const currentPassword = document.getElementById('currentPassword').value;
    const newPassword = document.getElementById('newPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;

    // Current password is required if changing password
    if (newPassword && !currentPassword) {
        document.getElementById('currentPasswordError').textContent = 'Current password is required to change password';
        console.log('Current password validation failed: missing current password');
        isValid = false;
    }

    // New password validation
    if (newPassword) {
        if (newPassword.length < 6) {
            document.getElementById('newPasswordError').textContent = 'New password must be at least 6 characters long';
            console.log('New password length validation failed');
            isValid = false;
        }
        if (newPassword !== confirmPassword) {
            document.getElementById('confirmPasswordError').textContent = 'Passwords do not match';
            console.log('New password match validation failed');
            isValid = false;
        }
    }

    // Email validation
    const email = document.getElementById('email').value;
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        document.getElementById('emailError').textContent = 'Please enter a valid email address';
        console.log('Email validation failed:', email);
        isValid = false;
    }

    // Phone validation
    const phone = document.getElementById('phonenum').value;
    const phoneRegex = /^\d{10}$/;
    if (!phoneRegex.test(phone.replace(/\D/g, ''))) {
        document.getElementById('phoneError').textContent = 'Please enter a valid 10-digit phone number';
        console.log('Phone validation failed:', phone);
        isValid = false;
    }

    console.log('Form validation result:', isValid);
    return isValid;
}

// Add event listeners to show real-time validation
document.addEventListener('DOMContentLoaded', function() {
    const inputs = ['currentPassword', 'newPassword', 'confirmPassword', 'email', 'phonenum'];
    inputs.forEach(id => {
        const element = document.getElementById(id);
        if (element) {
            element.addEventListener('blur', function() {
                validateForm();
            });
        }
    });
});
</script>

</body>
</html>
