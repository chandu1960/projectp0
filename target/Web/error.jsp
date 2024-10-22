<!-- File: error.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Error</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8d7da;
            color: #721c24;
            padding: 20px;
        }
        .error-message {
            border: 1px solid #f5c6cb;
            background-color: #f8d7da;
            padding: 15px;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <div class="error-message">
        <h2>Error Occurred</h2>
        <p>
            <% String errorMessage = request.getParameter("message");
               if (errorMessage != null) {
                   out.print(errorMessage);
               } else {
                   out.print("An unexpected error occurred.");
               }
            %>
        </p>
        <a href="cart.jsp">Go back to Cart</a>
    </div>
</body>
</html>
