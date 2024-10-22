<%@ page language="java" contentType="text/html; charset=UTF-8" 
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.revshop.db.Dbconnection" %>
<% 
    String productId = request.getParameter("productId"); // Get productId from query parameter
    if (productId != null) {
        try (Connection conn = Dbconnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM product WHERE id = ?")) {
            ps.setInt(1, Integer.parseInt(productId)); // Use productId to fetch product details
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String productName = rs.getString("name");
                double price = rs.getDouble("price");
                String description = rs.getString("description");

                // Output product details on the page
                out.println("<h2>" + productName + "</h2>");
                out.println("<p>Price: $" + price + "</p>");
                out.println("<p>" + description + "</p>");
            } else {
                out.println("<p>Product not found.</p>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    } else {
        out.println("<p>Invalid product ID.</p>");
    }
%>

<!-- Form to add product to cart -->
<form action="viewCart" method="post">
    <input type="hidden" name="productId" value="<%= productId %>"> <!-- Pass the productId -->
    <label for="quantity">Quantity:</label>
    <input type="number" id="quantity" name="quantity" value="1" min="1" required>
    <button type="submit">Add to Cart</button>
</form>
