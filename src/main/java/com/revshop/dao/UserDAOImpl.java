package com.revshop.dao;

import com.revshop.db.Dbconnection;
import com.revshop.entity.Buyer;
import com.revshop.entity.Seller;
import com.revshop.entity.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAOImpl {
    private Connection connection;

    public UserDAOImpl() throws SQLException {
        connection = Dbconnection.getConnection();
    }

    public Seller validateSeller(String email, String password) {
    	System.out.println("hello"+email);
    	System.out.println("hello"+password);
        Seller seller = null;
        String query = "SELECT * FROM sellers WHERE email = ? AND password = ?";

        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, email);
            statement.setString(2, password);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                seller = new Seller();
                seller.setEmail(resultSet.getString("email"));
                seller.setPassword(resultSet.getString("password"));
                seller.setShopId(resultSet.getString("shopId"));
                seller.setSellerId(resultSet.getString("seller_Id")); // Assuming this field exists in the database
                // Add other fields as necessary
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return seller;
    }

    public Buyer validateBuyer(String email, String password) throws SQLException {
        String sql = "SELECT * FROM buyers WHERE email = ? AND password = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, email);
            statement.setString(2, password);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    Buyer buyer = new Buyer();
                    buyer.setEmail(resultSet.getString("email"));
                    buyer.setPhoneNumber(resultSet.getString("phoneNumber"));
                    buyer.setAddress(resultSet.getString("address"));
                    return buyer; // Return the buyer object
                }
            }
        }
        return null; // Return null if no buyer found
    }

    public void addUser(User user) throws SQLException {
        String sql = "INSERT INTO users (email, password, phoneNumber, address) VALUES (?, ?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, user.getEmail());
            statement.setString(2, user.getPassword());
            statement.setString(3, user.getPhoneNumber());
            statement.setString(4, user.getAddress());
            statement.executeUpdate();
        }
    }

    public void addBuyer(Buyer buyer) throws SQLException {
        addUser(buyer); // Add to the 'users' table

        String sql = "INSERT INTO buyers (email, password, phoneNumber, address) VALUES (?, ?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, buyer.getEmail());
            statement.setString(2, buyer.getPassword());
            statement.setString(3, buyer.getPhoneNumber());
            statement.setString(4, buyer.getAddress());
            statement.executeUpdate();
        }
    }

    public void addApprovedEmail(String email) throws SQLException {
        String sql = "INSERT INTO approved_emails (email) VALUES (?)";
        
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, email);
            statement.executeUpdate();
        }
    }

    public boolean approveSeller(String shopId) throws SQLException {
        String sql = "UPDATE sellers SET isApproved = 1 WHERE shopId = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, shopId);
            return statement.executeUpdate() > 0; // Return true if the update was successful
        }
    }

    public boolean isEmailApproved(String email) throws SQLException {
        String sql = "SELECT * FROM approved_emails WHERE email = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, email);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next(); // Return true if the email exists
            }
        }
    }

    public void addSeller(Seller seller) throws SQLException {
        addUser(seller); // Add to the 'users' table

        String sql = "INSERT INTO sellers (email, password, phoneNumber, address, shopId) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, seller.getEmail());
            statement.setString(2, seller.getPassword());
            statement.setString(3, seller.getPhoneNumber());
            statement.setString(4, seller.getAddress());
            statement.setString(5, seller.getShopId());
            statement.executeUpdate();
        }
    }

    public boolean validateUser(String email, String password) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, email);
            statement.setString(2, password);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next(); // Return true if a matching user is found
            }
        }
    }

    public boolean isEmailUnique(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, email);
            try (ResultSet resultSet = statement.executeQuery()) {
                return !resultSet.next(); // Return true if the email does not exist
            }
        }
    }

    public void closeConnection() throws SQLException {
        if (connection != null && !connection.isClosed()) {
            connection.close();
        }
    }
}
