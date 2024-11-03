import 'package:btk/chat_page.dart';
import 'package:btk/navbar.dart';
import 'package:btk/splash_screen.dart';
import 'package:btk/topicpage.dart';
import 'package:flutter/material.dart';
import 'package:btk/second_screen.dart'; // Import the separate file
import 'package:btk/home_page.dart';
import 'package:btk/quotes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false, // Call the screen from another file
    );
  }
}
