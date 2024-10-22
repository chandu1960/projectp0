<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, org.json.JSONObject" %>
<%
    response.setContentType("application/json");
    JSONObject jsonResponse = new JSONObject();
    
    String jsonData = request.getReader().lines().collect(java.util.stream.Collectors.joining());
    JSONObject requestData = new JSONObject(jsonData);

    // Get productId as String
    String productId = requestData.getString("productId");
    String email = "user@example.com"; // Replace with logged-in user's email

    try {
        // Database connection parameters
        String url = "jdbc:mysql://localhost:3306/shop";
        String user = "root"; // Replace with your DB username
        String password = "root"; // Replace with your DB password

        // Load the JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Establish a connection
        Connection conn = DriverManager.getConnection(url, user, password);
        
        // Convert productId from String to int
        int productIdInt = Integer.parseInt(productId); // Convert productId to int

        String query = "INSERT INTO user_wishlist (email, product_id) VALUES (?, ?)";
        PreparedStatement pstmt = conn.prepareStatement(query);
        pstmt.setString(1, email);             // Set email
        pstmt.setInt(2, productIdInt);          // Set product_id as int
        pstmt.executeUpdate();

        jsonResponse.put("message", "Product added to wishlist successfully.");
    } catch (SQLException | ClassNotFoundException | NumberFormatException e) {
        jsonResponse.put("message", "Error adding to wishlist: " + e.getMessage());
    }

    out.print(jsonResponse);
%>
