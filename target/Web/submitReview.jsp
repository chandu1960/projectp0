<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, org.json.JSONObject" %>
<%
    StringBuilder jsonResponse = new StringBuilder();
    JSONObject responseJson = new JSONObject();

    String jsonData = request.getReader().lines().collect(Collectors.joining());
    JSONObject jsonObject = new JSONObject(jsonData);
    String productId = jsonObject.getString("productId");
    String reviewText = jsonObject.getString("reviewText");
    String email = "user@example.com"; // Replace with actual logged-in user email

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        String url = "jdbc:mysql://localhost:3306/shop";
        String user = "root";
        String password = "root";

        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, password);

        String insertReview = "INSERT INTO product_reviews (product_id, email, review_text) VALUES (?, ?, ?)";
        pstmt = conn.prepareStatement(insertReview);
        pstmt.setInt(1, Integer.parseInt(productId));
        pstmt.setString(2, email);
        pstmt.setString(3, reviewText);
        pstmt.executeUpdate();

        responseJson.put("message", "Review submitted successfully.");
    } catch (SQLException | ClassNotFoundException e) {
        responseJson.put("message", "Error: " + e.getMessage());
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }

    jsonResponse.append(responseJson.toString());
    out.print(jsonResponse.toString());
%>
