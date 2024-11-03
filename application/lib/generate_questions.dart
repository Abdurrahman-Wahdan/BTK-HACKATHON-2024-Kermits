import 'dart:convert';
import 'package:btk/custom_drawer.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:btk/second_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class GenerateQuestions extends StatefulWidget {
  @override
  _GenerateQuestionsState createState() => _GenerateQuestionsState();
}

class _GenerateQuestionsState extends State<GenerateQuestions> {
  String? firstMessageText; // Variable to store the first message's text
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<types.Message> _messages = [];
  final _user = const types.User(id: 'user-id', firstName: 'You');
  final _bot = const types.User(id: 'bot-id', firstName: 'Bot');
  bool _hasText = false;
  bool _isLoading = false; // Add loading state
  final TextEditingController _controller = TextEditingController();
  types.Message? _replyMessage;

  // Handle sending messages
  void _handleSendPressed(types.PartialText message) {
    // Check if a PDF file has been uploaded
    if (firstMessageText == null) {
      // Show a dialog to inform the user to upload a file
      _showUploadFileDialog();
      return; // Stop further processing
    }

    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: 'message-id-${_messages.length}',
      text: message.text,
      metadata: _replyMessage != null ? {'replyTo': _replyMessage?.id} : null,
    );

    setState(() {
      _messages.insert(0, textMessage); // Add user's message immediately
      _replyMessage = null; // Clear reply after sending
      _controller.clear(); // Clear the input field
      _hasText = false; // Reset the text state
    });

    String replyMessageId =
        _replyMessage != null && _replyMessage is types.TextMessage
            ? (_replyMessage as types.TextMessage)
                .text // Get the ID of the reply message
            : '';

    String userPrompt = message.text; // The user's prompt

    // Send the user's prompt and reply message ID to the API
    _sendToApi(userPrompt, replyMessageId).then((response) {
      // Assuming the response contains 'question' and 'answer'
      final String question = response['question'] ?? 'No question available';
      final String answer = response['answer'] ?? 'No answer available';

      // Add question message
      final questionMessage = types.TextMessage(
        author: _bot,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: 'question-message-id-${_messages.length}',
        text: question,
      );

      setState(() {
        _messages.insert(0, questionMessage); // Add the question to the chat
      });
    }).catchError((error) {
      // Handle any errors from the API call
      print('Error while sending message: $error');
      // Optionally show an error message to the user
    });
  }

// Function to send the user's prompt to the backend
  Future<Map<String, dynamic>> _sendToApi(
      String userPrompt, String replyMessageId) async {
    // Replace with your API endpoint
    final url = 'http://172.20.10.2:8080/get_question';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'prompt': userPrompt,
        'reply': replyMessageId,
        // Include any other parameters needed for your API
      }),
    );

    if (response.statusCode == 200) {
      // Parse the response body and return it as a Map
      return json.decode(response.body);
    } else {
      throw Exception('Failed to send message');
    }
  }

  // Method to show an error dialog with an image
  void _showUploadFileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding:
              EdgeInsets.all(20), // Optional: Adds padding around the content
          content: Column(
            mainAxisSize:
                MainAxisSize.min, // Ensure the dialog is sized based on content
            children: [
              Image.asset('assets/vectors/warn.png',
                  height: 60), // Set height as needed
              SizedBox(height: 16), // Adds space between image and text
              Text(
                'Please upload a valid PDF file.',
                textAlign: TextAlign.center, // Center align the text
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _isLoading = true; // Set loading state to true
      });

      File file = File(result.files.single.path!);
      print('Selected PDF: ${file.path}');

      try {
        // Change localhost to the appropriate address
        String url =
            'http://172.20.10.2:8080/get_question_document'; // For Android Emulator
        // String url = 'http://<your-local-ip>:8080/get_questions'; // For Physical Devices
        var request = http.MultipartRequest('POST', Uri.parse(url));

        // Add the file to the request
        request.files.add(await http.MultipartFile.fromPath(
          'pdf', // the field name expected by the server
          file.path,
        ));

        // Send the request
        var response = await request.send();

        // Check the response status
        if (response.statusCode == 200) {
          setState(() {
            _isLoading = false; // Set loading state to false
            firstMessageText = 'File uploaded successfully';
          });
        } else {
          setState(() {
            _isLoading = false;
            firstMessageText = 'File upload failed';
          });
          print('Failed to upload file. Status code: ${response.statusCode}');
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
          firstMessageText = 'An error occurred while uploading';
        });
        print('Error uploading file: $e');
      }
    } else {
      // Show a pop-up if no file is selected or if it's an unsupported type
      _showUploadErrorDialog();
    }
  }

  // Method to show an error dialog
  void _showUploadErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Please upload a valid PDF file.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Method to navigate back to the SignUpScreen with a sliding animation
  void _goToSignUpScreen() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SignUpScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Define the slide transition
          const begin = Offset(-1.0, 0.0); // Start from the right
          const end = Offset.zero; // End at the original position
          const curve = Curves.easeInOut;

          // Apply the animation
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          // Return the animated widget
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  Widget _buildReplyPreview() {
    // Check if _replyMessage exists and is a TextMessage
    if (_replyMessage == null || _replyMessage is! types.TextMessage)
      return SizedBox.shrink();

    return AnimatedSlide(
      offset: Offset(0, _replyMessage != null ? 0 : 1), // Slide up if replying
      duration: Duration(milliseconds: 300),
      child: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                'Replying to: ${(_replyMessage as types.TextMessage).text}',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    fontFamily: "Poppins"),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _replyMessage = null; // Clear reply on close
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Chat',
          style: TextStyle(fontFamily: "Poppins", fontSize: 30),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_sharp),
          onPressed: _goToSignUpScreen,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                _messages.clear(); // Clear messages for a new chat
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/Icons/post.png',
                width: 30,
                height: 30,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _scaffoldKey.currentState
                  ?.openEndDrawer(); // Opens the end drawer
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image.asset(
                'assets/Icons/right.png',
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
      ),
      endDrawer: CustomDrawer(
        onClose: () {
          _scaffoldKey.currentState?.closeEndDrawer(); // Close the drawer
        },
        firstMessageText: firstMessageText, // Pass the first message text
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessageWithProfilePic(_messages[index]);
                  },
                ),
              ),
              _buildInput(),
            ],
          ),
          if (_isLoading)
            Center(
              child: Lottie.asset(
                'assets/Lottie/Animation - 1729942099296.json',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageWithProfilePic(types.Message message) {
    final isUser = message.author.id == _user.id;
    final imageUrl =
        isUser ? 'assets/vectors/kermits.png' : 'assets/bot_profile.png';

    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          _replyMessage = message; // Set the message to reply to
        });
      },
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isUser)
              CircleAvatar(
                backgroundImage: AssetImage(imageUrl),
                radius: 20,
              ),
            Flexible(
              child: Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (message.metadata != null &&
                      message.metadata!['replyTo'] != null)
                    _buildReplyIndicator(
                        message.metadata!['replyTo'] as String),
                  Container(
                    margin: EdgeInsets.only(
                      left: isUser ? 0 : 8.0,
                      right: isUser ? 8.0 : 0,
                      top: 4.0,
                      bottom: 4.0,
                    ),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: isUser
                          ? LinearGradient(
                              colors: [Colors.blue, Colors.white],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isUser ? null : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      (message as types.TextMessage).text,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Inter',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isUser)
              CircleAvatar(
                backgroundImage: AssetImage(imageUrl),
                radius: 20,
              ),
          ],
        ),
      ),
    );
  }

// Helper widget to display the message being replied to
  Widget _buildReplyIndicator(String replyToMessageId) {
    types.Message? replyMessage;
    try {
      replyMessage = _messages.firstWhere((msg) => msg.id == replyToMessageId);
    } catch (e) {
      replyMessage = null;
    }

    if (replyMessage == null) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      margin: EdgeInsets.only(bottom: 4.0, right: 8.0),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        (replyMessage as types.TextMessage).text,
        style: TextStyle(color: Colors.blueGrey, fontSize: 12),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  // Custom input widget with a hovering effect
  Widget _buildInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
      child: Column(
        children: [
          _buildReplyPreview(),

          // Reply Preview Container
          if (_replyMessage != null)
            Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(bottom: 0.0),
              decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),

          // Message Input Row
          Row(
            children: [
              if (!_hasText)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: _pickPdf,
                    child: Image.asset(
                      'assets/Icons/paperclip.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),

              // Text Input Container
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _controller,
                    onChanged: (value) {
                      setState(() {
                        _hasText = value.isNotEmpty;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Type Here',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
              ),

              // Send Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () {
                    if (_controller.text.isNotEmpty) {
                      _handleSendPressed(
                          types.PartialText(text: _controller.text));
                    }
                  },
                  child: Image.asset(
                    'assets/Icons/send.png',
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
