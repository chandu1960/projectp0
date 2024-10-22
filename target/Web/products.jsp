<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.revshop.dao.ElectronicsDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="com.revshop.entity.ElectronicItem" %>

<%
    // Initialize DAO
    ElectronicsDAO electronicsDAO = new ElectronicsDAO();
    
    // Retrieve parameters
    String category = request.getParameter("category");
    String selectedProductId = request.getParameter("selectedProductId");
    
    // Retrieve items by category if category is provided
    List<ElectronicItem> items = null;
    if (category != null) {
        items = electronicsDAO.getItemsByCategory(category);
    }
    
    // Retrieve the selected product if selectedProductId is provided
    ElectronicItem selectedProduct = null;
    if (selectedProductId != null) {
        try {
            selectedProduct = electronicsDAO.getProductById(Integer.parseInt(selectedProductId));
        } catch (NumberFormatException e) {
            e.printStackTrace(); // Consider logging the error instead
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }
        nav {
            background-color: #333;
            padding: 10px 20px;
        }
        nav ul {
            list-style-type: none;
            margin: 0;
            padding: 0;
            display: flex;
        }
        nav ul li {
            margin-right: 20px;
        }
        nav ul li a {
            color: white;
            text-decoration: none;
            padding: 8px 16px;
        }
        nav ul li a:hover {
            background-color: #575757;
            border-radius: 4px;
        }
        .grid-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            padding: 20px;
        }
        .grid-item {
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 15px;
            text-align: center;
        }
        .grid-item img {
            max-width: 100%;
            height: auto;
        }
        #selected-product {
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 15px;
            margin: 20px;
            text-align: center;
        }
        h1, h2, h3, p {
            margin: 10px 0;
        }
    </style>
    <script>
        function addToCart(productId, quantity) {
            const xhr = new XMLHttpRequest();
            xhr.open("POST", "addToCart", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status === 200) {
                        alert("Product added to cart successfully!");
                    } else {
                        alert("Error adding product to cart.");
                    }
                }
            };
            xhr.send("action=add&productId=" + productId + "&quantity=" + quantity);
        }
    </script>
</head>
<body>

<nav>
    <ul>
        <li><a href="Electronics.html">Electronics</a></li>
        <li><a href="Accessories.html">Accessories</a></li>
        <li><a href="HomeNeeds.html">Home Needs</a></li>
        <li><a href="Toys.html">Toys</a></li>
        <li><a href="Fashion.html">Fashion</a></li>
        <li><a href="cart.jsp">Cart</a></li>
        <li><a href="profile.jsp">Profile</a></li>
        <li><a href="myorders.jsp">My Orders</a></li>
        <li><a href="logout.jsp">Logout</a></li> <!-- Logout Link -->
    </ul>
</nav>

<h1>Products</h1>

<%
    if (selectedProduct != null) {
%>
    <div id="selected-product">
        <h2>Selected Product</h2>
        <img src="<%= selectedProduct.getImageUrl() %>" alt="<%= selectedProduct.getName() %>">
        <h3><%= selectedProduct.getName() %></h3>
        <p><%= selectedProduct.getDescription() %></p>
        <p>Price: $<%= selectedProduct.getPrice() %></p>
        <label for="quantity">Quantity:</label>
        <input type="number" id="selectedQuantity" min="1" max="<%= selectedProduct.getProductQuantity() %>" value="1" required>
        <button onclick="addToCart(<%= selectedProduct.getProductId() %>, document.getElementById('selectedQuantity').value)">Add to Cart</button>
    </div>
<%
    } else if (items == null || items.isEmpty()) {
%>
    <p>No items found in this category.</p>
<%
    } else {
%>
    <div class="grid-container">
<%
        for (ElectronicItem item : items) {
            if (item != null) {
%>
          <div class="grid-item">
              <h3><%= item.getName() %></h3>
              <p><%= item.getDescription() %></p>
              <p>Price: $<%= item.getPrice() %></p>
              <img src="<%= item.getImageUrl() %>" alt="<%= item.getName() %>" />
              <p>Available Quantity: <%= item.getProductQuantity() %></p>
              <label for="quantity">Quantity:</label>
              <input type="number" id="quantity<%= item.getProductId() %>" min="1" max="<%= item.getProductQuantity() %>" value="1" required>
              <button onclick="addToCart(<%= item.getProductId() %>, document.getElementById('quantity<%= item.getProductId() %>').value)">Add to Cart</button>
              <a href="products.jsp?selectedProductId=<%= item.getProductId() %>">View Details</a>
          </div>
<%
            }
        }
%>
    </div>
<%
    }
%>

</body>
</html>
