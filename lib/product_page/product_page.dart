import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  final String? imageUrl; // Make nullable
  final String? productName; // Make nullable
  final double? price; // Make nullable
  final String? product_description; // Make nullable

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
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl ?? 'https://via.placeholder.com/250', // Default image if null
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Text(
              productName ?? 'Unnamed Product', // Default if null
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              '₱${(price ?? 0.0).toStringAsFixed(2)}', // Default to 0.0 if null
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                product_description ?? 'No description available', // Default if null
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Add your navigation or functionality here
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 80.0),
                backgroundColor: Colors.blue,
              ),
              child: Text(
                'Add to Cart',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
