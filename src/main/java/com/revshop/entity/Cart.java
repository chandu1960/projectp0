	package com.revshop.entity;
	
	import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
	
	public class Cart {
	    private int id; // ID of the cart item
	    private int productId; // ID of the product
	    private int quantity; // Quantity of the product
	    private BigDecimal totalPrice; // Total price for the quantity of the product
	    private List<ElectronicItem> items = new ArrayList<>();
	    // Constructor
	    public Cart(int id, int productId, int quantity, BigDecimal totalPrice) {
	        this.id = id;
	        this.productId = productId;
	        this.quantity = quantity;
	        this.totalPrice = totalPrice;
	    }
	
	    public Cart() {
			// TODO Auto-generated constructor stub
		}

		// Getters and Setters
	    public int getId() {
	        return id;
	    }
	
	    public void setId(int id) {
	        this.id = id;
	    }
	
	    public int getProductId() {
	        return productId;
	    }
	
	    public void setProductId(int productId) {
	        this.productId = productId;
	    }
	
	    public int getQuantity() {
	        return quantity;
	    }
	
	    public void setQuantity(int quantity) {
	        this.quantity = quantity;
	    }
	
	    public BigDecimal getTotalPrice() {
	        return totalPrice;
	    }
	
	    public void setTotalPrice(BigDecimal totalPrice) {
	        this.totalPrice = totalPrice;
	    }
	    public void addProduct(ElectronicItem item) {
	        items.add(item);
	    }
	    
	    public List<ElectronicItem> getItems() {
	        return items;
	    }

	    public void clearCart() {
	        items.clear();
	    }

	    public int getItemCount() {
	        return items.size();
	    }
	}
