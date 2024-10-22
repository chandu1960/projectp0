package com.revshop.servlet;

import java.io.IOException;
import java.util.List;

import com.revshop.dao.OrderDAO;
import com.revshop.entity.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/myorders")
public class MyOrdersServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Retrieve buyer's email from session
        String userEmail = (String) request.getSession().getAttribute("userEmail");
        
        if (userEmail != null) {
            OrderDAO orderDAO = new OrderDAO();
            List<Order> orders = orderDAO.getOrdersByBuyerEmail(userEmail);
            
            // Set orders as request attribute
            request.setAttribute("orders", orders);
            // Forward to myorders.jsp
            request.getRequestDispatcher("myorders.jsp").forward(request, response);
        } else {
            response.sendRedirect("login.jsp"); // Redirect to login if email is not present
        }
    }
}
