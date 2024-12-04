<!DOCTYPE html>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>
<html>
<head>
<title>Administrator Page</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 20px;
        background-color: #f4f4f9;
    }
    .admin-section {
        background-color: white;
        padding: 15px;
        margin: 20px auto;
        max-width: 1200px;
        border-radius: 5px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }
    .section-title {
        color: #333;
        border-bottom: 2px solid #3399FF;
        padding-bottom: 5px;
        margin-bottom: 15px;
        text-align: center;
    }
    .customer-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
        margin-bottom: 40px;
    }
    .customer-table th {
        background-color: #3399FF;
        color: white;
        text-align: left;
        padding: 12px;
    }
    .customer-table td {
        padding: 10px;
        border-bottom: 1px solid #ddd;
    }
    .customer-table tr:hover {
        background-color: #f5f5f5;
    }
    .customer-table tr.total-row {
        font-weight: bold;
        background-color: #e6f3ff;
    }
</style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="admin-section">
    <h1 class="section-title">Administrator Portal</h1>
    
    <%
    if (userName != null) {
        NumberFormat currFormat = NumberFormat.getCurrencyInstance();
        
        // Load SQL Server driver
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (java.lang.ClassNotFoundException e) {
            out.println("ClassNotFoundException: " + e);
        }

        try (Connection con = DriverManager.getConnection(url, uid, pw)) {
            String salesSql = "SELECT c.customerId, c.firstName, c.lastName, COUNT(o.orderId) as totalOrders, SUM(o.totalAmount) as totalSales FROM customer c LEFT JOIN ordersummary o ON c.customerId = o.customerId GROUP BY c.customerId, c.firstName, c.lastName ORDER BY c.customerId ASC";
            
            Statement salesStmt = con.createStatement();
            ResultSet salesResult = salesStmt.executeQuery(salesSql);

            out.println("<h2 class='section-title'>Sales Report</h2>");
            out.println("<table class='customer-table'>");
            out.println("<tr>");
            out.println("<th>Customer ID</th>");
            out.println("<th>Customer Name</th>");
            out.println("<th>Total Orders</th>");
            out.println("<th>Total Sales</th>");
            out.println("</tr>");

            double grandTotal = 0;
            int totalOrders = 0;

            while (salesResult.next()) {
                int orders = salesResult.getInt("totalOrders");
                double sales = salesResult.getDouble("totalSales");
                grandTotal += sales;
                totalOrders += orders;

                out.println("<tr>");
                out.println("<td>" + salesResult.getInt("customerId") + "</td>");
                out.println("<td>" + salesResult.getString("firstName") + " " + salesResult.getString("lastName") + "</td>");
                out.println("<td>" + orders + "</td>");
                out.println("<td>" + currFormat.format(sales) + "</td>");
                out.println("</tr>");
            }

            out.println("<tr class='total-row'>");
            out.println("<td colspan='2'><b>TOTAL</b></td>");
            out.println("<td><b>" + totalOrders + "</b></td>");
            out.println("<td><b>" + currFormat.format(grandTotal) + "</b></td>");
            out.println("</tr>");
            out.println("</table>");

            String customerSql = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country FROM customer ORDER BY customerId";
            Statement custStmt = con.createStatement();
            ResultSet custResult = custStmt.executeQuery(customerSql);

            out.println("<h2 class='section-title'>Customer List</h2>");
            out.println("<table class='customer-table'>");
            out.println("<tr>");
            out.println("<th>ID</th>");
            out.println("<th>Name</th>");
            out.println("<th>Email</th>");
            out.println("<th>Phone</th>");
            out.println("<th>Address</th>");
            out.println("<th>City</th>");
            out.println("<th>State</th>");
            out.println("<th>Postal Code</th>");
            out.println("<th>Country</th>");
            out.println("</tr>");

            while (custResult.next()) {
                out.println("<tr>");
                out.println("<td>" + custResult.getInt("customerId") + "</td>");
                out.println("<td>" + custResult.getString("firstName") + " " + custResult.getString("lastName") + "</td>");
                out.println("<td>" + custResult.getString("email") + "</td>");
                out.println("<td>" + custResult.getString("phonenum") + "</td>");
                out.println("<td>" + custResult.getString("address") + "</td>");
                out.println("<td>" + custResult.getString("city") + "</td>");
                out.println("<td>" + custResult.getString("state") + "</td>");
                out.println("<td>" + custResult.getString("postalCode") + "</td>");
                out.println("<td>" + custResult.getString("country") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
        } catch (SQLException e) {
            out.println("SQLException: " + e);
        }
    }
    %>
</div>

</body>
</html>

