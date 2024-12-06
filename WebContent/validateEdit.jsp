<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
    String userid = (String) session.getAttribute("authenticatedUser");
    String currentPassword = request.getParameter("currentPassword");
    String newPassword = request.getParameter("newPassword");
    String email = request.getParameter("email");
    String phonenum = request.getParameter("phonenum");
    String address = request.getParameter("address");
    String city = request.getParameter("city");
    String state = request.getParameter("state");
    String postalCode = request.getParameter("postalCode");
    String country = request.getParameter("country");

    try {
        getConnection();
        
        // If changing password, verify current password
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            if (currentPassword == null || currentPassword.trim().isEmpty()) {
                session.setAttribute("editMessage", "Current password is required to change password");
                response.sendRedirect("editAccount.jsp");
                return;
            }

            String sql = "SELECT userid FROM customer WHERE userid = ? AND password = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userid);
            pstmt.setString(2, currentPassword);
            ResultSet rs = pstmt.executeQuery();
            
            if (!rs.next()) {
                session.setAttribute("editMessage", "Current password is incorrect");
                response.sendRedirect("editAccount.jsp");
                return;
            }
        }

        // Check if email already exists (except for current user)
        String sql = "SELECT userid FROM customer WHERE email = ? AND userid != ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, email);
        pstmt.setString(2, userid);
        ResultSet rs = pstmt.executeQuery();
        
        if (rs.next()) {
            session.setAttribute("editMessage", "Email already exists");
            response.sendRedirect("editAccount.jsp");
            return;
        }

        // Update customer information
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            // Update including password
            sql = "UPDATE customer SET password = ?, email = ?, phonenum = ?, address = ?, city = ?, state = ?, postalCode = ?, country = ? WHERE userid = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, newPassword);
            pstmt.setString(2, email);
            pstmt.setString(3, phonenum);
            pstmt.setString(4, address);
            pstmt.setString(5, city);
            pstmt.setString(6, state);
            pstmt.setString(7, postalCode);
            pstmt.setString(8, country);
            pstmt.setString(9, userid);
        } else {
            // Update without changing password
            sql = "UPDATE customer SET email = ?, phonenum = ?, address = ?, city = ?, state = ?, postalCode = ?, country = ? WHERE userid = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, email);
            pstmt.setString(2, phonenum);
            pstmt.setString(3, address);
            pstmt.setString(4, city);
            pstmt.setString(5, state);
            pstmt.setString(6, postalCode);
            pstmt.setString(7, country);
            pstmt.setString(8, userid);
        }
        
        pstmt.executeUpdate();
        session.setAttribute("editMessage", "Account updated successfully!");
        response.sendRedirect("editAccount.jsp");
        
    } catch (SQLException ex) {
        session.setAttribute("editMessage", "Error updating account: " + ex.getMessage());
        response.sendRedirect("editAccount.jsp");
    } finally {
        closeConnection();
    }
%>
