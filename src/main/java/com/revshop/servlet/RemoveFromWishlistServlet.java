package com.revshop.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/removeFromWishlist")
public class RemoveFromWishlistServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productId = request.getParameter("productId");
        String email = (String) request.getSession().getAttribute("userEmail");
System.out.println("meow"+productId);
System.out.print("meow"+email);
        if (email != null && productId != null) {
            try {
                // Database connection
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/shop", "root", "root");

                // Delete from wishlist
                String query = "DELETE FROM user_wishlist WHERE email = ? AND product_id = ?";
                PreparedStatement pstmt = conn.prepareStatement(query);
                pstmt.setString(1, email);
                pstmt.setInt(2, Integer.parseInt(productId));
                pstmt.executeUpdate();

                pstmt.close();
                conn.close();

                response.sendRedirect("wishlist.jsp"); // Redirect back to wishlist page
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
