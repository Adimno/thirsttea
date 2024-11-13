import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:thirst_tea/product_page/product_page.dart';
import 'package:thirst_tea/sign_in/sign_in_page.dart'; // Import the SignInPage for logout navigation

class HomePage1 extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage1> {
  String selectedCategory = 'All';
  List products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final String url =
        'http://10.0.2.2/thirsteaFINALV2/login/adminmain/products_cp_connection.php'; // Replace with your server address

    try {
      final response = await http.get(Uri.parse(url +
          '?category=$selectedCategory')); // Pass category as a query parameter
      if (response.statusCode == 200) {
        final List<dynamic> productsList =
        json.decode(response.body); // Decode the JSON response

        setState(() {
          products = productsList.map((product) {
            // Convert fields to appropriate types
            product['price'] = double.tryParse(product['price'].toString()) ?? 0.0; // Ensure 'price' is a double
            return product;
          }).toList(); // Ensure the products list is updated with the correct types
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFDEBDF), Color(0xFFF5E6D8)], // Soft gradient
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: Center(
          child: Text(
            'ThirstTea',
            style: TextStyle(fontSize: screenWidth * 0.06),
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(  // Wrap the IconButton with Builder
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Now this context has Scaffold
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/images/thirstea_logo.jpg', // Your logo
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.home, color: Colors.blueAccent),
                title: Text(
                  'Home',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                leading: Icon(Icons.account_circle, color: Colors.blueAccent),
                title: Text(
                  'Profile',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.redAccent),
                title: Text(
                  'Logout',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.redAccent),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignInPage()), // Navigate to SignInPage
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFDEBDF), Color(0xFFF5E6D8)], // Soft gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Featured Products',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.04),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CategoryChip(
                      label: 'All',
                      isSelected: selectedCategory == 'All',
                      onSelected: () {
                        setState(() {
                          selectedCategory = 'All';
                          fetchProducts();
                        });
                      },
                    ),
                    CategoryChip(
                      label: 'Milktea',
                      isSelected: selectedCategory == 'Milktea',
                      onSelected: () {
                        setState(() {
                          selectedCategory = 'Milktea';
                          fetchProducts();
                        });
                      },
                    ),
                    CategoryChip(
                      label: 'Fruitea',
                      isSelected: selectedCategory == 'Fruitea',
                      onSelected: () {
                        setState(() {
                          selectedCategory = 'Fruitea';
                          fetchProducts();
                        });
                      },
                    ),
                    CategoryChip(
                      label: 'Frappe',
                      isSelected: selectedCategory == 'Frappe',
                      onSelected: () {
                        setState(() {
                          selectedCategory = 'Frappe';
                          fetchProducts();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenWidth * 0.025),
            Expanded(
              child: products.isEmpty
                  ? Center(
                  child: Text("No products available",
                      style: TextStyle(fontSize: 16, color: Colors.black)))
                  : GridView.builder(
                padding: EdgeInsets.all(screenWidth * 0.025),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: screenWidth * 0.025,
                  mainAxisSpacing: screenWidth * 0.025,
                  childAspectRatio: 0.7,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final product_name = product['product_name'];
                  final product_description = product['product_description'];
                  final imageUrl = product['imageUrl'];
                  final double price = product['price'];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductPage(
                            imageUrl: imageUrl,
                            productName: product_name,
                            price: price,
                            product_description: product_description,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product_name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      Icons.star,
                                      color: index < 5
                                          ? Colors.orange
                                          : Colors.grey,
                                      size: 14,
                                    );
                                  }),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '\₱$price',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  CategoryChip({required this.label, required this.isSelected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
