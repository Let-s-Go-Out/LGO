/*<<<<<<< HEAD
// 사용자 경로 정보 입력 시 입력한 출발지 기준 주변 장소 지도 + 목록 화면에 나타낼 때, 장소 관련 model

class Place {
  final String placeId;
  final String name;
  final double placeLat;
  final double placeLng;

  Place({
    required this.placeId,
    required this.name,
    required this.placeLat,
    required this.placeLng,
  });
}
=======*/
import 'dart:convert';

import 'package:http/http.dart';

class Place {
  final String name;
  final String placeId;
  final double placeLat;
  final double placeLng;

  Place({required this.name, required this.placeId, required this.placeLat, required this.placeLng});
}

class PlacesApi {
  static const String _apiKey = 'AIzaSyAIeZMzg3xE5dYXgiWNoIjDE34R0SzTAzE';
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

  static get http => null;

  static Future<List<Place>> searchPlaces(double latitude, double longitude) async {
    final String location = '$latitude,$longitude';
    final String radius = '500'; // Search radius in meters (adjust as needed)
    final String type = 'restaurant'; // You can change the type to fit your needs

    final Uri uri = Uri.parse('$_baseUrl?key=$_apiKey&location=$location&radius=$radius&type=$type');

    final response = await get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<Place> places = [];

      if (data['status'] == 'OK') {
        for (var placeData in data['results']) {
          final placeName = placeData['name'];
          final placeId = placeData['place_id'];
          final placeLat = placeData['geometry']['location']['lat'];
          final placeLng = placeData['geometry']['location']['lng'];
          places.add(Place(name: placeName, placeId: placeId, placeLat: placeLat, placeLng: placeLng));
        }
      }
      return places;
    } else {
      throw Exception('Failed to load places');
    }
  }
}
