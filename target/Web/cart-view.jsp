<%@ page import="java.util.List" %>
<%@ page import="com.revshop.entity.Item" %>
<%@ page import="com.revshop.dao.ProductService" %>

<%
    String email = (String) session.getAttribute("userEmail");
    ProductService productService = new ProductService();
    List<Item> cartItems = productService.getCartItems(email);
    double total = 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Your Cart</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="container">
        <h1>Your Cart</h1>

        <%
            if (cartItems.isEmpty()) {
                out.println("<p>Your cart is empty!</p>");
            } else {
        %>

        <table>
            <thead>
                <tr>
                    <th>Product</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Total</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (Item item : cartItems) {
                        double itemTotal = item.getPrice() * item.getQuantity();
                        total += itemTotal;
                %>
                <tr>
                    <td><%= item.getName() %></td>
                    <td>$<%= item.getPrice() %></td>
                    <td>
                        <form action="actions" method="post">
                            <input type="hidden" name="action" value="updateCart">
                            <input type="hidden" name="productId" value="<%= item.getProductId() %>">
                            <input type="number" name="newQuantity" value="<%= item.getQuantity() %>" min="1">
                            <button type="submit">Update</button>
                        </form>
                    </td>
                    <td>$<%= itemTotal %></td>
                    <td>
                        <form action="actions" method="post">
                            <input type="hidden" name="action" value="removeFromCart">
                            <input type="hidden" name="productId" value="<%= item.getProductId() %>">
                            <button type="submit">Remove</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>

        <h2>Total: $<%= total %></h2>
        <form action="checkout" method="post">
            <button type="submit">Proceed to Checkout</button>
        </form>

        <% } %>
    </div>
</body>
</html>
