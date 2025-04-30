public class Product {
    public String productId { get; set; }
    public Integer quantity { get; set; }

    // Constructor to initialize values
    public Product(String productId, Integer quantity) {
        this.productId = productId;
        this.quantity = quantity;
    }
}