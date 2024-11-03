import 'dart:async';
import 'package:btk/ask_questions.dart';
import 'package:btk/generate_questions.dart';
import 'package:btk/home_page.dart';
import 'package:flutter/material.dart';
import 'package:btk/chat_page.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late PageController _pageController;
  int _currentPageIndex = 0;
  late Timer _timer;

  final List<String> texts = [
    'Track your work.\nGet results.',
    'Stay organized.\nAchieve more.',
    'Connect with others.\nCollaborate easily.',
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

  ButtonStyle _buttonStyle() {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return Colors.transparent; // Transparent when pressed
        }
        return Colors.white; // White when not pressed
      }),
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        return Colors.black; // Black icon color
      }),
      side: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return BorderSide(color: Colors.white); // White border when pressed
        }
        return BorderSide.none; // No border when not pressed
      }),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Backgrounds/second_screen.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment(2.8, -0.4),
            child: Image.asset(
              'assets/Backgrounds/man.png',
              fit: BoxFit.cover,
              opacity: AlwaysStoppedAnimation(0.5),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 150,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: texts.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPageIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Text(
                            texts[index],
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 50,
                              color: Color.fromARGB(255, 6, 0, 0),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(texts.length, (index) {
                        return DotIndicator(
                            isActive: index == _currentPageIndex);
                      }),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    width: 300,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GenerateQuestions()),
                        );
                      },
                      style: _buttonStyle(),
                      child: Text(
                        'Generate Questions',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AskQuestions()),
                        );
                      },
                      style: _buttonStyle(),
                      child: Text(
                        'Ask Questions',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChatPage()),
                        );
                      },
                      style: _buttonStyle(),
                      child: Text(
                        'Normal Chat',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 60),
                ],
              ),
            ],
          ),
          // Removed the home button
        ],
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  final bool isActive;

  const DotIndicator({Key? key, this.isActive = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey.shade400,
        shape: BoxShape.circle,
      ),
    );
  }
}
