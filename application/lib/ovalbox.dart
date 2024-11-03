import 'package:flutter/material.dart'; // Import Flutter material package
import 'dart:async'; // Import async for Stream and StreamController

class OvalBox extends StatefulWidget {
  final Color color;
  final String text;
  final TextStyle textStyle;

  const OvalBox({
    required this.color,
    required this.text,
    required this.textStyle,
  });

  @override
  _OvalBoxState createState() => _OvalBoxState();
}

class _OvalBoxState extends State<OvalBox> {
  late Stream<String> _textStream;
  late StreamController<String> _textStreamController;

  @override
  void initState() {
    super.initState();
    _textStreamController = StreamController<String>();
    _textStream = _textStreamController.stream;
    _startTextAnimation();
  }

  void _startTextAnimation() async {
    String fullText = widget.text;
    String currentText = "";

    for (int i = 0; i < fullText.length; i++) {
      currentText += fullText[i];
      _textStreamController.add(currentText);
      await Future.delayed(Duration(milliseconds: 50));
    }
  }

  @override
  void dispose() {
    _textStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(0, 5), // Shadow position
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background image with opacity
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/Backgrounds/second_screen.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Opacity(
                opacity: 0.85, // Adjust opacity here
                child: Container(
                  color: widget.color, // Color overlay with opacity
                ),
              ),
            ),
          ),
          // Text overlay
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: StreamBuilder<String>(
                stream: _textStream,
                initialData: "",
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data ?? "",
                    style: widget.textStyle,
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
