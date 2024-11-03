import 'package:flutter/material.dart'; // Import Flutter material package
import 'dart:async'; // Import async for Stream and StreamController
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package

class TopicPage extends StatefulWidget {
  final String topic; // Change from text to topic

  const TopicPage({
    required this.topic,
  });

  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  late Stream<String> _textStream; // For the topic title animation
  late StreamController<String>
      _textStreamController; // For the topic title animation
  late Stream<String> _detailTextStream; // For the detail text animation
  late StreamController<String>
      _detailTextStreamController; // For the detail text animation

  // Mapping of topics to their detail texts
  final Map<String, String> _topicDetails = {
    'Mathematics':
        'Mathematics is a crucial subject that focuses on numbers, quantities, shapes, and patterns. Students learn essential concepts like arithmetic, algebra, geometry, and statistics, which develop their problem-solving and critical-thinking skills. Mathematics not only aids in everyday calculations but also enhances logical reasoning. By engaging in real-world applications, students prepare for advanced studies in science, technology, engineering, and mathematics (STEM), fostering creativity and innovation in their approach to challenges.',
    'Turkish':
        'Studying the Turkish language and literature is essential for effective communication and cultural understanding. Students learn grammar, vocabulary, and pronunciation while analyzing literary works, which fosters critical thinking. Through writing assignments, they express their thoughts creatively, enhancing language proficiency. This knowledge prepares students for both academic success and personal interactions, connecting them with their cultural heritage and improving their communication skills.',
    'History':
        'History is the exploration of past events and societies that shape our understanding of the world. Students study significant periods, influential figures, and transformative events, developing critical thinking through analysis of historical sources. This subject fosters a sense of identity and belonging while highlighting lessons from the past that inform present-day decisions. By discussing topics like democracy and civil rights, students become informed and engaged citizens.',
    'Biology':
        'Biology is the science of life that examines living organisms and their interactions with the environment. Students explore various branches like botany, zoology, and ecology through hands-on experiments and lab work. Topics such as cell structure and ecosystems help develop scientific literacy and critical thinking. Studying biology raises awareness of essential issues like conservation and health, encouraging responsible decision-making regarding environmental and societal impacts.',
    'Physics':
        'Physics studies matter, energy, and the fundamental forces of nature. Students explore concepts like motion, force, and electricity through experiments and problem-solving activities. Applying mathematical principles to real-world situations cultivates analytical and logical thinking, preparing students for careers in engineering and technology. Understanding physics helps students grasp the workings of the universe and enhances their problem-solving skills.',
    'Chemistry':
        'Chemistry is the study of matter, its properties, composition, and the changes it undergoes during chemical reactions. In chemistry classes, students learn about elements, compounds, and the principles governing chemical interactions. Through hands-on experiments and laboratory work, they observe reactions and analyze the results, developing critical scientific skills. Key topics include the periodic table, chemical bonding, stoichiometry, acids and bases, and organic chemistry. Understanding these concepts helps students grasp the role of chemistry in everyday life, from cooking to medicine. Chemistry education fosters analytical thinking and problem-solving abilities, preparing students for advanced studies in health sciences, environmental science, and engineering. By exploring the molecular world, students gain insights into how chemical processes impact the environment and society.',

    // Add more topics and their details here
  };

  @override
  void initState() {
    super.initState();
    _textStreamController = StreamController<String>();
    _textStream = _textStreamController.stream;
    _detailTextStreamController = StreamController<String>();
    _detailTextStream = _detailTextStreamController.stream;

    _startTextAnimation();
    _startDetailTextAnimation(); // Start detail text animation
  }

  void _startTextAnimation() async {
    String fullText = widget.topic; // Use the topic name
    String currentText = "";

    for (int i = 0; i < fullText.length; i++) {
      currentText += fullText[i];
      _textStreamController.add(currentText);
      await Future.delayed(Duration(milliseconds: 50));
    }
  }

  void _startDetailTextAnimation() async {
    String detailText = _topicDetails[widget.topic] ??
        "No details available."; // Get details based on the topic
    String currentText = "";

    for (int i = 0; i < detailText.length; i++) {
      currentText += detailText[i];
      _detailTextStreamController.add(currentText);
      await Future.delayed(Duration(milliseconds: 50));
    }
  }

  @override
  void dispose() {
    _textStreamController.close();
    _detailTextStreamController.close(); // Close the detail text stream
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    return true; // Return true to allow back navigation
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Customize back button action
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Topic",
            style: TextStyle(fontFamily: "Poppins", fontSize: 30.0),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_sharp),
            onPressed: () {
              Navigator.of(context).pop(); // Pop the current page off the stack
            },
          ),
        ),
        body: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align text to the start
          children: [
            SizedBox(height: 10), // Space below the AppBar

            // TopicPage widget directly under the SizedBox
            Container(
              height: 250, // Set the height to 250 pixels
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
                          image: AssetImage(
                              "assets/Backgrounds/second_screen.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Opacity(
                        opacity: 0.85, // Adjust opacity here
                        child: Container(
                          color: Colors.white, // Set color overlay to white
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
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Expanded widget to take the remaining space
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: SingleChildScrollView(
                  // Allow scrolling if the text is long
                  child: StreamBuilder<String>(
                    stream: _detailTextStream,
                    initialData: "",
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data ?? "",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign:
                            TextAlign.start, // Align the text to the start
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
