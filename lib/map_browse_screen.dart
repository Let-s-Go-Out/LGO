import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class MapBrowseScreen extends StatefulWidget {
  const MapBrowseScreen({Key? key}) : super(key: key);

  @override
  _MapBrowseScreenState createState() => _MapBrowseScreenState();
}

class _MapBrowseScreenState extends State<MapBrowseScreen> {
  late NaverMapController _mapController;
  late TextEditingController _searchController;
  late Position _position;

  @override
  void initState() {
    super.initState();
    _getPosition();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _getPosition() async{
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _position = position; // 위치 정보 업데이트
      });
      print(position);
    }catch(e){
      print('There was a problem with the internet connection.');
    }
  }

  @override
  Future<void> _performSearch() async {
  }

  void _addMarker(NLatLng position) {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('지도 검색'),
      ),
      body: Column(children: [
        Container(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: '장소를 검색하세요.',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: _performSearch,
              ),
            ),
            onSubmitted: (_) => _performSearch(),
          ),
        ),
        Expanded(
          child: NaverMap(
               options: const NaverMapViewOptions(
                   locationButtonEnable: true,
                 consumeSymbolTapEvents: true
               ),
            onMapReady: (controller) {
                 _mapController = controller;
                 print("네이버 맵 로딩됨!");
            },
            onMapTapped: (point, latLng) {},
            onSymbolTapped: (symbol) {},
            onCameraChange: (position, reason) {},
            onCameraIdle: () {},
            onSelectedIndoorChanged: (indoor) {},
          ),
        ),
      ]),
    );
  }
}