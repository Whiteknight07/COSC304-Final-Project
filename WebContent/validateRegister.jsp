<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        String userid = request.getParameter("userid");
        String password = request.getParameter("password");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phonenum = request.getParameter("phonenum");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String postalCode = request.getParameter("postalCode");
        String country = request.getParameter("country");

        if(userid == null || password == null || firstName == null || lastName == null || 
           email == null || phonenum == null || address == null || city == null || 
           state == null || postalCode == null || country == null) {
            session.setAttribute("registerMessage", "All fields are required");
            response.sendRedirect("register.jsp");
            return;
        }

        // Log all input parameters for debugging
        System.out.println("Registration attempt for user: " + userid);
        System.out.println("First Name: " + firstName);
        System.out.println("Last Name: " + lastName);
        System.out.println("Email: " + email);

        // Get the connection
        con = DriverManager.getConnection(url, uid, pw);
        
        // Check if username already exists
        String sql = "SELECT userid FROM customer WHERE userid = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, userid);
        rs = pstmt.executeQuery();
        
        if(rs.next()) {
            session.setAttribute("registerMessage", "Username already exists");
            response.sendRedirect("register.jsp");
            return;
        }

        // Check if email already exists
        sql = "SELECT email FROM customer WHERE email = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, email);
        rs = pstmt.executeQuery();
        
        if(rs.next()) {
            session.setAttribute("registerMessage", "Email already exists");
            response.sendRedirect("register.jsp");
            return;
        }

        // Insert new customer with explicit column names
        sql = "INSERT INTO customer (userid, password, firstName, lastName, email, phonenum, address, city, state, postalCode, country) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        System.out.println("Executing SQL: " + sql);
        
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, userid);
        pstmt.setString(2, password);
        pstmt.setString(3, firstName);
        pstmt.setString(4, lastName);
        pstmt.setString(5, email);
        pstmt.setString(6, phonenum);
        pstmt.setString(7, address);
        pstmt.setString(8, city);
        pstmt.setString(9, state);
        pstmt.setString(10, postalCode);
        pstmt.setString(11, country);
        
        int rowsAffected = pstmt.executeUpdate();
        System.out.println("Rows affected by INSERT: " + rowsAffected);
        
        if(rowsAffected > 0) {
            // Verify the insertion
            sql = "SELECT * FROM customer WHERE userid = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userid);
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
                System.out.println("User successfully inserted and verified in database");
                session.setAttribute("authenticatedUser", userid);
                response.sendRedirect("index.jsp");
            } else {
                System.out.println("User not found after insertion!");
                session.setAttribute("registerMessage", "Failed to verify account creation");
                response.sendRedirect("register.jsp");
            }
        } else {
            System.out.println("Insert failed - no rows affected");
            session.setAttribute("registerMessage", "Failed to create account: No rows inserted");
            response.sendRedirect("register.jsp");
        }
        
    } catch (SQLException ex) {
        System.out.println("SQLException: " + ex.getMessage());
        System.out.println("SQLState: " + ex.getSQLState());
        System.out.println("VendorError: " + ex.getErrorCode());
        session.setAttribute("registerMessage", "Database error: " + ex.getMessage());
        response.sendRedirect("register.jsp");
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (con != null) con.close();
        } catch (SQLException ex) {
            System.out.println("Error closing resources: " + ex.getMessage());
        }
    }
%>
