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
        .product-info {
            margin: 20px;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .info-row {
            margin: 10px 0;
            display: flex;
            align-items: center;
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
            font-size: 1.2em;
        }
        .inventory-table {
            margin-top: 20px;
            width: 100%;
            border-collapse: collapse;
        }
        .inventory-table th, .inventory-table td {
            padding: 8px;
            border: 1px solid #ddd;
            text-align: left;
        }
        .inventory-table th {
            background-color: #f8f9fa;
        }
        img {
            max-width: 300px;
            margin: 10px 0;
        }
        img[src=""], img:not([src]) {
            display: none;
        }
        .product-list {
            margin-top: 20px;
        }
        .product-list h2 {
            color: #333;
            margin-bottom: 15px;
        }
        .product-list ul {
            list-style: none;
            padding: 0;
        }
        .product-list li {
            margin: 10px 0;
            padding: 10px;
            border: 1px solid #eee;
            border-radius: 4px;
        }
        .product-list a {
            color: #007bff;
            text-decoration: none;
        }
        .product-list a:hover {
            text-decoration: underline;
        }
        .error-message {
            color: #dc3545;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #dc3545;
            border-radius: 4px;
            background-color: #f8d7da;
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
        <p>No product ID specified. Please select a product from the list below:</p>
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
