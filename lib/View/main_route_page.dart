import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:nagaja_app/Controller/map_controller.dart';
import 'package:nagaja_app/View/default_grabbing.dart';
import 'package:snapping_sheet_2/snapping_sheet.dart';

class MainRoutePage extends StatefulWidget {
  const MainRoutePage({Key? key}) : super(key: key);

  @override
  _MainRoutePageState createState() => _MainRoutePageState();
}

class _MainRoutePageState extends State<MainRoutePage> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(37.58638333, 127.0203333);
  MapController controller = MapController();
  bool isExpanded = false;
  ScrollController scrollcontroller = ScrollController();
  List<LatLng> pathPoints = [];
  Location location = Location();
  LocationData? currentUserPosition;

  @override
  void initState() {
    super.initState();
    pathPoints.clear();
    _setupLocationListener();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<LatLng> _getInitialCameraPosition() async {
    return await controller.getPosition().then((position) {
      return LatLng(position.latitude, position.longitude);
    });
  }

  void _updatePath(LatLng newPosition){
    setState(() {
      pathPoints.add(newPosition);
    });
  }

  void _setupLocationListener() {
    location.onLocationChanged.listen((LocationData currentLocation) {
      // Call the _updatePath() function with the new position
      _updatePath(LatLng(currentLocation.latitude!, currentLocation.longitude!));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 10,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text(
                  'AI 추천',
                  style: TextStyle(fontSize: 28),
                ),
              ),
              Tab(
                child: Text(
                  '둘러보기',
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ],
              indicatorColor: Colors.black,
              unselectedLabelColor: Colors.grey,
             unselectedLabelStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
             labelColor: Colors.black,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            _buildAIRecommendationTab(),
            _buildTourTab(),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildAIRecommendationTab() {
    return Scaffold(
      body: SnappingSheet(
        lockOverflowDrag: true,
        snappingPositions: [
          SnappingPosition.factor(positionFactor: 0,grabbingContentOffset: GrabbingContentOffset.top),
          SnappingPosition.factor(positionFactor: 0.5,snappingCurve: Curves.elasticOut,snappingDuration: Duration(milliseconds: 1750)),
          SnappingPosition.factor(positionFactor: 0.9,)
        ],
        initialSnappingPosition: SnappingPosition.factor(positionFactor: 0.5),
        child: _buildAIRecommendationContent(),
        grabbingHeight: 50,
        grabbing: GrabbingWidget(),
        sheetBelow: SnappingSheetContent(
          draggable: (details) => true,
          child: Container(
            color: Colors.white,
            child: ListView(
              scrollDirection: Axis.vertical,
            shrinkWrap: true,
            controller: scrollcontroller,
            reverse: false,
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildAIRecommendationContent() {
     return FutureBuilder<LatLng>(
      future: _getInitialCameraPosition(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: snapshot.data!,
              zoom: 15.0,
            ),
            markers: {
              Marker(
                markerId: MarkerId('marker_id'),
                position: snapshot.data!,
                infoWindow: InfoWindow(
                  title: '현재 위치',
                  snippet: '',
                ),
              ),
            },
            polylines: {
              Polyline(
                polylineId: PolylineId('path'),
                color: Colors.lightBlueAccent,
                points: pathPoints,
              ),
            },
          );
        }
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

class GrabbingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(blurRadius: 25, color: Colors.black.withOpacity(0.2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            width: 100,
            height: 7,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Container(
            color: Colors.grey[200],
            height: 2,
            margin: EdgeInsets.all(15).copyWith(top: 0, bottom: 0),
          )
        ],
      ),
    );
  }
}
