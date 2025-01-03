//packages
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController googleMapController;

  static const LatLng _initialPosition =
      LatLng(37.77483, -122.41942); // Example coordinates

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Maps")),
      body: GoogleMap(
        onMapCreated: (googleMapsController) {
          googleMapController = googleMapsController;
        },
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 14.0,
        ),
        mapType: MapType.normal,
      ),
    );
  }
}
