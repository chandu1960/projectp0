<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Details</title>
    <link rel="stylesheet" href="styles.css"> <!-- Link to your CSS file -->
    <script>
    function addToCart() {
        const quantity = document.getElementById('quantity').value;
        const productId = document.getElementById('productId').value;
        console.log(quantity);
        console.log(productId);
        fetch('addToCart.jsp', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ productId: productId, quantity: quantity }),
        })
        .then(response => response.json())
        .then(data => {
            alert(data.message);
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Failed to add to cart.');
        });
    }

    function addToWishlist(productId) {
        fetch('addToWishlist.jsp', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ productId: productId }),
        })
        .then(response => response.json())
        .then(data => {
            alert(data.message);
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Failed to add to wishlist.');
        });
    }

    function submitReview() {
        const reviewText = document.getElementById('reviewText').value;
        const productId = document.getElementById('productId').value;

        fetch('submitReview.jsp', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ productId: productId, reviewText: reviewText }),
        })
        .then(response => response.json())
        .then(data => {
            alert(data.message);
            document.getElementById('reviewText').value = ''; // Clear the input
            // Optionally, you can refresh reviews after submission
            loadReviews(productId);
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Failed to submit review.');
        });
    }

    function loadReviews(productId) {
        fetch(`getReviews.jsp?id=${productId}`)
        .then(response => response.json())
        .then(data => {
            const reviewsContainer = document.getElementById('reviews');
            reviewsContainer.innerHTML = ''; // Clear existing reviews
            data.reviews.forEach(review => {
                const reviewDiv = document.createElement('div');
                reviewDiv.classList.add('review');
                reviewDiv.innerHTML = `<strong>${review.email}</strong><p>${review.reviewText}</p>`;
                reviewsContainer.appendChild(reviewDiv);
            });
        })
        .catch(error => {
            console.error('Error loading reviews:', error);
        });
    }
    </script>
    <style>
       /* General Styles */
body {
    font-family: 'Arial', sans-serif;
    background-color: #f8f9fa;
    margin: 0;
    padding: 20px;
}

.container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
    background-color: #ffffff;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

/* Navigation Styles */
nav {
    background-color: #007bff;
    padding: 10px;
}

nav ul {
    list-style-type: none;
    padding: 0;
    margin: 0;
    display: flex;
    justify-content: space-around;
}

nav a {
    color: white;
    text-decoration: none;
    padding: 10px 15px;
}

nav a:hover {
    background-color: #0056b3;
    border-radius: 5px;
}

/* Header Styles */
h1 {
    font-size: 2.5em;
    margin-bottom: 10px;
    color: #333;
}

h2 {
    font-size: 1.8em;
    margin-top: 20px;
    color: #007bff;
}

/* Product Detail Styles */
.product-detail {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 30px;
}

.product-image {
    max-width: 400px;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.product-info {
    flex: 1;
    margin-left: 20px;
}

.product-info p {
    margin-bottom: 15px;
    line-height: 1.6;
    color: #555;
}

/* Quantity Input Styles */
.quantity-container {
    margin: 15px 0;
}

input[type="number"] {
    width: 60px;
    padding: 5px;
    border: 1px solid #ccc;
    border-radius: 5px;
}

/* Button Styles */
.button {
    display: inline-block;
    padding: 12px 20px;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s;
    text-decoration: none;
}

.button:hover {
    background-color: #0056b3;
}

/* Review Section Styles */
.review-section {
    margin-top: 30px;
}

#reviewText {
    width: 100%;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 5px;
    resize: vertical;
}

#reviews {
    margin-top: 20px;
}

.review {
    border: 1px solid #ccc;
    padding: 10px;
    margin-bottom: 10px;
    border-radius: 5px;
    background-color: #f9f9f9;
}

/* Responsive Styles */
@media (max-width: 768px) {
    .product-detail {
        flex-direction: column;
        align-items: center;
    }

    .product-info {
        margin-left: 0;
        text-align: center;
    }
}
    </style>
</head>
<body>
 <nav>
        <ul>
            <li><a href="Electronics.jsp">Electronics</a></li>
            <li><a href="Accessories.jsp">Accessories</a></li>
            <li><a href="HomeNeeds.jsp">Home Needs</a></li>
            <li><a href="Toys.jsp">Toys</a></li>
            <li><a href="Fashion.jsp">Fashion</a></li>
            <li><a href="cart">Cart</a></li>
            <li><a href="wishlist.jsp">wishlist</a></li>
            <li><a href="myorders">My Orders</a></li>
            <li><a href="index.html">Login</a></li>
        </ul>
    </nav><div class="container">

<%
    String productId = request.getParameter("id"); // Get the product ID from the URL
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        // Database connection parameters
        String url = "jdbc:mysql://localhost:3306/shop";
        String user = "root"; // Replace with your DB username
        String password = "root"; // Replace with your DB password

        // Load the JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Establish a connection
        conn = DriverManager.getConnection(url, user, password);

        // Create a statement and execute a query to fetch product details
        stmt = conn.createStatement();
        String query = "SELECT product_id, product_name, product_description, product_image, product_price FROM product WHERE product_id = '" + productId + "'";
        rs = stmt.executeQuery(query);

        if (rs.next()) {
            String productName = rs.getString("product_name");
            String productDescription = rs.getString("product_description");
            String productImage = rs.getString("product_image");
            double productPrice = rs.getDouble("product_price");
%>
            <div class="product-detail">
                <img src="<%= productImage %>" alt="<%= productName %>" class="product-image">
                <div class="product-info">
                    <h1><%= productName %></h1>
                    <p><strong>Price:</strong> $<%= productPrice %></p>
                    <p><strong>Description:</strong> <%= productDescription %></p>

                    <div class="quantity-container">
                        <label for="quantity">Quantity:</label>
                        <input type="number" id="quantity" name="quantity" value="1" min="1">
                    </div>
                    <button class="button" onclick="addToCart()">Add to Cart</button>
                    <button class="button" onclick="addToWishlist('<%= productId %>')">Add to Wishlist</button>
                </div>
            </div>

            <div class="review-section">
                <h2>Reviews</h2>
                <input type="hidden" id="productId" value="<%= productId %>">
                <textarea id="reviewText" rows="4" placeholder="Write your review..."></textarea>
                <br>
                <button class="button" onclick="submitReview()">Submit Review</button>
                
                <div id="reviews">
                    <!-- Reviews will be loaded here -->
                </div>
            </div>
<%
            // Fetch reviews for the product
            String reviewsQuery = "SELECT email, review_text FROM product_reviews WHERE product_id = ?";
            PreparedStatement reviewStmt = conn.prepareStatement(reviewsQuery);
            reviewStmt.setInt(1, Integer.parseInt(productId));
            ResultSet reviewRs = reviewStmt.executeQuery();
            
            while (reviewRs.next()) {
                String reviewerEmail = reviewRs.getString("email");
                String reviewText = reviewRs.getString("review_text");
%>
                <div class="review">
                    <strong><%= reviewerEmail %></strong>
                    <p><%= reviewText %></p>
                </div>
<%
            }
        } else {
            out.println("<h2>Product not found!</h2>");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    } finally {
        // Close resources
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>
</div>

<script>
    // Load reviews when the page loads
    document.addEventListener('DOMContentLoaded', function() {
        loadReviews('<%= productId %>');
    });
</script>

</body>
</html>
