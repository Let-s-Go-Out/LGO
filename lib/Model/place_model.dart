import 'dart:convert';
import 'package:http/http.dart';

class Place {
  final String name;
  final String placeId;
  final double placeLat;
  final double placeLng;
  final List<String> types;
  final List<String> photoUrls; // 사진 URL 리스트

  Place({
    required this.name,
    required this.placeId,
    required this.placeLat,
    required this.placeLng,
    required this.types,
    required this.photoUrls});
}

class PlacesApi {
  static const String _apiKey = 'AIzaSyAIeZMzg3xE5dYXgiWNoIjDE34R0SzTAzE';
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

  static get http => null;

  static Future<List<Place>> searchPlaces(double latitude, double longitude, String type) async {
    final String location = '$latitude,$longitude';
    final String radius = '500'; // Search radius in meters (adjust as needed)

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
          final placeTypes = List<String>.from(placeData['types']); // 장소 타입 추출
          // 사진 정보를 가져오기 위해 Place Details 요청을 보냄
          final detailsUri = Uri.parse(
              'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=photos&key=$_apiKey');
          final detailsResponse = await get(detailsUri);

          if (detailsResponse.statusCode == 200) {
            final detailsData = json.decode(detailsResponse.body);
            if (detailsData['status'] == 'OK') {
              List<String> photoUrls = [];

              int i =3;
              if (detailsData['result']['photos'] != null) {
                for (var photoData in detailsData['result']['photos']) {
                  if (i<=0){
                    break;
                  }
                  final photoReference = photoData['photo_reference'];
                  final photoUrl = 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=120&photoreference=$photoReference&key=$_apiKey';
                  photoUrls.add(photoUrl);
                  i--;
                }
              }
              places.add(
                Place(
                  name: placeName,
                  placeId: placeId,
                  placeLat: placeLat,
                  placeLng: placeLng,
                  types: placeTypes,
                  photoUrls: photoUrls,
                ),
              );
              print(placeName);
            }
          }
        }
          return places;
        } else {
        return places;
      }
    } else {
      throw Exception('Failed to load places');
    }
  }
}