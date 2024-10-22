package com.revshop.servlet;

import java.io.IOException;
import java.sql.SQLException;

import com.revshop.dao.UserDAOImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ApproveEmailServlet")
public class ApproveEmailServlet extends HttpServlet {
    private UserDAOImpl userDAO;

    @Override
    public void init() throws ServletException {
        try {
            userDAO = new UserDAOImpl();
        } catch (SQLException e) {
            throw new ServletException("Error initializing UserDAO", e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String shopId = request.getParameter("shopId"); // Get the shopId from the request
        String email = request.getParameter("email");

        try {
            boolean isApproved = userDAO.approveSeller(shopId); // Approve the seller
            if (isApproved) {
                userDAO.addApprovedEmail(email); // Add email to approved list
                request.setAttribute("successMessage", "Email approved successfully.");
            } else {
                request.setAttribute("errorMessage", "Seller not found or already approved.");
            }
            request.getRequestDispatcher("approve_email.html").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error during approval: " + e.getMessage());
            request.getRequestDispatcher("approve_email.html").forward(request, response);
        }
    }

    @Override
    public void destroy() {
        try {
            userDAO.closeConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
