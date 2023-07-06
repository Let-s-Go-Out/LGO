import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapBrowseScreen extends StatefulWidget {
  @override
  _MapBrowseScreenState createState() => _MapBrowseScreenState();
}

class _MapBrowseScreenState extends State<MapBrowseScreen> {
  late NaverMapController _mapController;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Future<void> _performSearch() async {
    final searchQuery = _searchController.text;
    if (_mapController != null) {
      _mapController.clearOverlays();

      final response = await http.get(Uri.parse(
          'https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=$searchQuery'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['addresses'] as List<dynamic>;

        for (var item in items) {
          final lat = double.parse(item['y']);
          final lng = double.parse(item['x']);
          final position = NLatLng(lat, lng);
          _addMarker(position);
        }

        if (items.isNotEmpty) {
          final firstItem = items.first;
          final lat = double.parse(firstItem['y']);
          final lng = double.parse(firstItem['x']);
          final position = NLatLng(lat, lng);
          _mapController.latLngToScreenLocation(position);
        }
      } else {
        print('API Error: ${response.statusCode}');
      }
    }
  }

  void _addMarker(NLatLng position) {
    final marker = NMarker(
      id: position.toString(),
      position: position,
    );
    _mapController.addOverlay(marker);
  }

  @override
  Widget build(BuildContext context) {
    //여기다가 맵 서칭 ui 추가하기
    return Scaffold(
      appBar: AppBar(
        title: Text('지도 검색'),
      ),
      body: Column(
        children: [
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
              options: const NaverMapViewOptions(),
              onMapReady: (controller) {
                setState(() {
                  _mapController = controller;
                });
                print("네이버 맵 로딩됨!");
              },
              onMapTapped: (point, latLng) {},
              onSymbolTapped: (symbol) {},
              onCameraChange: (position, reason) {},
              onCameraIdle: () {},
              onSelectedIndoorChanged: (indoor) {},
            ),
          ),
        ],
      ),
    );
  }
}
