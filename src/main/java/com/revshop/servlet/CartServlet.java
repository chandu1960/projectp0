package com.revshop.servlet;

import com.revshop.db.Dbconnection;
import com.revshop.entity.Product;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/addToCart")
public class CartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addToCart(request, response);
        } else if ("view".equals(action)) {
            viewCart(request, response);
        } else if ("remove".equals(action)) {
            removeFromCart(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productIdStr = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        if (productIdStr == null || productIdStr.isEmpty() || quantityStr == null || quantityStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"message\": \"Invalid input for productId or quantity\"}");
            return;
        }

        try (Connection connection = Dbconnection.getConnection()) {
            int productId = Integer.parseInt(productIdStr);
            int quantity = Integer.parseInt(quantityStr);

            // Fetch product details directly using a query
            Product product = getProductById(connection, productId);

            if (product != null && quantity <= product.getProductQuantity()) {
                HttpSession session = request.getSession();
                List<Product> cart = (List<Product>) session.getAttribute("cart");

                if (cart == null) {
                    cart = new ArrayList<>();
                }

                boolean found = false;
                for (Product p : cart) {
                    if (p.getProductId() == productId) {
                        p.setProductQuantity(p.getProductQuantity() + quantity);
                        found = true;
                        break;
                    }
                }

                if (!found) {
                    product.setProductQuantity(quantity);
                    cart.add(product);
                }

                session.setAttribute("cart", cart);
                response.setStatus(HttpServletResponse.SC_OK);
                out.write("{\"message\": \"Product added to cart successfully!\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("{\"message\": \"Insufficient stock for the selected product\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"message\": \"Invalid input for productId or quantity\"}");
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"message\": \"Database error\"}");
        } finally {
            out.close();
        }
    }

    private Product getProductById(Connection connection, int productId) throws SQLException {
        Product product = null;
        String query = "SELECT * FROM product WHERE productId = ?";
        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setInt(1, productId);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    product = new Product();
                    product.setProductId(resultSet.getInt("productId"));
                    product.setProductName(resultSet.getString("productName"));
                    product.setProductPrice(resultSet.getDouble("productPrice"));
                    product.setProductQuantity(resultSet.getInt("productQuantity"));
                    // Set other fields as necessary
                }
            }
        }
        return product;
    }

    private void viewCart(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<Product> cart = (List<Product>) session.getAttribute("cart");

        if (cart == null) {
            cart = new ArrayList<>(); // Initialize empty cart if none exists
        }

        request.setAttribute("cart", cart);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/cart.jsp");
        dispatcher.forward(request, response);
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<Product> cart = (List<Product>) session.getAttribute("cart");

        String productIdStr = request.getParameter("productId");
        if (productIdStr != null) {
            try {
                int productId = Integer.parseInt(productIdStr);
                if (cart != null) {
                    cart.removeIf(product -> product.getProductId() == productId);
                }
                session.setAttribute("cart", cart);
                response.sendRedirect("cart.jsp?message=Product removed from cart");
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid product ID");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Product ID is missing");
        }
    }
}
