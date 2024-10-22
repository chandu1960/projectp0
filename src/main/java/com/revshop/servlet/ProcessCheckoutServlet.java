package com.revshop.servlet;

import com.revshop.dao.ProductService;
import com.revshop.entity.Customer; // Make sure to import Customer entity

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/processCheckout")
public class ProcessCheckoutServlet extends HttpServlet {
    private ProductService productService;

    @Override
    public void init() throws ServletException {
        productService = new ProductService();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("userEmail");
System.out.println("tharun"+email);
        // Fetch customer details from the database
        Customer customer = productService.getCustomerDetails(email);
        
        // If customer is null, handle accordingly (e.g., redirect to an error page or show a message)
        if (customer == null) {
            request.setAttribute("errorMessage", "User details not found. Please try again.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        double totalAmount = productService.calculateTotalAmount(email);
       System.out.println("total price:"+totalAmount);
        // Set customer details in request attributes
        //request.setAttribute("name", customer.getName());
        request.setAttribute("address", customer.getAddress());
        request.setAttribute("phone", customer.getPhoneNumber());
        request.setAttribute("totalAmount", totalAmount);

        request.getRequestDispatcher("payment.jsp").forward(request, response);
    }
}