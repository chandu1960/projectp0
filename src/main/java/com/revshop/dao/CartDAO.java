package com.revshop.dao;

import com.revshop.entity.Cart;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {
    private Connection connection;

    public CartDAO(Connection connection) {
        this.connection = connection;
    }

    // Method to add an item to the cart
    public void addToCart(Cart cart) throws SQLException {
        String sql = "INSERT INTO cart (productId, quantity, totalPrice) VALUES (?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, cart.getProductId());
            statement.setInt(2, cart.getQuantity());
            statement.setBigDecimal(3, cart.getTotalPrice());
            statement.executeUpdate();
        }
    }

    // Method to get cart items
    public List<Cart> getCartItems() throws SQLException {
        List<Cart> cartItems = new ArrayList<>();
        String sql = "SELECT * FROM cart";
        try (PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                int id = resultSet.getInt("id");
                int productId = resultSet.getInt("productId");
                int quantity = resultSet.getInt("quantity");
                BigDecimal totalPrice = resultSet.getBigDecimal("totalPrice");
                Cart cart = new Cart(id, productId, quantity, totalPrice);
                cartItems.add(cart);
            }
        }
        return cartItems;
    }
}
