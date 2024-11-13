import 'package:flutter/material.dart';

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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Align all to the left
          children: [
            Text(
              'Product Details', // Text at the top of the image
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl ?? 'https://via.placeholder.com/250',
                height: 350,
                width: 350,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Text(
              productName ?? 'Unnamed Product',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 8),
            Text(
              '₱${(price ?? 0.0).toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 16),
            Text(
              product_description ?? 'No description available',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 24),
            Center( // Center the button horizontally
              child: ElevatedButton.icon(
                onPressed: () {
                  // Add your navigation or functionality here
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
