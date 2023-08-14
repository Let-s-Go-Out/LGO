
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//나들이 컨셉 - 장소 리스트 연결
//장소 리스트에서 n개 추출
//recommendPlaces = [];에 추가

//place_model.dart

class RecommendPlaceModel {
  String? placeName;
  double? latitude;
  double? longitude;
  LatLng? latlng;
  double? distance;

  RecommendPlaceModel({required this.placeName, required this.latlng, required this.longitude}) {
    distance = distanceCalculation(latitude!, longitude!);
    latlng = LatLng(latitude!, longitude!);
  } //* class 따로 생성할 필요 없이 place_model.dart에 있는 Place class 사용하면 됩니다. 임시 값 생성해서 테스트 해보는 것 추천드려요.

  double distanceCalculation(double lat, double lng) {
    final geo = GeolocatorPlatform.instance;

    //사용자 설정 출발지 위치 좌표
    double originLat = 0.0;
    double originLng = 0.0;

    double result = geo.distanceBetween(originLat, originLng, lat, lng);

    return result;
  }

  get distanceFromOrigin => distance;
  get location => latlng;
} //* 사용자 설정 출발지는 main_page_loading.dart 에서 controller.model.nowPLatLng 값 사용하면 됩니다.


class DrawRecommendRoute {
  static const String _apiKey = 'AIzaSyAIeZMzg3xE5dYXgiWNoIjDE34R0SzTAzE';

  List<RecommendPlaceModel> recommendPlaces = [];

  Map<int, Polyline> polylineList = {};
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  int polylineIdCounter = 0;


  sortingCloseDistance() { //* 임시 값으로 거리순 리스트 만드는 내용도 추가 부탁드려요
    recommendPlaces.sort((a,b) {
      return a.distanceFromOrigin.compareTo(b.distanceFromOrigin);
    });
  }

//* polyline 추가는 main_route_page.dart 154번째 줄의 google map에서 그려주시면 됩니다
  choosePlacesForPolyline() async{
    for(int i = 0; i < recommendPlaces.length - 1; i++) {
      LatLng startLocation = recommendPlaces[i].location;
      LatLng endLocation = recommendPlaces[i + 1].location;
      //
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

    //List<PointLatLng> polylineCoordinates = [];

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

  //희망 사항: GoogleMap( .. , polylines: polylineList, )

}