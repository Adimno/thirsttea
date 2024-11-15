import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Make sure to import intl for number formatting

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

  @override
  Widget build(BuildContext context) {
    // Format the totalAmount for display
    final currencyFormat = NumberFormat.currency(locale: 'en_PH', symbol: '₱');
    final formattedTotalAmount = currencyFormat.format(totalAmount);
    final formattedSubtotal = currencyFormat.format(subtotal);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(  // Wrap the body in SingleChildScrollView
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
            SizedBox(height: 24),  // Add spacing between the summary and button
            ElevatedButton(
              onPressed: () {
                // Add navigation or other logic for placing an order
              },
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
  bool _isSelected = false; // Track if the payment option is selected

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected; // Toggle selection state on tap
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
