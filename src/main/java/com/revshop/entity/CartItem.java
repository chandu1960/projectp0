package com.revshop.entity;

public class CartItem {
    private int productId;
    private String imageUrl; // URL to product image
    private double price; // Price of the product
    private int quantity;

    // Existing constructor
    public CartItem(int productId, String imageUrl, double price, int quantity) {
        this.productId = productId;
        this.imageUrl = imageUrl;
        this.price = price;
        this.quantity = quantity;
    }

    // New constructor
    public CartItem(int productId, double price, int quantity,String ImageUrl) {
        this.productId = productId;
        this.price = price;
        this.quantity = quantity;
        this.imageUrl = ImageUrl; // Set a default value or pass it as a parameter
    }

    public int getProductId() {
        return productId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setProductId(int productId) {
		this.productId = productId;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public double getPrice() {
        return price;
    }

    public int getQuantity() {
        return quantity;
    }
}
