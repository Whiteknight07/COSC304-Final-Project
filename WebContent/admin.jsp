<!DOCTYPE html>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>
<%
    String userName = (String) session.getAttribute("authenticatedUser");
    if (userName != null) {
        out.println("<h3 align=\"center\">Signed in as: " + userName + "</h3>");
    }
%>

<%
    // Load SQL Server driver
    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    } catch (java.lang.ClassNotFoundException e) {
        out.println("ClassNotFoundException: " + e);
    }

    try (Connection con = DriverManager.getConnection(url, uid, pw)) {
        // SQL query to get order date and total amount by user
        String sql = "SELECT orderDate, totalAmount FROM customer JOIN ordersummary ON customer.customerId = ordersummary.customerId WHERE userId = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, userName);
        ResultSet resultSet = pstmt.executeQuery();

        out.println("<table border='1' align='center'>");
        out.println("<tr><th>Order Date</th><th>Total Amount</th></tr>");

        while (resultSet.next()) {
            out.println("<tr>");
            out.println("<td>" + resultSet.getDate("orderDate") + "</td>");
            out.println("<td>" + resultSet.getDouble("totalAmount") + "</td>");
            out.println("</tr>");
        }

        out.println("</table>");
    } catch (SQLException e) {
        out.println("SQLException: " + e);
    }
%>

</body>
</html>

