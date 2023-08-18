import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:nagaja_app/Model/map_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController{
  static const String apiKey = 'AIzaSyARTEVA-q6Nnuxlcnlf4hzSUus3SFUOxkI';

  MapModel model = MapModel();
  Position? get nowPosition => model.nowPosition;
  String? get address => model.address;
  List<dynamic> get searchResults => model.searchResults;
  bool get showSearchResults => model.showSearchResults;
  String? get selectedPlaceName => model.selectedPlaceName;
  String? get selectedPlaceAddress => model.selectedPlaceAddress;
  LatLng get selectedPlaceLatLng => model.selectedPlaceLatLng;

  Future<Position> getPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    model.nowPosition = position;
    return position;
  }

  Future<String?> getMyAddress() async {
    if (model.nowPosition != null) {
      String lat = model.nowPosition!.latitude.toString();
      String lon = model.nowPosition!.longitude.toString();
      Response response = await get(Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?key=$apiKey&language=ko&latlng=$lat,$lon'));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          String? myAddress =
          data['results'][0]['formatted_address'] as String?;
          print("myAddress: $myAddress");

          model.selectedPlaceAddress = myAddress!;
          model.selectedPlaceName = "현재 위치";

          return myAddress;
        }
      }
    }
    return null;
  }

  Future<String?> getLatLngToAddress() async {
    if (model.selectedPlaceLatLng != null) {
      String lat = model.selectedPlaceLatLng.latitude.toString();
      String lon = model.selectedPlaceLatLng.longitude.toString();
      Response response = await get(Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?key=$apiKey&language=ko&latlng=$lat,$lon'));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          String? LatLngAddress = data['results'][0]['formatted_address'] as String?;
          String? LatLngName = data['results'][0]['address_components'][0]['long_name'] as String?;
          print("LatLngAddress: $LatLngAddress");

          model.selectedPlaceAddress = LatLngAddress!;
          model.selectedPlaceName = LatLngName!;

          return LatLngAddress;
        }
      }
    }
    return null;
  }

  Future<void> searchPlaces(String keyword) async {
    String apiKey = 'AIzaSyBrK8RWyR1_3P7M7yjNiJ8xyXTAuFpeLlM';
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
      model.searchResults = results;
      model.showSearchResults = true;
    } else {
      throw Exception('Failed to search places');
    }
  }

  static Future<Map<String, dynamic>> getLatLngFromAddress(String address) async {
    String formattedAddress = Uri.encodeComponent(address);
    String url = 'https://maps.googleapis.com/maps/api/geocode/json?address=$formattedAddress&key=$apiKey';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      if (data['results'] != null && data['results'].isNotEmpty) {
        double lat = data['results'][0]['geometry']['location']['lat'];
        double lng = data['results'][0]['geometry']['location']['lng'];
        return {'latitude': lat, 'longitude': lng};
      }
    }
    return {'latitude': null, 'longitude': null};
  }
}