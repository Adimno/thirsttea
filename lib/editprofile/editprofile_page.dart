import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:thirst_tea/profile/profile_page.dart';
import 'package:thirst_tea/home/home_page.dart';
import 'package:thirst_tea/sign_in/sign_in_page.dart';
import 'package:thirst_tea/home/home_page.dart';
import 'package:thirst_tea/developers/developers_page.dart';

class EditProfilePage extends StatefulWidget {
  final String email;

  EditProfilePage({required this.email});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController.text = widget.email;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final response = await http.get(
      Uri.parse(
          'http://10.0.2.2/thirsteaFINALV2/login/usermain/get_user_data_cp.php?email=${widget.email}'),
    );

    if (response.statusCode == 200) {
      final data = Map<String, dynamic>.from(json.decode(response.body));
      if (data['success']) {
        setState(() {
          nameController.text = data['name'];
          addressController.text = data['address'];
        });
      }
    }
  }

  Future<void> _updateUserProfile() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2/thirsteaFINALV2/login/usermain/update_profile_cp.php?email=${widget.email}'),
        body: {
          'email': emailController.text,
          'name': nameController.text,
          'address': addressController.text,
          'password': passwordController.text,
        },
      );

      final data = Map<String, dynamic>.from(json.decode(response.body));
      if (data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile updated successfully")),
        );
        // Redirect to ProfilePage with the updated email
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(email: emailController.text),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Failed to update profile")),
        );
      }
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
        title: const Text('Edit Profile'),
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
                Navigator.pop(context); // Close the drawer
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) =>
                value!.isEmpty ? "Please enter your email" : null,
              ),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) =>
                value!.isEmpty ? "Please enter your name" : null,
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) =>
                value!.isEmpty ? "Please enter your address" : null,
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                value!.length < 6 ? "Password must be at least 6 characters" : null,
              ),
              TextFormField(
                controller: confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) =>
                value != passwordController.text ? "Passwords do not match" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Color(0xFF8B5E3C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: _updateUserProfile,
                child: Text("Update Profile",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
