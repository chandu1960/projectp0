<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.revshop.dao.ElectronicsDAO" %>
<%@ page import="jakarta.servlet.http.HttpServletRequest" %>
<%@ page import="jakarta.servlet.http.HttpServletResponse" %>
<%@ page import="com.revshop.entity.ElectronicItem" %>
<%@ page import="jakarta.servlet.ServletException" %>
<%@ page import="java.io.IOException" %>
<%
// Initialize DAO and retrieve the selected product based on the parameter
ElectronicsDAO electronicsDAO = new ElectronicsDAO();
String selectedProductId = request.getParameter("selectedProductId");
ElectronicItem selectedProduct = null;

if (selectedProductId != null) {
    try {
        selectedProduct = electronicsDAO.getProductById(Integer.parseInt(selectedProductId));
    } catch (NumberFormatException e) {
        e.printStackTrace();
    }
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Welcome to RevShop</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <style>
        /* General Styles */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            color: #333;
        }

        /* Header Styles */
        header {
            background-color: #333;
            color: #fff;
            padding: 20px;
            text-align: center;
        }

        nav ul {
            list-style-type: none;
            padding: 0;
        }

        nav ul li {
            display: inline;
            margin: 0 15px;
        }

        nav ul li a {
            color: #fff;
            text-decoration: none;
        }

        /* Product List Styles */
        #product-list {
            margin: 20px;
        }

        /* Selected Product Styles */
        #selected-product {
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 20px;
            margin: 20px 0;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        #selected-product img {
            max-width: 100%;
            height: auto;
            border-radius: 5px;
        }

        /* Button Styles */
        button {
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 10px 15px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
    <header>
        <h1>RevShop</h1>
        <nav>
            <ul>
                <li><a href="home.jsp">Home</a></li>
                <li><a href="electronics.jsp">Electronics</a></li>
                <li><a href="fashion.jsp">Fashion</a></li>
                <li><a href="accessories.jsp">Accessories</a></li>
                <li><a href="cart.jsp">Cart</a></li>
            </ul>
        </nav>
    </header>

    <section id="product-list">
        <h2>Available Products</h2>
        <div class="product-grid">
            <div class="product-item">
                <img src="images/google_pixel.jpg" alt="Google Pixel 6">
                <h3>Google Pixel 6</h3>
                <p>Price: $599.99</p>
                <p>Features a powerful camera and clean Android experience.</p>
                <button onclick="addToCart(1)">Add to Cart</button>
                <a href="shop.jsp?selectedProductId=1">View Details</a>
            </div>

            <div class="product-item">
                <img src="images/laptop.jpg" alt="Laptop XYZ">
                <h3>Laptop XYZ</h3>
                <p>Price: $999.99</p>
                <p>High-performance laptop for all your needs.</p>
                <button onclick="addToCart(2)">Add to Cart</button>
                <a href="shop.jsp?selectedProductId=2">View Details</a>
            </div>

            <!-- Add other products here with corresponding IDs -->
        </div>
    </section>

    <% if (selectedProduct != null) { %>
        <div id="selected-product">
            <h2>Selected Product</h2>
            <img src="<%= selectedProduct.getImageUrl() %>" alt="<%= selectedProduct.getName() %>">
            <h3><%= selectedProduct.getName() %></h3>
            <p><%= selectedProduct.getDescription() %></p>
            <p>Price: $<%= selectedProduct.getPrice() %></p>
            <form action="addToCart" method="post">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="productId" value="<%= selectedProduct.getProductId() %>">
                <label for="quantity">Quantity:</label>
                <input type="number" name="quantity" min="1" max="<%= selectedProduct.getProductQuantity() %>" value="1" required>
                <button type="submit">Add to Cart</button>
            </form>
        </div>
    <% } else { %>
        <p>No product selected. Please choose a product from the category page.</p>
    <% } %>

    <footer>
        <p>&copy; 2024 RevShop. All rights reserved.</p>
        <p>Contact us: support@revshop.com</p>
        <div class="social-media">
            <a href="https://facebook.com">Facebook</a>
            <a href="https://twitter.com">Twitter</a>
            <a href="https://instagram.com">Instagram</a>
        </div>
    </footer>

    <script>
    function addToCart(productId) {
        alert("Product " + productId + " added to cart!");
    }
    </script>
</body>
</html>
