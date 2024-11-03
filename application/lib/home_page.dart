import 'dart:math';
import 'package:btk/navbar.dart';
import 'package:btk/quotes.dart';
import 'package:btk/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:btk/topicbox.dart';
import 'package:btk/ovalbox.dart';
import 'package:btk/topicpage.dart'; // Import your TopicPage here
import 'package:lottie/lottie.dart'; // Import the Lottie package

final List<String> quotes = [
  "The only way to do great work is to love what you do.",
  "Success is not the key to happiness. Happiness is the key to success.",
  "Your time is limited, so don't waste it living someone else's life.",
  "Believe you can and you're halfway there.",
  "What you get by achieving your goals is not as important as what you become by achieving your goals."
];

final List<String> authors = [
  "Steve Jobs",
  "Albert Schweitzer",
  "Steve Jobs",
  "Theodore Roosevelt",
  "Zig Ziglar"
];

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double avatarRadius = 25.0;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, Kermits",
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
              SizedBox(height: 5),
              Text(
                "Start Learning",
                style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ],
          ),
        ),
        centerTitle: false,
        actions: [
          _buildAvatarButton(
              avatarRadius, Icons.search, () => print("Search button pressed")),
          _buildAvatar(),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          _buildSectionTitle(context, "Motivation", "See All", () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CustomTopicPage()));
          }),
          _buildMotivationQuotes(),
          SizedBox(height: 20),
          _buildWideButton(context), // Add the wide button here
          SizedBox(height: 20), // Add some space below the button
          _buildSectionTitle(context, "Topics", "See All", () {
            print("See All Topics button pressed");
          }),
          _buildTopicGrid(context),
        ],
      ),
    );
  }

  Widget _buildWideButton(BuildContext context) {
    final controller =
        Get.find<NavigationController>(); // Get the NavigationController

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: ElevatedButton(
        onPressed: () {
          // Change the navbar index to 1 (which corresponds to SignUpScreen)
          controller.changeIndex(1);
        },
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.transparent; // Transparent when pressed
            }
            return Colors.blue; // Default color
          }),
          side: MaterialStateProperty.resolveWith<BorderSide>((states) {
            if (states.contains(MaterialState.pressed)) {
              return BorderSide(
                  color: Colors.blue, width: 2); // Blue border when pressed
            }
            return BorderSide.none; // No border in normal state
          }),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          padding:
              MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 18)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Lottie.asset(
              'assets/Lottie/Animation - ai.json', // Path to your Lottie file
              width: 50, // Width of the animation
              height: 50, // Height of the animation
              fit: BoxFit.contain,
            ),
            SizedBox(width: 10), // Space between the animation and text
            Text(
              "Get Started",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarButton(
      double radius, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.blue.withOpacity(0.15),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 2)),
          ],
        ),
        child: IconButton(
          icon: Icon(icon, color: Colors.black),
          onPressed: onPressed,
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.blue.withOpacity(0.15),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 2)),
          ],
        ),
        child: CircleAvatar(
          backgroundImage: AssetImage('assets/vectors/kermits.png'),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title,
      String buttonText, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black)),
          TextButton(
            onPressed: onPressed,
            child: Text(
              buttonText,
              style: GoogleFonts.poppins(
                  color: Colors.grey, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMotivationQuotes() {
    // Generate a random index
    final randomIndex = Random().nextInt(quotes.length);

    // Get a random quote and author
    final randomQuote = quotes[randomIndex];
    final randomAuthor = authors[randomIndex];

    return Container(
      height: 250,
      child: PageView(
        children: [
          OvalBox(
            color: Colors.white,
            text: "$randomQuote\n\n$randomAuthor",
            textStyle: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicGrid(BuildContext context) {
    return Flexible(
      flex: 1, // This gives the GridView a flexible size
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1,
        children: [
          _buildTopicBox(context, "Mathematics"),
          _buildTopicBox(context, "Turkish"),
          _buildTopicBox(context, "History"),
          _buildTopicBox(context, "Biology"),
          _buildTopicBox(context, "Physics"),
          _buildTopicBox(context, "Chemistry"),
        ],
      ),
    );
  }

  Widget _buildTopicBox(BuildContext context, String topic) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TopicPage(
                    topic: topic,
                  )),
        );
      },
      child: TopicBox(
        text: topic,
        color: Colors.white,
        hasAnimation: true,
      ),
    );
  }
}
