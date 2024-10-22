package com.Main;

import java.sql.Connection;
import java.sql.SQLException;

import com.revshop.db.Dbconnection;

public class TestDbConnection {
    public static void main(String[] args) {
        try (Connection connection = Dbconnection.getConnection()) {
            if (connection != null) {
                System.out.println("Database connected successfully!");
            } else {
                System.out.println("Failed to connect to the database.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
