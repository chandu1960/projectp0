<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout</title>
    <link rel="stylesheet" href="styles.css"> <!-- Include your CSS file -->
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            padding: 20px;
            background-color: #f4f4f4;
        }

        .hidden {
            display: none;
        }

        h1, h3 {
            color: #333;
        }

        .message {
            margin: 10px 0;
            padding: 10px;
            background-color: #e0ffe0;
            border: 1px solid #c3e6c3;
        }

        label {
            font-weight: bold;
        }

        input[type="text"], input[type="number"], input[type="month"] {
            width: 100%;
            padding: 10px;
            margin: 5px 0;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        button {
            padding: 10px 20px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #218838;
        }

        #qrCode img {
            width: 200px; /* Adjusted size for better visibility */
            height: 200px;
        }

        .billing-details {
            background-color: #ffffff;
            padding: 20px;
            margin-top: 20px;
            border-radius: 4px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .payment-options {
            margin-top: 20px;
        }

        .payment-option {
            padding: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
            margin-bottom: 10px;
            text-align: center;
            cursor: pointer;
            transition: background-color 0.3s, transform 0.2s;
        }

        .payment-option:hover {
            background-color: #f0f0f0;
            transform: scale(1.02);
        }

        .card-details, .paypal-details, .online-payment-details, .upi-details {
            margin-top: 20px;
            padding: 20px;
            background-color: #ffffff;
            border-radius: 4px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
    <h1>Checkout</h1>

    <form id="checkoutForm" method="post" action="placeOrder">
        <h3>Delivery Address</h3>
        <label for="address">Address:</label>
        <input type="text" id="address" name="address" required><br><br>
        <label for="contact">Contact Number:</label>
        <input type="text" id="contact" name="contact" required><br><br>
        
        <button type="button" onclick="showBillingDetails()">Pay Now</button>
    </form>

    <div id="billingDetails" class="hidden billing-details">
        <h3>Billing Details</h3>
        <p><strong>Address:</strong> <span id="billingAddress"></span></p>
        <p><strong>Contact Number:</strong> <span id="billingContact"></span></p>

        <h3>Payment Options</h3>
        <div class="payment-options">
            <div class="payment-option" onclick="showCardDetails()">Credit/Debit Card</div>
            <div class="payment-option" onclick="showPayPalDetails()">PayPal</div>
            <div class="payment-option" onclick="showCashOnDelivery()">Cash on Delivery</div>
            <div class="payment-option" onclick="showOnlinePaymentDetails()">Online Payment</div>
        </div>
    </div>

    <div id="cardDetails" class="hidden card-details">
        <h3>Enter Card Details</h3>
        <label for="cardNumber">Card Number:</label>
        <input type="number" id="cardNumber" name="cardNumber" required>
        <label for="expiryDate">Expiry Date:</label>
        <input type="month" id="expiryDate" name="expiryDate" required>
        <label for="cvv">CVV:</label>
        <input type="number" id="cvv" name="cvv" required>
        <button type="button" onclick="showQRCode()">Pay</button>
    </div>

    <div id="paypalDetails" class="hidden paypal-details">
        <h3>Enter PayPal Account Details</h3>
        <label for="paypalEmail">Email:</label>
        <input type="text" id="paypalEmail" name="paypalEmail" required>
        <button type="button" onclick="showQRCode()">Pay</button>
    </div>

    <div id="onlinePaymentDetails" class="hidden online-payment-details">
        <h3>Select Online Payment Method</h3>
        <div class="payment-option" onclick="showUPIDetails()">Google Pay (GPay)</div>
        <div class="payment-option" onclick="showUPIDetails()">PhonePe</div>
        <div class="payment-option" onclick="showUPIDetails()">Paytm</div>
    </div>

    <div id="upiDetails" class="hidden upi-details">
        <h3>Enter UPI Details</h3>
        <label for="upiPhone">UPI ID:</label>
        <input type="text" id="upiPhone" name="upiPhone" required placeholder="Enter your phone number">
        <label for="upiProvider">Provider:</label>
        <input type="text" id="upiProvider" name="upiProvider" required placeholder="Enter last 3 alphabets (e.g., @ybl)">
        <button type="button" onclick="showQRCode()">Pay</button>
    </div>

    <div id="cashOnDeliveryMessage" class="hidden message">
        <p>Cash on Delivery is not available.</p>
    </div>

    <div id="qrCode" class="hidden">
        <h3>Your QR Code</h3>
        <img src="images/WhatsApp Image 2024-10-07 at 13.22.55_947046df.jpg" alt="Fake QR Code" /> <!-- Fake QR Code -->
        <br><br>
        <button type="button" onclick="placeOrder()">Deliver</button>
    </div>

    <script>
        function showBillingDetails() {
            const address = document.getElementById('address').value;
            const contact = document.getElementById('contact').value;

            if (address && contact) {
                document.getElementById('billingDetails').classList.remove('hidden');
                document.getElementById('billingAddress').innerText = address;
                document.getElementById('billingContact').innerText = contact;
                document.getElementById('checkoutForm').classList.add('hidden');
            } else {
                alert("Please fill in your address and contact details before proceeding to payment.");
            }
        }

        function showCardDetails() {
            document.getElementById('cardDetails').classList.remove('hidden');
            document.getElementById('paypalDetails').classList.add('hidden');
            document.getElementById('onlinePaymentDetails').classList.add('hidden');
            document.getElementById('cashOnDeliveryMessage').classList.add('hidden');
            document.getElementById('upiDetails').classList.add('hidden');
        }

        function showPayPalDetails() {
            document.getElementById('paypalDetails').classList.remove('hidden');
            document.getElementById('cardDetails').classList.add('hidden');
            document.getElementById('onlinePaymentDetails').classList.add('hidden');
            document.getElementById('cashOnDeliveryMessage').classList.add('hidden');
            document.getElementById('upiDetails').classList.add('hidden');
        }

        function showOnlinePaymentDetails() {
            document.getElementById('onlinePaymentDetails').classList.remove('hidden');
            document.getElementById('cardDetails').classList.add('hidden');
            document.getElementById('paypalDetails').classList.add('hidden');
            document.getElementById('cashOnDeliveryMessage').classList.add('hidden');
            document.getElementById('upiDetails').classList.add('hidden');
        }

        function showUPIDetails() {
            const contactNumber = document.getElementById('contact').value;
            document.getElementById('upiDetails').classList.remove('hidden');
            document.getElementById('upiPhone').value = contactNumber; // Pre-fill with the contact number
            document.getElementById('onlinePaymentDetails').classList.add('hidden');
            document.getElementById('cardDetails').classList.add('hidden');
            document.getElementById('paypalDetails').classList.add('hidden');
            document.getElementById('cashOnDeliveryMessage').classList.add('hidden');
        }

        function showCashOnDelivery() {
            document.getElementById('cashOnDeliveryMessage').classList.remove('hidden');
            document.getElementById('cardDetails').classList.add('hidden');
            document.getElementById('paypalDetails').classList.add('hidden');
            document.getElementById('onlinePaymentDetails').classList.add('hidden');
            document.getElementById('upiDetails').classList.add('hidden');
        }

        function showQRCode() {
            document.getElementById('qrCode').classList.remove('hidden');
            document.getElementById('cardDetails').classList.add('hidden');
            document.getElementById('paypalDetails').classList.add('hidden');
            document.getElementById('onlinePaymentDetails').classList.add('hidden');
            document.getElementById('upiDetails').classList.add('hidden');
        }

        function placeOrder() {
            // Logic to place the order
            alert("Your order has been placed successfully!");
            location.reload(); // Optionally refresh the page or redirect
        }
    </script>
</body>
</html>
