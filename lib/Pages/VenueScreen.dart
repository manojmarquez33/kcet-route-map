import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kcet_route_map/Pages/ChatBot.dart';
import 'package:kcet_route_map/Pages/ChatBot.dart';
import 'package:kcet_route_map/Pages/DetailsPage.dart';
import '../AppConstants.dart';
import 'ChatBot.dart';
import 'DetailsPage.dart';
// Import the detailed venue screen

final LinearGradient appColor = AppConstants.BlueWhite;
final String BASH_URL = AppConstants.BASH_URL;
final String Class_API = AppConstants.Class_API;
final Color LightWhite = AppConstants.lightwhite;

class VenueScreen extends StatefulWidget {
  @override
  _VenueScreenState createState() => _VenueScreenState();
}

class _VenueScreenState extends State<VenueScreen> {
  int _selectedIndex = 0;
  List data = [];
  List filteredData = [];

  Future<String> getData() async {
    try {
      print('API URL: $BASH_URL/$Class_API');
      var response = await http.get(Uri.parse('$BASH_URL/$Class_API'));

      if (response.statusCode == 200) {
        print('Response data: ${response.body}');
        setState(() {
          data = json.decode(response.body);
          filteredData = data ?? [];
        });
        return "Success!";
      } else {
        throw Exception('Failed to load data from API. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to connect to the API');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    filteredData = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _buildSearchBar(),
          _buildList(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (text) {
          setState(() {
            filteredData = data
                .where((item) =>
            (item['place']?.toLowerCase() ?? '').contains(text.toLowerCase()) ||
                (item['block']?.toLowerCase() ?? '').contains(text.toLowerCase()) ||
                (item['floor']?.toLowerCase() ?? '').contains(text.toLowerCase()) ||
                (item['landmark']?.toLowerCase() ?? '').contains(text.toLowerCase()) ||
                (item['position']?.toLowerCase() ?? '').contains(text.toLowerCase()))
                .toList();
          });
        },
        decoration: InputDecoration(
          hintText: 'Search your class',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    return Expanded(
      child: data.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppConstants.Orange),
            ),
            SizedBox(height: 10.0),
            Text(
              "Loading...",
              style: TextStyle(
                color: AppConstants.Orange,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      )
          : filteredData.isNotEmpty
          ? ListView.builder(
        itemCount: filteredData.length,
        itemBuilder: (BuildContext context, int index) {
          String className = filteredData[index]['place'];
          String type = filteredData[index]['type'] ?? '';

          String imagePath;
          switch (type) {
            case 'Class':
              imagePath = 'assets/images/classroom.png';
              break;
            case 'Lab':
              imagePath = 'assets/images/laboratory.png';
              break;
            case 'Conference Hall':
              imagePath = 'assets/images/conference_hall.png';
              break;
            case 'Auditorium':
              imagePath = 'assets/images/auditorium.png';
              break;
            case 'Workshop':
              imagePath = 'assets/images/workshop.png';
              break;
            case 'Canteen':
              imagePath = 'assets/images/canteen.png';
              break;
            case 'Cabin':
              imagePath = 'assets/images/cabin.png';
              break;
            case 'Restroom':
              imagePath = 'assets/images/toilet.png';
              break;
            case 'Office':
              imagePath = 'assets/images/office.png';
              break;
            case 'Others':
              imagePath = 'assets/images/others.png';
              break;
            case 'Library':
              imagePath = 'assets/images/library.png';
              break;
            default:
              imagePath = 'assets/images/notfound.png';
              break;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 5.0),
            child: Card(
              elevation: 3.0,
              color: AppConstants.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                leading: Image.asset(
                  imagePath,
                  width: 48.0,
                  height: 48.0,
                ),
                title: Text(
                  className ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: AppConstants.Orange,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${filteredData[index]['floor'] ?? ''}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          '${filteredData[index]['block'] ?? ''}',
                          style: TextStyle(
                            color: AppConstants.SpecialDark,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${filteredData[index]['landmark'] ?? ''}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${filteredData[index]['position'] ?? ''}',
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: GestureDetector(
                  onTap: () async {
                    String apiUrl = '$BASH_URL/${AppConstants.ChatBot_API}/?destination=$className';

                    print(apiUrl);
                    try {
                      var response = await http.get(Uri.parse(apiUrl));

                      if (response.statusCode == 200) {
                        Map<String, dynamic> geoData = json.decode(response.body);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailedVenueScreen(
                              className: className,
                              floor: filteredData[index]['floor'] ?? '',
                              block: filteredData[index]['block'] ?? '',
                              geoData: geoData,
                            ),
                          ),
                        );
                      } else {
                        print('Failed to load data from API. Status code: ${response.statusCode}');
                      }
                    } catch (e) {
                      print('Error: $e');
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange, // Replace with your `AppConstants.Orange`
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Generate the prompt
                        String placeName = filteredData[index]['place'];
                        String promptText = "Help me to reach $placeName";


                        // Navigate to ChatbotPage and pass the promptText
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatBot(promptText: promptText),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/notfound.png',
              width: 80.0,
              height: 80.0,
              color: Colors.grey,
            ),
            SizedBox(height: 10.0),
            Text(
              "No data found",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
