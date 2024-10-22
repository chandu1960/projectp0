package com.revshop.servlet;

import com.revshop.dao.ProductService;
import com.revshop.entity.CartItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/cart")
public class CartViewServlet extends HttpServlet {
    private ProductService productService;

    @Override
    public void init() {
        productService = new ProductService();
    }
    

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("userEmail");
        System.out.println(email);
        System.out.println("hellowir");
        List<CartItem> cartItems = productService.getCartItems(email);
        
        request.setAttribute("cartItems", cartItems);
        request.getRequestDispatcher("cart-view.jsp").forward(request, response);
    }
}
