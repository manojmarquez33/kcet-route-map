// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:situm_flutter/sdk.dart';
// import 'package:situm_flutter/wayfinding.dart';
//
// class MapScreen extends StatelessWidget {
//   const MapScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   MapViewController? mapViewController;
//   String buildingIdentifier = "15487"; // Initial building identifier
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize SitumSdk class
//     _useSitum();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         //MapView widget will visualize the building cartography
//         child: MapView(
//           key: const Key("situm_map"),
//           configuration: MapViewConfiguration(
//             situmApiKey: "dc1074d66154e97773855ed65aee5f463551f06ff9e581d032b92c90b0cf941b",
//             buildingIdentifier: buildingIdentifier,
//           ),
//           onLoad: _onLoad,
//         ),
//       ),
//       // Button to toggle building identifier
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             // Toggle building identifier
//             if (buildingIdentifier == "15487") {
//               buildingIdentifier = "15499";
//             } else {
//               buildingIdentifier = "15487";
//             }
//           });
//         },
//         child: const Icon(Icons.change_history),
//       ),
//     );
//   }
//
//   void _onLoad(MapViewController controller) {
//     // Map successfully loaded: now you can register callbacks and perform
//     // actions over the map.
//     mapViewController = controller;
//     debugPrint("Situm> wayfinding> Map successfully loaded.");
//     controller.onPoiSelected((poiSelectedResult) {
//       debugPrint("Situm> wayfinding> Poi selected: ${poiSelectedResult.poi.name}");
//     });
//   }
//
//   //Step 4 - Positioning
//   void _useSitum() async {
//     var situmSdk = SitumSdk();
//     // Set up your credentials
//     situmSdk.init();
//     situmSdk.setApiKey("Your_Situm_Api_Key_Here");
//     // Set up location callbacks:
//     situmSdk.onLocationUpdate((location) {
//       debugPrint("Situm> sdk> Location updated: ${location.toMap().toString()}");
//     });
//     situmSdk.onLocationStatus((status) {
//       debugPrint("Situm> sdk> Status: $status");
//     });
//     situmSdk.onLocationError((error) {
//       debugPrint("Situm> sdk> Error: ${error.message}");
//     });
//     // Check permissions:
//     var hasPermissions = await _requestPermissions();
//     if (hasPermissions) {
//       // Happy path: start positioning using the default options.
//       // The MapView will automatically draw the user location.
//       situmSdk.requestLocationUpdates(LocationRequest());
//     } else {
//       // Handle permissions denial.
//       debugPrint("Situm> sdk> Permissions denied!");
//     }
//   }
//
//   // Requests positioning permissions
//   Future<bool> _requestPermissions() async {
//     var permissions = <Permission>[
//       Permission.locationWhenInUse,
//     ];
//     if (Platform.isAndroid) {
//       permissions.addAll([
//         Permission.bluetoothConnect,
//         Permission.bluetoothScan,
//       ]);
//     } else if (Platform.isIOS) {
//       permissions.add(Permission.bluetooth);
//     }
//     Map<Permission, PermissionStatus> statuses = await permissions.request();
//     return statuses.values.every((status) => status.isGranted);
//   }
// }
// // import 'package:flutter/material.dart';
// // import 'package:webview_flutter/webview_flutter.dart';
// //
// //
// // class MapScreen extends StatelessWidget {
// //   const MapScreen({Key? key, required className}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: WebViewPage(),
// //     );
// //   }
// // }
// //
// // class WebViewPage extends StatefulWidget {
// //   const WebViewPage({Key? key}) : super(key: key);
// //
// //   @override
// //   _WebViewPageState createState() => _WebViewPageState();
// // }
// //
// // class _WebViewPageState extends State<WebViewPage> {
// //   late WebViewController controller;
// //   bool isLoading = true;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       extendBody: true,
// //       body: Stack(
// //         children: [
// //           WillPopScope(
// //             onWillPop: () async {
// //               if (await controller.canGoBack()) {
// //                 // Check if WebView can go back
// //                 controller.goBack();
// //                 return false; // Prevent default back button behavior
// //               }
// //               return true; // Allow default back button behavior
// //             },
// //             child: WebView(
// //               javascriptMode: JavascriptMode.unrestricted,
// //               initialUrl: 'https://map-viewer.situm.com/?apikey=1acaf949bfe26eee639edd9733c8a4a2fdcb043dd1af83eb720bdb6a163cd1e7&domain=&lng=en-IN&buildingid=15488&floorid=49886&navigation_to=540169&navigation_from=540121',
// //               onWebViewCreated: (controller) {
// //                 this.controller = controller;
// //               },
// //               onPageFinished: (String url) {
// //                 controller
// //                     .evaluateJavascript("javascript:(function() { " +
// //                     "var head = document.getElementsByTagName('header')[0];" +
// //                     "head.parentNode.removeChild(head);" +
// //                     "var footer = document.getElementsByTagName('footer')[0];" +
// //                     "footer.parentNode.removeChild(footer);" +
// //                     "})()")
// //                     .then((value) =>
// //                     debugPrint('Page finished loading Javascript'))
// //                     .catchError((onError) => debugPrint('$onError'));
// //
// //                 setState(() {
// //                   isLoading =
// //                   false; // Set isLoading to false when the page finishes loading
// //                 });
// //               },
// //             ),
// //           ),
// //           if (isLoading)
// //             Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   SizedBox(height: 80.0),
// //                   Padding(
// //                     padding: EdgeInsets.only(left: 56.0),
// //                     child: Text(
// //                       '',
// //                       style: TextStyle(
// //                         color: Colors.black54,
// //                         fontSize: 16.0,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// // }
