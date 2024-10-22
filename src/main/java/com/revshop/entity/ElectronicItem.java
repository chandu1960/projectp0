package com.revshop.entity;

import java.math.BigDecimal;

public class ElectronicItem {
    private int productId;  // No extra semicolon
    private String category;
    private String name;
    private BigDecimal price;
    private String description;
    private String imageUrl;
    private int productQuantity; // Add this line if it was missing

    // Getters and Setters
    public int getProductId() {
        return productId; // This is correct
    }

    public void setProductId(int productId) { // Change here to match getter
        this.productId = productId; // Set productId correctly
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getProductQuantity() { // This method is fine
        return productQuantity;
    }

    public void setProductQuantity(int productQuantity) { // This method is fine
        this.productQuantity = productQuantity;
    }
}
