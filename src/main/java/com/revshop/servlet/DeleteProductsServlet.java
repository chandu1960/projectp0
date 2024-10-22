package com.revshop.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import com.revshop.dao.ProductDAO;
import com.revshop.db.Dbconnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/DeleteProductServlet")
public class DeleteProductsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productIdStr = request.getParameter("productId");
        Connection connection = null;

        if (productIdStr != null) {
            try {
                int productId = Integer.parseInt(productIdStr);
                connection = Dbconnection.getConnection();
                ProductDAO productDao = new ProductDAO(connection);

                // Delete product by ID
                boolean isDeleted = productDao.deleteProductById(productId);

                if (isDeleted) {
                    response.sendRedirect("sellerDashboard.jsp?message=Product deleted successfully.");
                } else {
                    response.getWriter().println("<h3>Error: Cannot delete the product as it is still in a user's cart.</h3>");
                }

            } catch (SQLException e) {
                e.printStackTrace();
                response.getWriter().println("<h3>Error: Unable to delete the product. Please try again later.</h3>");
            } catch (NumberFormatException e) {
                response.getWriter().println("<h3>Error: Invalid product ID format.</h3>");
            }
        } else {
            response.getWriter().println("<h3>Error: No product ID provided.</h3>");
        }
    }
}
