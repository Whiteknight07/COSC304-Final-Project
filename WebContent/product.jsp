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
</div>

</body>
</html>

