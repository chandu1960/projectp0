<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accessories Categories</title>
    <link rel="stylesheet" href="styles.css"> <!-- Link to your CSS file -->
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
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }

        h1 {
            text-align: center;
            color: #333;
        }

        .filter-container {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 20px;
        }

        .filter-container select,
        .filter-container input,
        .filter-container button {
            padding: 10px;
            margin: 0 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .filter-container button {
            background-color: #28a745;
            color: white;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .filter-container button:hover {
            background-color: #218838;
        }

        .category-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 16px;
        }

        .product-item {
            border: 1px solid #ccc;
            padding: 16px;
            text-align: center;
            border-radius: 8px;
            transition: box-shadow 0.3s;
        }

        .product-item:hover {
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        .product-item img {
            max-width: 100%;
            height: auto;
            border-radius: 4px;
        }

        .product-item h3 {
            margin: 10px 0;
            font-size: 1.2em;
        }

        .button {
            margin-top: 8px;
            padding: 8px 16px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

<h1>Accessories</h1>

<div class="filter-container">
    <label for="category">Select Category:</label>
    <select id="category" onchange="filterProducts(this.value)">
        <option value="All">All</option>
        <option value="Charger and Cables">Charger and Cables</option>
        <option value="Power Bank">Power Bank</option>
        <option value="Keyboard">Keyboard</option>
        <option value="Mouse">Mouse</option>
    </select>
    
    <label for="searchInput">Search:</label>
    <input type="text" id="searchInput" placeholder="Search by name" onkeyup="searchProducts()">
    <button onclick="searchProducts()">Search</button>
</div>

<div class="category-grid">
    <% 
        // Database connection parameters
        String url = "jdbc:mysql://localhost:3306/shop";
        String user = "root"; // Replace with your DB username
        String password = "root"; // Replace with your DB password
        
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            // Load the JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish a connection
            conn = DriverManager.getConnection(url, user, password);

            // Create a statement and execute a query to fetch products
            stmt = conn.createStatement();
            String query = "SELECT * FROM product WHERE category = 'Accessories'";
            rs = stmt.executeQuery(query);

            // Display each product in a grid format
            while (rs.next()) {
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
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } finally {
            // Close resources
            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
            if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    %>
</div>

</body>
</html>
