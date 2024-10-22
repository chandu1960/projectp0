package com.revshop.servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import com.revshop.dao.ProductDAO;
import com.revshop.entity.Product;
import com.revshop.db.Dbconnection; // Ensure Dbconnection class is present

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/SellerDashboardServlet")
@MultipartConfig
public class SellerDashboardServlet extends HttpServlet {
    private ProductDAO productDao;

    @Override
    public void init() throws ServletException {
        try {
            Connection connection = Dbconnection.getConnection(); // Ensure this returns a valid connection
            productDao = new ProductDAO(connection); // Pass connection to DAO
        } catch (SQLException e) {
            throw new ServletException("Database connection problem.", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int sellerId = Integer.parseInt(request.getParameter("sellerId"));
        List<Product> productList = productDao.getProductsBySellerId(sellerId);

        request.setAttribute("productList", productList);
        request.setAttribute("sellerId", sellerId);
        RequestDispatcher dispatcher = request.getRequestDispatcher("sellerDashboardServlet.jsp");
        dispatcher.forward(request, response); // Forward to the JSP page to display products
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("upload".equals(action)) {
            handleUpload(request, response);
        } else if ("delete".equals(action)) {
            handleDelete(request, response);
        }
    }

    private void handleUpload(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String productName = request.getParameter("productName");
        String productDescription = request.getParameter("productDescription");
        BigDecimal productPrice = new BigDecimal(request.getParameter("productPrice"));
        int productQuantity = Integer.parseInt(request.getParameter("productQuantity"));
        String category = request.getParameter("category"); // Main category
        String productCategory = request.getParameter("productCategory"); // Sub-category
        int sellerId = Integer.parseInt(request.getParameter("sellerId"));

        // Determine category_id based on the main category
        int categoryId = getCategoryId(category);

        // Handle file upload
        Part filePart = request.getPart("productImage");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String imagePath = "images/" + fileName; // Path to save the image
        filePart.write(getServletContext().getRealPath("") + "/" + imagePath); // Save image to server

        int productId = 0;
		// Create Product object using entity class
        Product newProduct = new Product(productId, sellerId, productName, productDescription, productPrice.doubleValue(), productQuantity, imagePath, categoryId, productCategory);
 productDao.addProduct(newProduct); // Add product to the database

        response.sendRedirect("sellerDashboard?sellerId=" + sellerId); // Redirect to the same servlet
    }

    private int getCategoryId(String category) {
        switch (category) {
            case "Electronics":
                return 1;
            case "Accessories":
                return 2;
            case "Toys":
                return 3;
            case "Fashion":
                return 4;
            case "HomeNeeds":
                return 5;
            default:
                throw new IllegalArgumentException("Invalid category: " + category);
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));
        productDao.deleteProduct(productId);

        int sellerId = Integer.parseInt(request.getParameter("sellerId"));
        response.sendRedirect("sellerDashboard?sellerId=" + sellerId); // Redirect to the same servlet
    }

    @Override
    public void destroy() {
        try {
            productDao.closeConnection(); // Close connection when servlet is destroyed
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
