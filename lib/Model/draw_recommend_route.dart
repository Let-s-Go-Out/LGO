
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nagaja_app/Model/place_model.dart';


//PlaceApi 이용해서 List<Place> placesByCategory (category: restaurant, cafe ..) 생성 (예시)
//나들이 컨셉 - 장소 리스트 연결
//만약 하나의 컨셉에 여러 개의 장소 리스트를 매칭하다면 합쳐진 컨셉-장소 리스트(testPlaces) 생성

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
    sortingCloseDistance();
  }


  sortingCloseDistance() { //* 임시 값으로 거리순 리스트 만드는 내용도 추가 부탁드려요
    recommendPlaces.sort((a,b) {
      return a.distanceFromOrigin.compareTo(b.distanceFromOrigin);
    });
  }


  drawPolyline() async{
    for(int i = 0; i < recommendPlaces.length - 1; i++) {
      LatLng startLocation = recommendPlaces[i].location;
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