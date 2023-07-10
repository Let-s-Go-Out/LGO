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
    _permission();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getPosition() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _position = position; // 위치 정보 업데이트
    });
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
               options: const NaverMapViewOptions(),
            onMapReady: (controller) {
              setState(() {
                _mapController = controller;
                _getPosition();
                controller.updateCamera(NCameraUpdate.scrollAndZoomTo(
                ));
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
      ]),
    );
  }
}

void _permission() async {
  var requestStatus = await Permission.location.request();
  var status = await Permission.location.status;
  if (requestStatus.isGranted && status.isLimited) {
    // isLimited - 제한적 동의 (ios 14 < )
    // 요청 동의됨
    print("isGranted");
    if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
      // 요청 동의 + gps 켜짐
      var position = await Geolocator.getCurrentPosition();
      print("serviceStatusIsEnabled position = ${position.toString()}");
    } else {
      // 요청 동의 + gps 꺼짐
      print("serviceStatusIsDisabled");
    }
  } else if (requestStatus.isPermanentlyDenied || status.isPermanentlyDenied) {
    // 권한 요청 거부, 해당 권한에 대한 요청에 대해 다시 묻지 않음 선택하여 설정화면에서 변경해야함. android
    print("isPermanentlyDenied");
    openAppSettings();
  } else if (status.isRestricted) {
    // 권한 요청 거부, 해당 권한에 대한 요청을 표시하지 않도록 선택하여 설정화면에서 변경해야함. ios
    print("isRestricted");
    openAppSettings();
  } else if (status.isDenied) {
    // 권한 요청 거절
    print("isDenied");
  }
  print("requestStatus ${requestStatus.name}");
  print("status ${status.name}");
}
