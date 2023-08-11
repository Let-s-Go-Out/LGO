import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nagaja_app/Controller/map_controller.dart';
import 'package:snapping_sheet_2/snapping_sheet.dart';
import 'package:provider/provider.dart';
import '../Model/place_model.dart';

class MainRoutePage extends StatefulWidget {
  final LatLng initialLatLng;
  const MainRoutePage({Key? key, required this.initialLatLng}) : super(key: key);

  @override
  _MainRoutePageState createState() => _MainRoutePageState();
}

class _MainRoutePageState extends State<MainRoutePage> {
  late GoogleMapController mapController;
<<<<<<< HEAD
=======

  // final LatLng _center = const LatLng(37.58638333, 127.0203333);
>>>>>>> GaEun
  MapController controller = MapController();
  bool isExpanded = false;
  ScrollController scrollcontroller = ScrollController();
  List<Place> places = [];
  LatLng nowP = LatLng(37.58638333, 127.0203333);
  List<Marker> newMarkers = [];
  Set<Marker> markers = Set<Marker>();
<<<<<<< HEAD
=======
  List<String> placeTypes = ['restaurant', 'cafe', 'park', 'museum'];

  String selectedPlaceType = 'restaurant'; // 초기값을 'restaurant'로 설정
>>>>>>> GaEun

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    nowP = widget.initialLatLng;
=======
    controller.getPosition().then((position) {
      setState(() {
        controller.model.nowPosition = position;
      });
    });
>>>>>>> GaEun
    markers = Set<Marker>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

<<<<<<< HEAD
  Future<void> addMarkersFromPlacesApi() async {
    markers.addAll(newMarkers);
  }

  Future<void> _updateCameraPosition(dynamic latlng, double zoom) async {
    await mapController.animateCamera(CameraUpdate.newLatLngZoom(
      LatLng(latlng.latitude, latlng.longitude),
      zoom,
    ));
=======
  Future<LatLng> _getInitialCameraPosition() async {
    nowP = LatLng(controller.model.nowPosition!.latitude,
        controller.model.nowPosition!.longitude);
    return nowP;
>>>>>>> GaEun
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
        initialSnappingPosition: SnappingPosition.factor(positionFactor: 0.4),
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
<<<<<<< HEAD
            List<Place> places = snapshot.data ?? [];
            markers.clear();
            int hue = 0;
            for (var place in places) {
              hue ++;
              var newMarker = Marker(
                icon: BitmapDescriptor.defaultMarkerWithHue(360-hue*16),
=======
            List<Place> allPlaces = snapshot.data ?? [];
            markers.clear();

            List<Place> filteredPlaces = allPlaces
                .where((place) => place.types.contains(selectedPlaceType))
                .toList();

            for (var place in filteredPlaces) {
              var newMarker = Marker(
>>>>>>> GaEun
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
<<<<<<< HEAD
                SnappingPosition.factor(positionFactor: 0.4),
=======
                SnappingPosition.factor(positionFactor: 0.5),
>>>>>>> GaEun
                child: _buildTourTabContent(),
                grabbingHeight: 50,
                grabbing: GrabbingWidget(),
                sheetBelow: SnappingSheetContent(
                  draggable: (details) => true,
                  child: Container(
<<<<<<< HEAD
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: ListView.separated(
                      itemCount: places.length,
                      itemBuilder: (context, index) {
                        return Material(
                            color: Colors.transparent,
                            child:PlaceCard(
                                place: places[index],
                                onTap: () {
                                  _updateCameraPosition(LatLng(places[index].placeLat, places[index].placeLng), 16.0);
                                  print('PlaceCard tapped: ${places[index].name}');
                                }));
                      },
                      separatorBuilder: (context, index) => const Divider(
                        height: 11.0,
                        color: Colors.grey,
=======
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
                          Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredPlaces.length,
                              itemBuilder: (context, index) {
                                return PlaceCard(place: filteredPlaces[index]);
                              },
                            ),
                          )
                        ],
>>>>>>> GaEun
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }

  Widget _buildTourTabContent() {
<<<<<<< HEAD
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
=======
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
>>>>>>> GaEun
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
<<<<<<< HEAD
    return InkWell(
      onTap: onTap,
      // Call the provided onTap callback when tapped
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
          ],
        ),
=======
    String firstPlaceType = place.types.isNotEmpty ? place.types[0] : 'Unknown';

    return Container(
      padding: EdgeInsets.fromLTRB(15, 5, 15, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 사진 표시
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: place.photoUrls.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Image.network(
                    place.photoUrls[index],
                    width: 120,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
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
            'Place ID: ${place.placeId}',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 5),
          Text(
            'Place LatLng: ${place.placeLat},${place.placeLng}',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 5),
          Text(
            'Place Type: $firstPlaceType',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
>>>>>>> GaEun
      ),
    );
  }
}
