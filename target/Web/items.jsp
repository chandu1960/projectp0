<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.revshop.dao.ElectronicsDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="com.revshop.entity.ElectronicItem" %>
<%
    String category = request.getParameter("category");
    ElectronicsDAO electronicsDAO = new ElectronicsDAO();
    List<ElectronicItem> items = electronicsDAO.getItemsByCategory(category);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Items in Category</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f4f4f4;
        }
        
        h1 {
            text-align: center;
            color: #333;
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
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .grid-item img {
            max-width: 100%;
            height: auto;
        }

        .quantity {
            margin-top: 10px;
        }

        button {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>

<h1>Items in Category: <%= category %></h1>

<%
    if (items == null || items.isEmpty()) {
%>
    <p>No items found in this category.</p>
<%
    } else {
%>
    <div class="grid-container">
<%
        for (ElectronicItem item : items) {
            // Ensure that item is not null and has valid data
            if (item != null) {
%>
          <div class="grid-item">
    <h3><%= item.getName() %></h3>
    <p><%= item.getDescription() %></p>
    <p>Price: $<%= item.getPrice() %></p>
    <img src="<%= item.getImageUrl() %>" alt="<%= item.getName() %>" />
    
    <p>Available Quantity: <%= item.getProductQuantity() %></p>
    
   <form action="addToCart" method="post">
    <input type="hidden" name="action" value="add"> <!-- Hidden input for action -->
    <input type="hidden" name="productId" value="<%= item.getProductId() %>"> <!-- Updated Product ID -->
    <label for="quantity">Quantity:</label>
    <input type="number" name="quantity" min="1" max="<%= item.getProductQuantity() %>" value="1" required>
    <button type="submit">Add to Cart</button>
</form>

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
