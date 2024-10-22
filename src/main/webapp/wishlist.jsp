<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*, org.json.JSONObject" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Wishlist</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f4f4f9;
        }

        h1 {
            color: #333;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        table, th, td {
            border: 1px solid #ccc;
        }

        th, td {
            padding: 12px;
            text-align: left;
        }

        th {
            background-color: #007bff;
            color: white;
        }

        td img {
            width: 80px;
            height: auto;
        }

        .empty-message {
            color: #555;
            font-size: 18px;
            margin-top: 20px;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
        }

        .action-buttons form {
            display: inline;
        }

        button {
            padding: 8px 16px;
            background-color: #007bff;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 4px;
        }

        button:hover {
            background-color: #0056b3;
        }

        button.remove {
            background-color: #dc3545;
        }

        button.remove:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>

<%
    // Assuming 'userEmail' is stored in the session from user login
    String email = (String) request.getSession().getAttribute("userEmail");

    if (email != null) {
        try {
            // Database connection parameters
            String url = "jdbc:mysql://localhost:3306/shop";
            String user = "root";  // Replace with your DB username
            String password = "root";  // Replace with your DB password

            // Load the JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish a connection
            Connection conn = DriverManager.getConnection(url, user, password);

            // Query to retrieve products in the wishlist
            String query = "SELECT p.product_id, p.product_name, p.product_image, p.product_description " +
                           "FROM user_wishlist uw " +
                           "JOIN product p ON uw.product_id = p.product_id " +
                           "WHERE uw.email = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, email);

            ResultSet rs = pstmt.executeQuery();

            // Check if any wishlist items are returned
            if (!rs.isBeforeFirst()) {
%>
                <div class="empty-message">Your wishlist is empty.</div>
<%
            } else {
%>
                <h1>Your Wishlist</h1>
                <table>
                    <tr>
                        <th>Product Image</th>
                        <th>Product Name</th>
                        <th>Description</th>
                        <th>Actions</th>
                    </tr>
<%
                while (rs.next()) {
                    String productId = rs.getString("product_id");
                    String productName = rs.getString("product_name");
                    String productDescription = rs.getString("product_description");
                    String productImage = rs.getString("product_image");  // Assuming product_image is a path to the image
%>
                    <tr>
                        <td><img src="<%= productImage %>" alt="<%= productName %>"></td>
                        <td><%= productName %></td>
                        <td><%= productDescription %></td>
                        <td>
                            <div class="action-buttons">
                                <!-- Form to add product to cart -->
                                <form action="addToCart" method="post">
                                    <input type="hidden" name="productId" value="<%= productId %>">
                                    <button type="submit" >Add to Cart</button>
                                </form>
                                
                                <!-- Form to remove product from wishlist -->
                                <form action="removeFromWishlist" method="post">
                                    <input type="hidden" name="productId" value="<%= productId %>">
                                    <button type="submit" class="remove">Remove</button>
                                </form>
                            </div>
                        </td>
                    </tr>
<%
                }
%>
                </table>
<%
            }

            // Close the resources
            rs.close();
            pstmt.close();
            conn.close();
        } catch (SQLException | ClassNotFoundException e) {
            out.println("Error retrieving wishlist: " + e.getMessage());
        }
    } else {
%>
        <div class="empty-message">Please log in to view your wishlist.</div>
<%
    }
%>

</body>
</html>
