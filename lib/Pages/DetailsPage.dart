import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../AppConstants.dart';

final LinearGradient appColor = AppConstants.BlueWhite;
final String BASH_URL = AppConstants.BASH_URL;
final String Class_API = AppConstants.Class_API;
final Color LightWhite = AppConstants.lightwhite;
final String ChatBotAPI = AppConstants.ChatBot_API;

class DetailedVenueScreen extends StatefulWidget {
  final String className;
  final String floor;
  final String block;
  final Map<String, dynamic> geoData;

  DetailedVenueScreen({
    required this.className,
    required this.floor,
    required this.block,
    required this.geoData,
  });

  @override
  _DetailedVenueScreenState createState() => _DetailedVenueScreenState();
}

class _DetailedVenueScreenState extends State<DetailedVenueScreen> {
  late Future<Map<String, dynamic>> _pathwayData;

  Future<Map<String, dynamic>> fetchPathwayData() async {
    final String apiUrl = '$BASH_URL/$ChatBotAPI/?destination=${widget.className}';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load pathway data');
    }
  }

  @override
  void initState() {
    super.initState();
    _pathwayData = fetchPathwayData();
  }

  @override
  Widget build(BuildContext context) {
    final String serverUrl = '$BASH_URL/images/'; // Replace with your actual server URL

    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _pathwayData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            final List<String> images = data['image_filename'].split(',');

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Place: ${widget.className}',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: AppConstants.Orange),
                          ),
                          Text(
                            'Floor: ${widget.floor}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Block: ${widget.block}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: AppConstants.Orange),
                          ),
                          Text(
                            data['description'] ?? 'No description available.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Pathway Images:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: AppConstants.Orange),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageViewerScreen(
                                  images: images,
                                  initialIndex: index,
                                  serverUrl: serverUrl,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Image.network(
                              '$serverUrl${images[index]}',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(Icons.error, color: Colors.red),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}

class ImageViewerScreen extends StatelessWidget {
  final List<String> images;
  final int initialIndex;
  final String serverUrl;

  ImageViewerScreen({
    required this.images,
    required this.initialIndex,
    required this.serverUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoViewGallery.builder(
        itemCount: images.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage('$serverUrl${images[index]}'),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        pageController: PageController(initialPage: initialIndex),
        scrollPhysics: BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          color: Colors.black,
        ),
      ),
    );
  }
}
