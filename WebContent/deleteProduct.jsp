<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>

<%
if (session.getAttribute("authenticatedUser") != null) {
    String productId = request.getParameter("productId");
    
    if (productId == null || productId.trim().isEmpty()) {
        response.sendRedirect("admin.jsp?message=No product selected");
        return;
    }
    
    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    } catch (java.lang.ClassNotFoundException e) {
        response.sendRedirect("admin.jsp?message=Error: " + e.getMessage());
        return;
    }
    
    try (Connection con = DriverManager.getConnection(url, uid, pw)) {
        String checkSql = "SELECT COUNT(*) as orderCount FROM orderproduct WHERE productId = ?";
        PreparedStatement checkStmt = con.prepareStatement(checkSql);
        checkStmt.setInt(1, Integer.parseInt(productId));
        ResultSet checkResult = checkStmt.executeQuery();
        checkResult.next();
        
        if (checkResult.getInt("orderCount") > 0) {
            response.sendRedirect("admin.jsp?message=Cannot delete: Product exists in orders");
            return;
        }

        con.setAutoCommit(false);
        try {
            String deleteInventorySql = "DELETE FROM productinventory WHERE productId = ?";
            PreparedStatement deleteInventoryStmt = con.prepareStatement(deleteInventorySql);
            deleteInventoryStmt.setInt(1, Integer.parseInt(productId));
            deleteInventoryStmt.executeUpdate();
            
            String sql = "DELETE FROM product WHERE productId = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(productId));
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                con.commit();
                response.sendRedirect("admin.jsp?message=Product deleted successfully");
            } else {
                con.rollback();
                response.sendRedirect("admin.jsp?message=Product not found");
            }
        } catch (SQLException e) {
            con.rollback();
            throw e;
        } finally {
            con.setAutoCommit(true);
        }
        
    } catch (SQLException e) {
        response.sendRedirect("admin.jsp?message=Database error: " + e.getMessage());
    }
} else {
    response.sendRedirect("login.jsp");
}
%> 