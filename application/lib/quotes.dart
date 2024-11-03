import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:btk/home_page.dart';

class CustomTopicBox extends StatelessWidget {
  final String text;
  final Color color; // Add a color parameter
  final bool hasImage; // Add a parameter for images

  const CustomTopicBox({
    required this.text,
    this.color = Colors.white, // Default to white
    this.hasImage = false, // Default to false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0), // Adjusted margin for better fit
      decoration: BoxDecoration(
        color: color, // Use the passed color
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
        // Center the container
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center items horizontally
            children: [
              // If hasImage is true, show the PNG image
              if (text == "Biology" && hasImage)
                Image.asset(
                  'assets/images/biology.png', // Replace with your image path
                  height: 100, // Adjust height as needed
                  width: 100, // Adjust width as needed
                ),
              if (text == "History" && hasImage)
                Image.asset(
                  'assets/images/history.png', // Replace with your image path
                  height: 100, // Adjust height as needed
                  width: 100, // Adjust width as needed
                ),
              if (text == "Physics" && hasImage)
                Image.asset(
                  'assets/images/physics.png', // Replace with your image path
                  height: 100, // Adjust height as needed
                  width: 100, // Adjust width as needed
                ),
              if (text == "Chemistry" && hasImage)
                Image.asset(
                  'assets/images/chemistry.png', // Replace with your image path
                  height: 100, // Adjust height as needed
                  width: 100, // Adjust width as needed
                ),
              if (text == "Turkish" && hasImage)
                Image.asset(
                  'assets/images/turkish.png', // Replace with your image path
                  height: 100, // Adjust height as needed
                  width: 100, // Adjust width as needed
                ),
              if (text == "english" && hasImage)
                Image.asset(
                  'assets/images/ataturk.png', // Replace with your image path
                  height: 100, // Adjust height as needed
                  width: 100, // Adjust width as needed
                ),
              SizedBox(height: 10),
              Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center, // Center the text
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTopicPage extends StatefulWidget {
  @override
  _CustomTopicPageState createState() => _CustomTopicPageState();
}

class _CustomTopicPageState extends State<CustomTopicPage> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPageIndex = 0;

  final List<String> texts = [
    "Atatürk",
    "Steve Jobs",
    "Mahatma Gandhi",
    "Eleanor Roosevelt",
    "Albert Einstein",
    "Buddha",
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPageIndex < texts.length - 1) {
        _currentPageIndex++;
      } else {
        _currentPageIndex = 0;
      }
      _pageController.animateToPage(
        _currentPageIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Topics',
          style: TextStyle(fontFamily: "Poppins", fontSize: 30),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_sharp),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous page
          },
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two boxes per row
          childAspectRatio:
              0.75, // Adjust this ratio to fit your needs (width / height)
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        padding: EdgeInsets.all(16.0),
        itemCount: texts.length,
        itemBuilder: (context, index) {
          return CustomTopicBox(text: texts[index], hasImage: true);
        },
      ),
    );
  }
}
