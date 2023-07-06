import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapBrowseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //여기다가 맵 서칭 ui 추가하기
    return Scaffold(
      appBar: AppBar(
        title: Text('지도 검색'),
      ),
      body: Container(
        //여기다가 맵 검색 위젯이랑 알고리즘 추가하기
        child: NaverMap(
          options: const NaverMapViewOptions(),
          onMapReady: (controller){
            print("네이버 맵 로딩됨!");
          },
          onMapTapped: (point, latLng){},
          onSymbolTapped: (symbol){},
          onCameraChange: (position, reason){},
          onCameraIdle: (){},
          onSelectedIndoorChanged: (indoor){},
        ),
      ),
    );
  }
}