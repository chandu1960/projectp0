<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.revshop.entity.Product" %>
<html>
<head>
    <title>Your Products</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid black;
            padding: 8px;
            text-align: left;
        }
    </style>
</head>
<body>
<h1>Your Uploaded Products</h1>
<table>
    <tr>
        <th>Product ID</th>
        <th>Product Name</th>
        <th>Description</th>
        <th>Price</th>
        <th>Quantity</th>
        <th>Image</th>
        <th>Category</th>
        <th>Actions</th>
    </tr>
    <%
        List<Product> productList = (List<Product>) request.getAttribute("productList");
        if (productList != null && !productList.isEmpty()) {
            for (Product product : productList) {
    %>
    <tr>
        <td><%= product.getProductId() %></td>
        <td><%= product.getProductName() %></td>
        <td><%= product.getProductDescription() %></td>
        <td><%= product.getProductPrice() %></td>
        <td><%= product.getProductQuantity() %></td>
        <td><img src="<%= product.getProductImage() %>" alt="Image" width="50"/></td>
        <td><%= product.getProductCategory() %></td>
        <td>
            <form action="SellerDashboardServlet" method="post">
                <input type="hidden" name="productId" value="<%= product.getProductId() %>">
                <input type="hidden" name="sellerId" value="<%= request.getAttribute("sellerId") %>">
                <input type="submit" name="action" value="Delete">
            </form>
        </td>
    </tr>
    <%
            }
        } else {
    %>
    <tr>
        <td colspan="8">No products uploaded yet.</td>
    </tr>
    <%
        }
    %>
</table>
<a href="Logout.jsp">Logout</a>
</body>
</html>
