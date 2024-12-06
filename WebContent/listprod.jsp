<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="javax.xml.transform.Result" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>YOUR NAME Grocery</title>
	<style>
		body {
			font-family: Arial, sans-serif;
			margin: 20px;
		}
		.search-box {
			margin: 20px 0;
			padding: 15px;
			background-color: #f4f4f4;
			border-radius: 5px;
		}
		.search-box input[type="text"] {
			padding: 8px;
			width: 300px;
			border: 1px solid #ddd;
			border-radius: 4px;
		}
		.search-box input[type="submit"], 
		.search-box input[type="reset"] {
			padding: 8px 15px;
			margin-left: 10px;
			border: none;
			border-radius: 4px;
			cursor: pointer;
		}
		.search-box input[type="submit"] {
			background-color: #3399FF;
			color: white;
		}
		.search-box input[type="reset"] {
			background-color: #f44336;
			color: white;
		}
		.category {
			margin: 20px 0;
			padding: 10px;
			background-color: #f4f4f4;
		}
		.category h2 {
			color: #333;
			border-bottom: 1px solid #ddd;
			padding-bottom: 5px;
		}
		.product {
			padding: 10px;
			margin: 10px 0;
			background-color: white;
		}
		.product a {
			text-decoration: none;
		}
		.product-name {
			color: #333;
			font-weight: bold;
			font-size: 16px;
		}
		.product-name:hover {
			color: #3399FF;
			text-decoration: underline;
		}
		.add-button {
			float: right;
			background-color: #3399FF;
			color: white;
			padding: 5px 10px;
			text-decoration: none;
			border-radius: 3px;
		}
		
		.add-button:hover {
			background-color: #2979cc;
		}

		.review-button {
			float: right;
			background-color: #2ecc71;
			color: white;
			padding: 5px 10px;
			text-decoration: none;
			border-radius: 3px;
			margin-right: 15px;
		}
		
		.review-button:hover {
			background-color: #27ae60;
		}
		.btn {
			display: inline-block;
			font-weight: 400;
			text-align: center;
			vertical-align: middle;
			cursor: pointer;
			border: 1px solid transparent;
			padding: 0.375rem 0.75rem;
			font-size: 1rem;
			line-height: 1.5;
			border-radius: 0.25rem;
			transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out, border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
		}
		.btn-primary {
			color: #fff;
			background-color: #007bff;
			border-color: #007bff;
		}
		.btn-secondary {
			color: #fff;
			background-color: #6c757d;
			border-color: #6c757d;
		}
		.btn-primary:hover {
			background-color: #0069d9;
			border-color: #0062cc;
		}
		.btn-secondary:hover {
			background-color: #5a6268;
			border-color: #545b62;
		}
	</style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="search-box">
	<h1>Search for products:</h1>
	<form method="get" action="listprod.jsp">
		<input type="text" name="productName" placeholder="Enter product name...">
		<input type="submit" value="Search">
		<input type="reset" value="Reset">
	</form>
</div>

<%
	String name = request.getParameter("productName");
	String searchCondition = "";
	if (name != null && !name.isEmpty()) {
		searchCondition = " AND productName LIKE ?";
	}

	try {
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	} catch (java.lang.ClassNotFoundException e) {
		out.println("ClassNotFoundException: " + e);
	}

	try (Connection con = DriverManager.getConnection(url, uid, pw)) {
		String categoryQuery = "SELECT categoryId, categoryName FROM category ORDER BY categoryName";
		PreparedStatement categoryStmt = con.prepareStatement(categoryQuery);
		
		ResultSet categories = categoryStmt.executeQuery();

		while (categories.next()) {
			int categoryId = categories.getInt("categoryId");
			String categoryName = categories.getString("categoryName");

			String countQuery = "SELECT COUNT(*) as count FROM product WHERE categoryId = ?" + searchCondition;
			PreparedStatement countStmt = con.prepareStatement(countQuery);
			
			countStmt.setInt(1, categoryId);
			if (name != null && !name.isEmpty()) {
				countStmt.setString(2, "%" + name + "%");
			}
			ResultSet countResult = countStmt.executeQuery();
			countResult.next();
			int productCount = countResult.getInt("count");

			if (productCount > 0) {
				String productQuery = "SELECT productId, productName, productPrice FROM product WHERE categoryId = ?" + searchCondition;
				PreparedStatement productStmt = con.prepareStatement(productQuery);
				productStmt.setInt(1, categoryId);
				if (name != null && !name.isEmpty()) {
					productStmt.setString(2, "%" + name + "%");
				}
				ResultSet products = productStmt.executeQuery();

				out.println("<div class='category'>");
				out.println("<h2>" + categoryName + "</h2>");

				while (products.next()) {
					String productId = String.valueOf(products.getInt("productId"));
					String productName = products.getString("productName");
					double productPrice = products.getDouble("productPrice");

					out.println("<div class='product'>");
					out.println("<a href='addcart.jsp?id=" + productId + 
							"&name=" + URLEncoder.encode(productName, StandardCharsets.UTF_8) + 
							"&price=" + productPrice + "' class='add-button'>Add to Cart</a>");
					out.println("<a href='product.jsp?id=" + productId + "' class='review-button'>Review</a>");
					out.println("<a href='product.jsp?id=" + productId + "' class='product-name'>" + 
							productName + "</a>");
					out.println("<br>Price: $" + productPrice);
					out.println("</div>");
				}
				out.println("</div>");
			}
		}
	} catch (SQLException e) {
		out.println(e);
	}
%>

</body>
</html>