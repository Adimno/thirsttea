import 'package:flutter/material.dart';
import 'package:thirst_tea/cart/cart_page.dart';

class ProductPage extends StatelessWidget {
  final String? imageUrl;
  final String? productName;
  final double? price;
  final String? product_description;

  const ProductPage({
    Key? key,
    this.imageUrl,
    this.productName,
    this.price,
    this.product_description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Product Details',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl ?? 'https://via.placeholder.com/250',
                height: 350,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Text(
              productName ?? 'Unnamed Product',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 8),
            Text(
              '₱${(price ?? 0.0).toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              product_description ?? 'No description available',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Check if the product is already in the cart
                  bool productExists = CartPage.cartItems.any((item) => item['productName'] == productName);

                  if (productExists) {
                    // If product is already in cart, show a message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('This product is already in the cart')),
                    );
                  } else {
                    // Add product to cart if it's not in the cart yet
                    CartPage.cartItems.add({
                      'productName': productName,
                      'imageUrl': imageUrl,
                      'price': price,
                      'quantity': 1, // Default quantity is 1
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Product added to cart')),
                    );
                  }
                },
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                label: Text(
                  'Add to Cart',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 80.0),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
