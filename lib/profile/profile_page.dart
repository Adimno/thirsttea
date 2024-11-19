import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:thirst_tea/sign_in/sign_in_page.dart';
import 'package:thirst_tea/home/home_page.dart';
import 'package:thirst_tea/orders/order_page.dart';
import 'package:thirst_tea/editprofile/editprofile_page.dart';

class ProfilePage extends StatefulWidget {
  final String email;

  ProfilePage({required this.email});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String address = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/thirsteaFINALV2/login/usermain/get_user_data_cp.php?email=${widget.email}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        setState(() {
          name = data['name'];
          address = data['address'];
        });
      } else {
        // Handle user not found
        print("User not found");
      }
    } else {
      // Handle server error
      print("Server error");
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
        title: const Text('Profile'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Column(children: [SizedBox(height: 20)]),
            ),
            ListTile(
              leading: Icon(Icons.account_circle, color: Colors.brown),
              title: Text('Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              onTap: () => Navigator.pop(context),
            ),
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
              leading: Icon(Icons.logout, color: Colors.redAccent),
              title: Text('Logout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.redAccent)),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage()));
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              name.isNotEmpty ? name : 'Loading...',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.email,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                SizedBox(width: 5),
                Text(
                  address.isNotEmpty ? address : 'Loading...',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit profile'),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(email: widget.email),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.history),
                    title: Text('Orders'),
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => OrderPage(email: widget.email)));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}