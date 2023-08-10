import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nagaja_app/Controller/map_controller.dart';
import 'package:snapping_sheet_2/snapping_sheet.dart';

import '../Model/place_model.dart';

class MainRoutePage extends StatefulWidget {
  const MainRoutePage({Key? key}) : super(key: key);

  @override
  _MainRoutePageState createState() => _MainRoutePageState();
}

class _MainRoutePageState extends State<MainRoutePage> {
  late GoogleMapController mapController;

  // final LatLng _center = const LatLng(37.58638333, 127.0203333);
  MapController controller = MapController();
  bool isExpanded = false;
  ScrollController scrollcontroller = ScrollController();
  List<Place> places = [];
  LatLng nowP = LatLng(37.58638333, 127.0203333);
  List<Marker> newMarkers = [];
  Set<Marker> markers = Set<Marker>();
  List<String> placeTypes = ['restaurant', 'cafe', 'park', 'museum'];

  String selectedPlaceType = 'restaurant'; // 초기값을 'restaurant'로 설정

  @override
  void initState() {
    super.initState();
    controller.getPosition().then((position) {
      setState(() {
        controller.model.nowPosition = position;
      });
    });
    markers = Set<Marker>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<LatLng> _getInitialCameraPosition() async {
    nowP = LatLng(controller.model.nowPosition!.latitude,
        controller.model.nowPosition!.longitude);
    return nowP;
  }

  Future<void> addMarkersFromPlacesApi() async {
    markers.addAll(newMarkers);
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
        initialSnappingPosition: SnappingPosition.factor(positionFactor: 0.5),
        child: _buildAIRecommendationContent(),
        grabbingHeight: 50,
        grabbing: GrabbingWidget(),
        sheetBelow: SnappingSheetContent(
          draggable: (details) => true,
          child: Container(
            color: Colors.white,
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              controller: scrollcontroller,
              reverse: false,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
      ),
    );
  }

  Widget _buildAIRecommendationContent() {
    return FutureBuilder<LatLng>(
      future: _getInitialCameraPosition(),
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
          return GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: snapshot.data!,
              zoom: 15.0,
            ),
            markers: {
              Marker(
                markerId: MarkerId('marker_id'),
                position: snapshot.data!,
                infoWindow: InfoWindow(
                  title: '현재 위치',
                  snippet: '',
                ),
              ),
            },
          );
        }
      },
    );
  }

  Widget _buildTourTab() {
    return FutureBuilder<List<Place>>(
        future: PlacesApi.searchPlaces(nowP.latitude, nowP.longitude, selectedPlaceType),
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
            List<Place> allPlaces = snapshot.data ?? [];
            markers.clear();

            List<Place> filteredPlaces = allPlaces
                .where((place) => place.types.contains(selectedPlaceType))
                .toList();

            for (var place in filteredPlaces) {
              var newMarker = Marker(
                markerId: MarkerId(place.placeId),
                position: LatLng(place.placeLat, place.placeLng),
                infoWindow: InfoWindow(title: place.name),
              );
              markers.add(newMarker);
            }
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
                SnappingPosition.factor(positionFactor: 0.5),
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
                              itemCount: placeTypes.length,
                              itemBuilder: (context, index) {
                                return Center(
                                  child: Container(
                                    /*height: 30,
                                    width: 50,*/
                                    margin: EdgeInsets.only(left: 10),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        textStyle: const TextStyle(
                                          fontSize: 10,
                                          fontStyle: FontStyle.normal,
                                          color: Colors.white,
                                        ),
                                        padding: EdgeInsets.all(10),
                                        // 선택한 타입에 따라 버튼 스타일 변경
                                        backgroundColor: selectedPlaceType == placeTypes[index]
                                            ? Colors.blue
                                            : Colors.blueGrey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          selectedPlaceType = placeTypes[index];
                                        });
                                      },
                                      child: Text(placeTypes[index].toUpperCase()),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          // 카테고리 별 장소 리스트
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: filteredPlaces.length,
                            itemBuilder: (context, index) {
                              return PlaceCard(place: filteredPlaces[index]);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
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
              ),
            );
          }
        });
  }

  Widget _buildTourTabContent() {
    return FutureBuilder<LatLng>(
        future: _getInitialCameraPosition(), builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (snapshot.hasError) {
        return Center(
          child: Text('Error: ${snapshot.error}'),
        );
      } else {
        LatLng target = snapshot.data!;
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
                return GoogleMap(
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: target,
                    zoom: 15.0,
                  ),
                  markers: markers,
                );
              }
            });
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

  PlaceCard({required this.place});

  @override
  Widget build(BuildContext context) {
    String firstPlaceType = place.types.isNotEmpty ? place.types[0] : 'Unknown';

    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          // 장소 사진 표시
          Container(
            height: 150, // 사진 높이
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: place.photos.length,
              itemBuilder: (context, index) {
                return Image.network(
                  place.photos[index],
                  width: 200, // 사진 너비
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          SizedBox(height: 10),
          Text(
            place.name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            'Place ID: ${place.placeId}', // Display the placeId
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 5),
          Text(
            'Place LatLng: ${place.placeLat},${place.placeLng}',
            // Display the placeId
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 5),
          Text(
            'Place Type: $firstPlaceType',
            // Display the type
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
