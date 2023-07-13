import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

import 'package:nagaja_app/Model/map_model.dart';
import 'package:nagaja_app/Controller/map_controller.dart';

class MapBrowseScreen extends StatefulWidget {
  const MapBrowseScreen({Key? key}) : super(key: key);

  @override
  State<MapBrowseScreen> createState() => _MapBrowseScreenState();
}

class _MapBrowseScreenState extends State<MapBrowseScreen> {
  late GoogleMapController mapController;
  late TextEditingController textController;
  MapController controller = MapController();


  final LatLng _center = const LatLng(37.58638333, 127.0203333);


  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    controller.getPosition().then((position) {
      setState(() {
        controller.model.nowPosition = position;
        _updateCameraPosition(controller.model.nowPosition!);
      });
      controller.getMyAddress().then((myAddress) {
        setState(() {
          controller.model.address = myAddress;
          textController.text = controller.model.address ?? '';
        });
      }).catchError((error) {
        if (kDebugMode) {
          print('Error retrieving address: $error');
        }
      });
    }).catchError((error) {
      if (kDebugMode) {
        print('Error retrieving position: $error');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initText() async {
    String? myAddress = await controller.getMyAddress();
    setState(() {
      controller.model.address = myAddress;
      textController.text = controller.model.address ?? '';
    });
  }

  void _clearSearchResults() {
    setState(() {
      controller.model.showSearchResults = false;
      controller.model.searchResults.clear();
    });
  }

  Future<void> _updateCameraPosition(dynamic latlng) async {
    await mapController.animateCamera(CameraUpdate.newLatLng(
  LatLng(latlng.latitude, latlng.longitude),
    ));
  }

  Future<void> _selectPlace(String placeName, String placeAddress) async {

      controller.model.selectedPlaceName = placeName;
      controller.model.selectedPlaceAddress = placeAddress;
      textController.text = placeName;
      Map<String, dynamic> latLng = await MapController.getLatLngFromAddress(placeAddress);
      controller.model.latitudeP = latLng['latitude'];
      controller.model.longitudeP = latLng['longitude'];

      setState(() {
        controller.model.markers.clear();
        controller.model.markers.add(
          Marker(markerId: const MarkerId('선택된 장소'),
            position: LatLng(controller.model.latitudeP, controller.model.longitudeP),
            infoWindow: InfoWindow(title: placeName, snippet: placeAddress),
          ),
        );
      });
  }

  Future<void> _onSearchPressed() async {
    String searchText = textController.text.trim();
    if(searchText.isNotEmpty){
      await controller.searchPlaces(searchText);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('지도 검색'),
      ),
      body: Column(children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: '장소를 검색하세요.',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _onSearchPressed,
                ),
              ),
              onSubmitted: (_) {
               _onSearchPressed();
                },
              ),
        ),
        if (controller.model.showSearchResults && controller.model.searchResults.isNotEmpty)
          Expanded(
            child: ListView.builder(
              itemCount: controller.model.searchResults.length,
              itemBuilder: (context, index) {
                dynamic result = controller.model.searchResults[index];
                String name = result['name'];
                String address = result['formatted_address'];
                return ListTile(
                  title: Text(name),
                  subtitle: Text(address),
                  onTap: () async {
                    await _selectPlace(name, address);
                    _clearSearchResults();
                    _updateCameraPosition(LatLng(controller.model.latitudeP, controller.model.longitudeP));
                    // Navigator.pop(context,name);
                  },
                );
              },
            ),
          ),
        if (!controller.model.showSearchResults || controller.model.searchResults.isEmpty)
          Expanded(
            child: Stack(children: [
              GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 15.0,
                ),
                markers: controller.model.markers,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                  child: FloatingActionButton(
                    onPressed: () async {
                      if (controller.model.showSearchResults) {
                        _clearSearchResults();
                      } else {
                        mapController.animateCamera(CameraUpdate.newLatLng(
                            LatLng(controller.model.nowPosition!.latitude, controller.model.nowPosition!.longitude)));
                      }
                    },
                    backgroundColor: Colors.white,
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ]),
          ),
      ]),
    );
  }
}
