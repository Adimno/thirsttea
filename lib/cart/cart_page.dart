import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:thirst_tea/payment/payment_page.dart';

class CartPage extends StatefulWidget {
  static List<Map<String, dynamic>> cartItems = [];
  final String email; // Add email parameter to the constructor



  const CartPage({Key? key, required this.email}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  late String email;



  @override
  void initState() {
    super.initState();
    fetchCartItems(); // Fetch cart items when the page is initialized
    email = widget.email;
  }



  Future<void> fetchCartItems() async {
    var url = Uri.parse('http://10.0.2.2/thirsteaFINALV2/login/usermain/fetch_cart_cp.php');
    Map<String, String> data = {
      'email': widget.email,
    };

    try {
      var response = await http.post(url, body: data);
      print(response.body); // Add this to inspect the response body

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['success']) {
          setState(() {
            // Check if cartItems exists and is not empty, otherwise return an empty list
            var cartItems = jsonResponse['cartItems'];
            if (cartItems != null && cartItems.isNotEmpty) {
              CartPage.cartItems = List<Map<String, dynamic>>.from(cartItems).map((item) {
                if (item['order_quantity'] == null) {
                  item['order_quantity'] = 1; // Set default quantity to 1
                }
                return item;
              }).toList();
            } else {
              // Set cartItems to empty list if no items are found
              CartPage.cartItems = [];
            }
          });
        } else {
          print('Error fetching cart items: ${jsonResponse['message']}');
          setState(() {
            CartPage.cartItems = []; // Ensure cart is empty if there's an error
          });
        }
      } else {
        print('Failed to fetch cart items. Status code: ${response.statusCode}');
        setState(() {
          CartPage.cartItems = []; // Ensure cart is empty if the request fails
        });
      }
    } catch (e) {
      print('Error fetching cart items: $e');
      setState(() {
        CartPage.cartItems = [];  // Set to empty if an error occurs
      });
    }
  }

  Future<void> updateOrderQuantity(int cartItemId, int quantity, double price) async {
    var url = Uri.parse('http://10.0.2.2/thirsteaFINALV2/login/usermain/update_cart_cp.php');

    // Calculate the order amount based on quantity and price
    double orderAmount = quantity * price;

    Map<String, String> data = {
      'cart_id': cartItemId.toString(),
      'order_quantity': quantity.toString(),
      'order_amount': orderAmount.toString(), // Use the calculated order amount
    };

    try {
      var response = await http.post(url, body: data);
      print(response.body); // Add this to inspect the response body

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['success']) {
          print('Quantity and order amount updated successfully');
        } else {
          print('Error updating quantity: ${jsonResponse['message']}');
        }
      } else {
        print('Failed to update quantity. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

// Decrease the quantity of a product in the cart
  void _decrementQuantity(int index) {
    setState(() {
      if (CartPage.cartItems[index]['order_quantity'] > 1) {
        CartPage.cartItems[index]['order_quantity']--;
        double price = double.tryParse(CartPage.cartItems[index]['order_amount'].toString()) ?? 0.0; // Parse to double
        updateOrderQuantity(CartPage.cartItems[index]['cart_id'], CartPage.cartItems[index]['order_quantity'], price);
      }
    });
  }

// Increase the quantity of a product in the cart
  void _incrementQuantity(int index) {
    setState(() {
      CartPage.cartItems[index]['order_quantity']++;
      double price = double.tryParse(CartPage.cartItems[index]['order_amount'].toString()) ?? 0.0; // Parse to double
      updateOrderQuantity(CartPage.cartItems[index]['cart_id'], CartPage.cartItems[index]['order_quantity'], price);
    });
  }

  // Remove an item from the cart
  Future<void> _removeItem(int index) async {
    var cartItemId = CartPage.cartItems[index]['cart_id'];  // Get the cart item ID
    var url = Uri.parse('http://10.0.2.2/thirsteaFINALV2/login/usermain/remove_cart_cp.php');  // Your PHP endpoint URL

    Map<String, String> data = {
      'action': 'delete',  // Specify that it's a delete action
      'cart_id': cartItemId.toString(),  // Pass the cart item ID
    };

    try {
      var response = await http.post(url, body: data);
      print(response.body);  // Add this to inspect the response body

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['success']) {
          setState(() {
            CartPage.cartItems.removeAt(index);  // Remove item from the cart in Flutter
          });
          print('Cart item deleted successfully');
        } else {
          print('Error deleting item: ${jsonResponse['message']}');
        }
      } else {
        print('Failed to delete cart item. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Method to calculate subtotal (sum of individual product totals)
  double getSubtotal() {
    double subtotal = 0.0;
    for (var item in CartPage.cartItems) {
      double order_amount = double.tryParse(item['order_amount'].toString()) ?? 0.0;  // Convert to double safely
      int quantity = item['order_quantity'] ?? 0;
      double sizeCost = getSizeCost(item['size']);  // Add size-specific cost
      subtotal += (order_amount + sizeCost) * quantity;  // Total per item = price * quantity + size cost
    }
    return subtotal;
  }

  double getSizeCost(String? size) {
    if (size == null) return 0.0;
    switch (size.toLowerCase()) {
      case 'medium':
        return 10.0;  // Additional 20 for medium size
      case 'large':
        return 20.0;  // Additional 50 for large size
      default:
        return 0.0;  // No additional cost for other sizes
    }
  }

  // Method to calculate total (includes shipping)
  double getTotal(double orderAmount) {
    double subtotal = orderAmount; // Use the orderAmount passed as the subtotal
    double shippingFee = 0.0;  // Free shipping
    return subtotal + shippingFee;
  }

  void _navigateToPaymentPage() {
    // Calculate the total amount from the cart
    double subtotal = getSubtotal();
    double totalAmount = getTotal(subtotal);

    // Pass the totalAmount and other required fields to the PaymentPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          totalAmount: totalAmount,  // Pass the total amount
          subtotal: subtotal,        // Pass the subtotal if needed
          email: widget.email,       // Pass the user's email
          cartItems: CartPage.cartItems, // Optionally, pass cart items if needed
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = getSubtotal();
    double total = getTotal(subtotal);

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
            // Check if the cart is empty
            CartPage.cartItems.isEmpty
                ? Center(
              child: Text(
                'Your cart is empty.',
                style: TextStyle(fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            )
                : Expanded(
              child: ListView.builder(
                itemCount: CartPage.cartItems.length,
                itemBuilder: (context, index) {
                  final item = CartPage.cartItems[index];
                  final price = double.tryParse(
                      item['order_amount'].toString()) ?? 0.0;
                  final quantity = item['order_quantity'] ?? 1;
                  final size = item['size'] ?? 'Not selected';

                  final productTotal = (price + getSizeCost(size)) *
                      quantity; // Include size cost in total

                  return Card(
                    color: Colors.white,
                    elevation: 8,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(item['imageUrl'] ??
                                'https://via.placeholder.com/50', width: 50,
                                height: 50,
                                fit: BoxFit.cover),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['product_name'] ?? 'No Name',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                SizedBox(height: 4),
                                Text('₱${price.toStringAsFixed(2)}',
                                    style: TextStyle(color: Colors.grey)),
                                SizedBox(height: 4),
                                Text('Size: $size',
                                    style: TextStyle(color: Colors.grey)),
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
                                  Text('$quantity',
                                      style: TextStyle(fontSize: 16)),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              color: Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Summary', style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
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
                          style: TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Text(
                          '₱${total.toStringAsFixed(2)}',
                          style: TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 18),
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
                // Check if the cart is empty before proceeding to payment
                if (CartPage.cartItems.isEmpty) {
                  // Show a message or a snack bar if the cart is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Your cart is empty. Please add items to proceed.')),
                  );
                } else {
                  _navigateToPaymentPage();
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 80.0),
                backgroundColor: Color(0xFF8B5E3C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text('Proceed to Payment',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            )

          ],
        ),
      ),
    );
  }
  }