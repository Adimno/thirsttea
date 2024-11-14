import 'package:flutter/material.dart';
import 'package:thirst_tea/cart/cart_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ProductPage extends StatefulWidget {
  final String imageUrl;
  final String productName;
  final double price;
  final String productDescription;
  final String productId;

  // Constructor for ProductPage
  const ProductPage({
    Key? key,
    required this.imageUrl,
    required this.productName,
    required this.price,
    required this.productDescription,
    required this.productId,
  }) : super(key: key);


  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String? selectedSize;

  // Add the addToCart function here...
  Future<void> addToCart({
    required String productId,
    required String imageUrl,
    required String size,
    required int orderQuantity,
    required String description,
    required String productName,
    required double price,
    required String userEmail,
  }) async {
    var url = Uri.parse('http://10.0.2.2/thirsteaFINALV2/login/usermain/add_to_cart_cp.php');
    double orderAmount = orderQuantity * price;

    Map<String, String> data = {
      'email': userEmail,
      'product_id': productId,
      'size': size,
      'order_quantity': orderQuantity.toString(),
      'order_amount': orderAmount.toStringAsFixed(2),
      'imageUrl': imageUrl,
      'description': description,
      'product_name': productName,
      'add_to_cart': 'true',
    };

    try {
      var response = await http.post(url, body: data);
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['success']) {
          print('Item added to the cart');
        } else {
          print('Error adding item to cart: ${jsonResponse['message']}');
        }
      } else {
        print('Failed to add item to cart. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Product Details', style: TextStyle(color: Colors.black)),
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
                widget.imageUrl,
                height: 350,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Text(
              widget.productName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 8),
            Text(
              '₱${widget.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              widget.productDescription,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedSize,
              hint: Text('Select Size'),
              items: ['Small', 'Medium', 'Large'].map((size) {
                return DropdownMenuItem<String>(
                  value: size,
                  child: Text(size),
                );
              }).toList(),
              onChanged: (newSize) {
                setState(() {
                  selectedSize = newSize;
                });
              },
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  if (selectedSize == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select a size')),
                    );
                    return;
                  }

                  bool productExists = CartPage.cartItems.any((item) =>
                  item['productName'] == widget.productName &&
                      item['size'] == selectedSize);

                  if (productExists) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('This product (size: $selectedSize) is already in the cart')),
                    );
                  } else {
                    CartPage.cartItems.add({
                      'productName': widget.productName,
                      'imageUrl': widget.imageUrl,
                      'price': widget.price,
                      'quantity': 1,
                      'size': selectedSize,
                    });

                    addToCart(
                      productId: widget.productId,
                      imageUrl: widget.imageUrl,
                      size: selectedSize!,
                      orderQuantity: 1,
                      description: widget.productDescription,
                      productName: widget.productName,
                      price: widget.price,
                      userEmail: 'user@example.com',
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
