import 'package:flutter/material.dart';
import 'package:kcet_route_map/Pages/ChatBot.dart';
import '../AppConstants.dart';
import '../Pages/MapScreen.dart';
import '../Pages/VenueScreen.dart';

class AppBottomNavBar extends StatefulWidget {
  @override
  _AppBottomNavBarState createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = [
    VenueScreen(),
    ChatBot(),
  ];

  List<Color> _iconColors = [
    Colors.white, // Color for Venue when not selected
    Color(0xFF0a1435), // Color for Map when not selected
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: AppConstants.Orange,
            labelTextStyle: MaterialStateProperty.all(
              TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          child: NavigationBar(
            height: 75,
            backgroundColor: Color(0xFFf1f5fb),
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                this._selectedIndex = index;
                _updateIconColors();
              });
            },
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home, color: _iconColors[0]),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.chat, color: _iconColors[1]),
                label: 'Bot',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateIconColors() {
    _iconColors = [
      _selectedIndex == 0 ? Colors.white : Color(0xFF0a1435),
      _selectedIndex == 1 ? Colors.white : Color(0xFF0a1435),
    ];
  }
}
