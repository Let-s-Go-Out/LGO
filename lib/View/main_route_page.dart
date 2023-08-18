import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nagaja_app/Controller/map_controller.dart';
import 'package:snapping_sheet_2/snapping_sheet.dart';
import '../Model/place_model.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'diary_page.dart';
import 'main_page.dart';
import 'my_page.dart';

class MainRoutePage extends StatefulWidget {
  final LatLng initialLatLng;
  final Map<String, List<Place>> categoryGroupPlaceLists;
  final List<Place> recommendPlaces;
  final GeoPoint selectP;

  const MainRoutePage(
      {Key? key,
      required this.initialLatLng,
      required this.categoryGroupPlaceLists,
      required this.recommendPlaces,
      required this.selectP})
      : super(key: key);

  @override
  _MainRoutePageState createState() => _MainRoutePageState();
}

class _MainRoutePageState extends State<MainRoutePage> {
  late GoogleMapController mapController;
  MapController controller = MapController();
  // DrawRecommendRoute drawRoute = DrawRecommendRoute();
  PolylinePoints polylinePoints = PolylinePoints();
  bool isExpanded = false;
  ScrollController scrollcontroller = ScrollController();
  List<Place> places = [];
  LatLng nowP = LatLng(37.58638333, 127.0203333);
  LatLng selectP = LatLng(37.58638333, 127.0203333);
  List<Marker> newMarkers = [];
  Set<Marker> markers = Set<Marker>();

  String selectedPlaceType = 'restaurant'; // 초기값을 'restaurant'로 설정

  // 카테고리 그룹명을 변수로 설정
  Map<String, List<Place>> categoryGroupPlaceLists = {};

  List<Place> allPlaces = [];

  int _selectedIndex = 0;

  List<Place> recommendPlaces=[];

  Map<PolylineId, Polyline> polylineList = {};
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};

  final List<Widget> _navIndex = [
    MainPage(),
    DiaryPage(),
    MyPage(),
  ];

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => MainPage(),
            transitionDuration: Duration(seconds: 0), // 애니메이션 시간을 0으로 설정
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => DiaryPage(),
            transitionDuration: Duration(seconds: 0), // 애니메이션 시간을 0으로 설정
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => MyPage(),
            transitionDuration: Duration(seconds: 0), // 애니메이션 시간을 0으로 설정
          ),
        );
        break;
    // 다른 인덱스에 대한 처리를 추가할 수 있습니다.
    }
  }

  @override
  void initState() {
    super.initState();
    nowP = widget.initialLatLng;
    recommendPlaces = widget.recommendPlaces;
    categoryGroupPlaceLists = widget.categoryGroupPlaceLists;
    selectP = LatLng(widget.selectP.latitude,widget.selectP.longitude);
    createMarkers(widget.recommendPlaces);
    drawPolyline(widget.recommendPlaces);
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

  void createMarkers(List<Place> places) {
    int hue = 0;
    for(var place in places){
      hue++;
      Marker marker = Marker(
        markerId: MarkerId(place.placeId),
        position: LatLng(place.placeLat, place.placeLng),
        icon: BitmapDescriptor.defaultMarkerWithHue(360 - hue * 35),
        infoWindow: InfoWindow(title: place.name),
      );
        newMarkers.add(marker);
  }
    markers.addAll(newMarkers);
  }

  void drawPolyline(List<Place> recommendPlaces) async{
    for(int i = 0; i < recommendPlaces.length - 1; i++) {
      //출발지가 항상 리스트 맨 처음
      LatLng startLocation = LatLng(recommendPlaces[i].placeLat,recommendPlaces[i].placeLng);
      LatLng endLocation = LatLng(recommendPlaces[i + 1].placeLat, recommendPlaces[i + 1].placeLng);
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyBrK8RWyR1_3P7M7yjNiJ8xyXTAuFpeLlM',

        PointLatLng(startLocation.latitude, startLocation.longitude),
        PointLatLng(endLocation.latitude, endLocation.longitude),

        travelMode: TravelMode.walking,
      );
      polylineCoordinates.addAll(result.points.map(
            (PointLatLng element) => LatLng(element.latitude, element.longitude),
      ));
    }
    PolylineId id = PolylineId('poly');
    Polyline newPolyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      color: Colors.purpleAccent,
      width: 5,
    );
    setState(() {
      _polylines.add(newPolyline);
    });
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
          bottomNavigationBar: BottomNavigationBar(
            fixedColor: Colors.black,
            unselectedItemColor: Colors.blueGrey,
            showSelectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Diary',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Mypage',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onNavTapped,
          ),
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
    int itemCount = recommendPlaces.length-1;
    double listViewHeight = 20.0 + 110.0 * itemCount; // 리스트뷰 스크롤 가능 높이

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
                  Text(
                    '추천하는 나들이 경로입니다.',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                    ),
                  ),
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
                          List<Place> selectedCategoryPlaces = recommendPlaces ?? [];
                          return SizedBox(
                            height: listViewHeight, // 리스트뷰 스크롤 가능 높이 길이
                            child: ListView.builder(
                                primary: false,
                                shrinkWrap: true, // 리스트뷰 크기 고정
                                itemCount: recommendPlaces.length-1, // 경로 추천 장소 개수 설정
                                itemBuilder: (context, index) {
                                  int order = index + 1;
                                  return RecommendPlaceCard(
                                    place: recommendPlaces[order],
                                    order: order, // 순서 표시할 수 있는 매개변수 추가
                                    onTap: () {
                                      // snapping sheet에서 장소 탭 -> 카메라 위치 - 임의의 좌표로 설정함
                                      _updateCameraPosition(recommendPlaces[order].latlng, 16.0);
                                      print('PlaceCard tapped: ${recommendPlaces[order].name}');
                                    },
                                  );
                                }),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAIRecommendationContent() {
      return GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: selectP,
          zoom: 15.0,
        ),
        markers: markers,
        polylines:_polylines,
      );
    // }});
  }

  Widget _buildTourTab() {
    markers.clear();
    
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
        initialSnappingPosition: SnappingPosition.factor(positionFactor: 0.4),
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
                        String groupName =
                            categoryGroupPlaceLists.keys.toList()[index];
                        List<Place> groupCategories =
                            categoryGroupPlaceLists[groupName]!;
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
                                      color: isSelectedGroup
                                          ? Colors.black
                                          : Colors.white10,
                                    )),
                                textStyle: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                padding: EdgeInsets.all(10),
                                backgroundColor: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedPlaceType = groupName;
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
                    height: MediaQuery.of(context).size.height * 0.8,
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
                          List<Place> selectedCategoryPlaces =
                              categoryGroupPlaceLists[selectedPlaceType] ?? [];
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: selectedCategoryPlaces.length,
                            itemBuilder: (context, index) {
                              return PlaceCard(
                                  place: selectedCategoryPlaces[index],
                                  onTap: () {
                                    _updateCameraPosition(
                                        LatLng(
                                            selectedCategoryPlaces[index]
                                                .placeLat,
                                            selectedCategoryPlaces[index]
                                                .placeLng),
                                        16.0);
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
    LatLng target = selectP;
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
            List<Place> selectedCategoryPlaces =
                categoryGroupPlaceLists[selectedPlaceType] ?? [];
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
        });
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
                      fontSize: 12.0),
                  valueLabelRadius: 10,
                  starSpacing: 2,
                  maxValueVisibility: false,
                  valueLabelVisibility: true,
                  animationDuration: Duration(milliseconds: 1000),
                  valueLabelPadding:
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
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
                itemCount: place.photoUrls.isNotEmpty ? place.photoUrls.length : 1,
                itemBuilder: (context, index) {
                  if (place.photoUrls.isEmpty) {
                    return Container(
                      margin: EdgeInsets.only(right: 5),
                      width: 100,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      // 대체 텍스트
                      child: Center(
                        child: Text("No Image"),
                      ),
                    );
                  } else {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey, // Border의 색상 설정
                          width: 2, // Border의 두께 설정
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      margin: EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        child: Image.network(
                          place.photoUrls[index],
                          width: 100,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }
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

class RecommendPlaceCard extends StatelessWidget {
  final Place place;
  final int order;
  final VoidCallback onTap;

  RecommendPlaceCard({required this.place, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // 장소 카테고리 변수 설정
    //String firstPlaceType = place.types.isNotEmpty ? place.types[0] : 'Unknown';
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Container(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 순서 원 + 실선 표시
              Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerLeft, // 왼쪽 정렬
                    child: Column(
                      children: [
                        // 원
                        Column(
                          children: [
                            //SizedBox(height: 10,),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Color(0xffff7b7b),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.7),
                                      blurRadius: 2.0,
                                      spreadRadius: 0.0,
                                      offset: const Offset(0,7),
                                    )
                                  ]
                              ),
                              child: Center(
                                child: Text(
                                  // 순서 출력(추천 경로 개수 반영)
                                  '$order',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        //Spacer(),
                        // 실선
                        Container(
                          height: 70,
                          width: 3.5,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  )
              ),
              // 장소 사진
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  width: 85,
                  height: 100,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(16))
                  ),

                  // 사진 1개 불러오기
                  child: place.photoUrls.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                          child: Image.network(
                            place.photoUrls.first,
                            width: 85,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                        width: 85,
                        height: 100,
                        child: Center(
                          child: Text("No Image", style: TextStyle(fontSize: 10)),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3,),
              // 장소이름 + 타입 + 별점
              Expanded(
                flex: 4,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.only(top: 12, bottom: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // 장소 이름 불러오기
                        Flexible(
                          flex: 2,
                          child: Text(
                            place.name,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),),
                        // 장소 타입
                        Flexible(
                          flex: 1,
                          child: Text(
                            place.types[0],
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          // 장소 타입 불러오기
                        ),
                        // 별점
                        Flexible(
                          flex: 1,
                          child: RatingStars(
                            // 별점 불러오기
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
                          ),),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}