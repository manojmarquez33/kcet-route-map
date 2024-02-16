import 'package:flutter/material.dart';
import 'package:kcet_route_map/Blocks/A_Block.dart';
import 'package:kcet_route_map/Blocks/Classroom.dart';
import 'package:kcet_route_map/Blocks/Laboratory.dart';
import 'package:kcet_route_map/Blocks/Worshop.dart';
import 'package:kcet_route_map/main.dart';

import '../AppConstants.dart';
import '../Blocks/Auditorium.dart';
import '../Blocks/B_Block.dart';
import '../Blocks/C_Block.dart';
import '../Blocks/ConferenceHall.dart';
import '../Blocks/D_Block.dart';
import '../Blocks/E_Block.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: AppConstants.OrangeWhite,
            ),
            accountName: Text(
              'KCET',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              'Route Map',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Image.asset(
                'assets/images/classroom.png',
                height: 60,
              ),
            ),
          ),
          ListTile(
            title: Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            },
            leading: Icon(Icons.home, color: Colors.pink),
          ),
          ListTile(
            title: Text(
              'Block',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: Icon(Icons.category, color: Colors.blue),
          ),
          ListTile(
            title: Text('A Block'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => A_Block(),
                ),
              );
            },
            leading: Icon(Icons.location_on, color: Colors.pink),
          ),
          ListTile(
            title: Text('B Block'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => B_Block(),
                ),
              );
            },
            leading: Icon(Icons.location_on, color: Colors.green),
          ),
          ListTile(
            title: Text('C Block'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => C_Block(),
                ),
              );
            },
            leading: Icon(Icons.location_on, color: Colors.purpleAccent),
          ),
          ListTile(
            title: Text('D Block'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => D_Block(),
                ),
              );
            },
            leading: Icon(Icons.location_on, color: Colors.orange),
          ),
          ListTile(
            title: Text('E Block'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => E_Block(),
                ),
              );
            },
            leading: Icon(Icons.location_on, color: Colors.brown),
          ),
          Divider(
            height: 15,
            color: Colors.black,
          ),
          ListTile(
            title: Text('Classroom'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Classroom(),
                ),
              );
            },
            leading: Icon(Icons.event, color: Colors.purple),
          ),
          ListTile(
            title: Text('Laboratory'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Laboratory(),
                ),
              );
            },
            leading: Icon(Icons.event, color: Colors.purple),
          ),
          ListTile(
            title: Text('Auditorium'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Auditorium(),
                ),
              );
            },
            leading: Icon(Icons.event, color: Colors.purple),
          ),
          ListTile(
            title: Text('Conference Hall'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConferenceHall(),
                ),
              );
            },
            leading: Icon(Icons.event, color: Colors.purple),
          ),
          ListTile(
            title: Text('Workshops'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Workshop(),
                ),
              );
            },
            leading: Icon(Icons.build, color: Colors.orange),
          ),
          Divider(
            height: 15,
            color: Colors.black,
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
          Divider(), // Add a divider for visual separation
          // Additional blocks
        ],
      ),
    );
  }
}
