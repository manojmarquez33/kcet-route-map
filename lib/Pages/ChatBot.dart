import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../AppConstants.dart';

final LinearGradient appColor = AppConstants.BlueWhite;
final String BASH_URL = AppConstants.BASH_URL;
final String ChatBotAPI = AppConstants.ChatBot_API;
final Color LightWhite = AppConstants.lightwhite;

class ChatBot extends StatefulWidget {
  final String? promptText; // Accept optional initial prompt

  ChatBot({this.promptText});

  @override
  _ChatBotState createState() => _ChatBotState();
}
class _ChatBotState extends State<ChatBot> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  List<String> destinations = [];
  List<String> _imagesToShow = [];

  @override
  void initState() {
    super.initState();
    if (widget.promptText != null) {
      _controller.text = widget.promptText!;
      if (_controller.text.isNotEmpty) {
        _fetchDestinations().then((_) {
          _sendMessage(widget.promptText!); // Send the message after fetching destinations
        });
      }
    } else {
      _fetchDestinations();
    }
  }


  Future<void> _fetchDestinations() async {
    try {
      final response = await http.get(
        Uri.parse('$BASH_URL/getDestinations.php'),
        headers: {'X-SSL-CERTIFICATE': 'skip'},
      );

      // Log the full response for debugging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        if (decodedResponse is List<dynamic>) {
          setState(() {
            destinations = decodedResponse
                .map((item) => item.toString().toLowerCase())
                .toList();
          });
        }
      } else {
        throw Exception('Failed to load destinations: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching destinations: $e');
    }
  }

  Future<void> _fetchDetails(String destination) async {
    try {
      final response = await http.get(
        Uri.parse('$BASH_URL/$ChatBotAPI/?destination=$destination'),
        headers: {'X-SSL-CERTIFICATE': 'skip'},
      );

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        print('Fetched response for $destination: ${response.body}');

        if (decodedResponse is List<dynamic> && decodedResponse.isNotEmpty) {
          var detail = decodedResponse.first;

          // Parse image filenames safely
          List<String> imageFilenames;
          if (detail['image_filename'] is String) {
            imageFilenames = detail['image_filename'].split(',');
          } else if (detail['image_filename'] is List) {
            imageFilenames = List<String>.from(detail['image_filename']);
          } else {
            imageFilenames = [];
          }

          // Remove empty or 'null' values
          imageFilenames.removeWhere((filename) => filename.trim().isEmpty || filename.trim().toLowerCase() == 'null');

          if (detail['description'] != null) {
            // Convert the description to bullet points
            final description = detail['description']
                .toString()
                .split('.')
                .where((sentence) => sentence.trim().isNotEmpty)
                .map((sentence) => '• ${sentence.trim()}')
                .join('\n');

            setState(() {
              _messages.add({
                'type': 'response',
                'content': {
                  'text': 'This is the way to the $destination:\n$description',
                  'images': imageFilenames.map((filename) => '$BASH_URL/images/$filename').toList(),
                }
              });
              _imagesToShow = imageFilenames.map((filename) => '$BASH_URL/images/$filename').toList();
            });
            return; // Exit if valid data is found
          }
        }
      }

      _addErrorMessage(destination);
    } catch (e) {
      print('Error fetching details: $e');
      _addErrorMessage(destination);
    }
  }





  void _addErrorMessage(String destination) {
    final suggestionText = destinations.isNotEmpty
        ? 'Available destinations are:\n' +
        destinations.asMap().entries.map((entry) {
          int index = entry.key + 1; // To start numbering from 1
          String destination = entry.value;
          return '$index. $destination';
        }).join('\n')
        : 'No destinations available at the moment.';

    setState(() {
      _messages.add({
        'type': 'response',
        'content': {
          'text': 'Currently, path is not available to $destination.',
          'images': [] // Placeholder image for not found
        }
      });
      if (destinations.isNotEmpty) {
        _messages.add({
          'type': 'response',
          'content': {
            'text': suggestionText,
            'images': [] // No images for the suggestion message
          }
        });
      }
    });
  }

  void _sendMessage([String? text]) {
    final messageText = text ?? _controller.text.trim();
    if (messageText.isNotEmpty) {
      setState(() {
        _messages.add({'type': 'sent', 'content': messageText});
      });
      if (!_handleWelcomeAndFarewell(messageText)) {
        _extractAndFetchDetails(messageText);
      }
      _controller.clear();
    }
  }

  bool _handleWelcomeAndFarewell(String messageText) {
    final lowerMessage = messageText.toLowerCase();

    // Handle greeting messages
    const greetings = ['hi', 'hello', 'hey', 'good morning', 'good afternoon', 'good evening', 'how are you'];
    if (greetings.any((greeting) => lowerMessage.contains(greeting))) {
      setState(() {
        _messages.add({
          'type': 'response',
          'content': {
            'text': 'Hello! How can I assist you today?',
            'images': []
          }
        });
      });
      return true; // Stop further processing
    }

    // Handle farewell messages
    const farewells = ['bye', 'goodbye', 'see you', 'thanks', 'thank you'];
    if (farewells.any((farewell) => lowerMessage.contains(farewell))) {
      setState(() {
        _messages.add({
          'type': 'response',
          'content': {
            'text': 'It was my pleasure! 😊 Have an amazing day ahead! If you enjoyed our chat, feel free to rate me on the Google Play Store. 🌟',
            'images': []
          }
        });
      });
      return true; // Stop further processing
    }


    return false; // No greeting or farewell found
  }

  void _extractAndFetchDetails(String messageText) {
    // Make sure we handle both lowercase and exact matches
    String destination = destinations.firstWhere(
          (destination) => messageText.toLowerCase().contains(destination.toLowerCase()),
      orElse: () => '',
    );

    if (destination.isNotEmpty) {
      _fetchDetails(destination);
    } else {
      _addErrorMessage('destination');
    }
  }


  void _showImageGallery(List<String> imageUrls, int initialIndex) {
    final photoController = PhotoViewController();
    final ValueNotifier<double> zoomLevelNotifier = ValueNotifier(1.0); // Tracks the zoom level

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Map View'),
          ),
          body: Stack(
            children: [
              PhotoViewGallery.builder(
                itemCount: imageUrls.length,
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(imageUrls[index]),
                    controller: photoController,
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 3, // Max zoom level
                    initialScale: PhotoViewComputedScale.contained,
                  );
                },
                scrollPhysics: const BouncingScrollPhysics(),
                pageController: PageController(initialPage: initialIndex),
                backgroundDecoration: const BoxDecoration(
                  color: Colors.black,
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                child: Column(
                  children: [
                    ValueListenableBuilder<double>(
                      valueListenable: zoomLevelNotifier,
                      builder: (context, zoomLevel, child) {
                        return Text(
                          'Zoom: ${(zoomLevel * 100).toInt()}%', // Display zoom percentage
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        );
                      },
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.zoom_out, color: Colors.white),
                          onPressed: () {
                            photoController.scale = (photoController.scale ?? 1.0) - 0.1;
                            zoomLevelNotifier.value = photoController.scale ?? 1.0;
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.zoom_in, color: Colors.white),
                          onPressed: () {
                            photoController.scale = (photoController.scale ?? 1.0) + 0.1;
                            zoomLevelNotifier.value = photoController.scale ?? 1.0;
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.fullscreen, color: Colors.white),
                          onPressed: () {
                            photoController.scale = (PhotoViewComputedScale.covered * 2) as double?;
                            zoomLevelNotifier.value = (PhotoViewComputedScale.covered * 2) as double;
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
                          onPressed: () {
                            photoController.scale = PhotoViewComputedScale.contained as double?;
                            zoomLevelNotifier.value = PhotoViewComputedScale.contained as double;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  final images = (message['content']['images'] as List<dynamic>)
                      .map((e) => e.toString())
                      .toList();

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
                      ...images.map((url) =>
                          GestureDetector(
                            onTap: () {
                              _showImageGallery(images, images.indexOf(url));
                            },
                            child: Container(
                              margin: EdgeInsets.all(8.0),
                              child: Image.network(
                                url,
                                errorBuilder: (context, error, stackTrace) {
                                  print('Error loading image: $error');
                                  return Text('Image load error');
                                },
                              ),
                            ),
                          )).toList(),
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
                    onSubmitted: _sendMessage,
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
