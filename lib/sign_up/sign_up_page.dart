import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thirst_tea/sign_in/sign_in_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _fullNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Send data to the PHP server
        var response = await http.post(
          Uri.parse('http://10.0.2.2/thirsteaFINALV2/login/registration_cp.php'),
          // Your PHP server URL
          body: {
            'name': _fullNameController.text.trim(),
            'address': _addressController.text.trim(),
            'email': _emailController.text.trim(),
            'password': _passwordController.text.trim(),
          },
        );

        if (response.statusCode == 200) {
          // Parse the JSON response
          var responseData = json.decode(response.body);

          if (responseData['status'] == 'success') {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('You registered successfully!')),
            );

            // Navigate to the sign-in page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignInPage()),
            );
          } else {
            // Handle error from server
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseData['message'])),
            );
          }
        } else {
          // Handle other HTTP errors
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign-up failed. Please try again.')),
          );
        }
      } catch (e) {
        // Handle network errors
        print("Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong.')),
        );
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
                        Image.asset(
                          'assets/thirstea_logo.png', // Replace with your image path
                          width: 100,  // Set the width of the box
                          height: 100, // Set the height of the box
                          fit: BoxFit.cover, // Ensures the image covers the entire box
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B5E3C),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    _buildTextField(
                      controller: _fullNameController,
                      labelText: "Full Name",
                      icon: Icons.person,
                    ),
                    SizedBox(height: 16.0),
                    _buildTextField(
                      controller: _addressController,
                      labelText: "Address",
                      icon: Icons.location_city,
                    ),
                    SizedBox(height: 16.0),
                    _buildTextField(
                      controller: _emailController,
                      labelText: "Email",
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16.0),
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
                    SizedBox(height: 16.0),
                    _buildPasswordTextField(
                      controller: _confirmPasswordController,
                      labelText: "Confirm Password",
                      isVisible: _isConfirmPasswordVisible,
                      onVisibilityToggle: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                    SizedBox(height: 32.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF8B5E3C), // Dark brown button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SignInPage()),
                          );
                        },
                        child: Text(
                          "Already have an account? Sign In",
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
