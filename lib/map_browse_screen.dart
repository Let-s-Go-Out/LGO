import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

class MapBrowseScreen extends StatefulWidget {
  const MapBrowseScreen({Key? key}) : super(key: key);

  @override
  State<MapBrowseScreen> createState() => _MapBrowseScreenState();
}

class _MapBrowseScreenState extends State<MapBrowseScreen> {
  late GoogleMapController mapController;
  late TextEditingController textController;
  final LatLng _center = const LatLng(37.58638333, 127.0203333);
  Position? _position;
  String? address;
  List<dynamic> searchResults = [];
  bool showSearchResults = false;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    _getPosition().then((position) {
      setState(() {
        _position = position;
        _updateCameraPosition();
      });
      _getMyAddress().then((myAddress) {
        setState(() {
          address = myAddress;
          textController.text = address ?? '';
        });
      }).catchError((error) {
        print('Error retrieving address: $error');
      });
    }).catchError((error) {
      print('Error retrieving position: $error');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initText() async {
    String? myAddress = await _getMyAddress();
    setState(() {
      address = myAddress;
      textController.text = address ?? '';
    });
  }

  Future<Position> _getPosition() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future<String?> _getMyAddress() async {
    if (_position != null) {
      String lat = _position!.latitude.toString();
      String lon = _position!.longitude.toString();
      Response response = await get(Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyAIeZMzg3xE5dYXgiWNoIjDE34R0SzTAzE&language=ko&latlng=${lat},${lon}'));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          String? myAddress =
              data['results'][0]['formatted_address'] as String?;
          print("myAddress: $myAddress");
          return myAddress;
        }
      }
    }
    return null;
  }

  Future<void> searchPlaces(String keyword) async {
    String apiKey = 'AIzaSyAIeZMzg3xE5dYXgiWNoIjDE34R0SzTAzE';
    String baseUrl =
        'https://maps.googleapis.com/maps/api/place/textsearch/json';

    // 검색 요청 URL 생성
    String url = '$baseUrl?key=$apiKey&language=ko&query=$keyword';

    // HTTP 요청 보내기
    Response response = await get(Uri.parse(url));

    // 결과 파싱
    if (response.statusCode == 200) {
      dynamic jsonData = jsonDecode(response.body);
      List<dynamic> results = jsonData['results'];
      setState(() {
        searchResults = results;
        showSearchResults = true;
      });
    } else {
      throw Exception('Failed to search places');
    }
  }

  Future<void> _performSearch() async {
    String searchText = textController.text.trim();
    if (searchText.isNotEmpty) {
      setState(() {
        showSearchResults = true;
      });
    }
  }

  void _clearSearchResults() {
    setState(() {
      showSearchResults = false;
      searchResults.clear();
    });
  }

  void _updateCameraPosition() {
    if (_position != null) {
      mapController.animateCamera(CameraUpdate.newLatLng(
        LatLng(_position!.latitude, _position!.longitude),
      ));
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
                  onPressed: () {
                    String searchText = textController.text.trim();
                    if (searchText.isNotEmpty) {
                      searchPlaces(searchText);
                    }
                  },
                ),
              ),
              onSubmitted: (_) {
                String searchText = textController.text.trim();
                if (searchText.isNotEmpty) {
                  searchPlaces(searchText);
                }
              }),
        ),
        if (showSearchResults && searchResults.isNotEmpty)
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                dynamic result = searchResults[index];
                String name = result['name'];
                String address = result['formatted_address'];
                return ListTile(
                  title: Text(name),
                  subtitle: Text(address),
                  onTap: () {},
                );
              },
            ),
          ),
        if (!showSearchResults || searchResults.isEmpty)
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
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                  child: FloatingActionButton(
                    onPressed: () async {
                      if (showSearchResults) {
                        _clearSearchResults();
                      } else {
                        var gps = await _getPosition();
                        mapController.animateCamera(CameraUpdate.newLatLng(
                            LatLng(_position!.latitude, _position!.longitude)));
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
