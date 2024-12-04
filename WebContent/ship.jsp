<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>YOUR NAME Grocery Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%

	String orderId = request.getParameter("orderId");
	if ( orderId==null || orderId.isEmpty()) {
		out.println("<h4>Error: Missing or invalid Order ID.</h4>");
		return;
	}


	// Load SQL Server driver
	try {
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	} catch (java.lang.ClassNotFoundException e) {
		out.println("ClassNotFoundException: " + e);
	}

	try (Connection con = DriverManager.getConnection(url, uid, pw)) {
		String sql="select count(*) from ordersummary where orderId=?";
		PreparedStatement preparedStatement=con.prepareStatement(sql);
		preparedStatement.setString(1,orderId);
		ResultSet resultSet=preparedStatement.executeQuery();
		while (resultSet.next()){
			if(resultSet.getInt(1)==0){
				out.println("Invalid order ID");
				return;
			}
		}
		con.setAutoCommit(false);
		// TODO: Retrieve all items in order with given id
		String sql2="select productId,quantity from orderproduct where orderId=?";
		PreparedStatement preparedStatement1=con.prepareStatement(sql2);
		preparedStatement1.setString(1,orderId);
		ResultSet resultSet1=preparedStatement1.executeQuery();
		// TODO: Create a new shipment record.
		String newrec="INSERT into shipment(shipmentDate) values (GETDATE())";
		PreparedStatement insetship = con.prepareStatement(newrec, Statement.RETURN_GENERATED_KEYS);
		insetship.executeUpdate();

		ResultSet shipmentKeys = insetship.getGeneratedKeys();
		if (!shipmentKeys.next()) {
			out.println(" Could not create shipment record");
			con.rollback();
			return;
		}
		int shipmentId = shipmentKeys.getInt(1);
		// TODO: For each item verify sufficient quantity available in warehouse 1.
		String checkinven = "SELECT quantity FROM productinventory WHERE productId = ? AND warehouseId = 1";
		PreparedStatement preparedStatement3 = con.prepareStatement(checkinven);
		String updateinven = "UPDATE productinventory SET quantity = ? WHERE productId = ? AND warehouseId = 1";
		PreparedStatement updateinvenprep = con.prepareStatement(updateinven);

		boolean suff = true;
		while (resultSet1.next()) {
			int productId = resultSet1.getInt("productId");
			int orderQuantity = resultSet1.getInt("quantity");

			preparedStatement3.setInt(1, productId);
			ResultSet inventory = preparedStatement3.executeQuery();

			if (inventory.next()) {

				int availQuan = inventory.getInt("quantity");
				if (availQuan < orderQuantity) {
					out.println("<h4>Insufficient inventory for product id: " + productId + "</h4>");
					suff = false;
					
				}
				else {
					int newQU = availQuan - orderQuantity;
					updateinvenprep.setInt(1, newQU);
					updateinvenprep.setInt(2, productId);
					updateinvenprep.executeUpdate();

					out.println("<p>Ordered product: " + productId + " Qty: " + orderQuantity + " Previous inventory: " + availQuan + " New inventory: " + newQU + "</p>");
				}
			}
			else {
				out.println("<h4>Shipment not done. Insufficient product:  " + productId + "</h4>");
				suff = false;

			}
		}

		if (suff) {
			out.println("<h4>Shipment successfully processed.</h4>");
			con.commit();
		} else {
			con.rollback();
		}

		con.setAutoCommit(true);


	}catch (SQLException e){
		out.println(e);
	}
	

%>                       				

<h2><a href="shop.html">Back to Main Page</a></h2>

</body>
</html>
