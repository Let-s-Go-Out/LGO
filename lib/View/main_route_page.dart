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

  // final LatLng _center = const LatLng(37.58638333, 127.0203333);
=======
>>>>>>> f427a30b008ff1b3c1aae6c53a8d1bea7bc3b049
  MapController controller = MapController();
  bool isExpanded = false;
  ScrollController scrollcontroller = ScrollController();
  List<Place> places = [];
  LatLng nowP = LatLng(37.58638333, 127.0203333);
<<<<<<< HEAD

  List<Marker> newMarkers = [];
  Set<Marker> markers = Set<Marker>();

=======
  List<Marker> newMarkers = [];
  Set<Marker> markers = Set<Marker>();
>>>>>>> f427a30b008ff1b3c1aae6c53a8d1bea7bc3b049

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    controller.getPosition().then((position) {
      setState(() {
        controller.model.nowPosition = position;
      });
    });

    markers = Set<Marker>();

=======
    nowP = widget.initialLatLng;
    markers = Set<Marker>();
>>>>>>> f427a30b008ff1b3c1aae6c53a8d1bea7bc3b049
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

<<<<<<< HEAD
  Future<LatLng> _getInitialCameraPosition() async {
    nowP = LatLng(controller.model.nowPosition!.latitude,
        controller.model.nowPosition!.longitude);
    return nowP;
=======
  Future<void> addMarkersFromPlacesApi() async {
    markers.addAll(newMarkers);
>>>>>>> f427a30b008ff1b3c1aae6c53a8d1bea7bc3b049
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
<<<<<<< HEAD
                  TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
=======
              TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
>>>>>>> f427a30b008ff1b3c1aae6c53a8d1bea7bc3b049
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
        future: PlacesApi.searchPlaces(nowP.latitude, nowP.longitude),
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
            List<Place> places = snapshot.data ?? [];
<<<<<<< HEAD

=======
>>>>>>> f427a30b008ff1b3c1aae6c53a8d1bea7bc3b049
            markers.clear();
            int hue = 0;
            for (var place in places) {
              hue ++;
              var newMarker = Marker(
                icon: BitmapDescriptor.defaultMarkerWithHue(360-hue*16),
                markerId: MarkerId(place.placeId),
                position: LatLng(place.placeLat, place.placeLng),
                infoWindow: InfoWindow(title: place.name),
              );
              markers.add(newMarker);
            }
<<<<<<< HEAD

=======
>>>>>>> f427a30b008ff1b3c1aae6c53a8d1bea7bc3b049
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
                    SnappingPosition.factor(positionFactor: 0.5),
=======
                SnappingPosition.factor(positionFactor: 0.4),
>>>>>>> f427a30b008ff1b3c1aae6c53a8d1bea7bc3b049
                child: _buildTourTabContent(),
                grabbingHeight: 50,
                grabbing: GrabbingWidget(),
                sheetBelow: SnappingSheetContent(
                  draggable: (details) => true,
                  child: Container(
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
<<<<<<< HEAD
    return FutureBuilder<LatLng>(
        future: _getInitialCameraPosition(),
=======
    LatLng target = nowP;
    return FutureBuilder<void>(
        future: addMarkersFromPlacesApi(),
>>>>>>> f427a30b008ff1b3c1aae6c53a8d1bea7bc3b049
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
    return Container(
      padding: EdgeInsets.all(21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
        ],
      ),
    );
  }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// // import 'package:nagaja_app/Controller/map_controller.dart';
// // 문제: 패키지 이름이 각자 다름 (유진 - nagaja_app 이 아니라 lets_go_out)
// // import '../Controller/map_controller.dart'; 이렇게 상대경로(?)로 하면 되려나
//
// import 'package:snapping_sheet_2/snapping_sheet.dart';
//
// import '../Model/place_model.dart';
//
// class MainRoutePage extends StatefulWidget {
//   const MainRoutePage({Key? key}) : super(key: key);
//
//   @override
//   _MainRoutePageState createState() => _MainRoutePageState();
// }
//
// class _MainRoutePageState extends State<MainRoutePage> {
//   late GoogleMapController mapController;
//   // final LatLng _center = const LatLng(37.58638333, 127.0203333);
//   MapController controller = MapController();
//   bool isExpanded = false;
//   ScrollController scrollcontroller = ScrollController();
//   List<Place> places = [];
//   LatLng nowP = LatLng(37.58638333, 127.0203333);
//
//   @override
//   void initState() {
//     super.initState();
//     controller.getPosition().then((position) {
//       setState(() {
//         controller.model.nowPosition = position;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }
//
//   Future<LatLng> _getInitialCameraPosition() async {
//     nowP = LatLng(controller.model.nowPosition!.latitude, controller.model.nowPosition!.longitude);
//     return nowP;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         return true;
//       },
//       child: DefaultTabController(
//         length: 2,
//         child: Scaffold(
//           appBar: AppBar(
//             toolbarHeight: 10,
//             automaticallyImplyLeading: false,
//             backgroundColor: Colors.white,
//             bottom: const TabBar(
//               tabs: [
//                 Tab(
//                   child: Text(
//                     '경로 추천',
//                     style: TextStyle(fontSize: 28),
//                   ),
//                 ),
//                 Tab(
//                   child: Text(
//                     '둘러보기',
//                     style: TextStyle(fontSize: 28),
//                   ),
//                 ),
//               ],
//               indicatorColor: Colors.black,
//               unselectedLabelColor: Colors.grey,
//               unselectedLabelStyle:
//               TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
//               labelColor: Colors.black,
//               labelStyle: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           body: TabBarView(
//             physics: NeverScrollableScrollPhysics(),
//             children: [
//               _buildAIRecommendationTab(),
//               _buildTourTab(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAIRecommendationTab() {
//     return Scaffold(
//       body: SnappingSheet(
//         lockOverflowDrag: true,
//         snappingPositions: [
//           SnappingPosition.factor(
//               positionFactor: 0,
//               grabbingContentOffset: GrabbingContentOffset.top),
//           SnappingPosition.factor(
//               positionFactor: 0.5,
//               snappingCurve: Curves.elasticOut,
//               snappingDuration: Duration(milliseconds: 1750)),
//           SnappingPosition.factor(
//             positionFactor: 0.9,
//           )
//         ],
//         initialSnappingPosition: SnappingPosition.factor(positionFactor: 0.5),
//         child: _buildAIRecommendationContent(),
//         grabbingHeight: 50,
//         grabbing: GrabbingWidget(),
//         sheetBelow: SnappingSheetContent(
//           draggable: (details) => true,
//           child: Container(
//             color: Colors.white,
//             child: ListView(
//               scrollDirection: Axis.vertical,
//               shrinkWrap: true,
//               controller: scrollcontroller,
//               reverse: false,
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.book),
//             label: 'Diary',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Mypage',
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAIRecommendationContent() {
//     return FutureBuilder<LatLng>(
//       future: _getInitialCameraPosition(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (snapshot.hasError) {
//           return Center(
//             child: Text('Error: ${snapshot.error}'),
//           );
//         } else {
//           return GoogleMap(
//             myLocationEnabled: true,
//             myLocationButtonEnabled: false,
//             onMapCreated: _onMapCreated,
//             initialCameraPosition: CameraPosition(
//               target: snapshot.data!,
//               zoom: 15.0,
//             ),
//             markers: {
//               Marker(
//                 markerId: MarkerId('marker_id'),
//                 position: snapshot.data!,
//                 infoWindow: InfoWindow(
//                   title: '현재 위치',
//                   snippet: '',
//                 ),
//               ),
//             },
//           );
//         }
//       },
//     );
//   }
//
//   Widget _buildTourTab() {
//     return FutureBuilder<List<Place>>(
//         future: PlacesApi.searchPlaces(nowP.latitude, nowP.longitude),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           } else {
//             List<Place> places = snapshot.data ?? [];
//             return Scaffold(
//               body: SnappingSheet(
//                 lockOverflowDrag: true,
//                 snappingPositions: [
//                   SnappingPosition.factor(
//                       positionFactor: 0,
//                       grabbingContentOffset: GrabbingContentOffset.top),
//                   SnappingPosition.factor(
//                       positionFactor: 0.5,
//                       snappingCurve: Curves.elasticOut,
//                       snappingDuration: Duration(milliseconds: 1750)),
//                   SnappingPosition.factor(
//                     positionFactor: 0.9,
//                   )
//                 ],
//                 initialSnappingPosition:
//                 SnappingPosition.factor(positionFactor: 0.5),
//                 child: _buildTourTabContent(),
//                 grabbingHeight: 50,
//                 grabbing: GrabbingWidget(),
//                 sheetBelow: SnappingSheetContent(
//                   draggable: (details) => true,
//                   child: Container(
//                     color: Colors.white,
//                     child: ListView.builder(
//                       itemCount: places.length,
//                       itemBuilder: (context, index) {
//                         return PlaceCard(place: places[index]);
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//               bottomNavigationBar: BottomNavigationBar(
//                 items: const <BottomNavigationBarItem>[
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.home),
//                     label: 'Home',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.book),
//                     label: 'Diary',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.person),
//                     label: 'Mypage',
//                   ),
//                 ],
//               ),
//             );
//           }
//         });
//   }
//
//   Widget _buildTourTabContent() {
//     return FutureBuilder<LatLng>(
//       future: _getInitialCameraPosition(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (snapshot.hasError) {
//           return Center(
//             child: Text('Error: ${snapshot.error}'),
//           );
//         } else {
//           return GoogleMap(
//             myLocationEnabled: true,
//             myLocationButtonEnabled: false,
//             onMapCreated: _onMapCreated,
//             initialCameraPosition: CameraPosition(
//               target: snapshot.data!,
//               zoom: 15.0,
//             ),
//             markers: {
//               Marker(
//                 markerId: MarkerId('marker_id'),
//                 position: snapshot.data!,
//                 infoWindow: InfoWindow(
//                   title: '현재 위치',
//                   snippet: '',
//                 ),
//               ),
//             },
//           );
//         }
//       },
//     );
//   }
// }
//
// class GrabbingWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         boxShadow: [
//           BoxShadow(blurRadius: 25, color: Colors.black.withOpacity(0.2)),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             margin: EdgeInsets.only(top: 20),
//             width: 100,
//             height: 7,
//             decoration: BoxDecoration(
//               color: Colors.grey,
//               borderRadius: BorderRadius.circular(5),
//             ),
//           ),
//           Container(
//             color: Colors.grey[200],
//             height: 2,
//             margin: EdgeInsets.all(15).copyWith(top: 0, bottom: 0),
//           )
//         ],
//       ),
//     );
//   }
// }
//
// class PlaceCard extends StatelessWidget {
//   final Place place;
//
//   PlaceCard({required this.place});
//
//   @override
//   Widget build(BuildContext context) {
//     print("출력완료");
//     return Container(
//       padding: EdgeInsets.all(21),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 10),
//           Text(
//             place.name,
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 5),
//           Text(
//             'Place ID: ${place.placeId}', // Display the placeId
//             style: TextStyle(fontSize: 16, color: Colors.grey),
//           ),
//           SizedBox(height: 5),
//           Text(
//             'Place LatLng: ${place.placeLat},${place.placeLng}', // Display the placeId
//             style: TextStyle(fontSize: 16, color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }
// }
=======
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
      ),
    );
  }
>>>>>>> f427a30b008ff1b3c1aae6c53a8d1bea7bc3b049
}
