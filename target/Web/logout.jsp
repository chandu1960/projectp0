<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.ServletException"%>
<%@ page import="java.io.IOException"%>

<%
    // Redirect to home page directly without session management
    response.sendRedirect("home.jsp"); // Change 'home.jsp' to your main page
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Logout - RevShop</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            margin-top: 50px;
        }
        h1 {
            color: #4CAF50;
        }
    </style>
</head>
<body>
    <h1>You have been logged out</h1>
    <p>Thank you for visiting RevShop. You can <a href="home.jsp">click here</a> to go back to the home page.</p>
</body>
</html>
