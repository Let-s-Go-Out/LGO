import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nagaja_app/Controller/map_controller.dart';

class MainRoutePage extends StatefulWidget {
  const MainRoutePage({Key? key}) : super(key: key);

  @override
  _MainRoutePageState createState() => _MainRoutePageState();
}

class _MainRoutePageState extends State<MainRoutePage> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(37.58638333, 127.0203333);
  MapController controller = MapController();

  @override
  void initState() {
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<LatLng> _getInitialCameraPosition() async {
    return await controller.getPosition().then((position) {
      return LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            _buildAppBar(), // 상단 바
            _buildTabBarView(), // 탭 바 아래 내용
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height / 3,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '출발지에서',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                'PM 6시 30분에 출발하여',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              Text(
                '1시간 소요되는',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              Text(
                '나들이 컨셉의 코스는',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBarView() {
    return SliverFillRemaining(
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          _buildAIRecommendationTab(),
          _buildTourTab(),
        ],
      ),
    );
  }

  Widget _buildAIRecommendationTab() {
    return Scaffold(
        body: FutureBuilder<LatLng>(
            future: _getInitialCameraPosition(),
            builder: (context, snapshot) {
              if (snapshot.hasData == false) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return GoogleMap(
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
                );
              }
            }));
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
