<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Store Inventory - Ray's Grocery</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f8f9fa;
        }
        .inventory-container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
        }
        .warehouse-section {
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            padding: 20px;
        }
        .warehouse-header {
            background-color: #4CAF50;
            color: white;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
        }
        .inventory-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        .inventory-table th, .inventory-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .inventory-table th {
            background-color: #f8f9fa;
            font-weight: bold;
        }
        .inventory-table tr:hover {
            background-color: #f5f5f5;
        }
        .stock-low {
            color: #dc3545;
            font-weight: bold;
        }
        .stock-medium {
            color: #ffc107;
            font-weight: bold;
        }
        .stock-good {
            color: #28a745;
            font-weight: bold;
        }
        .warehouse-summary {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            padding: 10px;
            background-color: #f8f9fa;
            border-radius: 4px;
        }
        .summary-item {
            text-align: center;
        }
        .summary-item span {
            display: block;
            font-size: 1.2em;
            font-weight: bold;
            color: #4CAF50;
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="inventory-container">
    <h1>Store Inventory</h1>

    <%
    try {
        getConnection();
        
        // Get list of warehouses
        String warehouseQuery = "SELECT w.warehouseId, w.warehouseName FROM warehouse w";
        Statement stmt = con.createStatement();
        ResultSet warehouses = stmt.executeQuery(warehouseQuery);

        NumberFormat currFormat = NumberFormat.getCurrencyInstance();

        while (warehouses.next()) {
            int warehouseId = warehouses.getInt("warehouseId");
            String warehouseName = warehouses.getString("warehouseName");
    %>
            <div class="warehouse-section">
                <div class="warehouse-header">
                    <h2><%= warehouseName %></h2>
                </div>

                <%
                // Get warehouse summary
                String summaryQuery = "SELECT COUNT(DISTINCT pi.productId) as totalProducts, " +
                                    "SUM(pi.quantity) as totalItems, " +
                                    "SUM(pi.quantity * p.productPrice) as totalValue " +
                                    "FROM productinventory pi JOIN product p ON pi.productId = p.productId " +
                                    "WHERE pi.warehouseId = ?";
                PreparedStatement pstmt = con.prepareStatement(summaryQuery);
                pstmt.setInt(1, warehouseId);
                ResultSet summary = pstmt.executeQuery();

                if (summary.next()) {
                %>
                <div class="warehouse-summary">
                    <div class="summary-item">
                        <span><%= summary.getInt("totalProducts") %></span>
                        Total Products
                    </div>
                    <div class="summary-item">
                        <span><%= summary.getInt("totalItems") %></span>
                        Total Items
                    </div>
                    <div class="summary-item">
                        <span><%= currFormat.format(summary.getDouble("totalValue")) %></span>
                        Total Value
                    </div>
                </div>
                <%
                }

                // Get inventory for this warehouse with table aliases
                String inventoryQuery = "SELECT pi.productId, p.productName, pi.quantity, p.productPrice, c.categoryName " +
                                      "FROM productinventory pi " +
                                      "JOIN product p ON pi.productId = p.productId " +
                                      "JOIN category c ON p.categoryId = c.categoryId " +
                                      "WHERE pi.warehouseId = ? " +
                                      "ORDER BY c.categoryName, p.productName";
                pstmt = con.prepareStatement(inventoryQuery);
                pstmt.setInt(1, warehouseId);
                ResultSet inventory = pstmt.executeQuery();
                %>

                <table class="inventory-table">
                    <tr>
                        <th>Product ID</th>
                        <th>Product Name</th>
                        <th>Category</th>
                        <th>Quantity</th>
                        <th>Price</th>
                        <th>Total Value</th>
                    </tr>
                    <%
                    String currentCategory = "";
                    while (inventory.next()) {
                        int quantity = inventory.getInt("quantity");
                        double price = inventory.getDouble("productPrice");
                        String stockClass = quantity < 5 ? "stock-low" : 
                                          quantity < 10 ? "stock-medium" : "stock-good";
                        
                        String category = inventory.getString("categoryName");
                        if (!category.equals(currentCategory)) {
                            currentCategory = category;
                    %>
                            <tr>
                                <td colspan="6" style="background-color: #e9ecef; font-weight: bold;">
                                    <%= category %>
                                </td>
                            </tr>
                    <%
                        }
                    %>
                        <tr>
                            <td><%= inventory.getInt("productId") %></td>
                            <td><%= inventory.getString("productName") %></td>
                            <td><%= category %></td>
                            <td class="<%= stockClass %>"><%= quantity %></td>
                            <td><%= currFormat.format(price) %></td>
                            <td><%= currFormat.format(quantity * price) %></td>
                        </tr>
                    <%
                    }
                    %>
                </table>
            </div>
    <%
        }
    } catch (SQLException ex) {
        out.println("Error: " + ex.getMessage());
    } finally {
        closeConnection();
    }
    %>
</div>

</body>
</html>
