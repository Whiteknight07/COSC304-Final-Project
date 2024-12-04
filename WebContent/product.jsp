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
    <title>Product Information</title>
    <style>
        img {
            display: block;
        }

        img[src=""] {
            display: none;
        }

        img:not([src]) {
            display: none;
        }

    </style>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>

<%
// Get product name to search for
String productId = request.getParameter("id");
// Load SQL Server driver
    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    } catch (java.lang.ClassNotFoundException e) {
        out.println("ClassNotFoundException: " + e);
    }

    try (Connection con = DriverManager.getConnection(url, uid, pw)) {
        String sql = "select productImageURL,productPrice,productName from product where productId=?";
        PreparedStatement preparedStatement = con.prepareStatement(sql);
        preparedStatement.setString(1, productId);
        ResultSet resultSet = preparedStatement.executeQuery();
        String productImage = "";
        Double price = 0.0;
        String pname= "";
        while (resultSet.next()) {
            productImage = resultSet.getString(1);
            price = resultSet.getDouble(2);
            pname = resultSet.getString(3);
        }

            %><h1> <%out.println(pname); %></h1>

            <br>
                <img src="<%= productImage %>" alt="Product Image" />
                <img src="<%= "displayImage.jsp?id="+productId %>"/>
                <br>
                <strong>ID    <%=productId %> </strong>
                <br>
                <strong>Price    <%=price %> </strong>
                <br>
                <a class="addcart" href="<%= "addcart.jsp?id=" + productId + "&name=" + URLEncoder.encode(pname, StandardCharsets.UTF_8) + "&price=" + price %>">Add to cart</a>
                <br>
                <a href="<%= "listprod.jsp" %>"> Continue Shopping </a>
                <br>
            <%

    }catch (SQLException e){
        out.println(e);
    }

%>

</body>
</html>

