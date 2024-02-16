import 'package:flutter/material.dart';
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
    MapScreen(className: null,),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
              indicatorColor: Colors.orange,
              labelTextStyle: MaterialStateProperty.all(
                  TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          child: NavigationBar(
            height: 75,
            backgroundColor: Color(0xFFf1f5fb),
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) =>
                setState(() => this._selectedIndex = index),
            destinations: [
              NavigationDestination(
                  icon: Icon(Icons.home), label: 'Venue'),
              NavigationDestination(
                  icon: Icon(Icons.location_on_outlined), label: 'Map'),
            ],
          ),
        ),
      ),
    );
  }
}
