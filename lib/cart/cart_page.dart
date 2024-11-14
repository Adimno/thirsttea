import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  static List<Map<String, dynamic>> cartItems = [];

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Decrease the quantity of a product in the cart
  void _decrementQuantity(int index) {
    setState(() {
      if (CartPage.cartItems[index]['quantity'] > 1) {
        CartPage.cartItems[index]['quantity']--;
      }
    });
  }

  // Increase the quantity of a product in the cart
  void _incrementQuantity(int index) {
    setState(() {
      CartPage.cartItems[index]['quantity']++;
    });
  }

  // Remove an item from the cart
  void _removeItem(int index) {
    setState(() {
      CartPage.cartItems.removeAt(index);
    });
  }

  // Method to calculate subtotal (sum of individual product totals)
  double getSubtotal() {
    double subtotal = 0.0;
    for (var item in CartPage.cartItems) {
      double price = item['price'] ?? 0.0;
      int quantity = item['quantity'] ?? 0;
      subtotal += price * quantity;  // Total per item = price * quantity
    }
    return subtotal;
  }

  // Method to calculate total (includes shipping)
  double getTotal() {
    double subtotal = getSubtotal();
    double shippingFee = 0.0;  // Free shipping
    return subtotal + shippingFee;
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = getSubtotal();
    double total = getTotal();


    return Scaffold(
      appBar: AppBar(
        title: Text('Cart', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: CartPage.cartItems.length,
                itemBuilder: (context, index) {
                  final item = CartPage.cartItems[index];
                  final price = item['price'] ?? 0.0;
                  final quantity = item['quantity'] ?? 0;
                  final productTotal = price * quantity;  // Total for this product

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(item['imageUrl'] ?? 'https://via.placeholder.com/50', width: 50, height: 50, fit: BoxFit.cover),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['productName'] ?? 'No Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                SizedBox(height: 4),
                                Text('₱${price.toStringAsFixed(2)}', style: TextStyle(color: Colors.grey)),
                                Text(item['description'] ?? '', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove_circle_outline),
                                    onPressed: () => _decrementQuantity(index),
                                  ),
                                  Text('$quantity', style: TextStyle(fontSize: 16)),
                                  IconButton(
                                    icon: Icon(Icons.add_circle_outline),
                                    onPressed: () => _incrementQuantity(index),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removeItem(index),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              color: Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal:'),
                        Text('₱${subtotal.toStringAsFixed(2)}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Shipping Fee:'),
                        Text('Free'),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          '₱${total.toStringAsFixed(2)}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Proceed to payment functionality
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 80.0),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text('Proceed to Payment', style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
