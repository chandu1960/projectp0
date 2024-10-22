package com.revshop.entity;

/**
 * Represents a product in the e-commerce application.
 */

public class Product {
    private int productId; // Unique identifier for the product
    private int sellerId; // Identifier for the seller
    private String productName; // Name of the product
    private String productDescription; // Description of the product
    private double productPrice; // Price of the product
    private int productQuantity; // Available quantity of the product
    private String productImage; // Image URL or path of the product
    private int categoryId; // Unique identifier for the category
    private String productCategory; // Optional, to track the category name
    public Product(int productId, String productName, String productDescription, double productPrice, int productQuantity, String productImage, int sellerId, int categoryId, String productCategory) {
        this.productId = productId; // Set the product ID
        this.productName = productName;
        this.productDescription = productDescription;
        this.productPrice = productPrice;
        this.productQuantity = productQuantity;
        this.productImage = productImage;
        this.sellerId = sellerId; // Set the seller ID
        this.categoryId = categoryId; // Set the category ID
        this.productCategory = productCategory; // Set the product category
    }

    // Getter for productId
    public int getProductId() {
        return productId; // Return the product ID
    }

    // Setter for productId
    public void setProductId(int productId) {
        this.productId = productId; // Set the product ID
    }

    // Getter for categoryId
    public int getCategoryId() {
        return categoryId; // Return the category ID
    }

    // Getter for productCategory
    public String getProductCategory() {
        return productCategory; // Get the category name
    }

    public void setProductCategory(String productCategory) {
        if (productCategory == null || productCategory.trim().isEmpty()) {
            throw new IllegalArgumentException("Product category cannot be null or empty.");
        }
        this.productCategory = productCategory; // Set the category name
    }

    /**
     * Constructor for fetching a product from the database.
     *
     * @param sellerId       Identifier for the seller
     * @param productName     Name of the product
     * @param productDescription Description of the product
     * @param productPrice    Price of the product
     * @param productQuantity Available quantity of the product
     * @param productImage    Image URL or path of the product
     * @param categoryId      Identifier for the category
     * @param productCategory  Category of the product
     */
    public Product(int productId, int sellerId, String productName, String productDescription, double productPrice, int productQuantity, String productImage, int categoryId, String productCategory) {
        this.productId = productId; // Set the product ID
        this.sellerId = sellerId;
        this.productName = productName;
        this.productDescription = productDescription;
        this.productPrice = productPrice;
        this.productQuantity = productQuantity;
        this.productImage = productImage;
        this.categoryId = categoryId; // Update this line
        this.productCategory = productCategory; // This may remain if you want to keep the product category
    }

    // Default constructor
    public Product() {
    }

    // Getters and Setters for other fields

    public int getSellerId() {
        return sellerId;
    }

    public void setSellerId(int sellerId) {
        this.sellerId = sellerId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        if (productName == null || productName.trim().isEmpty()) {
            throw new IllegalArgumentException("Product name cannot be null or empty.");
        }
        this.productName = productName;
    }

    public String getProductDescription() {
        return productDescription;
    }

    public void setProductDescription(String productDescription) {
        this.productDescription = productDescription;
    }

    public double getProductPrice() {
        return productPrice;
    }

    public void setProductPrice(double productPrice) {
        if (productPrice < 0) {
            throw new IllegalArgumentException("Product price cannot be negative.");
        }
        this.productPrice = productPrice;
    }

    public int getProductQuantity() {
        return productQuantity;
    }

    public void setProductQuantity(int productQuantity) {
        if (productQuantity < 0) {
            throw new IllegalArgumentException("Product quantity cannot be negative.");
        }
        this.productQuantity = productQuantity;
    }

    public String getProductImage() {
        return productImage;
    }

    public void setProductImage(String productImage) {
        this.productImage = productImage;
    }
}
