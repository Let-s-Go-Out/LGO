
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
  }

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
}


class DrawRecommendRoute {
  static const String _apiKey = 'AIzaSyAIeZMzg3xE5dYXgiWNoIjDE34R0SzTAzE';

  List<RecommendPlaceModel> recommendPlaces = [];

  Map<int, Polyline> polylineList = {};
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  int polylineIdCounter = 0;


  sortingCloseDistance() {
    recommendPlaces.sort((a,b) {
      return a.distanceFromOrigin.compareTo(b.distanceFromOrigin);
    });
  }


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