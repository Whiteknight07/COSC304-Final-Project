<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%
String id = request.getParameter("id");


HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList != null && id != null) {
    productList.remove(id);
    session.setAttribute("productList", productList);
}

response.sendRedirect("showcart.jsp");
%> 