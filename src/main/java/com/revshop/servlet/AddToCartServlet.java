package com.revshop.servlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.revshop.db.Dbconnection;


    @WebServlet("/viewCart")
    public class AddToCartServlet extends HttpServlet {
        @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            HttpSession session = request.getSession();
            String buyerEmail = (String) session.getAttribute("email"); // Get the buyer's email from the session
            
            // Debugging: Check if buyerEmail is null
            System.out.println("Buyer Email from session: " + buyerEmail); 

            // Check if buyerEmail is null (i.e., the user is not logged in)
            if (buyerEmail == null) {
                response.sendRedirect("login.jsp"); // Redirect to login if not authenticated
                return;
            }

            int productId;
            int quantity;

            // Get parameters from the request
            try {
                productId = Integer.parseInt(request.getParameter("productId")); // Product ID from request
                quantity = Integer.parseInt(request.getParameter("quantity")); // Quantity from request
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid product ID or quantity.");
                request.getRequestDispatcher("cart.jsp").forward(request, response);
                return;
            }

            // SQL query to add or update cart items
            String query = "INSERT INTO buyer_cart (buyer_email, product_id, quantity) VALUES (?, ?, ?) " +
                           "ON DUPLICATE KEY UPDATE quantity = quantity + ?";

            try (Connection conn = Dbconnection.getConnection(); // Assume you have a method to get a DB connection
                 PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setString(1, buyerEmail);
                ps.setInt(2, productId);
                ps.setInt(3, quantity);
                ps.setInt(4, quantity); // Update the quantity if the product already exists in the cart
                ps.executeUpdate();

                // Optionally set a success message
                request.setAttribute("message", "Product added to cart successfully!");
            } catch (SQLException e) {
                e.printStackTrace();
                // Optionally set an error message
                request.setAttribute("errorMessage", "Failed to add product to cart. Please try again.");
            }

            // Redirect to cart page
            response.sendRedirect("cart-view.jsp");
        }
    }
