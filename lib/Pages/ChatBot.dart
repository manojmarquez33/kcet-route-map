import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../AppConstants.dart';


final LinearGradient appColor = AppConstants.BlueWhite;
final String BASH_URL = AppConstants.BASH_URL;
final String ChatBotAPI = AppConstants.ChatBot_API;
final Color LightWhite = AppConstants.lightwhite;

class ChatBot extends StatefulWidget {
  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  Future<void> _fetchImages(String destination) async {
    try {
      final response = await http.get(
        Uri.parse('$BASH_URL/$ChatBotAPI/?destination=$destination'),
        headers: {'X-SSL-CERTIFICATE': 'skip'},
      );

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);

        if (decodedResponse is List<dynamic>) {
          List<String> imageUrls = decodedResponse.map((item) => item.toString()).toList();

          setState(() {
            if (imageUrls.isNotEmpty) {
              _messages.add({
                'type': 'response',
                'content': {
                  'text': 'This is the way to the $destination:',
                  'images': imageUrls.map((filename) => '$BASH_URL/images/$filename').toList()
                }
              });
            } else {
              _messages.add({
                'type': 'response',
                'content': {
                  'text': 'Currently, path is not available to $destination.',
                  'images': ['$BASH_URL/images/not-found.png'] // Placeholder image for not found
                }
              });
            }
          });
        } else {
          setState(() {
            _messages.add({
              'type': 'response',
              'content': {
                'text': 'Currently, path is not available to $destination.',
                'images': ['$BASH_URL/images/not-found.png'] // Placeholder image for not found
              }
            });
          });
        }
      } else {
        throw Exception('Failed to load images: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching images: $e'); // Print any error that occurs during fetch
      setState(() {
        _messages.add({
          'type': 'response',
          'content': {
            'text': 'Currently, path is not available to $destination.',
            'images': ['$BASH_URL/images/not-found.png'] // Placeholder image for not found
          }
        });
      });
    }
  }

  void _sendMessage() {
    final text = _controller.text;
    if (text.isNotEmpty) {
      setState(() {
        _messages.add({'type': 'sent', 'content': text});
      });
      _fetchImages(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('ChatBot',),
      //   backgroundColor: Colors.white,
      // ),
      drawer: Drawer(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                if (message['type'] == 'sent') {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        message['content'],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          message['content']['text'],
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                      ...((message['content']['images'] as List<String>)
                          .map((url) => Container(
                        margin: EdgeInsets.all(8.0),
                        child: Image.network(
                          url,
                          errorBuilder: (context, error, stackTrace) {
                            print('Error loading image: $error');
                            return Text('Image load error');
                          },
                        ),
                      ))
                          .toList()),
                    ],
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter destination...',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
