<!DOCTYPE html>
<html>
<head>
	<title>Customer Profile</title>
	<style>
		body {
			font-family: Arial, sans-serif;
			margin: 20px;
		}
		.category-section {
			background-color: white;
			padding: 15px;
			margin: 20px auto;
			max-width: 800px;
			border-radius: 5px;
			box-shadow: 0 2px 5px rgba(0,0,0,0.1);
		}
		.category-title {
			color: #333;
			border-bottom: 2px solid #3399FF;
			padding-bottom: 5px;
			margin-bottom: 15px;
			text-align: center;
		}
		.profile-table th {
			background-color: #3399FF;
			color: white;
			text-align: left;
			padding: 12px;
			width: 30%;
		}
		.profile-table td {
			padding: 12px;
			border-bottom: 1px solid #ddd;
		}
	</style>
</head>
<body>

<%@ include file="auth.jsp" %>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>



<div class="category-section">
	<h1 class="category-title">Customer Profile</h1>
<%
	// Load driver
	try {
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	} catch (java.lang.ClassNotFoundException e) {
		out.println("ClassNotFoundException: " + e);
	}

	try (Connection con = DriverManager.getConnection(url, uid, pw)) {
		String sql = "SELECT * FROM customer WHERE userid = ?";
		PreparedStatement preparedStatement = con.prepareStatement(sql);
		preparedStatement.setString(1, userName);
		ResultSet resultSet = preparedStatement.executeQuery();

		if (resultSet.next()) {
			out.println("<table class='profile-table'>");
			out.println("<tr><th>ID</th><td>" + resultSet.getInt("customerId") + "</td></tr>");
			out.println("<tr><th>First Name</th><td>" + resultSet.getString("firstName") + "</td></tr>");
			out.println("<tr><th>Last Name</th><td>" + resultSet.getString("lastName") + "</td></tr>");
			out.println("<tr><th>Email</th><td>" + resultSet.getString("email") + "</td></tr>");
			out.println("<tr><th>Phone</th><td>" + resultSet.getString("phonenum") + "</td></tr>");
			out.println("<tr><th>Address</th><td>" + resultSet.getString("address") + "</td></tr>");
			out.println("<tr><th>City</th><td>" + resultSet.getString("city") + "</td></tr>");
			out.println("<tr><th>State</th><td>" + resultSet.getString("state") + "</td></tr>");
			out.println("<tr><th>Postal Code</th><td>" + resultSet.getString("postalCode") + "</td></tr>");
			out.println("<tr><th>Country</th><td>" + resultSet.getString("country") + "</td></tr>");
			
			out.println("</table>");
		} else {
			out.println("<p>No customer information available.</p>");
		}
	} catch (SQLException e) {
		out.println("SQLException: " + e);
	}
%>
</div>

</body>
</html>
