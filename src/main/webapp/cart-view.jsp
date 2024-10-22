<%@ page import="java.util.List" %>
<%@ page import="com.revshop.entity.CartItem" %>
<%
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    double totalAmount = 0.0;

    if (cartItems != null) {
        for (CartItem item : cartItems) {
            totalAmount += item.getPrice() * item.getQuantity();
        }
    }
%>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Cart</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
            background: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }
        h1 {
            text-align: center;
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 15px;
            text-align: center;
            border: 1px solid #ddd;
            transition: background-color 0.3s ease;
        }
        th {
            background-color: #f2f2f2;
            color: #333;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        img {
            width: 100px;
            border-radius: 5px;
        }
        .btn {
            padding: 10px 15px;
            color: white;
            background-color: #28a745;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }
        .btn:hover {
            background-color: #218838;
            transform: scale(1.05);
        }
        .btn-secondary {
            background-color: #dc3545;
        }
        .btn-secondary:hover {
            background-color: #c82333;
        }
        .total-amount {
            text-align: right;
            font-size: 1.5em;
            margin-top: 20px;
        }
        .checkout-btn {
            display: block;
            margin: 20px auto;
            padding: 15px 30px;
            font-size: 1.2em;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }
        .checkout-btn:hover {
            background-color: #0056b3;
            transform: scale(1.05);
        }
        nav ul {
            list-style: none;
            padding: 0;
            display: flex;
            justify-content: center;
            background-color: #333;
        }
        nav ul li {
            margin: 0 10px;
        }
        nav ul li a {
            color: white;
            text-decoration: none;
            padding: 10px 20px;
            display: block;
        }
        nav ul li a:hover {
            background-color: #555;
        }
    </style>
</head>
<body>
    <nav>
        <ul>
            <li><a href="Electronics.jsp">Electronics</a></li>
            <li><a href="Accessories.jsp">Accessories</a></li>
            <li><a href="HomeNeeds.jsp">Home Needs</a></li>
            <li><a href="Toys.jsp">Toys</a></li>
            <li><a href="Fashion.jsp">Fashion</a></li>
            <li><a href="cart">Cart</a></li>
            <li><a href="profile.jsp">Profile</a></li>
            <li><a href="myorders">My Orders</a></li>
        </ul>
    </nav>
    <div class="container">
        <h1>Your Shopping Cart</h1>
        <table>
            <thead>
                <tr>
                    <th>Product ID</th>
                    <th>Image</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Update Quantity</th>
                    <th>Delete</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (cartItems != null) {
                        for (CartItem item : cartItems) {
                %>
                <tr>
                    <td><%= item.getProductId() %></td>
                    
                    <td><img src="<%= request.getContextPath() + "/" + item.getImageUrl() %>" alt="Product Image" /></td>
                    <td>$<%= String.format("%.2f", item.getPrice()) %></td>
                    <td><%= item.getQuantity() %></td>
                    <td>
                        <form action="manageCart" method="post" style="display: inline;">
                            <input type="hidden" name="productId" value="<%= item.getProductId() %>">
                            <input type="hidden" name="action" value="update">
                            <input type="number" name="quantity" value="<%= item.getQuantity() %>" min="1" style="width: 60px;">
                            <input type="submit" value="Update" class="btn">
                        </form>
                    </td>
                    <td>
                        <form action="manageCart" method="post" style="display: inline;">
                            <input type="hidden" name="productId" value="<%= item.getProductId() %>">
                            <input type="hidden" name="action" value="delete">
                            <input type="submit" value="Delete" class="btn btn-secondary">
                        </form>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="6">Your cart is empty.</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>

        <div class="total-amount">
            Total Amount: $<%= String.format("%.2f", totalAmount) %>
        </div>

        <form action="processCheckout" method="post">
            <input type="submit" value="Checkout" class="checkout-btn">
        </form>
    </div>
    <script>
    console.log(item.getImageUrl());
    </script>
</body>
</html>
