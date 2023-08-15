
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

  //수정 >> 사용자 설정 현재 위치, 데이터 받아 오기
  LatLng origin = LatLng(0.0, 0.0);

  //예시 >> 초기 리스트 비어 있음
  List<Place> recommendPlaces = [
    Place(
    name: '스타벅스 성신여대점',
    placeId: 'A',
    placeLat: 37.591054,
    placeLng: 127.022626,
    types: ['cafe'],
    rating: 0,
    photoUrls: [''],
  ),
    Place(
    name: '이디야 카페 성신여대점',
    placeId: 'B',
    placeLat: 37.591776,
    placeLng: 127.021206,
    types: ['cafe'],
      rating: 0,
    photoUrls: [''],
  ),
    Place(
    name: '메가커피 성신여대점',
    placeId: 'C',
    placeLat: 37.590641,
    placeLng: 127.021988,
    types: ['cafe'],
      rating: 0,
    photoUrls: [''],
  ),
  ];

  Map<int, Polyline> polylineList = {};
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  int polylineIdCounter = 0;

  //수정 >> 사용자 설정 추천 장소 갯수, 데이터 받아 오기
  int placesCounter = 3;

  //
  DrawRecommendRoute(Map<String, List<Place>> categoryGroupPlaceLists) {
    setRecommendPlaces(categoryGroupPlaceLists);
  }

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
  setRecommendPlaces(Map<String, List<Place>> categoryGroupPlaceLists) {
    setOriginPlace(DrawRecommendRoute(categoryGroupPlaceLists).origin);


    for(var type in categoryGroupPlaceLists.keys) {
      Map<String, int> typeList = {
        '음식점': 1,
        '카페': 1,
        '쇼핑': 1,
        '문화': 2,
        '바': 1,
        '어트랙션': 3,
      };

      //사용자가 선택한 type 인지 확인 후
      //수정
      var selectedType = {};

      int addedPlaceCounter = 0;

      // i < selectedType.length;
      //categoryGroupPlaceLists[selectedType[i++]] => categoryGroupPlaceLists['음식점']
      // => types: 'restaurant'

      //categoryGroupPlaceLists[selectedType[i++]]
      // => categoryGroupPlaceLists['어트랙션']
      // => types: 'tourist_attraction', 'amusement_park', 'bowling_alley'
      //

      }
    }


    /*
    //이미 별점 순서로 정렬
    categoryGroupPlaceLists.forEach((place) {
      // if(types 가 한 가지로만 이루어진 경우)
      //recommendPlaces.addAll(categoryGroupPlaceLists.take(placesCounter));
      if(!addedType.contains(place.types)) {
        recommendPlaces.add(place);
        addedPlaceCounter++;
        addedType.add(place.types);
      }
      // if(recommendPlaces 에 types 가 한번씩 다 들어간 경우)
      // addedType 리셋

      if (addedPlaceCounter > placesCounter) { return ;}

    });

     */

    sortingCloseDistance();
  }


  sortingCloseDistance() {
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