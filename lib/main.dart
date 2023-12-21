import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'AppConstants.dart';
import 'MapScreen.dart';

void main() => runApp(MyApp());

// Constant declaration
final LinearGradient appColor = AppConstants.appColor;
final String BASH_URL = AppConstants.BASH_URL;
final String Class_API = AppConstants.Class_API;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Find your Class',
      home: ClassList(),
    );
  }
}

class ClassList extends StatefulWidget {
  @override
  _ClassListState createState() => _ClassListState();
}

class _ClassListState extends State<ClassList> {
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
      print('API URL: $BASH_URL$Class_API');
      var response = await http.get(Uri.parse('$BASH_URL$Class_API'));

      if (response.statusCode == 200) {
        setState(() {
          data = json.decode(response.body);
          filteredData = data ?? [];
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (text) {
          setState(() {
            filteredData = data
                .where((item) =>
                    (item['class']?.toLowerCase() ?? '')
                        .contains(text.toLowerCase()) ||
                    (item['block']?.toLowerCase() ?? '')
                        .contains(text.toLowerCase()) ||
                    (item['floor']?.toLowerCase() ?? '')
                        .contains(text.toLowerCase()) ||
                    (item['landmart']?.toLowerCase() ?? '')
                        .contains(text.toLowerCase()))
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
      child: ListView.builder(
        itemCount: filteredData.length,
        itemBuilder: (BuildContext context, int index) {
          if (filteredData.isNotEmpty) {
            String type = filteredData[index]['type'] ?? '';

            String imagePath;
            if (type == 'Class') {
              imagePath = 'assets/images/classroom.png';
            } else if (type == 'Lab') {
              imagePath = 'assets/images/laboratory.png';
            } else if (type == 'Hall') {
              imagePath = 'assets/images/auditorium.png';
            } else {
              imagePath =
                  'assets/images/classroom.png'; // Provide a default image
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Card(
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  leading: Image.asset(
                    imagePath,
                    width: 48.0,
                    height: 48.0,
                    // Customize the image size
                  ),
                  title: Text(
                    filteredData[index]['class'] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.blue,
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
                                color: Colors.grey[600],
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'Landmark: ${filteredData[index]['landmark'] ?? ''}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapScreen(
                            className: filteredData[index]['class'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Find Your Class"),
        elevation: 0.0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'KCET',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Route Map',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share App'),
              onTap: () {
                // handle share app
              },
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text('Rate App'),
              onTap: () {
                // handle rate app
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                // handle about
              },
            ),
            ListTile(
              leading: Icon(Icons.feedback),
              title: Text('Feedback'),
              onTap: () {
                // handle feedback
              },
            ),
            ListTile(
              leading: Icon(Icons.bug_report),
              title: Text('Bug Report'),
              onTap: () {
                // handle bug report
              },
            ),
          ],
        ),
      ),
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
            icon: Icon(Icons.person),
            label: 'Cabin',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
