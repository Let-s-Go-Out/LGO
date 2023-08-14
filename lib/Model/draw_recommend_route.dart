
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nagaja_app/Model/place_model.dart';


//PlaceApi 이용해서 List<Place> placesByCategory (category: restaurant, cafe ..) 생성 (예시)
//나들이 컨셉 - 장소 리스트 연결
//만약 하나의 컨셉에 여러 개의 장소 리스트를 매칭하다면 합쳐진 컨셉-장소 리스트(testPlaces) 생성
//* 아직 수정중인 부분인데, 가은님이 컨셉 별 타입 및 장소 리스트 정리해주셔서 추후 로딩 페이지에서 컨셉 별 장소 리스트 생성할 예정입니다!
//* 에뮬레이터에서 테스트가 안돼서 추가를 못하고 있습니다.
//* 확인하고 싶으시면 NewGaEun 브랜치에 main_route_page.dart에서 확인 가능해요.

//DrawRecommendRoute test = DrawRecommendRoute(testPlaces);
//사용하려면 수정
class DrawRecommendRoute {
  static const String _apiKey = 'AIzaSyAIeZMzg3xE5dYXgiWNoIjDE34R0SzTAzE';

  //예시
  List<Place> recommendPlaces = [
    Place(
    name: '스타벅스 성신여대점',
    placeId: 'A',
    placeLat: 37.591054,
    placeLng: 127.022626,
    types: ['cafe'],
    photoUrls: [''],
  ),
    Place(
    name: '이디야 카페 성신여대점',
    placeId: 'B',
    placeLat: 37.591776,
    placeLng: 127.021206,
    types: ['cafe'],
    photoUrls: [''],
  ),
    Place(
    name: '메가커피 성신여대점',
    placeId: 'C',
    placeLat: 37.590641,
    placeLng: 127.021988,
    types: ['cafe'],
    photoUrls: [''],
  ),
  ];

  Map<int, Polyline> polylineList = {};
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  int polylineIdCounter = 0;

  //수정 >> 사용자 설정 추천 장소 갯수, 데이터 받아 오기
  int placesCounter = 3;


  //testPlaces = placesMatchingMood
  setRecommendPlaces(List<Place> placesMatchingMood) {
    recommendPlaces.addAll(placesMatchingMood.take(placesCounter));
    //* 정렬이 된 상태에서 사용자가 설정한 개수만큼 받아오는 게 좋을 것 같습니다.
    //* 그리고 앞에서부터 순서대로 가져오면 장소 타입이 겹칠 수도 있을 것 같은데,
    //* 가은님 코드 참고해서 컨셉 별 타입 하나씩 가져오고, 더 없다면 순서대로 가져오는 게 어떨까요?
    sortingCloseDistance();
  }


  sortingCloseDistance() {
    recommendPlaces.sort((a,b) {
      return a.distanceFromOrigin.compareTo(b.distanceFromOrigin);
    });
  }


  drawPolyline() async{
    for(int i = 0; i < recommendPlaces.length - 1; i++) {
      LatLng startLocation = recommendPlaces[i].location;
      //* 출발지점이 사용자 현재 위치나 사용자가 지정한 위치여야 할 것 같아요. recommendPlaces에 출발지점을 추가하거나, 따로 지정해주는 게 좋을 것 같습니다!
      LatLng endLocation = recommendPlaces[i + 1].location;

      polylineCoordinates = await getPolyline(startLocation, endLocation);
      addPolyline(polylineCoordinates);
    }
  }

  getPolyline(LatLng startL, LatLng endL) async{
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        _apiKey,

      PointLatLng(startL.latitude, startL.longitude),
      PointLatLng(endL.latitude, endL.longitude),

      travelMode: TravelMode.walking,
    );

    if (result.points.isNotEmpty) {
      for (var element in result.points) {
        polylineCoordinates.add(LatLng(element.latitude, element.longitude));
      }
    }
  }

  addPolyline(List<LatLng> polylineCoordinates) {
    polylineIdCounter++;

    Polyline newPolyline = Polyline(
      polylineId: PolylineId('$polylineIdCounter'),
      points: polylineCoordinates,
      color: Colors.blue,
    );

    polylineList[polylineIdCounter] = newPolyline;
  }

}