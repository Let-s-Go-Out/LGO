import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nagaja_app/Controller/map_controller.dart';
import 'package:nagaja_app/Model/draw_recommend_route.dart';
import 'package:snapping_sheet_2/snapping_sheet.dart';
//import 'package:provider/provider.dart';
import '../Model/place_model.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

class MainRoutePage extends StatefulWidget {
  final LatLng initialLatLng;
  final Map<String, List<Place>> categoryGroupPlaceLists;
  const MainRoutePage({Key? key, required this.initialLatLng, required this.categoryGroupPlaceLists}) : super(key: key);

  @override
  _MainRoutePageState createState() => _MainRoutePageState();
}

class _MainRoutePageState extends State<MainRoutePage> {
  late GoogleMapController mapController;
  MapController controller = MapController();
  bool isExpanded = false;
  ScrollController scrollcontroller = ScrollController();
  List<Place> places = [];
  LatLng nowP = LatLng(37.58638333, 127.0203333);
  List<Marker> newMarkers = [];
  Set<Marker> markers = Set<Marker>();
  /*List<String> placeTypes = [
    'restaurant',
    'cafe',
    'bakery',
    'clothing_store',
    'department_store',
    'shopping_mall',
    'jewelry_store',
    'shoe_store',
    'store',
    'museum',
    'movie_theater',
    'library',
    'bar',
    'tourist_attraction',
    'amusement_park',
    'bowling_alley'
  ];*/
  String selectedPlaceType = 'restaurant';// 초기값을 'restaurant'로 설정

  // 카테고리 그룹명을 변수로 설정
  Map<String, List<Place>> categoryGroupPlaceLists = {};

  List<Place> allPlaces = [];

  //List<Place> selectedCategoryPlaces = categoryGroupPlaceLists[selectedPlaceType] ?? [];
  //DrawRecommendRoute routeDraw = DrawRecommendRoute(selectedCategoryPlaces);
  //routeDraw.drawPolyline();

  @override
  void initState() {
    super.initState();
    nowP = widget.initialLatLng;
    categoryGroupPlaceLists = widget.categoryGroupPlaceLists;
    markers = Set<Marker>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> addMarkersFromPlacesApi() async {
    markers.addAll(newMarkers);
  }

  Future<void> _updateCameraPosition(dynamic latlng, double zoom) async {
    await mapController.animateCamera(CameraUpdate.newLatLngZoom(
      LatLng(latlng.latitude, latlng.longitude),
      zoom,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 10,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            bottom: const TabBar(
              tabs: [
                Tab(
                  child: Text(
                    '경로 추천',
                    style: TextStyle(fontSize: 28),
                  ),
                ),
                Tab(
                  child: Text(
                    '둘러보기',
                    style: TextStyle(fontSize: 28),
                  ),
                ),
              ],
              indicatorColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              unselectedLabelStyle:
              TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
              labelColor: Colors.black,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              _buildAIRecommendationTab(),
              _buildTourTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAIRecommendationTab() {
    return Scaffold(
      body: Stack(
        children: [
          SnappingSheet(
            lockOverflowDrag: true,
            snappingPositions: [
              SnappingPosition.factor(
                  positionFactor: 0,
                  grabbingContentOffset: GrabbingContentOffset.top),
              SnappingPosition.factor(
                  positionFactor: 0.5,
                  snappingCurve: Curves.elasticOut,
                  snappingDuration: Duration(milliseconds: 1750)),
              SnappingPosition.factor(
                positionFactor: 0.9,
              )
            ],
            initialSnappingPosition: SnappingPosition.factor(positionFactor: 0.4),
            child: _buildAIRecommendationContent(),
            grabbingHeight: 50,
            grabbing: GrabbingWidget(),
            sheetBelow: SnappingSheetContent(
              draggable: (details) => true,
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10),
                      // 추천 멘트
                      Text('OO님의 선택에 따른 나들이 추천경로입니다.'),
                      SizedBox(height: 10),
                      // 추천 경로
                      Container(
                        child: FutureBuilder<void>(
                          future: addMarkersFromPlacesApi(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else {
                              List<Place> selectedCategoryPlaces = categoryGroupPlaceLists[selectedPlaceType] ?? [];
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: 5, // 경로 추천 장소 개수
                                  itemBuilder: (context, index) {
                                    return RecommendPlaceCard(
                                      place: selectedCategoryPlaces[index],
                                      onTap: () {
                                        // snapping sheet에서 장소 탭 -> 카메라 위치 - 임의의 좌표 설정
                                        _updateCameraPosition(LatLng(41.40338, 2.17403), 16.0);
                                        print('PlaceCard tapped: ${selectedCategoryPlaces[index].name}');
                                      },
                                    );
                                  });
                            }
                          },
                        ),
                      ),

                      /*// 추천 경로 -> 클래스 틀
                      Container(
                        height: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // 장소 이름
                            Text('스타벅스'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // 장소 사진
                                Text('장소 사진'),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    // 장소 타입
                                    Text('type'),
                                    // 별점
                                    Text('별점'),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      )*/
                    ],
                  ),
                ),
              ),
            ),
          ),
          // 하단 고정 - 다이어리에 저장하기 버튼
          Positioned(
            bottom: 10, // 원하는 여백 조정
            left: 30,
            right: 30,
            child: ElevatedButton(
              child: Text('다이어리에 저장하기'),
              style: ElevatedButton.styleFrom(
                primary: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)
                ),
              ),
              onPressed: () {
                // 다이어리에 저장하기 로직 구현
              },
            ),
          ),
        ],
      ),

    );
  }

  Widget _buildAIRecommendationContent() {
          return GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: nowP,
              zoom: 15.0,
            ),
            markers: {
              Marker(
                markerId: MarkerId('marker_id'),
                position: nowP,
                infoWindow: InfoWindow(
                  title: '현재 위치',
                  snippet: '',
                ),
              ),
            },
            //
            // polylines: Set<Polyline>.of(test.polylineList.values),
          );
  }

  //임의 변경
  Widget _buildTourTab() {
            markers.clear();
            /*List<Place> filteredPlaces = allPlaces
                .where((place) => place.types.contains(selectedPlaceType))
                .toList();
            int hue = 0;
            for (var place in filteredPlaces) {
              hue ++;
              var newMarker = Marker(
                icon: BitmapDescriptor.defaultMarkerWithHue(360-hue*16),
                markerId: MarkerId(place.placeId),
                position: LatLng(place.placeLat, place.placeLng),
                infoWindow: InfoWindow(title: place.name),
              );
              markers.add(newMarker);
            }*/
            // 선택된 장소 유형에 기반한 장소 목록 가져오기
            //List<Place> selectedCategoryPlaces = categoryGroupPlaceLists[selectedPlaceType] ?? [];

            return Scaffold(
              body: SnappingSheet(
                lockOverflowDrag: true,
                snappingPositions: [
                  SnappingPosition.factor(
                      positionFactor: 0,
                      grabbingContentOffset: GrabbingContentOffset.top),
                  SnappingPosition.factor(
                      positionFactor: 0.5,
                      snappingCurve: Curves.elasticOut,
                      snappingDuration: Duration(milliseconds: 1750)),
                  SnappingPosition.factor(
                    positionFactor: 0.9,
                  )
                ],
                initialSnappingPosition:
                SnappingPosition.factor(positionFactor: 0.4),
                child: _buildTourTabContent(),
                grabbingHeight: 50,
                grabbing: GrabbingWidget(),
                sheetBelow: SnappingSheetContent(
                  draggable: (details) => true,
                  child: Container(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 10),
                          // 장소 카테고리 버튼
                          SizedBox(
                            height: 50.0,
                            child: ListView.builder(
                              physics: ClampingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: categoryGroupPlaceLists.length,
                              itemBuilder: (context, index) {
                                String groupName = categoryGroupPlaceLists.keys.toList()[index];
                                List<Place> groupCategories = categoryGroupPlaceLists[groupName]!;
                                bool isSelectedGroup = groupName == selectedPlaceType;
                                return Center(
                                  child: Container(
                                    /*height: 30,
                                    width: 50,*/
                                    margin: EdgeInsets.only(left: 10),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        onPrimary: Colors.black,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(50),
                                            side: BorderSide(
                                              width: 2,
                                              // 버튼 선택 유무에 따른 버튼 스타일 변경
                                              color: isSelectedGroup ? Colors.black : Colors.white10,
                                            )
                                        ),
                                        textStyle: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          //color: Colors.black,
                                        ),
                                        padding: EdgeInsets.all(10),
                                        backgroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          selectedPlaceType = groupName;
                                          //selectedPlaceType = categoryGroupPlaceLists.keys.elementAt(index);
                                        });
                                      },
                                      child: Text(groupName),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          // 카테고리 별 장소 리스트
                          Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: FutureBuilder<void>(
                              future: addMarkersFromPlacesApi(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text('Error: ${snapshot.error}'),
                                    );
                                  } else {
                                    List<Place> selectedCategoryPlaces = categoryGroupPlaceLists[selectedPlaceType] ?? [];
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: selectedCategoryPlaces.length,
                                      itemBuilder: (context, index) {
                                        return PlaceCard(
                                            place: selectedCategoryPlaces[index], onTap: () {
                                          _updateCameraPosition(LatLng(selectedCategoryPlaces[index].placeLat, selectedCategoryPlaces[index].placeLng), 16.0);
                                          print('PlaceCard tapped: ${selectedCategoryPlaces[index].name}');
                                        });
                                      },
                                    );
                                  }
                                },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
  }

  Widget _buildTourTabContent() {
        LatLng target = nowP;
        return FutureBuilder<void>(
            future: addMarkersFromPlacesApi(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                // 선택된 카테고리 그룹에 해당하는 장소 리스트 가져오기
                List<Place> selectedCategoryPlaces = categoryGroupPlaceLists[selectedPlaceType] ?? [];
                return GoogleMap(
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: target,
                    zoom: 15.0,
                  ),
                  //markers: markers,
                  // 선택된 카테고리 그룹의 장소 리스트로 마커 추가
                  markers: selectedCategoryPlaces.map((place) {
                    return Marker(
                      markerId: MarkerId(place.placeId),
                      position: LatLng(place.placeLat, place.placeLng),
                      infoWindow: InfoWindow(title: place.name),
                    );
                  }).toSet(),
                );
              }
            }
                );
              }
}


class GrabbingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(blurRadius: 25, color: Colors.black.withOpacity(0.2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            width: 100,
            height: 7,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Container(
            color: Colors.grey[200],
            height: 2,
            margin: EdgeInsets.all(15).copyWith(top: 0, bottom: 0),
          )
        ],
      ),
    );
  }
}

class PlaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback onTap;

  PlaceCard({required this.place, required this.onTap});

  @override
  Widget build(BuildContext context) {
    String firstPlaceType = place.types.isNotEmpty ? place.types[0] : 'Unknown';
    return InkWell(
        onTap: onTap,
        child: Container(
      padding: EdgeInsets.fromLTRB(15, 5, 15, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            place.name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$firstPlaceType',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              // 별점 표시
              RatingStars(
                value: place.rating,
                starCount: 5,
                starSize: 10,
                valueLabelColor: const Color(0xff9b9b9b),
                valueLabelTextStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'WorkSans',
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0
                ),
                valueLabelRadius: 10,
                starSpacing: 2,
                maxValueVisibility: false,
                valueLabelVisibility: true,
                animationDuration: Duration(milliseconds: 1000),
                valueLabelPadding: const EdgeInsets.symmetric(
                    vertical: 1, horizontal: 8),
                valueLabelMargin: const EdgeInsets.only(right: 8),
                starOffColor: const Color(0xffe7e8ea),
                starColor: Colors.yellow,
              ),
            ],
          ),
          SizedBox(height: 8),
          // 사진 표시
          Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: place.photoUrls.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Image.network(
                    place.photoUrls[index],
                    width: 100,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    ),
    );
  }
}

class RecommendPlaceCard extends StatelessWidget{
  final Place place;
  final VoidCallback onTap;

  RecommendPlaceCard({required this.place, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // 장소 카테고리 변수 설정
    //String firstPlaceType = place.types.isNotEmpty ? place.types[0] : 'Unknown';
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          // 순서 원 + 실선 표시
          SizedBox(width: 50),
          Container(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 장소 사진
                Container(
                  width: 95,
                  height: 95,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(16))
                  ),
                  // 사진 1개 불러오기
                  /*child: ListView.builder(
                        //scrollDirection: Axis.horizontal,
                        itemCount: 1, // 사진 1개만 불러오기
                        //itemCount: place.photoUrls.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(right: 5),
                            child: Image.network(
                              place.photoUrls[index],
                              width: 100,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),*/
                ),
                SizedBox(width: 13,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 22),
                    // 장소 이름
                    Text(
                      // 장소 이름 불러오기
                      place.name,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 7),
                    // 장소 타입
                    Text(
                      '카페',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    // 장소 타입 불러오기
                    /*Text(
                         '$firstPlaceType',
                         style: TextStyle(fontSize: 13, color: Colors.grey),
                       ),*/
                    SizedBox(height: 20),
                    // 별점
                    RatingStars(
                      // 별점 불러오기
                      //value: place.rating,
                      value: 4.3,
                      starCount: 5,
                      starSize: 10,
                      valueLabelColor: const Color(0xff9b9b9b),
                      valueLabelTextStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'WorkSans',
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 12.0
                      ),
                      valueLabelRadius: 10,
                      starSpacing: 2,
                      maxValueVisibility: false,
                      valueLabelVisibility: true,
                      animationDuration: Duration(milliseconds: 1000),
                      valueLabelPadding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 8),
                      valueLabelMargin: const EdgeInsets.only(right: 8),
                      starOffColor: const Color(0xffe7e8ea),
                      starColor: Colors.yellow,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}