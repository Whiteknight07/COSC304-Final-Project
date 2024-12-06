<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>

<%
// Get parameters from the form
String productId = request.getParameter("productId");
String rating = request.getParameter("rating");
String reviewComment = request.getParameter("reviewText");

// Get customer ID from session
String userId = session.getAttribute("authenticatedUser") != null ? 
    session.getAttribute("authenticatedUser").toString() : null;

if (userId == null) {
    response.sendRedirect("login.jsp");
    return;
}

try {
    getConnection();
    
    // First get the customer ID from the userid
    String customerQuery = "SELECT customerId FROM customer WHERE userid = ?";
    PreparedStatement custStmt = con.prepareStatement(customerQuery);
    custStmt.setString(1, userId);
    ResultSet custRs = custStmt.executeQuery();
    
    if (custRs.next()) {
        int customerId = custRs.getInt("customerId");

        // Check if user has already reviewed this product
        String existingReviewQuery = "SELECT reviewId FROM review WHERE customerId = ? AND productId = ?";
        PreparedStatement reviewCheckStmt = con.prepareStatement(existingReviewQuery);
        reviewCheckStmt.setInt(1, customerId);
        reviewCheckStmt.setInt(2, Integer.parseInt(productId));
        ResultSet reviewCheckRs = reviewCheckStmt.executeQuery();

        if (reviewCheckRs.next()) {
            response.sendRedirect("product.jsp?id=" + productId + "&message=already_reviewed");
            return;
        }

        // Check if user has purchased this product
        String purchaseQuery = "SELECT op.orderId FROM orderproduct op " +
                             "JOIN ordersummary os ON op.orderId = os.orderId " +
                             "WHERE os.customerId = ? AND op.productId = ?";
        PreparedStatement purchaseStmt = con.prepareStatement(purchaseQuery);
        purchaseStmt.setInt(1, customerId);
        purchaseStmt.setInt(2, Integer.parseInt(productId));
        ResultSet purchaseRs = purchaseStmt.executeQuery();

        if (!purchaseRs.next()) {
            response.sendRedirect("product.jsp?id=" + productId + "&message=not_purchased");
            return;
        }
        
        // Now insert the review
        String sql = "INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (?, GETDATE(), ?, ?, ?)";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(rating));
        pstmt.setInt(2, customerId);
        pstmt.setInt(3, Integer.parseInt(productId));
        pstmt.setString(4, reviewComment);
        
        pstmt.executeUpdate();
        
        response.sendRedirect("product.jsp?id=" + productId + "&message=review_success");
    } else {
        response.sendRedirect("product.jsp?id=" + productId + "&message=user_error");
    }
} catch (SQLException ex) {
    response.sendRedirect("product.jsp?id=" + productId + "&message=error&details=" + URLEncoder.encode(ex.getMessage(), "UTF-8"));
} finally {
    closeConnection();
}
%>
