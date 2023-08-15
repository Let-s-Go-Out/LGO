
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:nagaja_app/Controller/map_controller.dart';
import 'package:nagaja_app/Model/place_model.dart';


//PlaceApi 이용해서 List<Place> placesByCategory (category: restaurant, cafe ..) 생성 (예시)
//나들이 컨셉 - 장소 리스트 연결
//만약 하나의 컨셉에 여러 개의 장소 리스트를 매칭하다면 합쳐진 컨셉-장소 리스트(selectedCategoryPlaces) 생성
//* 아직 수정중인 부분인데, 가은님이 컨셉 별 타입 및 장소 리스트 정리해주셔서 추후 로딩 페이지에서 컨셉 별 장소 리스트 생성할 예정입니다!
//* 에뮬레이터에서 테스트가 안돼서 추가를 못하고 있습니다.
//* 확인하고 싶으시면 NewGaEun 브랜치에 main_route_page.dart에서 확인 가능해요.

// 선택된 장소 유형에 기반한 장소 목록 가져오기
//List<Place> selectedCategoryPlaces = categoryGroupPlaceLists[selectedPlaceType] ?? [];


//DrawRecommendRoute routeDraw = DrawRecommendRoute(selectedCategoryPlaces);
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

  DrawRecommendRoute(List<Place> selectedCategoryPlaces) {
    setRecommendPlaces(selectedCategoryPlaces);
  }

  setOriginPlace(LatLng origin) {
    recommendPlaces.insert(0, Place(
      name: '출발',
      placeId: ' ',
      placeLat: origin.latitude,
      placeLng: origin.longitude,
      types: [''],
      photoUrls: [''],
    ),);
  }

  //selectedCategoryPlaces = placesMatchingMood
  setRecommendPlaces(List<Place> placesMatchingMood) {
    /*
    recommendPlaces.addAll(placesMatchingMood.where((place)
        => place.types.contains('')));

     */
    recommendPlaces.addAll(placesMatchingMood.take(placesCounter));
    //* 정렬이 된 상태에서 사용자가 설정한 개수만큼 받아오는 게 좋을 것 같습니다.
    //* 그리고 앞에서부터 순서대로 가져오면 장소 타입이 겹칠 수도 있을 것 같은데,
    //* 가은님 코드 참고해서 컨셉 별 타입 하나씩 가져오고, 더 없다면 순서대로 가져오는 게 어떨까요?
    sortingCloseDistance();
    setOriginPlace(DrawRecommendRoute(placesMatchingMood).origin);
  }


  sortingCloseDistance() {
    recommendPlaces.sort((a,b) {
      return a.distanceFromOrigin.compareTo(b.distanceFromOrigin);
    });
  }


  drawPolyline() async{
    for(int i = 0; i < recommendPlaces.length - 1; i++) {
      //출발지가 항상 리스트 맨 처음이라는 가정
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