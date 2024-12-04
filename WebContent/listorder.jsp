<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<title>Order List</title>
	<style>
		body {
			font-family: Arial, sans-serif;
			margin: 20px;
		}
		h1 {
			color: #333;
		}
		table {
			width: 100%;
			margin-bottom: 20px;
		}
		th, td {
			border: 1px solid #ddd;
			padding: 8px;
			text-align: left;
		}
		th {
			background-color: #f2f2f2;
			font-weight: bold;
		}
		.order-summary th, .order-summary td {
			background-color: #e6f3ff;
		}
		.product-details th, .product-details td {
			background-color: #fff;
		}

	</style>
</head>
<body>

<%@ include file="header.jsp" %>

<h1>Order List</h1>

<%
	//Note: Forces loading of SQL Server driver
	try {
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	} catch (java.lang.ClassNotFoundException e) {
		out.println("ClassNotFoundException: " + e);
	}

	NumberFormat currFormat = NumberFormat.getCurrencyInstance();

	try (Connection con = DriverManager.getConnection(url, uid, pw)) {
		Statement stmt = con.createStatement();
		String query = "SELECT orderId, orderDate, ordersummary.customerId, firstName,lastName, totalAmount FROM ordersummary JOIN customer ON ordersummary.customerId = customer.customerId WHERE customer.userid = ?";
		PreparedStatement preparedStatement = con.prepareStatement(query);
		preparedStatement.setString(1, userName);
		ResultSet rs = preparedStatement.executeQuery();

		String productQuery = "SELECT orderproduct.productId, orderproduct.quantity, orderproduct.price FROM orderproduct JOIN product ON orderproduct.productId = product.productId WHERE orderproduct.orderId = ?";
		PreparedStatement pstmt = con.prepareStatement(productQuery);

		while (rs.next()) {
			out.println("<table class='order-summary'>");
			out.println("<tr>");
			out.println("<th>Order Id</th>");
			out.println("<th>Order Date</th>");
			out.println("<th>Customer Id</th>");
			out.println("<th>Customer Name</th>");
			out.println("<th>Total Amount</th>");
			out.println("</tr>");

			out.println("<tr>");
			out.println("<td>" + rs.getInt("orderId") + "</td>");
			out.println("<td>" + rs.getTimestamp("orderDate") + "</td>");
			out.println("<td>" + rs.getInt("customerId") + "</td>");
			out.println("<td>" + rs.getString("firstName")+"  "+rs.getString("lastName") + "</td>");
			out.println("<td>" + currFormat.format(rs.getDouble("totalAmount")) + "</td>");
			out.println("</tr>");

			pstmt.setInt(1, rs.getInt("orderId"));
			ResultSet productRs = pstmt.executeQuery();

			out.println("<tr><td colspan='5'>");
			out.println("<table class='product-details'>");
			out.println("<tr>");
			out.println("<th>Product Id</th>");
			out.println("<th>Quantity</th>");
			out.println("<th>Price</th>");
			out.println("</tr>");

			while (productRs.next()) {
				out.println("<tr>");
				out.println("<td>" + productRs.getInt("productId") + "</td>");
				out.println("<td>" + productRs.getInt("quantity") + "</td>");
				out.println("<td>" + currFormat.format(productRs.getDouble("price")) + "</td>");
				out.println("</tr>");
			}

			out.println("</table>");
			out.println("</td></tr>");

			out.println("</table><br>");
		}
	} catch (SQLException e) {
		out.println(e);
	}
%>

</body>
</html>