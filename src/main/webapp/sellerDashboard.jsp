<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.revshop.dao.ProductDAO" %>
<%@ page import="com.revshop.entity.Product" %>
<%@ page import="com.revshop.db.Dbconnection" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.SQLException" %>
<%@ page session="true" %>

<%
    // Fetch seller ID from session
    String sellerIdStr = (String) session.getAttribute("sellerId");
    Connection connection = null;
    ProductDAO productDao = null;
    List<Product> productList = null;

    if (sellerIdStr == null) {
        out.println("<h3>Error: Seller ID is not available. Please log in again.</h3>");
        response.sendRedirect("login.jsp");
    } else {
        try {
            Integer sellerId = Integer.valueOf(sellerIdStr);
            connection = Dbconnection.getConnection();
            productDao = new ProductDAO(connection);
            productList = productDao.getProductsBySellerId(sellerId);
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<h3>Error: Unable to retrieve products. Please try again later.</h3>");
        } catch (NumberFormatException e) {
            out.println("<h3>Error: Invalid Seller ID format.</h3>");
            e.printStackTrace();
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seller Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background-color: #f0f0f0;
            display: flex;
        }
        .sidebar {
            width: 200px; 
            background-color: #f4f4f4; 
            padding: 15px;
            position: fixed; 
            height: 100%;
            box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
        }
        .sidebar h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        .sidebar ul {
            list-style-type: none;
            padding: 0;
        }
        .sidebar li {
            margin: 15px 0;
        }
        .sidebar a {
            text-decoration: none;
            color: #333;
            padding: 8px;
            display: block;
            transition: background-color 0.3s;
        }
        .sidebar a:hover {
            background-color: #ddd;
        }
        .content {
            margin-left: 220px;
            padding: 20px;
            width: calc(100% - 220px);
        }
        h2 {
            color: #333;
        }
        .form-container {
            background-color: #fff;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        label {
            display: block;
            margin-bottom: 5px;
        }
        input[type="text"], input[type="number"], select, input[type="file"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        button {
            background-color: #5cb85c;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }
        button:hover {
            background-color: #4cae4c;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: #fff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        .actions {
            display: flex;
            gap: 10px;
        }
        .actions a {
            text-decoration: none;
            color: #007bff;
        }
        .actions a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>Seller Dashboard</h2>
        <ul>
            <li><a href="sellerDashboard.jsp">Home</a></li>
            <li><a href="ViewProducts.jsp">View Products</a></li>
            <li><a href="OrderHistory.jsp">Order History</a></li>
            <li><a href="Logout.jsp">Logout</a></li>
        </ul>
    </div>

    <div class="content">
        <h2>Upload New Product</h2>
        <div class="form-container">
            <form action="SellerDashboardServlet" method="post" enctype="multipart/form-data">
                <label for="productName">Product Name:</label>
                <input type="text" name="productName" required>

                <label for="productDescription">Product Description:</label>
                <input type="text" name="productDescription" required>

                <label for="productPrice">Product Price:</label>
                <input type="number" name="productPrice" step="0.01" required>

                <label for="productQuantity">Product Quantity:</label>
                <input type="number" name="productQuantity" required>

                <label for="productImage">Product Image:</label>
                <input type="file" name="productImage" accept="image/*" required>

                <label for="category">Category:</label>
                <select name="category" required>
                    <option value="Electronics">Electronics</option>
                    <option value="Accessories">Accessories</option>
                    <option value="Toys">Toys</option>
                    <option value="Fashion">Fashion</option>
                    <option value="HomeNeeds">HomeNeeds</option>
                </select>

              <label for="productCategory">Product Category:</label>
<select name="productCategory" required>
    <optgroup label="Electronics">
        <option value="Mobile">Mobile</option>
        <option value="Laptop">Laptop</option>
        <option value="Headset">Headset</option>
        <option value="Speaker">Speaker</option>
        <option value="Smartwatch">Smartwatch</option>
    </optgroup>

    <optgroup label="Accessories">
        <option value="Charger and Cables">Charger and Cables</option>
        <option value="Power Bank">Power Bank</option>
        <option value="Keyboard">Keyboard</option>
        <option value="Mouse">Mouse</option>
    </optgroup>

    <optgroup label="Toys">
        <option value="Puzzles">Puzzles</option>
        <option value="Soft Toys">Soft Toys</option>
        <option value="Action Figures">Action Figures</option>
        <option value="Cricket">Cricket</option>
        <option value="Football">Football</option>
    </optgroup>

    <optgroup label="Fashion">
        <option value="Men's Wear">Men's Wear</option>
        <option value="Women's Wear">Women's Wear</option>
        <option value="Footwear">Footwear</option>
        <option value="Eyewear">Eyewear</option>
        <option value="Bags and Wallets">Bags and Wallets</option>
    </optgroup>

    <optgroup label="Home Needs">
        <option value="Home Utility">Home Utility</option>
        <option value="Festive and Decor">Festive and Decor</option>
        <option value="Bath and Bedding">Bath and Bedding</option>
        <option value="Cookware">Cookware</option>
    </optgroup>
</select>

                <input type="hidden" name="sellerId" value="<%= sellerIdStr %>">
                <button type="submit" name="action" value="upload">Upload Product</button>
            </form>
        </div>

        <h2>Your Products</h2>
        <table>
            <thead>
                <tr>
                    <th>Product ID</th>
                    <th>Product Name</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                if (productList != null && !productList.isEmpty()) {
                    for (Product product : productList) {
                %>
                <tr>
                    <td><%= product.getProductId() %></td>
                    <td><%= product.getProductName() %></td>
                    <td>$<%= product.getProductPrice() %></td>
                    <td><%= product.getProductQuantity() %></td>
                    <td class="actions">
                        <a href="EditProduct.jsp?productId=<%= product.getProductId() %>">Edit</a>
                        <a href="DeleteProductServlet?productId=<%= product.getProductId() %>" onclick="return confirm('Are you sure you want to delete this product?');">Delete</a>

                    </td>
                </tr>
                <%
                    }
                } else {
                    out.println("<tr><td colspan='5'>No products found.</td></tr>");
                }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>
