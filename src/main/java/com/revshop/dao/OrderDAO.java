package com.revshop.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.revshop.db.Dbconnection;
import com.revshop.entity.Order;

public class OrderDAO {
    public List<Order> getOrdersByBuyerEmail(String email) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE buyer_email = ?";
        try (Connection conn = Dbconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setTotal(rs.getDouble("total_amount")); // Ensure you have the correct column name
                order.setDate(rs.getTimestamp("order_date")); // Adjust as per your database
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
}
