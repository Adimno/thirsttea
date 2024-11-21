import 'package:flutter/material.dart';
import 'package:thirst_tea/sign_up/sign_up_page.dart';
import 'package:thirst_tea/sign_in/sign_in_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter engine is initialized before Firebase

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SignInPage(), // Ensure MyHomePage is defined properly
    );
  }
}
