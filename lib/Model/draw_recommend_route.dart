import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nagaja_app/Model/place_model.dart';

class DrawRecommendRoute {
  static const String _apiKey = 'AIzaSyBrK8RWyR1_3P7M7yjNiJ8xyXTAuFpeLlM';
  List<String> categoryRestaurant = ['restaurant'];
  List<String> categoryCafe = ['cafe'];
  List<String> categoryShopping = ['store'];
  List<String> categoryCulture = ['museum', 'library'];
  List<String> categoryBar = ['bar'];
  List<String> categoryAttraction = ['tourist_attraction', 'amusement_park', 'bowling_alley'];
  List<Place> recommendPlaces = [];

  Map<PolylineId, Polyline> polylineList = {};
  PolylinePoints polylinePoints = PolylinePoints();
  int polylineIdCounter = 0;
  List<LatLng> polylineCoordinates=[];

  setOriginPlace(LatLng origin) {
    recommendPlaces.insert(0, Place(
      name: '출발 지점',
      placeId: 'start_place',
      placeLat: origin.latitude,
      placeLng: origin.longitude,
      types: ['start'],
      rating: 0,
      photoUrls: [''],
    ),);
  }

  //categoryGroupPlaceLists['category'], 예시 참고
  List<Place> setRecommendPlaces(Map<String, List<Place>> categoryGroupPlaceLists,GeoPoint gp, int placesCounter, String userType) {
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
    for(int i=1;i<placesCounter+1;) {
        switch (userType) {
          case '음식점':
            if(categoryGroupPlaceLists['음식점'] != null && a < categoryGroupPlaceLists['음식점']!.length){
              if(i<=placesCounter){
                recommendPlaces.add(categoryGroupPlaceLists['음식점']![a]);
                i++;
                a++;
              }
            }
            break;
          case '카페':
            if(categoryGroupPlaceLists['카페'] != null && b < categoryGroupPlaceLists['카페']!.length){
              if(i<=placesCounter&&categoryGroupPlaceLists['카페']?.length != 0){
                recommendPlaces.add(categoryGroupPlaceLists['카페']![b]);
                i++;
                b++;
              }
            }
            break;
          case '쇼핑':
            if(categoryGroupPlaceLists['쇼핑'] != null && c < categoryGroupPlaceLists['쇼핑']!.length){
              if(i<=placesCounter&&categoryGroupPlaceLists['쇼핑']?.length != 0){
                recommendPlaces.add(categoryGroupPlaceLists['쇼핑']![c]);
                i++;
                c++;
              }
            }
            break;
          case '문화':
            if(categoryGroupPlaceLists['문화'] != null && d < categoryGroupPlaceLists['문화']!.length){
              if(i<=placesCounter){
                    cultureList = categoryGroupPlaceLists['문화']?.where((item) => categoryCulture.contains(item.types[culture%2])).toList();
                    if(cultureList?.length != 0) {
                      recommendPlaces.add(cultureList![d]);
                      d++;
                      i++;
                    }
                culture++;
              }
            }
            break;
          case '바':
            if(categoryGroupPlaceLists['바'] != null && e < categoryGroupPlaceLists['바']!.length){
              if(i<=placesCounter&&categoryGroupPlaceLists['바']?.length != 0){
                recommendPlaces.add(categoryGroupPlaceLists['바']![e]);
                i++;
                e++;
              }
            }
            break;
          case '어트랙션':
            if(categoryGroupPlaceLists['어트랙션'] != null && f < categoryGroupPlaceLists['어트랙션']!.length){
              if(i<=placesCounter){
                attractionList = categoryGroupPlaceLists['어트랙션']?.where((item) => categoryAttraction.contains(item.types[attraction%3])).toList();
                if(attractionList?.length != 0){
                  recommendPlaces.add(attractionList![f]);
                  f++;
                }
                i++;
                attraction++;
              }
            }
            break;
      }
    }
    sortingCloseDistance(gp, recommendPlaces);
    setOriginPlace(LatLng(gp.latitude, gp.longitude));
    print('추천장소');
    for(int i =0;i<placesCounter+1&& i < recommendPlaces.length;i++){
      print(recommendPlaces[i].name);
    }
    return recommendPlaces;
  }


  sortingCloseDistance(GeoPoint gp, List<Place> recommendPlaces) {
    recommendPlaces.sort((a,b) {
      double distanceA = distanceCalculation(gp.latitude, gp.longitude, a.placeLat, a.placeLng);
      double distanceB = distanceCalculation(gp.latitude, gp.longitude, b.placeLat, b.placeLng);
      return distanceA.compareTo(distanceB);
    });
  }

  double distanceCalculation(double originLat, double originLng, double lat, double lng) {
    final geo = GeolocatorPlatform.instance;
    double result = geo.distanceBetween(originLat, originLng, lat, lng);
    return result;
  }


  drawPolyline(List<Place> recommendPlaces) async{
    for(int i = 0; i < recommendPlaces.length - 1; i++) {
      //출발지가 항상 리스트 맨 처음
      LatLng startLocation = LatLng(recommendPlaces[i].placeLat,recommendPlaces[i].placeLng);
      LatLng endLocation = LatLng(recommendPlaces[i + 1].placeLat, recommendPlaces[i + 1].placeLng);

      List<LatLng> polylineP = await getPolyline(startLocation, endLocation);
      print(polylineP);
      addPolyline(polylineP);
    }
  }

  Future<List<LatLng>> getPolyline(LatLng startL, LatLng endL) async{
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        _apiKey,

      PointLatLng(startL.latitude, startL.longitude),
      PointLatLng(endL.latitude, endL.longitude),

      travelMode: TravelMode.walking,
    );

    polylineCoordinates.addAll(result.points.map(
          (PointLatLng element) => LatLng(element.latitude, element.longitude),
    ));
    return polylineCoordinates;
  }

  addPolyline(List<LatLng> polylineCoordinates) {
    polylineIdCounter++;
    PolylineId id = PolylineId('$polylineIdCounter');
    Polyline newPolyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      color: Colors.blue,
    );
    polylineList[id] = newPolyline;
    print('Added polyline: $newPolyline');
  }
}