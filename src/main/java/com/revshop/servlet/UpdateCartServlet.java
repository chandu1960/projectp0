// File: com/revshop/servlet/UpdateCartServlet.java
package com.revshop.servlet;

import com.revshop.entity.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/updateCart")
public class UpdateCartServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        
        HttpSession session = request.getSession();
        List<Product> cart = (List<Product>) session.getAttribute("cart");

        if (cart != null) {
            for (Product product : cart) {
                if (product.getProductId() == productId) {
                    product.setProductQuantity(quantity); // Update the quantity
                    break;
                }
            }
            session.setAttribute("cart", cart); // Update the session cart
        }

        response.sendRedirect("cart.jsp"); // Redirect back to cart.jsp
    }
}
