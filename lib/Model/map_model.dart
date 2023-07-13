import 'package:geolocator/geolocator.dart';

class MapModel {
  Position? nowPosition;
  String? address;
  List<dynamic> searchResults = [];
  bool showSearchResults = false;
  String? selectedPlaceName;
  String? selectedPlaceAddress;

  void updateSearchResults(List<dynamic> results){
    searchResults.clear();
    searchResults.addAll(results);
    showSearchResults = true;
  }
}