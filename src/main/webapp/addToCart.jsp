<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, org.json.JSONObject" %>
<%
    response.setContentType("application/json");
    JSONObject jsonResponse = new JSONObject();

    // Read the incoming JSON data
    String jsonData = request.getReader().lines().collect(java.util.stream.Collectors.joining());
    JSONObject requestData = new JSONObject(jsonData);

    String productId = requestData.getString("productId");
    int quantity = requestData.getInt("quantity");
    
    // Retrieve the logged-in user's email from the session
    String email = (String) request.getSession().getAttribute("userEmail");

    // Check if the email is null (user not logged in)
    if (email == null) {
        jsonResponse.put("message", "User is not logged in. Please log in to add items to the cart.");
    } else {
        String url = "jdbc:mysql://localhost:3306/shop";
        String user = "root"; // Replace with your DB username
        String password = "root"; // Replace with your DB password

        try (Connection conn = DriverManager.getConnection(url, user, password);
             PreparedStatement productStmt = conn.prepareStatement("SELECT product_price AS price, product_image AS image_url FROM product WHERE product_id = ?");
             PreparedStatement pstmt = conn.prepareStatement("INSERT INTO user_cart (email, product_id, quantity, image_url, price) VALUES (?, ?, ?, ?, ?) " +
                                                            "ON DUPLICATE KEY UPDATE quantity = quantity + ?")) {

            // Assuming productId is an integer, convert it
            int productIdInt = Integer.parseInt(productId); // Convert String to int

            // Query to get product details (price and image URL)
            productStmt.setInt(1, productIdInt);
            try (ResultSet productRs = productStmt.executeQuery()) {
                // Check if product exists
                if (productRs.next()) {
                    double price = productRs.getDouble("price");
                    String imageUrl = productRs.getString("image_url");

                    // Set parameters for inserting/updating the cart
                    pstmt.setString(1, email);
                    pstmt.setInt(2, productIdInt);
                    pstmt.setInt(3, quantity);
                    pstmt.setString(4, imageUrl);
                    pstmt.setDouble(5, price);
                    pstmt.setInt(6, quantity);

                    pstmt.executeUpdate();
                    jsonResponse.put("message", "Product added to cart successfully.");
                } else {
                    jsonResponse.put("message", "Product not found.");
                }
            }
        } catch (SQLException e) {
            jsonResponse.put("message", "Error adding to cart: " + e.getMessage());
            e.printStackTrace(); // Log the full stack trace for debugging
        } catch (NumberFormatException e) {
            jsonResponse.put("message", "Invalid product ID format.");
        }
    }

    // Send the JSON response
    out.print(jsonResponse);
%>
