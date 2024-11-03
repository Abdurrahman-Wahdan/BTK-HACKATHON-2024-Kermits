import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background animation with opacity
          Opacity(
            opacity: 0.6, // Adjust background opacity
            child: SizedBox.expand(
              child: Lottie.asset(
                'assets/Lottie/Animation - profile-design.json',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Centered avatar with shadow
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: MediaQuery.of(context).size.width * 0.5 - 55,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.25),
                    spreadRadius: 4,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/vectors/kermits.png'),
                backgroundColor: Colors.white,
              ),
            ),
          ),
          // Centered name above the rectangular box
          Positioned(
            top: MediaQuery.of(context).size.height * 0.23,
            left: 0,
            right: 0,
            child: Text(
              'Kermits',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins', // Use the Poppins font
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          // Rectangular box with 3 sections under avatar
          Positioned(
            top: MediaQuery.of(context).size.height * 0.28, // Adjusted position
            left: MediaQuery.of(context).size.width * 0.07,
            right: MediaQuery.of(context).size.width * 0.07,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Points Section
                  Column(
                    children: [
                      Text(
                        'Points',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w100,
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '1200',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  // Divider line
                  Container(
                    height: 40, // Adjust height as needed
                    width: 1, // Adjust width for thickness
                    color: Colors.grey,
                  ),
                  // Followers Section
                  Column(
                    children: [
                      Text(
                        'Followers',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w100,
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '500',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  // Divider line
                  Container(
                    height: 40, // Adjust height as needed
                    width: 1, // Adjust width for thickness
                    color: Colors.grey,
                  ),
                  // Following Section
                  Column(
                    children: [
                      Text(
                        'Following',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w100,
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '180',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Smaller rectangular boxes above the big box
          Positioned(
            top: MediaQuery.of(context).size.height *
                0.45, // Adjusted position for smaller boxes
            left: MediaQuery.of(context).size.width * 0.07,
            right: MediaQuery.of(context).size.width * 0.07,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // First smaller box
                    Container(
                      width: MediaQuery.of(context).size.width *
                          0.4, // Adjust width as needed
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Courses Taken',
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w100,
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '20',
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Spacer for height adjustment
                    SizedBox(width: 10), // Add space between the boxes
                    // Second smaller box
                    Container(
                      width: MediaQuery.of(context).size.width *
                          0.4, // Adjust width as needed
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Topics Searched',
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w100,
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '134',
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Taller rectangular box with topics below the smaller boxes
          Positioned(
            top: MediaQuery.of(context).size.height *
                0.58, // Adjusted position for larger box
            left: MediaQuery.of(context).size.width * 0.07,
            right: MediaQuery.of(context).size.width * 0.07,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Contact Us Section
                  _buildTopicRow(
                      'Contact Us', 'assets/Icons/question-and-answer.png'),
                  _buildSeparator(),
                  // Help and Information Section
                  _buildTopicRow(
                      'Help and Information', 'assets/Icons/info.png'),
                  _buildSeparator(),
                  // Offline Download Section
                  _buildTopicRow(
                      'Offline Download', 'assets/Icons/download-offline.png'),
                  _buildSeparator(),
                  // Ability Level Test Section
                  _buildTopicRow('Ability Level Test', 'assets/Icons/exam.png'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to build topic rows with icons
  Widget _buildTopicRow(String title, String iconPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            width: 24, // Adjust icon size
            height: 24,
          ),
          SizedBox(width: 10), // Space between icon and text
          Text(
            title,
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // Function to build separator
  Widget _buildSeparator() {
    return Divider(
      height: 4,
      color: Colors.grey,
      thickness: 0.2,
    );
  }
}
