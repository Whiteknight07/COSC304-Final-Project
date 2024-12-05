<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Ray's Grocery Checkout</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f8f9fa;
        }
        .checkout-container {
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        .checkout-form {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        .form-section {
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .form-section h2 {
            margin-top: 0;
            color: #333;
            font-size: 1.2em;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #555;
        }
        .form-group input, .form-group select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .buttons {
            grid-column: span 2;
            text-align: center;
            padding: 20px;
        }
        .btn {
            padding: 10px 20px;
            margin: 0 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        .btn-primary {
            background-color: #4CAF50;
            color: white;
        }
        .btn-secondary {
            background-color: #f44336;
            color: white;
        }
        .error-message {
            color: #dc3545;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 4px;
            padding: 10px;
            margin-bottom: 20px;
            text-align: center;
        }
        .error {
            color: #dc3545;
            font-size: 0.875em;
            display: none;
            margin-top: 4px;
        }
        .input-error {
            border-color: #dc3545 !important;
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<%
    // Check if user is logged in
    if (userName == null || userName.isEmpty()) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get customer info if logged in
    String firstName = "", lastName = "", email = "", phone = "", address = "", city = "", state = "", postalCode = "", country = "";
    try {
        getConnection();
        String sql = "SELECT * FROM customer WHERE userid = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, userName);
        ResultSet rs = pstmt.executeQuery();
        
        if (rs.next()) {
            firstName = rs.getString("firstName");
            lastName = rs.getString("lastName");
            email = rs.getString("email");
            phone = rs.getString("phonenum");
            address = rs.getString("address");
            city = rs.getString("city");
            state = rs.getString("state");
            postalCode = rs.getString("postalCode");
            country = rs.getString("country");
        }
    } catch (SQLException ex) {
        out.println("<div class='error-message'>Error retrieving customer information: " + ex.getMessage() + "</div>");
    } finally {
        closeConnection();
    }
%>

<div class="checkout-container">
    <h1>Checkout</h1>
    
    <% 
    String message = (String) session.getAttribute("checkoutMessage");
    if (message != null) { 
    %>
        <div class="error-message"><%= message %></div>
    <%
        session.removeAttribute("checkoutMessage");
    } 
    %>

    <form method="post" action="order.jsp" class="checkout-form" id="checkoutForm" onsubmit="return validateCheckoutForm()">
        <!-- Shipping Information -->
        <div class="form-section">
            <h2>Shipping Information</h2>
            <div class="form-group">
                <label for="firstName">First Name:</label>
                <input type="text" id="firstName" name="firstName" value="<%= firstName %>" required pattern="[A-Za-z ]{2,40}">
                <div class="error" id="firstNameError">Please enter a valid first name (2-40 letters)</div>
            </div>
            <div class="form-group">
                <label for="lastName">Last Name:</label>
                <input type="text" id="lastName" name="lastName" value="<%= lastName %>" required pattern="[A-Za-z ]{2,40}">
                <div class="error" id="lastNameError">Please enter a valid last name (2-40 letters)</div>
            </div>
            <div class="form-group">
                <label for="address">Address:</label>
                <input type="text" id="address" name="address" value="<%= address %>" required minlength="5">
                <div class="error" id="addressError">Please enter a valid address (minimum 5 characters)</div>
            </div>
            <div class="form-group">
                <label for="city">City:</label>
                <input type="text" id="city" name="city" value="<%= city %>" required pattern="[A-Za-z ]{2,40}">
                <div class="error" id="cityError">Please enter a valid city name (2-40 letters)</div>
            </div>
            <div class="form-group">
                <label for="state">State/Province:</label>
                <input type="text" id="state" name="state" value="<%= state %>" required pattern="[A-Za-z ]{2,40}">
                <div class="error" id="stateError">Please enter a valid state/province (2-40 letters)</div>
            </div>
            <div class="form-group">
                <label for="postalCode">Postal Code:</label>
                <input type="text" id="postalCode" name="postalCode" value="<%= postalCode %>" required pattern="[A-Za-z0-9]{5,10}">
                <div class="error" id="postalCodeError">Please enter a valid postal code (5-10 characters)</div>
            </div>
            <div class="form-group">
                <label for="country">Country:</label>
                <input type="text" id="country" name="country" value="<%= country %>" required pattern="[A-Za-z ]{2,40}">
                <div class="error" id="countryError">Please enter a valid country name (2-40 letters)</div>
            </div>
            <div class="form-group">
                <label for="phone">Phone:</label>
                <input type="tel" id="phone" name="phone" value="<%= phone %>" required pattern="[0-9-+]{10,15}">
                <div class="error" id="phoneError">Please enter a valid phone number (10-15 digits)</div>
            </div>
        </div>

        <!-- Payment Information -->
        <div class="form-section">
            <h2>Payment Information</h2>
            <div class="form-group">
                <label for="paymentMethod">Payment Method:</label>
                <select id="paymentMethod" name="paymentMethod" required>
                    <option value="">Select Payment Method</option>
                    <option value="credit">Credit Card</option>
                    <option value="debit">Debit Card</option>
                    <option value="paypal">PayPal</option>
                </select>
                <div class="error" id="paymentMethodError">Please select a payment method</div>
            </div>
            <div id="cardDetails" style="display: none;">
                <div class="form-group">
                    <label for="cardName">Name on Card:</label>
                    <input type="text" id="cardName" name="cardName" pattern="[A-Za-z ]{2,50}">
                    <div class="error" id="cardNameError">Please enter the name as it appears on your card</div>
                </div>
                <div class="form-group">
                    <label for="cardNumber">Card Number:</label>
                    <input type="text" id="cardNumber" name="cardNumber" maxlength="16" placeholder="XXXX-XXXX-XXXX-XXXX">
                    <div class="error" id="cardNumberError">Please enter a valid 16-digit card number</div>
                </div>
                <div class="form-group">
                    <label for="expiryDate">Expiry Date:</label>
                    <input type="text" id="expiryDate" name="expiryDate" placeholder="MM/YY" maxlength="5">
                    <div class="error" id="expiryDateError">Please enter a valid expiry date (MM/YY)</div>
                </div>
                <div class="form-group">
                    <label for="cvv">CVV:</label>
                    <input type="text" id="cvv" name="cvv" maxlength="3" placeholder="XXX">
                    <div class="error" id="cvvError">Please enter a valid 3-digit CVV</div>
                </div>
            </div>
        </div>

        <div class="buttons">
            <button type="submit" class="btn btn-primary">Place Order</button>
            <button type="button" class="btn btn-secondary" onclick="window.location='showcart.jsp'">Back to Cart</button>
        </div>
    </form>
</div>

<script>
    function showError(elementId, message) {
        const element = document.getElementById(elementId);
        const errorElement = document.getElementById(elementId + 'Error');
        element.classList.add('input-error');
        errorElement.style.display = 'block';
        errorElement.textContent = message;
        return false;
    }

    function clearError(elementId) {
        const element = document.getElementById(elementId);
        const errorElement = document.getElementById(elementId + 'Error');
        element.classList.remove('input-error');
        errorElement.style.display = 'none';
    }

    function validateCheckoutForm() {
        let isValid = true;

        // Clear all previous errors
        const inputs = document.querySelectorAll('input, select');
        inputs.forEach(input => clearError(input.id));

        // Validate shipping information
        const nameRegex = /^[A-Za-z ]{2,40}$/;
        const postalRegex = /^[A-Za-z0-9]{5,10}$/;
        const phoneRegex = /^[0-9-+]{10,15}$/;

        if (!nameRegex.test(document.getElementById('firstName').value)) {
            isValid = showError('firstName', 'Please enter a valid first name (2-40 letters)');
        }
        if (!nameRegex.test(document.getElementById('lastName').value)) {
            isValid = showError('lastName', 'Please enter a valid last name (2-40 letters)');
        }
        if (document.getElementById('address').value.length < 5) {
            isValid = showError('address', 'Please enter a valid address (minimum 5 characters)');
        }
        if (!nameRegex.test(document.getElementById('city').value)) {
            isValid = showError('city', 'Please enter a valid city name (2-40 letters)');
        }
        if (!nameRegex.test(document.getElementById('state').value)) {
            isValid = showError('state', 'Please enter a valid state/province (2-40 letters)');
        }
        if (!postalRegex.test(document.getElementById('postalCode').value)) {
            isValid = showError('postalCode', 'Please enter a valid postal code (5-10 characters)');
        }
        if (!nameRegex.test(document.getElementById('country').value)) {
            isValid = showError('country', 'Please enter a valid country name (2-40 letters)');
        }
        if (!phoneRegex.test(document.getElementById('phone').value)) {
            isValid = showError('phone', 'Please enter a valid phone number (10-15 digits)');
        }

        // Validate payment information
        const paymentMethod = document.getElementById('paymentMethod').value;
        if (!paymentMethod) {
            isValid = showError('paymentMethod', 'Please select a payment method');
        }

        if (paymentMethod === 'credit' || paymentMethod === 'debit') {
            // Card name validation
            if (!nameRegex.test(document.getElementById('cardName').value)) {
                isValid = showError('cardName', 'Please enter a valid name on card (2-50 letters)');
            }

            // Card number validation
            const cardNumber = document.getElementById('cardNumber').value.replace(/\D/g, '');
            if (!/^\d{16}$/.test(cardNumber)) {
                isValid = showError('cardNumber', 'Please enter a valid 16-digit card number');
            }

            // Expiry date validation
            const expiryDate = document.getElementById('expiryDate').value;
            if (!/^(0[1-9]|1[0-2])\/([0-9]{2})$/.test(expiryDate)) {
                isValid = showError('expiryDate', 'Please enter a valid expiry date (MM/YY)');
            } else {
                const [month, year] = expiryDate.split('/');
                const expiry = new Date(2000 + parseInt(year), parseInt(month) - 1);
                if (expiry < new Date()) {
                    isValid = showError('expiryDate', 'Card has expired');
                }
            }

            // CVV validation
            if (!/^\d{3}$/.test(document.getElementById('cvv').value)) {
                isValid = showError('cvv', 'Please enter a valid 3-digit CVV');
            }
        }

        return isValid;
    }

    // Payment method change handler
    document.getElementById('paymentMethod').addEventListener('change', function() {
        const cardDetails = document.getElementById('cardDetails');
        const cardInputs = cardDetails.getElementsByTagName('input');
        
        if (this.value === 'credit' || this.value === 'debit') {
            cardDetails.style.display = 'block';
            for (let input of cardInputs) {
                input.required = true;
            }
        } else {
            cardDetails.style.display = 'none';
            for (let input of cardInputs) {
                input.required = false;
                input.value = '';
                clearError(input.id);
            }
        }
    });

    // Format card number as user types
    document.getElementById('cardNumber').addEventListener('input', function(e) {
        let value = this.value.replace(/\D/g, '');
        if (value.length > 16) value = value.slice(0, 16);
        this.value = value;
    });

    // Format expiry date
    document.getElementById('expiryDate').addEventListener('input', function(e) {
        let value = this.value.replace(/\D/g, '');
        if (value.length >= 2) {
            value = value.slice(0, 2) + '/' + value.slice(2);
        }
        this.value = value;
    });

    // Format CVV
    document.getElementById('cvv').addEventListener('input', function(e) {
        this.value = this.value.replace(/\D/g, '').slice(0, 3);
    });
</script>

</body>
</html>
