
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:nagaja_app/Controller/map_controller.dart';
import 'package:nagaja_app/Model/place_model.dart';


//나들이 컨셉 - 장소 리스트 연결
//만약 하나의 컨셉에 여러 개의 장소 리스트를 매칭하다면 합쳐진 컨셉-장소 리스트 생성

//DrawRecommendRoute routeDraw = DrawRecommendRoute(categoryGroupPlaceLists);
class DrawRecommendRoute {
  static const String _apiKey = ' ';
  List<String> categoryRestaurant = ['restaurant'];
  List<String> categoryCafe = ['cafe'];
  List<String> categoryShopping = ['store'];
  List<String> categoryCulture = ['museum', 'library'];
  List<String> categoryBar = ['bar'];
  List<String> categoryAttraction = ['tourist_attraction', 'amusement_park', 'bowling_alley'];

  //수정 >> 사용자 설정 현재 위치, 데이터 받아 오기
  LatLng origin = LatLng(0.0, 0.0);

  //예시 >> 초기 리스트 비어 있음
  // List<Place> recommendPlaces = [
  //   Place(
  //   name: '스타벅스 성신여대점',
  //   placeId: 'A',
  //   placeLat: 37.591054,
  //   placeLng: 127.022626,
  //   types: ['cafe'],
  //   rating: 0,
  //   photoUrls: [''],
  // ),
  //   Place(
  //   name: '이디야 카페 성신여대점',
  //   placeId: 'B',
  //   placeLat: 37.591776,
  //   placeLng: 127.021206,
  //   types: ['cafe'],
  //     rating: 0,
  //   photoUrls: [''],
  // ),
  //   Place(
  //   name: '메가커피 성신여대점',
  //   placeId: 'C',
  //   placeLat: 37.590641,
  //   placeLng: 127.021988,
  //   types: ['cafe'],
  //     rating: 0,
  //   photoUrls: [''],
  // ),
  // ];
  List<Place> recommendPlaces = [];

  Map<int, Polyline> polylineList = {};
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  int polylineIdCounter = 0;

  //수정 >> 사용자 설정 추천 장소 갯수, 데이터 받아 오기
  int placesCounter = 3;
  List<String> userType = ['음식점','문화'];


  //
  // DrawRecommendRoute(Map<String, List<Place>> categoryGroupPlaceLists) {
  //   setRecommendPlaces(categoryGroupPlaceLists);
  // }

  setOriginPlace(LatLng origin) {
    recommendPlaces.insert(0, Place(
      name: '출발',
      placeId: ' ',
      placeLat: origin.latitude,
      placeLng: origin.longitude,
      types: [''],
      rating: 0,
      photoUrls: [''],
    ),);
  }


  //categoryGroupPlaceLists['category'], 예시 참고
  List<Place> setRecommendPlaces(Map<String, List<Place>> categoryGroupPlaceLists) {
    setOriginPlace(LatLng(0, 0));
    int a=0;
    int b=0;
    int c=0;
    int d=0;
    int e=0;
    int f=0;
    int culture = 0;
    int attraction = 0;
    List<Place>? cultureList =[];
    List<Place>? attractionList = [];
    for(int i=0;i<=placesCounter;) {
      for (var type in userType) {
        switch (type) {
          case '음식점':
            if(categoryGroupPlaceLists['음식점'] != null){
              if(i<=placesCounter){
                recommendPlaces.add(categoryGroupPlaceLists['음식점']![a]);
                i++;
                a++;
              }
            }
            break;
          case '카페':
            if(categoryGroupPlaceLists['카페'] != null){
              if(i<=placesCounter&&categoryGroupPlaceLists['카페']?.length != 0){
                recommendPlaces.add(categoryGroupPlaceLists['카페']![b]);
                i++;
                b++;
              }
            }
            break;
          case '쇼핑':
            if(categoryGroupPlaceLists['쇼핑'] != null){
              if(i<=placesCounter&&categoryGroupPlaceLists['쇼핑']?.length != 0){
                recommendPlaces.add(categoryGroupPlaceLists['쇼핑']![c]);
                i++;
                c++;
              }
            }
            break;
          case '문화':
            if(categoryGroupPlaceLists['문화'] != null){
              if(i<=placesCounter){
                    cultureList = categoryGroupPlaceLists['문화']?.where((item) => categoryCulture.contains(item.types[culture%2])).toList();
                    if(cultureList?.length != 0) {
                      recommendPlaces.add(cultureList![d]);
                    }
                i++;
                d++;
                culture++;
              }
            }
            break;
          case '바':
            if(categoryGroupPlaceLists['바'] != null){
              if(i<=placesCounter&&categoryGroupPlaceLists['바']?.length != 0){
                recommendPlaces.add(categoryGroupPlaceLists['바']![e]);
                i++;
                e++;
              }
            }
            break;
          case '어트랙션':
            if(categoryGroupPlaceLists['어트랙션'] != null){
              if(i<=placesCounter){
                attractionList = categoryGroupPlaceLists['어트랙션']?.where((item) => categoryAttraction.contains(item.types[attraction%3])).toList();
                if(attractionList?.length != 0){
                  recommendPlaces.add(attractionList![f]);
                }
                i++;
                f++;
                attraction++;
              }
            }
            break;
        }
      }
    }
    sortingCloseDistance(recommendPlaces);
    print('추천장소');
    for(int i =0;i<placesCounter+1;i++){
      print(recommendPlaces[i].name);
    }
    return recommendPlaces;
  }


  sortingCloseDistance(List<Place> recommendPlaces) {
    recommendPlaces.sort((a,b) {
      return a.distanceFromOrigin.compareTo(b.distanceFromOrigin);
    });
  }


  drawPolyline() async{
    for(int i = 0; i < recommendPlaces.length - 1; i++) {
      //출발지가 항상 리스트 맨 처음
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