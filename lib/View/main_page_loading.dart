import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nagaja_app/View/main_route_page.dart';

import '../Controller/map_controller.dart';
import '../Model/draw_recommend_route.dart';
import '../Model/place_model.dart';



class MainLoadingPage extends StatefulWidget {
  const MainLoadingPage({Key? key}) : super(key: key);

  @override
  _MainLoadingPageState createState() => _MainLoadingPageState();
}

class _MainLoadingPageState extends State<MainLoadingPage> {
  DrawRecommendRoute test = DrawRecommendRoute();
  MapController controller = MapController();
  bool isLoading = true;
  List<String> typeList= [
    'restaurant',
    'cafe',
    'store',
    'museum',
    'library',
    'bar',
    'tourist_attraction',
    'amusement_park',
    'bowling_alley'
  ];
  List<Place> placeInfo=[];

  // 카테고리 그룹명을 변수로 설정
  Map<String, List<Place>> categoryGroupPlaceLists = {
    '음식점': [],
    '카페': [],
    '쇼핑': [],
    '문화': [],
    '바': [],
    '어트랙션': []
  };

  List<String> categoryRestaurant = ['restaurant'];
  List<String> categoryCafe = ['cafe'];
  List<String> categoryShopping = ['store'];
  List<String> categoryCulture = ['museum', 'library'];
  List<String> categoryBar = ['bar'];
  List<String> categoryAttraction = ['tourist_attraction', 'amusement_park', 'bowling_alley'];

  @override
  void initState() {
    super.initState();
  }

  Future<void> getLocation() async {
    var position = await controller.getPosition();
      controller.model.nowPosition = position;
      controller.model.nowPLatLng = LatLng(controller.model.nowPosition!.latitude, controller.model.nowPosition!.longitude);
      print(controller.model.nowPLatLng);
  }

  Future<void> getPlaceInfo() async {
    for (var type in typeList) {
      List<Place> placeInfoFragment;
      placeInfoFragment = await PlacesApi.searchPlaces(
          controller.model.nowPLatLng.latitude,
          controller.model.nowPLatLng.longitude, type);
      placeInfo.addAll(placeInfoFragment);
    }

    categoryGroupPlaceLists['음식점'] = placeInfo
        .where((place) => categoryRestaurant.contains(place.types[0]))
        .toList();
    categoryGroupPlaceLists['카페'] = placeInfo
        .where((place) => categoryCafe.contains(place.types[0]))
        .toList();
    categoryGroupPlaceLists['쇼핑'] = placeInfo
        .where((place) => categoryShopping.contains(place.types[0]))
        .toList();
    categoryGroupPlaceLists['바'] = placeInfo
        .where((place) => categoryBar.contains(place.types[0]))
        .toList();
    categoryGroupPlaceLists['문화'] = placeInfo
        .where((place) => categoryBar.contains(place.types[0]))
        .toList();
    categoryGroupPlaceLists['어트랙션'] = placeInfo
        .where((place) => categoryAttraction.contains(place.types[0]))
        .toList();

    for(var type in categoryGroupPlaceLists.keys){
      categoryGroupPlaceLists[type]?.sort((a,b) => b.rating.compareTo(a.rating));
    }

    setState(() {
      isLoading = false;
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainRoutePage(initialLatLng: controller.model.nowPLatLng, categoryGroupPlaceLists: {
      '음식점': categoryGroupPlaceLists['음식점']!,
      '카페': categoryGroupPlaceLists['카페']!,
      '쇼핑': categoryGroupPlaceLists['쇼핑']!,
      '문화': categoryGroupPlaceLists['문화']!,
      '바': categoryGroupPlaceLists['바']!,
      '어트랙션': categoryGroupPlaceLists['어트랙션']!},)));
  }



  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      getLocation().then((_) {
        return getPlaceInfo();
      }).then((_){
        test.setRecommendPlaces(categoryGroupPlaceLists);
      });
      return WillPopScope(
        onWillPop: () async {
          // 뒤로가기 버튼 동작을 막음
          return false;
        },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SpinKitPianoWave(
            color: Colors.black,
            size: 80.0,
          ),
        ),
      ),
      );
    } else{
      return MainRoutePage(initialLatLng: controller.model.nowPLatLng, categoryGroupPlaceLists: {
        '음식점': categoryGroupPlaceLists['음식점']!,
        '카페': categoryGroupPlaceLists['카페']!,
        '쇼핑': categoryGroupPlaceLists['쇼핑']!,
        '문화': categoryGroupPlaceLists['문화']!,
        '바': categoryGroupPlaceLists['바']!,
        '어트랙션': categoryGroupPlaceLists['어트랙션']!},);
    }
  }
}