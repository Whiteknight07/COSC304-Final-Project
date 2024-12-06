<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Add Product - Error</title>
    <style>
        .error-message {
            color: #dc3545;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            padding: 10px;
            margin: 10px 0;
            border-radius: 4px;
        }
        .back-link {
            display: inline-block;
            margin-top: 15px;
            color: #0066cc;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<%
if (session.getAttribute("authenticatedUser") != null) {
    String productName = request.getParameter("productName");
    String priceStr = request.getParameter("productPrice");
    String description = request.getParameter("productDesc");
    String categoryId = request.getParameter("categoryId");
    
    StringBuilder errors = new StringBuilder();
    
    if (productName == null || productName.trim().isEmpty()) {
        errors.append("Product name is required.<br>");
    }
    if (priceStr == null || priceStr.trim().isEmpty()) {
        errors.append("Price is required.<br>");
    }
    if (description == null || description.trim().isEmpty()) {
        errors.append("Description is required.<br>");
    }
    if (categoryId == null || categoryId.trim().isEmpty()) {
        errors.append("Category is required.<br>");
    }
    
    double price = 0;
    if (priceStr != null && !priceStr.trim().isEmpty()) {
        try {
            price = Double.parseDouble(priceStr.trim());
            if (price < 0) {
                errors.append("Price cannot be negative.<br>");
            }
        } catch (NumberFormatException e) {
            errors.append("Invalid price format. Please enter a valid number.<br>");
        }
    }
    
    if (errors.length() > 0) {
        out.println("<div class='error-message'>");
        out.println("<strong>Please correct the following errors:</strong><br>");
        out.println(errors.toString());
        out.println("</div>");
        out.println("<a href='admin.jsp' class='back-link'>Back to Admin Page</a>");
        return;
    }
    
    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    } catch (java.lang.ClassNotFoundException e) {
        out.println("<div class='error-message'>Database driver error: " + e.getMessage() + "</div>");
        return;
    }
    
    try (Connection con = DriverManager.getConnection(url, uid, pw)) {
        String sql = "INSERT INTO product (productName, productPrice, productDesc, categoryId) VALUES (?, ?, ?, ?)";
        PreparedStatement pstmt = con.prepareStatement(sql);
        
        // Set parameters
        pstmt.setString(1, productName.trim());
        pstmt.setDouble(2, price);
        pstmt.setString(3, description.trim());
        pstmt.setInt(4, Integer.parseInt(categoryId.trim()));
        
        // Execute update
        pstmt.executeUpdate();
        
        // Redirect back to admin page
        response.sendRedirect("admin.jsp?message=Product added successfully");
        
    } catch (SQLException e) {
        out.println("<div class='error-message'>");
        out.println("Database error: " + e.getMessage());
        out.println("</div>");
        out.println("<a href='admin.jsp' class='back-link'>← Back to Admin Page</a>");
    }
} else {
    response.sendRedirect("login.jsp");
}
%>

</body>
</html> 