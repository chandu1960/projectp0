package com.revshop.servlet;

import java.io.IOException;
import java.sql.SQLException;

import com.revshop.dao.UserDAOImpl;
import com.revshop.entity.Buyer;
import com.revshop.entity.Seller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {
    private UserDAOImpl userDAO;

    @Override
    public void init() throws ServletException {
        try {
            userDAO = new UserDAOImpl();
        } catch (SQLException e) {
            throw new ServletException("Error initializing UserDAO", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        System.out.println(action);

        switch (action) {
            case "registerBuyer":
                handleBuyerRegistration(request, response);
                break;
            case "registerSeller":
                handleSellerRegistration(request, response);
                break;
            case "login":
                handleLogin(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                break;
        }
    }

    private void handleBuyerRegistration(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Buyer buyer = new Buyer();
        
        // Retrieving parameters from the request
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phoneNumber = request.getParameter("phoneNumber");
        String address = request.getParameter("address");

        buyer.setEmail(email);
        buyer.setPassword(password);
        buyer.setPhoneNumber(phoneNumber);
        buyer.setAddress(address);

        try {
            if (userDAO.isEmailUnique(buyer.getEmail())) {
                userDAO.addBuyer(buyer);
                response.sendRedirect("login.html");
            } else {
                request.setAttribute("errorMessage", "Email already exists.");
                request.getRequestDispatcher("registration.html").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Consider using a logger here
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error during registration: " + e.getMessage());
        }
    }

    private void handleSellerRegistration(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Seller seller = new Seller();
        seller.setEmail(request.getParameter("email"));
        seller.setPassword(request.getParameter("password"));
        seller.setPhoneNumber(request.getParameter("phoneNumber"));
        seller.setAddress(request.getParameter("address"));
        seller.setShopId(request.getParameter("shopId"));

        try {
            if (userDAO.isEmailUnique(seller.getEmail())) {
                userDAO.addSeller(seller);
                response.sendRedirect("index.html");
            } else {
                request.setAttribute("errorMessage", "Email already exists.");
                request.getRequestDispatcher("index.html").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Consider using a logger here
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error during registration: " + e.getMessage());
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userType = request.getParameter("userType");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
       System.out.print(userType);
        System.out.println(email);
        System.out.println(password);
        
        try {
            if ("buyer".equals(userType)) {
                Buyer buyer = userDAO.validateBuyer(email, password);
                if (buyer != null) {
                    // Set session and redirect for buyer
                    HttpSession session = request.getSession();
                    session.setAttribute("userEmail", buyer.getEmail());
                    session.setAttribute("userName", buyer.getPhoneNumber());
                    session.setMaxInactiveInterval(30 * 60);
                    response.sendRedirect("welcome.html");
                } else {
                    request.setAttribute("errorMessage", "Invalid login credentials.");
                    request.getRequestDispatcher("index.html").forward(request, response);
                }
            } else if ("seller".equals(userType)) {
                // Validate seller using email and password
                Seller seller = userDAO.validateSeller(email, password);
                if (seller != null) {
                    HttpSession session = request.getSession();
                    session.setAttribute("userEmail", seller.getEmail());
                    session.setAttribute("userName", seller.getShopId());
                    session.setAttribute("sellerId", seller.getSellerId()); // Store sellerId in session
                    session.setMaxInactiveInterval(30 * 60);
                    response.sendRedirect("sellerDashboard.jsp");
                } else {
                    request.setAttribute("errorMessage", "Invalid login credentials.");
                    request.getRequestDispatcher("index.html").forward(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred during login.");
            request.getRequestDispatcher("index.html").forward(request, response);
        }
    }

}