<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
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
    // Get customer id and password
    String custId = request.getParameter("customerId");
    String custPass = request.getParameter("password");
    @SuppressWarnings({"unchecked"})
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    } catch (java.lang.ClassNotFoundException e) {
        out.println("ClassNotFoundException: " + e);
    }

    try (Connection con = DriverManager.getConnection(url, uid, pw)) {
        con.setAutoCommit(false);  // Start transaction

        // First check if the input is a numeric customer ID
        String customerQuery;
        if (custId != null && custId.matches("\\d+")) {
            customerQuery = "SELECT customerId, password FROM customer WHERE customerId = ?";
        } else {
            customerQuery = "SELECT customerId, password FROM customer WHERE userid = ?";
        }

        String actualCustomerId = null;
        try (PreparedStatement pstmt = con.prepareStatement(customerQuery)) {
            pstmt.setString(1, custId);
            ResultSet rs = pstmt.executeQuery();
            
            if (!rs.next()) {
                out.println("<h4>Customer does not exist or password is wrong</h4>");
                return;
            }
            
            String dbPassword = rs.getString("password");
            if (!dbPassword.equals(custPass)) {
                out.println("<h4>Incorrect password. Note: Passwords are case-sensitive.</h4>");
                return;
            }
            
            actualCustomerId = String.valueOf(rs.getInt("customerId"));
        }

        // Check if shopping cart is empty
        if (productList == null || productList.isEmpty()) {
            out.println("<h4>Shopping cart is empty</h4>");
            return;
        }

        // Insert order summary
        String sql = "INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (?, GETDATE(), 0)";
        int orderId;
        try (PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, actualCustomerId);
            pstmt.executeUpdate();
            ResultSet keys = pstmt.getGeneratedKeys();
            keys.next();
            orderId = keys.getInt(1);
        }

        double totalAmount = 0;

        String insertProduct = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)";
        try (PreparedStatement pstmt = con.prepareStatement(insertProduct)) {
            for (Map.Entry<String, ArrayList<Object>> entry : productList.entrySet()) {
                ArrayList<Object> product = entry.getValue();
                String productId = (String) product.get(0);
                String price = (String) product.get(2);
                double pr = Double.parseDouble(price);
                int qty = ((Integer) product.get(3)).intValue();

                pstmt.setInt(1, orderId);
                pstmt.setString(2, productId);
                pstmt.setInt(3, qty);
                pstmt.setDouble(4, pr);
                pstmt.executeUpdate();

                totalAmount += pr * qty;
            }
        }

        // Update total amount in ordersummary
        String updateTotal = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";
        try (PreparedStatement pstmt = con.prepareStatement(updateTotal)) {
            pstmt.setDouble(1, totalAmount);
            pstmt.setInt(2, orderId);
            pstmt.executeUpdate();
        }

        String showOrder="Select orderId,productId,quantity,price from orderproduct where orderId=?";
        try (PreparedStatement pstmt=con.prepareStatement(showOrder)){
            pstmt.setInt(1,orderId);
            ResultSet resultSet=pstmt.executeQuery();
            out.println("<h1>Order Summary</h1>");
            out.println("<table class='order-table'>");
            out.println("<tr>");
            out.println("<th>Product Id</th>");
            out.println("<th>Quantity</th>");
            out.println("<th>Price</th>");
            out.println("</tr>");
            NumberFormat currFormat = NumberFormat.getCurrencyInstance();
            while (resultSet.next()){
                out.println("<tr>");
                out.println("<td>"+resultSet.getInt("productId")+"</td>");
                out.println("<td>"+resultSet.getInt("quantity")+"</td>");
                out.println("<td>"+currFormat.format(resultSet.getDouble("price"))+"</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            out.println("<div class='success-message'><h4>Order completed successfully!</h4></div>");
        }

        con.commit();  // Commit transaction


    } catch (SQLException e) {
        out.println(e);
    }
%>
</BODY>
</HTML>

