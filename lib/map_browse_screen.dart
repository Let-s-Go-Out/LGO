import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

class MapBrowseScreen extends StatefulWidget {
  const MapBrowseScreen({Key? key}) : super(key: key);

  @override
  State<MapBrowseScreen> createState() => _MapBrowseScreenState();
}

class _MapBrowseScreenState extends State<MapBrowseScreen> {
  late GoogleMapController mapController;
  late TextEditingController textController;
  final LatLng _center = const LatLng(127.0203333, 37.58638333);
  Position? _position;

  get address async => await myAddress();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();

    textController = TextEditingController();
    initText();
    _getPosition();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initText() async {
    var address = await myAddress();
  }

  Future<Position> _getPosition() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _position = position; // 위치 정보 업데이트
    });
    print(position);
    return position;
  }

  Future<String> myAddress() async {
    var gps = await _getPosition();
    // 좌표로 주소 구하기
    String lat = gps.latitude.toString();
    String lon = gps.longitude.toString();
    Response response = await get(Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lon&key=AIzaSyAIeZMzg3xE5dYXgiWNoIjDE34R0SzTAzE'));

    String jsonData = response.body;
    return jsonDecode(jsonData)['results'][0]['formatted_address'];
  }

  Future<void> _performSearch() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('지도 검색'),
      ),
      body: Column(children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: '장소를 검색하세요.',
              labelText: address,
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: _performSearch,
              ),
            ),
            onSubmitted: (_) => _performSearch(),
          ),
        ),
        Expanded(
            child: GoogleMap(
              myLocationEnabled: true,
          myLocationButtonEnabled: false,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 15.0,
          ),
        )),
        FloatingActionButton(onPressed: () async {
          var gps = await _getPosition();
          mapController.animateCamera(CameraUpdate.newLatLng(LatLng(gps.latitude, gps.longitude)));
          },backgroundColor: Colors.white,
        child: const Icon(Icons.my_location, color: Colors.black,),),
      ]),
    );
  }
}
