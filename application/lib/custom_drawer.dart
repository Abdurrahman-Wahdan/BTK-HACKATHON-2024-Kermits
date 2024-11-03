import 'package:flutter/material.dart';
import 'dart:async'; // Import the async library for StreamController

class CustomDrawer extends StatefulWidget {
  final VoidCallback onClose; // Callback to close the drawer
  final String? firstMessageText; // Accept the first message text

  const CustomDrawer({Key? key, required this.onClose, this.firstMessageText})
      : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final StreamController<String> _textStreamController =
      StreamController<String>();
  String fullText = "New Chat"; // The text to display
  final List<String> _messages = []; // List to hold messages

  @override
  void initState() {
    super.initState();
    _startTextAnimation(); // Start the text animation when the widget is initialized
  }

  void _startTextAnimation() async {
    String currentText = "";

    // Use the first message text if it is provided
    String textToAnimate = widget.firstMessageText ?? fullText;

    for (int i = 0; i < textToAnimate.length; i++) {
      currentText += textToAnimate[i];
      _textStreamController.add(currentText);
      await Future.delayed(
          Duration(milliseconds: 100)); // Delay for typing effect
    }
  }

  @override
  void dispose() {
    _textStreamController
        .close(); // Close the stream when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color drawerColor = Colors.white; // Drawer body color

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          color: drawerColor, // Blue tint with transparency
        ),
        child: Column(
          children: [
            AppBar(
              backgroundColor:
                  drawerColor, // Match AppBar color with drawer body
              automaticallyImplyLeading: false, // Hide the default back button
              actions: [
                // New button to clear messages (left)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0), // Add horizontal padding
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _messages.clear(); // Clear messages for a new chat
                      });
                    },
                    child: Image.asset(
                      'assets/Icons/post.png', // Your new icon
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
                Spacer(), // Take up remaining space between the buttons
                // Close button (right)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0), // Add horizontal padding
                  child: IconButton(
                    icon: SizedBox(
                      child: Image.asset(
                        'assets/Icons/right.png',
                        height: 24.0, // Set the height of the icon
                        width: 24.0,
                      ),
                    ),
                    onPressed: widget.onClose, // Close the drawer when pressed
                  ),
                ),
              ],
            ),
            SizedBox(height: 15), // Space to push the box down

            // Add a rectangular transparent box
            Container(
              width: 300, // Set a specific width for the box
              margin:
                  EdgeInsets.symmetric(horizontal: 16.0), // Margin for spacing
              padding:
                  EdgeInsets.all(12.0), // Reduced padding for a thinner box
              decoration: BoxDecoration(
                color:
                    Colors.grey.withOpacity(0.3), // Grey tint with transparency
                borderRadius: BorderRadius.circular(8.0), // Rounded corners
              ),
              child: StreamBuilder<String>(
                stream: _textStreamController.stream, // Listen to the stream
                builder: (context, snapshot) {
                  return Text(
                    snapshot.hasData
                        ? snapshot.data!
                        : '', // Display the streaming text
                    style: TextStyle(
                      fontSize: 16.0, // Reduced font size
                      fontWeight: FontWeight.bold, // Font weight
                      color: Colors.black, // Text color
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
