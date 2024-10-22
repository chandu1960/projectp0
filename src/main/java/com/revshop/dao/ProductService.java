package com.revshop.dao;

import com.revshop.entity.CartItem;
import com.revshop.entity.Customer;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductService {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/shop"; // Change to your DB URL
    private static final String USER = "root"; // Change to your DB username
    private static final String PASSWORD = "root"; // Change to your DB password

    // Method to get database connection
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, USER, PASSWORD);
    }

    // Method to update the quantity of a cart item
    public void updateCartItemQuantity(String email, int productId, int quantity) {
        String query = "UPDATE user_cart SET quantity = ? WHERE email = ? AND product_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, quantity);
            stmt.setString(2, email);
            stmt.setInt(3, productId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
    }

    // Method to delete a cart item
    public void deleteCartItem(String email, int productId) {
        String query = "DELETE FROM user_cart WHERE email = ? AND product_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, email);
            stmt.setInt(2, productId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Method to get customer details
    public Customer getCustomerDetails(String email) {
        Customer customer = null;
        String query = "SELECT  address, phoneNumber FROM buyers WHERE email = ?";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                customer = new Customer(rs.getString("address"), rs.getString("phoneNumber"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customer;
    }

    // Method to calculate the total amount for a user's cart
    public double calculateTotalAmount(String email) {
        double totalAmount = 0.0;
        String query = "SELECT SUM(price * quantity) AS total FROM user_cart WHERE email = ?";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                totalAmount = rs.getDouble("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return totalAmount;
    }

    // Method to get all cart items for a user
 // Method to get all cart items for a user
 // Method to get all cart items for a user
    public List<CartItem> getCartItems(String email) {
        List<CartItem> cartItems = new ArrayList<>();
        String query = "SELECT uc.product_id, p.product_price, p.product_image, uc.quantity " +
                "FROM user_cart uc " +
                "JOIN product p ON uc.product_id = p.product_id " +
                "WHERE uc.email = ?";
 // Adjust 'products' and 'id' to your actual table and column names

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                int productId = rs.getInt("product_id");
                double price = rs.getDouble("product_price");
                int quantity = rs.getInt("quantity");
                String imageUrl = rs.getString("product_image"); // Replace with actual image URL retrieval logic
                cartItems.add(new CartItem(productId, imageUrl, price, quantity));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cartItems;
    }

    // Method to place an order
 // Method to place an order
 // Method to place an order
    public boolean placeOrder(String email, double totalAmount) {
        List<CartItem> cartItems = getCartItems(email); // Get the cart items first
        Connection conn = null; // Declare the Connection variable outside

        try {
            conn = getConnection(); // Initialize the connection
            conn.setAutoCommit(false); // Disable auto-commit for transaction

            String orderQuery = "INSERT INTO orders (buyer_email, total_amount, product_id, quantity) VALUES (?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(orderQuery)) {
                for (CartItem item : cartItems) {
                    stmt.setString(1, email);
                    stmt.setDouble(2, totalAmount);
                    stmt.setInt(3, item.getProductId()); // Get product_id from CartItem
                    stmt.setInt(4, item.getQuantity()); // Get quantity from CartItem
                    stmt.addBatch(); // Add to batch
                }
                // Execute batch insert
                stmt.executeBatch();
            }

            conn.commit(); // Commit transaction
            return true; // Indicate that the order was placed successfully

        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback on failure
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            return false; // Indicates failure to place the order
        } finally {
            if (conn != null) {
                try {
                    conn.close(); // Close the connection
                } catch (SQLException closeEx) {
                    closeEx.printStackTrace();
                }
            }
        }
    }
    public void clearCart(String email) {
        String query = "DELETE FROM user_cart WHERE email = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, email);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
