import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:thirst_tea/sign_up/sign_up_page.dart';

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
        // Firebase Auth sign-in logic
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // User sign-in successful
        print("User signed in: ${userCredential.user?.email}");

        // Fetch user data from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();
        String firstName = userDoc['firstName'] ?? '';
        String lastName = userDoc['lastName'] ?? '';

        // Navigate to HomePage after successful sign-in
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage())); // Uncomment and define HomePage

      } on FirebaseAuthException catch (e) {
        String errorMessage = "Wrong password or email";
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password or email provided.';
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      } catch (e) {
        // Handle any other errors
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
