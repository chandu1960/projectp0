<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmation</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            text-align: center;
        }
        h1 {
            color: #333;
        }
        p {
            font-size: 1.2em;
            color: #555;
            margin: 20px 0;
        }
        .success {
            color: #28a745;
            font-weight: bold;
            padding: 15px;
            border: 2px solid #28a745;
            border-radius: 5px;
            background-color: #e7f5e7;
            margin: 20px 0;
        }
        .error {
            color: #dc3545;
            font-weight: bold;
            padding: 15px;
            border: 2px solid #dc3545;
            border-radius: 5px;
            background-color: #f8d7da;
            margin: 20px 0;
        }
        a {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            transition: background-color 0.3s, transform 0.2s;
        }
        a:hover {
            background-color: #0056b3;
            transform: scale(1.05);
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Order Confirmation</h1>
        <%
            String message = (String) request.getAttribute("message");
            String errorMessage = (String) request.getAttribute("errorMessage");
        %>
        <%
            if (message != null) {
        %>
            <div class="success">
                <p><%= message %></p>
            </div>
        <%
            } else if (errorMessage != null) {
        %>
            <div class="error">
                <p><%= errorMessage %></p>
            </div>
        <%
            }
        %>
        <a href="cart">Go back to cart</a>
    </div>
</body>
</html>
