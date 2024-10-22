package com.revshop.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.revshop.entity.ElectronicItem;
import com.revshop.db.Dbconnection;

public class ElectronicsDAO {
    public List<ElectronicItem> getItemsByCategory(String category) {
        List<ElectronicItem> items = new ArrayList<>();
        String query = "SELECT * FROM electronics WHERE category = ?";

        try (Connection connection = Dbconnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
             
            ps.setString(1, category); // Set the category parameter
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(mapRowToElectronicItem(rs));
                }
            }
            System.out.println("Number of items retrieved: " + items.size()); // Debug line
        } catch (SQLException e) {
            e.printStackTrace(); // Consider using a logger
            System.out.println("Error executing query: " + e.getMessage()); // Log any errors
        }
        return items;
    }

    // New method to get a product by its ID
    public ElectronicItem getProductById(int productId) {
        ElectronicItem item = null;
        String query = "SELECT * FROM electronics WHERE id = ?";

        try (Connection connection = Dbconnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
             
            ps.setInt(1, productId); // Set the product ID parameter
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    item = mapRowToElectronicItem(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Consider using a logger
            System.out.println("Error executing query: " + e.getMessage()); // Log any errors
        }
        return item; // Return the retrieved item or null if not found
    }

    // Helper method to map ResultSet to ElectronicItem
    private ElectronicItem mapRowToElectronicItem(ResultSet rs) throws SQLException {
        ElectronicItem item = new ElectronicItem();
        item.setProductId(rs.getInt("id"));
        item.setCategory(rs.getString("category"));
        item.setName(rs.getString("name"));
        item.setPrice(rs.getBigDecimal("price"));
        item.setDescription(rs.getString("description"));
        item.setImageUrl(rs.getString("image_url"));
        item.setProductQuantity(rs.getInt("product_quantity"));
        return item;
    }
}
