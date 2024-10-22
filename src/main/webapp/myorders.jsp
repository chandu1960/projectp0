<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.revshop.entity.Order" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders</title>
    <link rel="stylesheet" href="styles.css"> <!-- Include your CSS file -->
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa; /* Light background for better contrast */
            margin: 0;
            padding: 40px;
        }

        h2 {
            color: #343a40; /* Dark gray for headings */
            text-align: center;
            margin-bottom: 30px;
            font-size: 2.5em; /* Larger heading */
        }

        .order-container {
            max-width: 900px; /* Set a maximum width for the order list */
            margin: 0 auto;
            background: #ffffff; /* White background for the order container */
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            padding: 20px;
            animation: fadeIn 0.5s;
        }

        .order {
            border-bottom: 1px solid #dee2e6; /* Light gray border */
            padding: 15px 0;
            transition: background-color 0.3s;
        }

        .order:last-child {
            border-bottom: none; /* Remove border for last order */
        }

        .order-details {
            display: flex; /* Flexbox for layout */
            justify-content: space-between; /* Space between elements */
            align-items: center; /* Center align items */
            padding: 10px 0;
        }

        .order-details span {
            color: #6c757d; /* Subtle color for details */
            font-size: 1.1em; /* Font size for details */
        }

        .no-orders {
            text-align: center;
            font-size: 1.5em;
            color: #6c757d; /* Gray for 'No orders found' */
        }

        a.back-home {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 25px;
            background-color: #007bff; /* Bootstrap primary color */
            color: white;
            text-decoration: none;
            border-radius: 4px;
            text-align: center;
            transition: background-color 0.3s, transform 0.2s;
        }

        a.back-home:hover {
            background-color: #0056b3; /* Darker shade on hover */
            transform: translateY(-2px); /* Lift effect on hover */
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }
    </style>
</head>
<body>
    <div class="order-container">
        <h2>Your Orders</h2>
        
        <%
            List<Order> orders = (List<Order>) request.getAttribute("orders");
            
            if (orders == null || orders.isEmpty()) {
                out.println("<p class='no-orders'>No orders found.</p>");
            } else {
                for (Order order : orders) {
                    out.println("<div class='order'>");
                    out.println("<div class='order-details'>");
                    out.println("<span>Order ID: <strong>" + order.getId() + "</strong></span>");
                    out.println("<span>Total: <strong>$" + String.format("%.2f", order.getTotal()) + "</strong></span>");
                    out.println("<span>Date: <strong>" + order.getDate() + "</strong></span>");
                    out.println("</div>");
                    out.println("</div>");
                }
            }
        %>
        <a href="welcome.html" class="back-home">Back to Home</a>
    </div>
</body>
</html>
