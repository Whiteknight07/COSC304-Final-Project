<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>
<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null)
{	// No products currently in list.  Create a list.
	productList = new HashMap<String, ArrayList<Object>>();
}

// Add new product selected
// Get product information
String id = request.getParameter("id");
String name = request.getParameter("name");
String price = request.getParameter("price");

// Check inventory before adding
try {
    getConnection();
    String sql = "SELECT SUM(quantity) as total FROM productinventory WHERE productId = ?";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, id);
    ResultSet rs = pstmt.executeQuery();
    
    int currentInventory = 0;
    if (rs.next()) {
        currentInventory = rs.getInt("total");
    }

    // Get current quantity in cart
    int quantityInCart = 0;
    if (productList.containsKey(id)) {
        ArrayList<Object> currentProduct = productList.get(id);
        quantityInCart = ((Integer) currentProduct.get(3)).intValue();
    }

    // Only add if there's enough inventory
    if (currentInventory > quantityInCart) {
        Integer quantity = new Integer(1);

        // Store product information in an ArrayList
        ArrayList<Object> product = new ArrayList<Object>();
        product.add(id);
        product.add(name);
        product.add(price);
        product.add(quantity);

        // Update quantity if add same item to order again
        if (productList.containsKey(id)) {
            product = (ArrayList<Object>) productList.get(id);
            int curAmount = ((Integer) product.get(3)).intValue();
            product.set(3, new Integer(curAmount+1));
        } else {
            productList.put(id,product);
        }

        session.setAttribute("productList", productList);
        response.sendRedirect("showcart.jsp");
    } else {
        String message = "Sorry, the product '" + name + "' is out of stock.";
        session.setAttribute("errorMessage", message);
        response.sendRedirect("listprod.jsp");
        return;
    }
} catch (SQLException e) {
    out.println("Error: " + e);
} finally {
    closeConnection();
}
%>