package com.revshop.servlet;

import com.revshop.dao.ProductService;
import com.revshop.entity.CartItem;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/manageCart")
public class CartManagementServlet extends HttpServlet {
    private ProductService productService;

    @Override
    public void init() throws ServletException {
        productService = new ProductService();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("userEmail");
        String action = request.getParameter("action");
        int productId = Integer.parseInt(request.getParameter("productId"));

        if ("update".equals(action)) {
            // Update cart item quantity
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            productService.updateCartItemQuantity(email, productId, quantity);
            
        } else if ("delete".equals(action)) {
            // Delete cart item
            productService.deleteCartItem(email, productId);
        }

        // Retrieve updated cart items
        List<CartItem> updatedCartItems = productService.getCartItems(email);
        request.setAttribute("cartItems", updatedCartItems);

        // Forward to cart-view.jsp instead of redirecting
        RequestDispatcher dispatcher = request.getRequestDispatcher("cart-view.jsp");
        dispatcher.forward(request, response);
    }
}
