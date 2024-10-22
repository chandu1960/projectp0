<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, org.json.JSONObject" %>
<%
    response.setContentType("application/json");
    JSONObject jsonResponse = new JSONObject();
    
    String jsonData = request.getReader().lines().collect(java.util.stream.Collectors.joining());
    JSONObject requestData = new JSONObject(jsonData);

    String productId = requestData.getString("productId");
    int quantity = requestData.getInt("quantity");
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
        
        // Assuming productId is an integer, convert it
        int productIdInt = Integer.parseInt(productId); // Convert String to int

        String query = "INSERT INTO user_cart (email, product_id, quantity) VALUES (?, ?, ?) " +
                       "ON DUPLICATE KEY UPDATE quantity = quantity + ?";
        PreparedStatement pstmt = conn.prepareStatement(query);
        pstmt.setString(1, email);
        pstmt.setInt(2, productIdInt); // Set the converted integer
        pstmt.setInt(3, quantity);
        pstmt.setInt(4, quantity);
        pstmt.executeUpdate();

        jsonResponse.put("message", "Product added to cart successfully.");
    } catch (SQLException | ClassNotFoundException | NumberFormatException e) {
        jsonResponse.put("message", "Error adding to cart: " + e.getMessage());
    }

    out.print(jsonResponse);  
%>
