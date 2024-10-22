package com.revshop.servlet;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.revshop.dao.ElectronicsDAO;
import com.revshop.entity.Cart;
import com.revshop.entity.ElectronicItem;
@WebServlet("/ItemServlet")
public class ItemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the category from the request parameter
        String category = request.getParameter("category");
        
        // Redirect to products.jsp with the selected category as a request attribute
        if (category != null && !category.isEmpty()) {
            request.setAttribute("selectedCategory", category);
            RequestDispatcher dispatcher = request.getRequestDispatcher("products.jsp");
            dispatcher.forward(request, response);
        } else {
            // Handle the case where category is not provided
            request.setAttribute("errorMessage", "No category selected!");
            RequestDispatcher dispatcher = request.getRequestDispatcher("error.jsp"); // Redirect to an error page if needed
            dispatcher.forward(request, response);
        }
    }
    // Handles POST requests
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String selectedProductId = request.getParameter("selectedProductId");

        // Initialize DAO
        ElectronicsDAO electronicsDAO = new ElectronicsDAO();

        // Logic to add the product to the cart
        Cart cart = (Cart) request.getSession().getAttribute("cart");
        if (cart == null) {
            cart = new Cart(); // Create a new cart if it doesn't exist
            request.getSession().setAttribute("cart", cart); // Store the new cart in the session
        }

        // Fetch product by ID
        ElectronicItem product = null;
        try {
            product = electronicsDAO.getProductById(Integer.parseInt(selectedProductId));
        } catch (NumberFormatException e) {
            // Handle invalid product ID format
            request.setAttribute("errorMessage", "Invalid product ID format!");
            RequestDispatcher dispatcher = request.getRequestDispatcher("products.jsp");
            dispatcher.forward(request, response);
            return;
        }

        if (product != null) {
            cart.addProduct(product); // Add the product to the cart
            response.sendRedirect("cart.jsp"); // Redirect to cart.jsp
        } else {
            // Handle the case where the product doesn't exist
            request.setAttribute("errorMessage", "Product not found!");
            RequestDispatcher dispatcher = request.getRequestDispatcher("products.jsp");
            dispatcher.forward(request, response);
        }
    }
}
