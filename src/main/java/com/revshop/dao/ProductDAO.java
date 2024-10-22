package com.revshop.dao;

import com.revshop.entity.Product;
import com.revshop.db.Dbconnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
    private Connection connection;

    public ProductDAO(Connection connection) {
        this.connection = connection; // Use the provided connection
    }

    // Method to add a product to the database
    public void addProduct(Product product) {
        String sql = "INSERT INTO product (product_name, product_description, product_price, product_quantity, product_image, seller_id, category_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, product.getProductName());
            statement.setString(2, product.getProductDescription());
            statement.setBigDecimal(3, BigDecimal.valueOf(product.getProductPrice()));
            statement.setInt(4, product.getProductQuantity());
            statement.setString(5, product.getProductImage());
            statement.setInt(6, product.getSellerId());
            statement.setInt(7, product.getCategoryId());
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace(); // Consider using logging instead
        }
    }

    // Method to get products by seller ID
    public List<Product> getProductsBySellerId(int sellerId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM product WHERE seller_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, sellerId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Product product = new Product(
                            resultSet.getInt("product_id"),
                            resultSet.getString("product_name"),
                            resultSet.getString("product_description"),
                            resultSet.getDouble("product_price"),
                            resultSet.getInt("product_quantity"),
                            resultSet.getString("product_image"),
                            resultSet.getInt("seller_id"),
                            resultSet.getInt("category_id"),
                            resultSet.getString("category")
                    );
                    products.add(product);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Consider using logging instead
        }
        return products;
    }

    // Method to delete a product by ID
    public boolean deleteProductById(int productId) throws SQLException {
        // Check if the product is in any user's cart
        String checkCartSQL = "SELECT COUNT(*) FROM user_cart WHERE product_id = ?";
        try (PreparedStatement checkCartStmt = connection.prepareStatement(checkCartSQL)) {
            checkCartStmt.setInt(1, productId);
            ResultSet rs = checkCartStmt.executeQuery();
            rs.next();
            int count = rs.getInt(1);

            if (count > 0) {
                // Product is in the cart, handle this case as needed
                return false; // Indicate that deletion cannot proceed
            }
        }

        // Now delete the product as there are no associated cart items
        String deleteProductSQL = "DELETE FROM product WHERE product_id = ?";
        try (PreparedStatement deleteProductStmt = connection.prepareStatement(deleteProductSQL)) {
            deleteProductStmt.setInt(1, productId);
            return deleteProductStmt.executeUpdate() > 0; // Return true if deleted
        }
    }

    // Method to delete a product (optional, just calls deleteProductById)
    public boolean deleteProduct(int productId) {
        try {
            return deleteProductById(productId);
        } catch (SQLException e) {
            e.printStackTrace(); // Handle exception
            return false;
        }
    }

    public void closeConnection() throws SQLException {
        if (connection != null && !connection.isClosed()) {
            connection.close();
        }
    }
}
