import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainRoutePage extends StatefulWidget {
  const MainRoutePage({Key? key}) : super(key: key);

  @override
  _MainRoutePageState createState() => _MainRoutePageState();
}

class _MainRoutePageState extends State<MainRoutePage> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(37.58638333, 127.0203333);

  @override
  void initState() {
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Route Page'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 15.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId('marker_id'),
            position: _center,
            infoWindow: InfoWindow(
              title: 'Sample Marker',
              snippet: 'This is a sample marker on Google Maps',
            ),
          ),
        },
      ),
    );
  }
}