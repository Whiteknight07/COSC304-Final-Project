<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
	<title>Your Shopping Cart</title>
	<style>
		body {
			font-family: Arial, sans-serif;
			margin: 20px;
			background-color: #f4f4f9;
		}
		h1 {
			color: #333;
			text-align: center; /* Center the title */
		}
		table {
			width: 80%;
			margin: 20px auto;
			border-collapse: collapse;
			background-color: #fff;
			box-shadow: 0 2px 5px rgba(0,0,0,0.1);
		}
		th, td {
			padding: 12px;
			text-align: left;
			border-bottom: 1px solid #ddd;
		}
		th {
			background-color: #f8f8f8;
		}
		tr:hover {
			background-color: #f1f1f1;
		}
		td {
			text-align: center;
		}
		td:last-child {
			text-align: right;
		}
		.total-row {
			font-weight: bold;
			background-color: #f8f8f8;
		}
		a {
			text-decoration: none;
		}
		a.checkout {
			color: red; /* Red color for Check Out link */
		}
		a.continue-shopping {
			color: blue; /* Blue color for Continue Shopping link */
		}
		a:hover {
			text-decoration: underline;
		}
		.actions {
			text-align: center;
			margin-top: 20px;
		}
		.remove-item {
			color: #dc3545;
			text-decoration: none;
			padding: 5px 10px;
			border: 1px solid #dc3545;
			border-radius: 4px;
			font-size: 0.9em;
		}
		.remove-item:hover {
			background-color: #dc3545;
			color: white;
			text-decoration: none;
		}
	</style>
</head>
<body>

<%@ include file="header.jsp" %>

<%
	@SuppressWarnings({"unchecked"})
	HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

	if (productList == null) {
		out.println("<h1>Your shopping cart is empty!</h1>");
		productList = new HashMap<String, ArrayList<Object>>();
	} else {
		NumberFormat currFormat = NumberFormat.getCurrencyInstance();

		out.println("<h1>Your Shopping Cart</h1>");
		out.print("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
		out.println("<th>Price</th><th>Subtotal</th><th>Actions</th></tr>");

		double total = 0;
		Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();

		while (iterator.hasNext()) {
			Map.Entry<String, ArrayList<Object>> entry = iterator.next();
			ArrayList<Object> product = (ArrayList<Object>) entry.getValue();

			if (product.size() < 4) {
				out.println("Expected product with four entries. Got: " + product);
				continue;
			}

			String productId = product.get(0).toString();
			out.print("<tr><td>" + productId + "</td>");
			out.print("<td>" + product.get(1) + "</td>");

			out.print("<td>" + product.get(3) + "</td>");

			Object price = product.get(2);
			Object itemqty = product.get(3);

			double pr = 0;
			int qty = 0;

			try {
				pr = Double.parseDouble(price.toString());
			} catch (Exception e) {
				out.println("Invalid price for product: " + product.get(0) + " price: " + price);
			}

			try {
				qty = Integer.parseInt(itemqty.toString());
			} catch (Exception e) {
				out.println("Invalid quantity for product: " + product.get(0) + " quantity: " + qty);
			}

			out.print("<td>" + currFormat.format(pr) + "</td>");
			out.print("<td>" + currFormat.format(pr * qty) + "</td>");
			out.print("<td><a href='removecart.jsp?id=" + productId + "' class='remove-item'>Remove</a></td></tr>");

			total += pr * qty;
		}

		out.println("<tr class='total-row'><td colspan='5' align='right'><b>Order Total</b></td>"
				+ "<td align='right'>" + currFormat.format(total) + "</td></tr>");

		out.println("</table>");

		out.println("<div class='actions'><h2><a href=\"checkout.jsp\" class='checkout'>Check Out</a></h2></div>");
	}
%>

<div class="actions">
	<h2><a href="listprod.jsp" class='continue-shopping'>Continue Shopping</a></h2>
</div>

</body>
</html>