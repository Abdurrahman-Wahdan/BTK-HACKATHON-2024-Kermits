import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Import the Lottie package
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package

class TopicBox extends StatelessWidget {
  final String text;
  final Color color;
  final bool hasAnimation;

  const TopicBox({
    required this.text,
    this.color = Colors.white,
    this.hasAnimation = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      height: 200,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (hasAnimation)
                SizedBox(
                  height: 100,
                  width: 100,
                  child: _getAnimation(), // Call a helper method
                ),
              SizedBox(height: 10),
              Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getAnimation() {
    switch (text) {
      case "Biology":
        return Lottie.asset('assets/Lottie/Animation - biology.json');
      case "History":
        return Lottie.asset('assets/Lottie/history.json');
      case "Physics":
        return Lottie.asset('assets/Lottie/Animation - Physics.json');
      case "Chemistry":
        return Lottie.asset('assets/Lottie/Animation - Chemistry.json');
      case "Turkish":
        return Lottie.asset('assets/Lottie/Animation - Turkish.json');
      case "Mathematics":
        return Lottie.asset('assets/Lottie/Animation - math.json');
      default:
        return Container(); // Return an empty container for unhandled cases
    }
  }
}
