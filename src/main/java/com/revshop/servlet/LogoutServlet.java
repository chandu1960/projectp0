package com.revshop.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Logger;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(LogoutServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String userEmail = null;

        if (session != null) {
            userEmail = (String) session.getAttribute("userEmail"); // Retrieve user email for logging
            session.invalidate(); // Invalidate the session
            logger.info("User logged out: " + userEmail); // Log the logout action
        }

        // Redirect to the logout confirmation JSP page
        response.sendRedirect("logoutConfirmation.jsp");
    }
}
