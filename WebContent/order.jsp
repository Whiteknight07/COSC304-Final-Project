<%@ page import="java.sql.*, java.util.HashMap, java.util.ArrayList, java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery Order Processing</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 20px;
        background-color: #f5f5f5;
    }
    h1, h4 {
        color: #333;
        text-align: center;
    }
    .order-table {
        width: 80%;
        margin: 20px auto;
        border-collapse: collapse;
        background-color: white;
        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        border-radius: 5px;
    }
    .order-table th {
        background-color: #4CAF50;
        color: white;
        padding: 12px;
        text-align: left;
    }
    .order-table td {
        padding: 10px;
        border-bottom: 1px solid #ddd;
    }
    .order-table tr:hover {
        background-color: #f5f5f5;
    }
    .success-message {
        text-align: center;
        color: #4CAF50;
        margin: 20px 0;
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

    // Validate required fields
    String[] requiredFields = {"firstName", "lastName", "address", "city", "state", "postalCode", "country", "phone", "paymentMethod"};
    String[] fieldNames = {"First Name", "Last Name", "Address", "City", "State", "Postal Code", "Country", "Phone", "Payment Method"};
    
    for (int i = 0; i < requiredFields.length; i++) {
        String value = request.getParameter(requiredFields[i]);
        if (value == null || value.trim().isEmpty()) {
            session.setAttribute("checkoutMessage", fieldNames[i] + " is required.");
            response.sendRedirect("checkout.jsp");
            return;
        }
    }

    // Validate field formats
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String address = request.getParameter("address");
    String city = request.getParameter("city");
    String state = request.getParameter("state");
    String postalCode = request.getParameter("postalCode");
    String country = request.getParameter("country");
    String phone = request.getParameter("phone");
    String paymentMethod = request.getParameter("paymentMethod");

    // Name validations
    if (!firstName.matches("[A-Za-z ]{2,40}") || !lastName.matches("[A-Za-z ]{2,40}")) {
        session.setAttribute("checkoutMessage", "Invalid name format. Please use only letters.");
        response.sendRedirect("checkout.jsp");
        return;
    }

    // Address validation
    if (address.length() < 5) {
        session.setAttribute("checkoutMessage", "Address must be at least 5 characters long.");
        response.sendRedirect("checkout.jsp");
        return;
    }

    // City and State validation
    if (!city.matches("[A-Za-z ]{2,40}") || !state.matches("[A-Za-z ]{2,40}")) {
        session.setAttribute("checkoutMessage", "Invalid city or state format. Please use only letters.");
        response.sendRedirect("checkout.jsp");
        return;
    }

    // Postal code validation
    if (!postalCode.matches("[A-Za-z0-9]{5,10}")) {
        session.setAttribute("checkoutMessage", "Invalid postal code format.");
        response.sendRedirect("checkout.jsp");
        return;
    }

    // Country validation
    if (!country.matches("[A-Za-z ]{2,40}")) {
        session.setAttribute("checkoutMessage", "Invalid country format. Please use only letters.");
        response.sendRedirect("checkout.jsp");
        return;
    }

    // Phone validation
    if (!phone.matches("[0-9-+]{10,15}")) {
        session.setAttribute("checkoutMessage", "Invalid phone number format.");
        response.sendRedirect("checkout.jsp");
        return;
    }

    // Payment validation
    if (paymentMethod.equals("credit") || paymentMethod.equals("debit")) {
        String cardName = request.getParameter("cardName");
        String cardNumber = request.getParameter("cardNumber");
        String expiryDate = request.getParameter("expiryDate");
        String cvv = request.getParameter("cvv");

        if (cardName == null || !cardName.matches("[A-Za-z ]{2,50}")) {
            session.setAttribute("checkoutMessage", "Invalid card name format.");
            response.sendRedirect("checkout.jsp");
            return;
        }

        if (cardNumber == null || !cardNumber.matches("\\d{16}")) {
            session.setAttribute("checkoutMessage", "Invalid card number format.");
            response.sendRedirect("checkout.jsp");
            return;
        }

        if (expiryDate == null || !expiryDate.matches("(0[1-9]|1[0-2])/[0-9]{2}")) {
            session.setAttribute("checkoutMessage", "Invalid expiry date format.");
            response.sendRedirect("checkout.jsp");
            return;
        }

        // Check if card is expired
        String[] dateParts = expiryDate.split("/");
        int month = Integer.parseInt(dateParts[0]);
        int year = Integer.parseInt(dateParts[1]) + 2000;
        java.util.Calendar expiry = java.util.Calendar.getInstance();
        expiry.set(year, month - 1, 1);
        if (expiry.before(java.util.Calendar.getInstance())) {
            session.setAttribute("checkoutMessage", "Card has expired.");
            response.sendRedirect("checkout.jsp");
            return;
        }

        if (cvv == null || !cvv.matches("\\d{3}")) {
            session.setAttribute("checkoutMessage", "Invalid CVV format.");
            response.sendRedirect("checkout.jsp");
            return;
        }
    }

    // Get customer ID
    String customerId = "";
    try {
        getConnection();
        String sql = "SELECT customerId FROM customer WHERE userid = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, userName);
        ResultSet rs = pstmt.executeQuery();
        if (rs.next()) {
            customerId = rs.getString("customerId");
        }
    } catch (SQLException ex) {
        out.println("<h1>Error retrieving customer ID: " + ex.getMessage() + "</h1>");
        return;
    } finally {
        closeConnection();
    }

    // Get shopping cart
    @SuppressWarnings({"unchecked"})
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    if (productList == null || productList.isEmpty()) {
        out.println("<h1>Your shopping cart is empty!</h1>");
        return;
    }

    try {
        getConnection();
        con.setAutoCommit(false);

        // Create a new order record
        String sql = "INSERT INTO ordersummary (orderDate, customerId, totalAmount) VALUES (GETDATE(), ?, 0)";
        PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        pstmt.setString(1, customerId);
        pstmt.executeUpdate();

        // Get the orderId
        ResultSet keys = pstmt.getGeneratedKeys();
        keys.next();
        int orderId = keys.getInt(1);

        // Insert each item into OrderProduct
        double total = 0;
        sql = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)";
        pstmt = con.prepareStatement(sql);

        for (String productId : productList.keySet()) {
            ArrayList<Object> product = productList.get(productId);
            double price = Double.parseDouble(product.get(2).toString());
            int quantity = Integer.parseInt(product.get(3).toString());
            double subtotal = price * quantity;
            total += subtotal;

            pstmt.setInt(1, orderId);
            pstmt.setString(2, productId);
            pstmt.setInt(3, quantity);
            pstmt.setDouble(4, price);
            pstmt.executeUpdate();
        }

        // Update total amount for order
        sql = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setDouble(1, total);
        pstmt.setInt(2, orderId);
        pstmt.executeUpdate();

        // Save shipping info
        sql = "UPDATE ordersummary SET shiptoAddress=?, shiptoCity=?, shiptoState=?, shiptoPostalCode=?, shiptoCountry=? WHERE orderId=?";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, request.getParameter("address"));
        pstmt.setString(2, request.getParameter("city"));
        pstmt.setString(3, request.getParameter("state"));
        pstmt.setString(4, request.getParameter("postalCode"));
        pstmt.setString(5, request.getParameter("country"));
        pstmt.setInt(6, orderId);
        pstmt.executeUpdate();

        // Save payment info (in a real system, this would be handled securely)
        // Payment method already validated and stored above
        // In a real system, you would integrate with a payment processor here

        // Process order and update inventory
        try {
            // Retrieve cart from session
            @SuppressWarnings("unchecked")
            HashMap<String, ArrayList<Object>> cartProductList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

            if (cartProductList != null) {
                for (Map.Entry<String, ArrayList<Object>> entry : cartProductList.entrySet()) {
                    String productId = entry.getKey();
                    ArrayList<Object> product = entry.getValue();
                    int quantity = (Integer) product.get(3);

                    // Update inventory
                    String updateSql = "UPDATE productinventory SET quantity = quantity - ? WHERE productId = ?";
                    PreparedStatement updateStmt = con.prepareStatement(updateSql);
                    updateStmt.setInt(1, quantity);
                    updateStmt.setString(2, productId);
                    updateStmt.executeUpdate();
                }
            }

            // Commit transaction
            con.commit();
            session.setAttribute("productList", null); // Clear cart
            response.sendRedirect("orderconfirmation.jsp?orderId=" + orderId);
        } catch (SQLException e) {
            con.rollback(); // Rollback transaction on error
            out.println("Error processing order: " + e.getMessage());
        } finally {
            if (con != null) {
                con.setAutoCommit(true);
                closeConnection();
            }
        }
    } catch (SQLException ex) {
        con.rollback();
        out.println("<h1>Error processing order: " + ex.getMessage() + "</h1>");
    } finally {
        if (con != null) {
            con.setAutoCommit(true);
            closeConnection();
        }
    }
%>
</BODY>
</HTML>