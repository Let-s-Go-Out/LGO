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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            color: Theme.of(context).primaryColor,
            child: TabBar(
              tabs: const [
                Tab(text: 'AI추천'),
                Tab(text: '둘러보기'),
              ],
              labelStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Increase font size for active tab
              unselectedLabelStyle: TextStyle(fontSize: 18), // Font size for inactive tabs
              padding:EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildAIRecommendationTab(),
            _buildTourTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildAIRecommendationTab() {
    return GoogleMap(
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
    );
  }

  Widget _buildTourTab() {
    return Center(
      child: Text(
        'AI recommendation tab content',
        style: TextStyle(fontSize: 20, color: Colors.black),
      ),
    );
  }
}