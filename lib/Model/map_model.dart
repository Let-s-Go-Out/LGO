import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapModel {
  Position? nowPosition;
  String? address;
  List<dynamic> searchResults = [];
  bool showSearchResults = false;
  String? selectedPlaceName;
  String? selectedPlaceAddress;
  late LatLng selectedPlaceLatLng;
  Set<Marker> markers = {};
  double latitudeP = 0;
  double longitudeP= 0;

  void updateSearchResults(List<dynamic> results){
    searchResults.clear();
    searchResults.addAll(results);
    showSearchResults = true;
  }
}