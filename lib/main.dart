import 'dart:convert';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kcet_route_map/Pages/VenueScreen.dart';

import 'AppConstants.dart';

import 'Components/AppBottomNavBar .dart';
import 'Components/AppDrawer.dart';
import 'Pages/MapScreen.dart';

void main() => runApp(MyApp());

final LinearGradient appColor = AppConstants.BlueWhite;
final String BASH_URL = AppConstants.BASH_URL;
final String Class_API = AppConstants.Class_API;
final Color LightWhite = AppConstants.lightwhite;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Find your Class',
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AnimatedSplashScreen(
          splash: Transform.scale(
            scale: 2,
            child: Image.asset('assets/images/classroom.png'),
          ),
          nextScreen: HomePage(),)
        
        );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

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
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Text(
            'KCET Route Map',
            style: TextStyle(
                color: Color(0xFF0a1435), fontWeight: FontWeight.bold),
          ),
        ),

        //----------------Navigation Drawer------------------------------------------=
        drawer: AppDrawer(),

        body: AppBottomNavBar(),
      ),
    );
  }
}

