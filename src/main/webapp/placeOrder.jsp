<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmation</title>
</head>
<body>
<h1>Order Placed Successfully!</h1>
<p>Your order has been placed. Thank you for shopping with us!</p>

<%
    // Session is already declared; don't declare it again
    // HttpSession session = request.getSession();
    
    session.removeAttribute("cart"); // Clear the cart after placing the order
%>

<a href="shop.jsp">Continue Shopping</a>
</body>
</html>
