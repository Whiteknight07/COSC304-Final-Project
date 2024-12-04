<%
    String userName = request.getParameter("customerId");
    if (userName == null) {
        userName = (String) session.getAttribute("authenticatedUser");
    }
%>

<style>
    .header {
        background-color: #f8f9fa;
        padding: 10px 20px;
        border-bottom: 1px solid #ddd;
        margin-bottom: 20px;
    }
    .header-content {
        display: flex;
        justify-content: space-between;
        align-items: center;
        max-width: 1200px;
        margin: 0 auto;
    }
    .store-name {
        color: #3399FF;
        text-decoration: none;
        font-size: 24px;
    }
    .nav-links a {
        color: #333;
        text-decoration: none;
        margin-left: 20px;
    }
    .nav-links a:hover {
        color: #3399FF;
    }
    .welcome-msg {
        color: #666;
    }
</style>

<div class="header">
    <div class="header-content">
        <a href="index.jsp" class="store-name">Ray's Grocery</a>
        <span class="welcome-msg">
            <% if (userName != null && !userName.isEmpty()) { %>
                Welcome, <%= userName %>!
            <% } %>
        </span>
        <div class="nav-links">
            <a href="listprod.jsp">Shop</a>
            <a href="listorder.jsp">Orders</a>
            <a href="showcart.jsp">Cart</a>
            <a href="customer.jsp">Account Page</a>
            <a href="logout.jsp">Logout</a>
        </div>
    </div>
</div>
