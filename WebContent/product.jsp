<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>

<!DOCTYPE html>
<html>
<head>
    <title>Ray's Grocery - Product Information</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f4f9;
            color: #333;
            margin: 0;
            padding: 0;
        }
        .product-info {
            margin: 20px;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            background-color: #fff;
        }
        .info-row {
            margin: 10px 0;
            display: flex;
            align-items: center;
        }
        .info-row:hover {
            background-color: #f1f1f1;
        }
        .label {
            font-weight: bold;
            width: 120px;
            color: #666;
        }
        .value {
            color: #333;
        }
        .price {
            color: #28a745;
            font-weight: bold;
            font-size: 1.4em;
        }
        .inventory-table {
            margin-top: 20px;
            width: 100%;
            border-collapse: collapse;
        }
        .inventory-table th, .inventory-table td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
        }
        .inventory-table th {
            background-color: #e9ecef;
        }
        .inventory-table tr:hover {
            background-color: #f1f1f1;
        }
        img {
            max-width: 300px;
            margin: 10px 0;
        }
        img[src=""], img:not([src]) {
            display: none;
        }
        .product-list {
            margin: 20px auto;
            max-width: 800px;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .product-list h2 {
            color: #333;
            margin-bottom: 20px;
            font-size: 24px;
            text-align: center;
        }
        .product-list ul {
            list-style: none;
            padding: 0;
        }
        .product-list li {
            margin: 10px 0;
            padding: 15px;
            border: 1px solid #eee;
            border-radius: 6px;
            transition: all 0.3s ease;
        }
        .product-list li:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .product-list a {
            color: #007bff;
            text-decoration: none;
            display: block;
            font-size: 16px;
        }
        .product-list a:hover {
            color: #0056b3;
        }
        .error-message {
            background-color: #fff;
            border: 1px solid #dc3545;
            border-radius: 6px;
            color: #dc3545;
            padding: 15px 20px;
            margin: 20px auto;
            max-width: 800px;
            text-align: center;
            font-size: 16px;
            box-shadow: 0 2px 4px rgba(220, 53, 69, 0.1);
        }
        .review-section {
            margin: 20px;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .review-form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        .rating-input, .review-input {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        .submit-review {
            padding: 10px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .submit-review:hover {
            background-color: #218838;
        }
        .reviews-display {
            margin: 20px;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .review-item {
            border-bottom: 1px solid #eee;
            padding: 15px 0;
        }
        .review-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            color: #666;
        }
        .review-rating {
            color: #ffc107;
        }
        .review-text {
            line-height: 1.5;
        }
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: 4px;
        }
        .alert-success {
            color: #155724;
            background-color: #d4edda;
            border-color: #c3e6cb;
        }
        .alert-warning {
            color: #856404;
            background-color: #fff3cd;
            border-color: #ffeeba;
        }
        .alert-danger {
            color: #721c24;
            background-color: #f8d7da;
            border-color: #f5c6cb;
        }
    </style>
    <link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>

<div class="product-info">
<%
String productId = request.getParameter("id");

if (productId == null || productId.trim().isEmpty()) {
    %>
    <div class="error-message">
        <p>Welcome to our product catalog! Please select a product from the list below to view details.</p>
    </div>
    <div class="product-list">
        <h2>Available Products</h2>
        <%
        try (Connection con = DriverManager.getConnection(url, uid, pw)) {
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT productId, productName, productPrice FROM product ORDER BY productName");
            %>
            <ul>
            <%
            while (rs.next()) {
                %>
                <li>
                    <a href="product.jsp?id=<%= rs.getInt("productId") %>">
                        <%= rs.getString("productName") %> - <%= NumberFormat.getCurrencyInstance().format(rs.getDouble("productPrice")) %>
                    </a>
                </li>
                <%
            }
            %>
            </ul>
            <%
        } catch (SQLException e) {
            out.println("<p>Error accessing database: " + e.getMessage() + "</p>");
        }
        %>
    </div>
    <%
} else {
    try (Connection con = DriverManager.getConnection(url, uid, pw)) {
        String sql = "SELECT * FROM product WHERE productId = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, productId);
        ResultSet rs = pstmt.executeQuery();
        
        if (rs.next()) {
            String productName = rs.getString("productName");
            double price = rs.getDouble("productPrice");
            String productImage = rs.getString("productImageURL");
            NumberFormat currFormat = NumberFormat.getCurrencyInstance();
            %>
            <h1><%= productName %></h1>
            
            <img src="<%= productImage %>" alt="Product Image" />
            <img src="<%= "displayImage.jsp?id="+productId %>"/>
            
            <div class="info-row">
                <span class="label">Product ID:</span>
                <span class="value"><%= productId %></span>
            </div>
            
            <div class="info-row">
                <span class="label">Price:</span>
                <span class="value price"><%= currFormat.format(price) %></span>
            </div>

            <% if (userName != null && !userName.isEmpty()) { %>
                <%
                String invSql = "SELECT w.warehouseName, COALESCE(pi.quantity, 0) as quantity " +
                              "FROM warehouse w " +
                              "LEFT JOIN productinventory pi ON w.warehouseId = pi.warehouseId " +
                              "AND pi.productId = ? " +
                              "ORDER BY w.warehouseId";
                PreparedStatement invStmt = con.prepareStatement(invSql);
                invStmt.setString(1, productId);
                ResultSet invRs = invStmt.executeQuery();
                %>
                <table class="inventory-table">
                    <tr>
                        <th>Warehouse</th>
                        <th>Stock Level</th>
                    </tr>
                    <% while (invRs.next()) { %>
                        <tr>
                            <td><%= invRs.getString("warehouseName") %></td>
                            <td><%= invRs.getInt("quantity") %></td>
                        </tr>
                    <% } %>
                </table>
            <% } %>
        <%
        } else {
            %>
            <div class="error-message">
                <p>Product not found with ID: <%= productId %></p>
            </div>
            <div class="product-list">
                <h2>Available Products</h2>
                <%
                Statement stmt = con.createStatement();
                ResultSet listRs = stmt.executeQuery("SELECT productId, productName, productPrice FROM product ORDER BY productName");
                %>
                <ul>
                <%
                while (listRs.next()) {
                    %>
                    <li>
                        <a href="product.jsp?id=<%= listRs.getInt("productId") %>">
                            <%= listRs.getString("productName") %> - <%= NumberFormat.getCurrencyInstance().format(listRs.getDouble("productPrice")) %>
                        </a>
                    </li>
                    <%
                }
                %>
                </ul>
            </div>
            <%
        }
    } catch (SQLException e) {
        out.println("<p>Error accessing database: " + e.getMessage() + "</p>");
    }
}
%>

<!-- Review Form -->
<div class="review-section">
    <h3>Write a Review</h3>
    <%
    String message = request.getParameter("message");
    if (message != null) {
        if (message.equals("already_reviewed")) {
            %><div class="alert alert-warning">You have already reviewed this product.</div><%
        } else if (message.equals("not_purchased")) {
            %><div class="alert alert-warning">You can only review products you have purchased.</div><%
        } else if (message.equals("review_success")) {
            %><div class="alert alert-success">Thank you for your review!</div><%
        } else if (message.equals("user_error")) {
            %><div class="alert alert-danger">There was an error with your user account.</div><%
        } else if (message.equals("error")) {
            String details = request.getParameter("details");
            %><div class="alert alert-danger">Error submitting review: <%= details != null ? details : "Unknown error" %></div><%
        }
    }

    if (session.getAttribute("authenticatedUser") != null) {
        Connection con2 = null;
        PreparedStatement custStmt = null;
        PreparedStatement reviewCheckStmt = null;
        PreparedStatement purchaseStmt = null;
        ResultSet custRs = null;
        ResultSet reviewCheckRs = null;
        ResultSet purchaseRs = null;

        try {
            con2 = DriverManager.getConnection(url, uid, pw);
            String userId = session.getAttribute("authenticatedUser").toString();
            
            // Get customer ID
            String customerQuery = "SELECT customerId FROM customer WHERE userid = ?";
            custStmt = con2.prepareStatement(customerQuery);
            custStmt.setString(1, userId);
            custRs = custStmt.executeQuery();
            
            if (custRs.next()) {
                int customerId = custRs.getInt("customerId");
                
                // Check for existing review
                String reviewCheckQuery = "SELECT reviewId FROM review WHERE customerId = ? AND productId = ?";
                reviewCheckStmt = con2.prepareStatement(reviewCheckQuery);
                reviewCheckStmt.setInt(1, customerId);
                reviewCheckStmt.setInt(2, Integer.parseInt(productId));
                reviewCheckRs = reviewCheckStmt.executeQuery();
                
                if (!reviewCheckRs.next()) {
                    // Check if purchased
                    String purchaseQuery = "SELECT op.orderId FROM orderproduct op " +
                                       "JOIN ordersummary os ON op.orderId = os.orderId " +
                                       "WHERE os.customerId = ? AND op.productId = ?";
                    purchaseStmt = con2.prepareStatement(purchaseQuery);
                    purchaseStmt.setInt(1, customerId);
                    purchaseStmt.setInt(2, Integer.parseInt(productId));
                    purchaseRs = purchaseStmt.executeQuery();
                    
                    if (purchaseRs.next()) {
                        // Show review form only if user has purchased and not reviewed
                        %>
                        <form action="submitReview.jsp" method="POST" class="review-form">
                            <input type="hidden" name="productId" value="<%= productId %>">
                            <div class="rating-input">
                                <label>Rating:</label>
                                <select name="rating" required>
                                    <option value="5">5 - Excellent</option>
                                    <option value="4">4 - Very Good</option>
                                    <option value="3">3 - Good</option>
                                    <option value="2">2 - Fair</option>
                                    <option value="1">1 - Poor</option>
                                </select>
                            </div>
                            <div class="review-input">
                                <label>Your Review:</label>
                                <textarea name="reviewText" required rows="4" cols="50"></textarea>
                            </div>
                            <button type="submit" class="submit-review">Submit Review</button>
                        </form>
                        <%
                    } else {
                        %><p>You can only review products you have purchased.</p><%
                    }
                } else {
                    %><p>You have already reviewed this product.</p><%
                }
            }
        } catch (SQLException ex) {
            %><p>Error checking purchase history: <%= ex.getMessage() %></p><%
        } finally {
            try {
                if (custRs != null) custRs.close();
                if (reviewCheckRs != null) reviewCheckRs.close();
                if (purchaseRs != null) purchaseRs.close();
                if (custStmt != null) custStmt.close();
                if (reviewCheckStmt != null) reviewCheckStmt.close();
                if (purchaseStmt != null) purchaseStmt.close();
                if (con2 != null) con2.close();
            } catch (SQLException ex) {
                %><p>Error closing database resources: <%= ex.getMessage() %></p><%
            }
        }
    } else {
        %><p>Please <a href="login.jsp">login</a> to write a review.</p><%
    }
    %>
</div>

<!-- Display Reviews -->
<div class="reviews-display">
    <h3>Customer Reviews</h3>
    <%
    try {
        getConnection();
        String reviewSql = "SELECT r.*, c.firstName, c.lastName FROM review r JOIN customer c ON r.customerId = c.customerId WHERE r.productId = ? ORDER BY r.reviewDate DESC";
        PreparedStatement reviewStmt = con.prepareStatement(reviewSql);
        reviewStmt.setInt(1, Integer.parseInt(productId));
        ResultSet reviewRs = reviewStmt.executeQuery();

        while (reviewRs.next()) {
            %>
            <div class="review-item">
                <div class="review-header">
                    <span class="review-rating">
                        <% for(int i = 0; i < reviewRs.getInt("reviewRating"); i++) { %>★<% } %>
                        <% for(int i = reviewRs.getInt("reviewRating"); i < 5; i++) { %>☆<% } %>
                    </span>
                    <span class="review-author">by <%= reviewRs.getString("firstName") %> <%= reviewRs.getString("lastName") %></span>
                    <span class="review-date"><%= reviewRs.getTimestamp("reviewDate") %></span>
                </div>
                <div class="review-text">
                    <%= reviewRs.getString("reviewComment") %>
                </div>
            </div>
            <%
        }
        reviewRs.close();
        reviewStmt.close();
    } catch (SQLException ex) {
        out.println("Failed to load reviews: " + ex.getMessage());
    } finally {
        closeConnection();
    }
    %>
</div>

</div>

</body>
</html>
