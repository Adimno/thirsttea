import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:thirst_tea/sign_up/sign_up_page.dart';
// import 'package:thirst_tea/home/home_page.dart';
import 'package:thirst_tea/bottom_tabs/bottom_tabs_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class SignInPage extends StatefulWidget {

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Send login data to your PHP server
        var response = await http.post(
          Uri.parse('http://10.0.2.2/thirsteaFINALV2/login/validation.php'), // Your PHP server URL
          body: {
            'email': _emailController.text.trim(),
            'password': _passwordController.text.trim(),
          },
        );

        // Check the response status code and handle accordingly
        if (response.statusCode == 200) {
          // Parse the response from the PHP server
          var responseData = json.decode(response.body);

          // Check if login was successful
          if (responseData['status'] == 'success') {
            // If the response is successful, navigate to the HomePage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(), // Navigate to HomePage
              ),
            );
          } else {
            // Handle invalid credentials from PHP server
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Invalid email or password')),
            );
          }
        } else {
          // Handle different HTTP status codes
          switch (response.statusCode) {
            case 400:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Bad request. Please check your input.')),
              );
              break;
            case 401:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Unauthorized. Please check your credentials.')),
              );
              break;
            case 403:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Forbidden. You do not have permission to access this resource.')),
              );
              break;
            case 404:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Server not found. Please check the URL.')),
              );
              break;
            case 500:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Server error. Please try again later.')),
              );
              break;
            default:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Login failed. Please try again.')),
              );
          }
        }
      } catch (e) {
        // Handle errors for network or other exceptions
        if (e is SocketException) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No internet connection. Please check your connection.')),
          );
        } else if (e is FormatException) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid response format. Please try again later.')),
          );
        } else {
          print("Error: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An unexpected error occurred. Please try again.")),
          );
        }
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFDEBDF), Color(0xFFF5E6D8)], // Soft gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              constraints: BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Column(
                      children: [
                        Icon(
                          Icons.local_cafe, // Add a custom icon here
                          size: 60,
                          color: Color(0xFF8B5E3C),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B5E3C),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.0),
                    // Email Field
                    _buildTextField(
                      controller: _emailController,
                      labelText: "Email",
                      icon: Icons.email,
                    ),
                    SizedBox(height: 16.0),
                    // Password Field
                    _buildPasswordTextField(
                      controller: _passwordController,
                      labelText: "Password",
                      isVisible: _isPasswordVisible,
                      onVisibilityToggle: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    SizedBox(height: 32.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF8B5E3C), // Dark brown button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        child: Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.0),
                    // Don't have an account? Text
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SignUpPage()),
                          );
                        },
                        child: Text(
                          " Don't have an account? Sign Up",
                          style: TextStyle(
                            color: Color(0xFF8B5E3C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Color(0xFFB2795A)),
        labelText: labelText,
        labelStyle: TextStyle(color: Color(0xFFB2795A)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Color(0xFFDABF9E)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Color(0xFF8B5E3C)),
        ),
        filled: true,
        fillColor: Color(0xFFF5E6D8).withOpacity(0.1),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Please enter $labelText' : null,
    );
  }

  Widget _buildPasswordTextField({
    required TextEditingController controller,
    required String labelText,
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, color: Color(0xFFB2795A)),
        labelText: labelText,
        labelStyle: TextStyle(color: Color(0xFFB2795A)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Color(0xFFDABF9E)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Color(0xFF8B5E3C)),
        ),
        filled: true,
        fillColor: Color(0xFFF5E6D8).withOpacity(0.1),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Color(0xFFB2795A),
          ),
          onPressed: onVisibilityToggle,
        ),
      ),
      obscureText: !isVisible,
      validator: (value) => value == null || value.isEmpty
          ? 'Please enter $labelText'
          : value.length < 6
          ? 'Password must be at least 6 characters long'
          : null,
    );
  }
}