package com.revshop.entity;

public class Seller extends User {
    private String shopId;
    private String sellerId; // Add sellerId property

    // Getter for shopId
    public String getShopId() {
        return shopId;
    }

    // Setter for shopId
    public void setShopId(String shopId) {
        this.shopId = shopId;
    }

    // Getter for sellerId
    public String getSellerId() {
        return sellerId;
    }

    // Setter for sellerId
    public void setSellerId(String sellerId) { // Implement the setter
        this.sellerId = sellerId;
    }
}
