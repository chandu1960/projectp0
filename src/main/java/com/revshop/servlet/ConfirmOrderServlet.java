package com.revshop.servlet;

import com.revshop.dao.ProductService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/confirmOrder")
public class ConfirmOrderServlet extends HttpServlet {
    private ProductService productService;

    @Override
    public void init() throws ServletException {
        productService = new ProductService();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("userEmail");
        System.out.println(email);

        // Retrieve total amount from the session
        double totalAmount = productService.calculateTotalAmount(email);
        System.out.println("Total price: " + totalAmount);

        // Place the order without payment method
        boolean orderPlaced = productService.placeOrder(email, totalAmount);

        // Check if the order was successfully placed
        if (orderPlaced) {
            // Clear the user's cart after a successful order
            productService.clearCart(email);
            request.setAttribute("message", "Order placed successfully!");
        } else {
            request.setAttribute("errorMessage", "Order could not be placed. Please try again.");
        }

        // Forward to the order confirmation page
        request.getRequestDispatcher("orderConfirmation.jsp").forward(request, response);
    }
}