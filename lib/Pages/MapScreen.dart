import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  final String className;

  const MapScreen({Key? key, required this.className}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LatLng markerPosition;
    double zoomLevel;
    switch (className) {
      case 'C1':
        markerPosition = LatLng(9.673480066012225, 77.96498426065126);
        zoomLevel = 20.0;
        break;
      case 'C2':
        markerPosition = LatLng(9.673433374812525, 77.96471360546255);
        zoomLevel = 15.0;
        break;
      // Add cases for other class names here
      default:
        markerPosition = LatLng(9.673724450451568, 77.964762076041);
        zoomLevel = 15.0;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(className),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: markerPosition,
          zoom: zoomLevel,
        ),
        markers: {
          Marker(
            markerId: MarkerId(className),
            position: markerPosition,
            infoWindow: InfoWindow(title: className),
          ),
        },
      ),
    );
  }
}
