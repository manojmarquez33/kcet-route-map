import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kcet_route_map/Components/AppDrawer.dart';

import '../AppConstants.dart';
import '../Pages/ChatBot.dart';
import '../Pages/MapScreen.dart';

final LinearGradient appColor = AppConstants.BlueWhite;
final String BASH_URL = AppConstants.BASH_URL;
final String Class_API = AppConstants.Class_API;
final Color LightWhite = AppConstants.lightwhite;

class Workshop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Workshop',
      home: WorkshopList(),
    );
  }
}

class WorkshopList extends StatefulWidget {
  @override
  _WorkshopListState createState() => _WorkshopListState();
}

class _WorkshopListState extends State<WorkshopList> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home'),
    Text('Cabin'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List data = [];
  List filteredData = [];

  Future<String> getData() async {
    try {
      print('API URL: $BASH_URL/$Class_API');
      var response = await http.get(Uri.parse('$BASH_URL/$Class_API'));

      if (response.statusCode == 200) {
        setState(() {
          data = json.decode(response.body);
          // Filter data where type is "Workshop"
          filteredData =
              data.where((item) => item['type'] == 'Workshop').toList() ?? [];
        });
        return "Success!";
      } else {
        throw Exception(
            'Failed to load data from API. Status code: ${response.statusCode}');
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
      appBar: AppBar(
        title: Text(
          "Workshop",
          style: TextStyle(color: Color(0xFF0d0d0d)),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0.0,
        iconTheme:
        IconThemeData(color: Colors.black), // Set the icon color here
      ),
      backgroundColor: AppConstants.lightwhite,
      drawer:AppDrawer(),
      body: Column(
        children: <Widget>[
          _buildSearchBar(),
          _buildList(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            label: 'Map',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppConstants.Orange,
        unselectedItemColor: Colors.grey,
        backgroundColor: Color(0xFFffffff),
        onTap: _onItemTapped,
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
            (item['place']?.toLowerCase() ?? '')
                .contains(text.toLowerCase()) ||
                (item['block']?.toLowerCase() ?? '')
                    .contains(text.toLowerCase()) ||
                (item['floor']?.toLowerCase() ?? '')
                    .contains(text.toLowerCase()) ||
                (item['landmark']?.toLowerCase() ?? '')
                    .contains(text.toLowerCase()))
                .toList();
          });
        },
        decoration: InputDecoration(
          hintText: 'Search your Workshop',
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
              valueColor:
              AlwaysStoppedAnimation<Color>(AppConstants.Orange),
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
          // Use only "Workshop.png" image
          String imagePath = 'assets/images/workshop.png';

          return Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 1.0, horizontal: 5.0),
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
                  filteredData[index]['place'] ?? '',
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
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
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
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      '${filteredData[index]['landmark'] ?? ''}',
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                trailing: GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => MapScreen(
                    //       //className: filteredData[index]['class'],
                    //     ),
                    //   ),
                    // );
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppConstants.Orange,
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
                       // color: Colors.grey,
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