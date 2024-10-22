<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.revshop.entity.Product" %>
<%@ page import="com.revshop.entity.Order" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Shopping Cart</title>
    <link rel="stylesheet" href="styles.css"> <!-- Include your CSS file -->
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
            animation: fadeIn 0.5s; /* Fade-in effect for the entire page */
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }

        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        .message {
            background-color: #d4edda;
            color: #155724;
            padding: 10px;
            border: 1px solid #c3e6cb;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
            animation: slideIn 0.5s; /* Slide-in effect for the message */
        }

        @keyframes slideIn {
            from {
                transform: translateY(-20px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            background-color: white;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #dddddd;
            transition: background-color 0.3s; /* Smooth transition for row hover */
        }

        th {
            background-color: #4CAF50;
            color: white;
        }

        tr:hover {
            background-color: #f1f1f1; /* Light background on row hover */
            transform: translateY(-2px); /* Slight lift on hover */
            transition: transform 0.2s; /* Smooth transition for lifting effect */
        }

        form {
            display: inline;
        }

        button {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px 15px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
            margin: 4px 2px;
            cursor: pointer;
            border-radius: 5px;
            transition: background-color 0.3s ease, transform 0.2s; /* Smooth transitions */
        }

        button:hover {
            background-color: #45a049; /* Darker green on hover */
            transform: scale(1.05); /* Slightly enlarge button on hover */
        }

        .total-price {
            font-size: 18px;
            font-weight: bold;
            text-align: right;
            margin-top: 20px;
        }

        .continue-shopping {
            text-align: center;
            margin-top: 20px;
        }

        .continue-shopping a {
            color: #4CAF50;
            text-decoration: none;
            font-size: 16px;
            transition: color 0.3s ease;
        }

        .continue-shopping a:hover {
            color: #388E3C;
            text-decoration: underline; /* Underline on hover */
        }
    </style>
</head>
<body>
    <h1>Your Shopping Cart</h1>
    
    <%
        // Retrieve cart from session
        List<Product> cart = (List<Product>) session.getAttribute("cart");
        double totalPrice = 0.0;

        // Display success message if present
        String message = (String) request.getAttribute("message");
        if (message != null) {
    %>
        <div class="message"><%= message %></div>
    <%
        }
    %>

    <%
        if (cart == null || cart.isEmpty()) {
    %>
        <p>Your cart is empty.</p>
        <div class="continue-shopping">
            <a href="products.jsp">Continue Shopping</a>
        </div>
    <%
        } else {
    %>
        <table>
            <thead>
                <tr>
                    <th>Product Name</th>
                    <th>Description</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Total</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <%
                for (Product product : cart) {
                    double productTotal = product.getProductPrice() * product.getProductQuantity();
                    totalPrice += productTotal;
            %>
                <tr>
                    <td><%= product.getProductName() %></td>
                    <td><%= product.getProductDescription() %></td>

                    <td>$<%= String.format("%.2f", product.getProductPrice()) %></td>
                    <td>
                        <form action="updateCart" method="post">
                            <input type="hidden" name="productId" value="<%= product.getProductId() %>">
                            <input type="number" name="quantity" value="<%= product.getProductQuantity() %>" min="1" max="<%= product.getProductQuantity() %>" required>
                            <input type="hidden" name="action" value="update">
                            <button type="submit">Update</button>
                        </form>
                    </td>
                    <td>$<%= String.format("%.2f", productTotal) %></td>
                    <td>
                        <form action="removeFromCart" method="post">
                            <input type="hidden" name="productId" value="<%= product.getProductId() %>">
                            <input type="hidden" name="action" value="remove">
                            <button type="submit">Remove</button>
                        </form>
                    </td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>

        <div class="total-price">Total Price: $<%= String.format("%.2f", totalPrice) %></div>
        <form action="checkout" method="post">
            <button type="submit">Proceed to Checkout</button>
        </form>

        <div class="continue-shopping">
            <a href="products.jsp">Continue Shopping</a> <!-- Link to go back to products page -->
        </div>
        
        <hr>
        <h2>Your Orders</h2>
        <div class="continue-shopping">
            <a href="myorders?userEmail=<%= session.getAttribute("userEmail") %>">View My Orders</a> <!-- Link to view orders -->
        </div>
    <%
        }
    %>
</body>
</html>
