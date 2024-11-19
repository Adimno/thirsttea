import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:thirst_tea/home/home_page.dart';
import 'package:thirst_tea/sign_in/sign_in_page.dart';
import 'package:thirst_tea/profile/profile_page.dart';
import 'package:thirst_tea/developers/developers_page.dart';
import 'package:thirst_tea/about/about_page.dart';

class OrderPage extends StatefulWidget {
  final String email;

  OrderPage({required this.email});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List orders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  // Fetch orders from the PHP API
  Future<void> _fetchOrders() async {
    final String url =
        'http://10.0.2.2/thirsteaFINALV2/login/usermain/fetch_orders_cp.php'; // Your server URL

    try {
      // Append the email parameter to the URL
      final response = await http.get(Uri.parse('$url?email=${widget.email}'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          setState(() {
            orders = data['orders'];
          });
        } else {
          // Handle error (no orders or user not logged in)
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Error"),
              content: Text(data['message']),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        }
      } else {
        // Handle request failure
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Error"),
            content: Text("Failed to load orders. Please try again later."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Handle network or parsing error
      print("Error: $e");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("An error occurred. Please try again."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFDEBDF), Color(0xFFF5E6D8)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Text('Orders'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFDAB68C), Color(0xFFF5E6D8)], // Milk tea-themed colors
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 35, // Reduced radius to prevent overflow
                    backgroundImage: AssetImage('assets/thirstea_logo.png'), // Replace with your logo path
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'ThirsTea Shop',
                    style: TextStyle(
                      fontSize: 20, // Reduced font size
                      fontWeight: FontWeight.bold,
                      color: Colors.brown, // Milk tea theme
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Your favorite milk tea destination!',
                    style: TextStyle(
                      fontSize: 14, // Reduced font size for tagline
                      color: Colors.brown[300], // Softer shade for tagline
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle, color: Colors.brown),
              title: Text('Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage(email: widget.email)),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.home, color: Colors.brown),
              title: Text('Home', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage1(email: widget.email)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.help, color: Colors.brown),
              title: Text(
                'About Us',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage(email: widget.email)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.code, color: Colors.brown),
              title: Text(
                'Developers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DeveloperPage(email: widget.email)),
                );
              },
            ),
          ],
        ),
      ),
      body: orders.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Your Orders",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                var order = orders[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Image.network(order['imageUrl']),
                    title: Text(order['product_name']),
                    subtitle: Text(
                      "Size: ${order['size']}\n"
                          "Quantity: ${order['order_quantity']}\n"
                          "Amount: \₱${order['order_amount']}\n"
                          "Status: ${order['order_status']}\n"
                          "Order Date: ${order['order_date']}",
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
