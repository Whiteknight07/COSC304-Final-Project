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
        max-width: 500px;
        margin: 20px auto;
        padding: 20px;
        background-color: white;
        border-radius: 5px;
        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    }
    .checkout-form input[type="text"],
    .checkout-form input[type="password"] {
        width: 100%;
        padding: 8px;
        margin: 5px 0;
        border: 1px solid #ddd;
        border-radius: 4px;
    }
    .checkout-form input[type="submit"],
    .checkout-form input[type="reset"] {
        padding: 8px 15px;
        margin: 10px 5px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }
    .checkout-form input[type="submit"] {
        background-color: #4CAF50;
        color: white;
    }
    .checkout-form input[type="reset"] {
        background-color: #f44336;
        color: white;
    }
</style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="checkout-container">
    <h1>Enter your customer id and password to complete the transaction:</h1>

    <form method="get" action="order.jsp" class="checkout-form">
        <table>
            <tr>
                <td>Customer ID:</td>
                <td><input type="text" name="customerId" size="20"></td>
            </tr>
            <tr>
                <td>Password:</td>
                <td><input type="password" name="password" size="20"></td>
            </tr>
            <tr>
                <td><input type="submit" value="Submit"></td>
                <td><input type="reset" value="Reset"></td>
            </tr>
        </table>
    </form>
</div>

</body>
</html>

