<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home Needs Categories</title>
    <link rel="stylesheet" href="styles.css">
    <script>
        function filterProducts(category) {
            const allProducts = document.querySelectorAll('.product-item');
            allProducts.forEach(product => {
                if (product.dataset.category === category || category === 'All') {
                    product.style.display = 'block';
                } else {
                    product.style.display = 'none';
                }
            });
        }

        function searchProducts() {
            const searchInput = document.getElementById('searchInput').value.toLowerCase();
            const allProducts = document.querySelectorAll('.product-item');
            allProducts.forEach(product => {
                const productName = product.querySelector('h3').innerText.toLowerCase();
                if (productName.includes(searchInput)) {
                    product.style.display = 'block';
                } else {
                    product.style.display = 'none';
                }
            });
        }
    </script>
    <style>
        /* CSS styles */
        .category-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
        }

        .product-item {
            border: 1px solid #ccc;
            border-radius: 8px;
            padding: 10px;
            text-align: center;
            width: 200px;
        }

        .product-item img {
            width: 100%;
            height: auto;
            border-radius: 8px;
        }

        .button {
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
            border-radius: 4px;
        }

        .button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>

<h1>Home Needs</h1>

<div class="filter-container">
    <label for="category">Select Category:</label>
    <select id="category" onchange="filterProducts(this.value)">
        <option value="All">All</option>
        <option value="Home Utility">Home Utility</option>
        <option value="Festive and Decor">Festive and Decor</option>
        <option value="Bath and Bedding">Bath and Bedding</option>
        <option value="Cookware">Cookware</option>
    </select>
    
    <label for="searchInput">Search:</label>
    <input type="text" id="searchInput" placeholder="Search by name" onkeyup="searchProducts()">
    <button onclick="searchProducts()">Search</button>
</div>

<div class="category-grid">
    <% 
        String url = "jdbc:mysql://localhost:3306/shop";
        String user = "root"; // Replace with your DB username
        String password = "root"; // Replace with your DB password
        
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, password);
            stmt = conn.createStatement();
            String query = "SELECT * FROM product WHERE category = 'HomeNeeds'";
            rs = stmt.executeQuery(query);

            boolean hasProducts = false; // Track if any products were found

            while (rs.next()) {
                hasProducts = true; // Found at least one product
                String productId = rs.getString("product_id");
                String productName = rs.getString("product_name");
                String productImage = rs.getString("product_image");
                String productCategory = rs.getString("productCategory");
                double productPrice = rs.getDouble("product_price");
    %>
                <div class="product-item" data-category="<%= productCategory %>">
                    <img src="<%= productImage %>" alt="<%= productName %>">
                    <h3><%= productName %></h3>
                    <p>Price: $<%= productPrice %></p>
                    <a href="productDetails.jsp?id=<%= productId %>" class="button">View Details</a>
                </div>
    <%
            }

            // If no products were found, display a message
            if (!hasProducts) {
    %>
                <p>Product not found in the selected category.</p>
    <%
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
            if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    %>
</div>

</body>
</html>
