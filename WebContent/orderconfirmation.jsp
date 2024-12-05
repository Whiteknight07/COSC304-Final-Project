<%@ page import="java.sql.*, java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Order Confirmation - Ray's Grocery</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f8f9fa;
        }
        .confirmation-container {
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        .order-details {
            margin: 20px 0;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .order-table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        .order-table th, .order-table td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }
        .order-table th {
            background-color: #f8f9fa;
        }
        .shipping-info {
            margin: 20px 0;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .success-message {
            color: #28a745;
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            border-radius: 4px;
            padding: 15px;
            margin-bottom: 20px;
            text-align: center;
        }
        .total-amount {
            font-size: 1.2em;
            font-weight: bold;
            text-align: right;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<%
    String orderId = request.getParameter("orderId");
    if (orderId == null || orderId.isEmpty()) {
        response.sendRedirect("index.jsp");
        return;
    }

    try {
        getConnection();
        
        // Get order details
        String sql = "SELECT O.*, C.firstName, C.lastName " +
                    "FROM ordersummary O JOIN customer C ON O.customerId = C.customerId " +
                    "WHERE orderId = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, orderId);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            NumberFormat currFormat = NumberFormat.getCurrencyInstance();
%>
            <div class="confirmation-container">
                <div class="success-message">
                    <h2>Order Confirmed!</h2>
                    <p>Thank you for your order, <%= rs.getString("firstName") %> <%= rs.getString("lastName") %>!</p>
                </div>

                <div class="order-details">
                    <h3>Order Information</h3>
                    <p><strong>Order ID:</strong> <%= orderId %></p>
                    <p><strong>Order Date:</strong> <%= rs.getTimestamp("orderDate") %></p>
                    
                    <h3>Shipping Information</h3>
                    <div class="shipping-info">
                        <p><%= rs.getString("shiptoAddress") %></p>
                        <p><%= rs.getString("shiptoCity") %>, <%= rs.getString("shiptoState") %></p>
                        <p><%= rs.getString("shiptoPostalCode") %></p>
                        <p><%= rs.getString("shiptoCountry") %></p>
                    </div>

                    <h3>Order Summary</h3>
                    <table class="order-table">
                        <tr>
                            <th>Product</th>
                            <th>Quantity</th>
                            <th>Price</th>
                            <th>Subtotal</th>
                        </tr>
<%
                        // Get order products
                        sql = "SELECT OP.*, P.productName FROM orderproduct OP JOIN product P ON OP.productId = P.productId WHERE orderId = ?";
                        pstmt = con.prepareStatement(sql);
                        pstmt.setString(1, orderId);
                        ResultSet products = pstmt.executeQuery();

                        while (products.next()) {
                            double price = products.getDouble("price");
                            int quantity = products.getInt("quantity");
                            double subtotal = price * quantity;
%>
                            <tr>
                                <td><%= products.getString("productName") %></td>
                                <td><%= quantity %></td>
                                <td><%= currFormat.format(price) %></td>
                                <td><%= currFormat.format(subtotal) %></td>
                            </tr>
<%
                        }
%>
                    </table>
                    <div class="total-amount">
                        Total Amount: <%= currFormat.format(rs.getDouble("totalAmount")) %>
                    </div>
                </div>
            </div>
<%
        } else {
            out.println("<h1>Order not found!</h1>");
        }
    } catch (SQLException ex) {
        out.println("<h1>Error retrieving order: " + ex.getMessage() + "</h1>");
    } finally {
        closeConnection();
    }
%>

</body>
</html>