import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For encoding data into JSON
import 'package:thirst_tea/cart/cart_page.dart';
import 'package:thirst_tea/home/home_page.dart';

class PaymentPage extends StatelessWidget {
  final double totalAmount;
  final double subtotal;
  final String email;
  final List<Map<String, dynamic>> cartItems; // Pass the cart items if needed

  const PaymentPage({
    Key? key,
    required this.totalAmount,
    required this.subtotal,
    required this.email,
    required this.cartItems,
  }) : super(key: key);


  Future<void> fetchCartItems() async {
    var url = Uri.parse('http://10.0.2.2/thirsteaFINALV2/login/usermain/fetch_cart_cp.php');
    Map<String, String> data = {
      'email': email, // Use the 'email' variable passed to this class
    };

    try {
      var response = await http.post(url, body: data);
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['success']) {
          // Update the cart items
          CartPage.cartItems = List<Map<String, dynamic>>.from(jsonResponse['cartItems']);
        } else {
          print('Error fetching cart items: ${jsonResponse['message']}');
        }
      } else {
        print('Failed to fetch cart items. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> placeOrder(BuildContext context, String address) async {
    // Collect data from the page
    final selectedPaymentMethod = 'COD'; // Replace with actual selected payment method

    // Calculate the total amount and subtotal by multiplying order_amount with order_quantity for each item
    double calculatedTotalAmount = 0.0;
    double calculatedSubtotal = 0.0;

    // Loop through each cart item and calculate the total for each item
    for (var item in CartPage.cartItems) {
      final price = double.tryParse(item['order_amount'].toString()) ?? 0.0;
      final quantity = item['order_quantity'] ?? 1;
      final itemTotal = price * quantity; // Multiply price by quantity to get the total for the item

      calculatedTotalAmount += itemTotal; // Add item total to the grand total
      calculatedSubtotal += itemTotal;   // Add item total to the subtotal
    }

    // Send HTTP POST request to the server
    final url = Uri.parse('http://10.0.2.2/thirsteaFINALV2/login/usermain/place_order_cp.php');
    final response = await http.post(url, body: {
      'email': email,
      'payment_method': selectedPaymentMethod,
      'address': address,
      'cart_items': json.encode(CartPage.cartItems), // Convert cart items to JSON string
      'total_amount': calculatedTotalAmount.toString(),
      'subtotal': calculatedSubtotal.toString(),
    });

    if (response.statusCode == 200) {
      // Success, show success message and navigate back
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Your order has been placed successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.pop(context);

                // Navigate to the home page (replace with your home page widget)
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage1(email: email)), // Replace HomePage() with your actual home page widget
                );

                // Call fetchCartItems to refresh the cart and ensure it's empty after placing the order
                fetchCartItems();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Error handling
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('There was an error placing your order. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_PH', symbol: '₱');
    final formattedTotalAmount = currencyFormat.format(totalAmount);
    final formattedSubtotal = currencyFormat.format(subtotal);

    final TextEditingController addressController = TextEditingController(); // Added controller for address

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Method',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Choose your payment option',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PaymentOption(icon: Icons.money, text: 'Cash'),
              ],
            ),
            SizedBox(height: 24),
            TextField(
              controller: addressController, // Assign the controller here
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SummaryRow(label: 'Subtotal', value: formattedSubtotal),
                  SummaryRow(label: 'Shipping fee', value: 'Free'),
                  Divider(),
                  SummaryRow(
                    label: 'Total',
                    value: formattedTotalAmount,
                    isTotal: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Use the address text entered by the user
                placeOrder(context, addressController.text);
              }, // Call placeOrder when button is pressed
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'Place Order',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentOption extends StatefulWidget {
  final IconData icon;
  final String text;

  PaymentOption({required this.icon, required this.text});

  @override
  _PaymentOptionState createState() => _PaymentOptionState();
}

class _PaymentOptionState extends State<PaymentOption> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
      },
      child: Container(
        width: 120,
        height: 100,
        decoration: BoxDecoration(
          color: _isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 40, color: _isSelected ? Colors.blue : Colors.grey),
            SizedBox(height: 8),
            Text(
              widget.text,
              style: TextStyle(fontSize: 16, color: _isSelected ? Colors.blue : Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  SummaryRow({required this.label, required this.value, this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
