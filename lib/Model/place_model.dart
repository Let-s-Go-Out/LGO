import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

class Place {
  final String name;
  final String placeId;
  final double placeLat;
  final double placeLng;
  final double rating; // 평점 정보
  final List<String> types;
  final List<String> photoUrls;
  LatLng? latlng;
  double? distance;

  Place({
    required this.name,
    required this.placeId,
    required this.placeLat,
    required this.placeLng,
    required this.rating,
    required this.types,
    required this.photoUrls}) {

    latlng = LatLng(placeLat, placeLng);
  }
  get location => latlng;
}

class PlacesApi {
  static const String _apiKey = 'AIzaSyARTEVA-q6Nnuxlcnlf4hzSUus3SFUOxkI';
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

  static get http => null;

  static Future<List<Place>> searchPlaces(double latitude, double longitude,
      String type) async {
    final String location = '$latitude,$longitude';
    final String radius = '500'; // Search radius in meters (adjust as needed)

    final Uri uri = Uri.parse(
        '$_baseUrl?key=$_apiKey&location=$location&radius=$radius&type=$type');
    try {
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
              final placeTypes = List<String>.from(
                  placeData['types']); // 장소 타입 추출
              // 사진 정보를 가져오기 위해 Place Details 요청을 보냄
              final detailsUri = Uri.parse(
                  'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=photos,rating&key=$_apiKey');
              final detailsResponse = await get(detailsUri);

              if (detailsResponse.statusCode == 200) {
                final detailsData = json.decode(detailsResponse.body);
                if (detailsData['status'] == 'OK') {
                  List<String> photoUrls = [];
                  // 평점 정보 가져오기
                  //double rating = detailsData['result']['rating'] ?? 0.0;
                  dynamic ratingData = detailsData['result']['rating'];

                  double? rating; // Nullable로 선언

                  if (ratingData is int) {
                    rating = ratingData.toDouble();
                  } else if (ratingData is double) {
                    rating = ratingData;
                  }

                  if (detailsData['result']['photos'] != null) {
                    int j =0;
                      for (var photoData in detailsData['result']['photos']) {
                        if(j<3) {
                          j++;
                        final photoReference = photoData['photo_reference'];
                        final photoUrl = 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=120&photoreference=$photoReference&key=$_apiKey';
                        photoUrls.add(photoUrl);
                      }else {
                          break;
                    }
                    }
                  }
                  places.add(
                    Place(
                      name: placeName,
                      placeId: placeId,
                      placeLat: placeLat,
                      placeLng: placeLng,
                      rating: rating ?? 0.0,
                      //rating이 null인 경우 기본값 0.0으로 설정
                      types: placeTypes,
                      photoUrls: photoUrls,
                    ),
                  );
                  print(placeName);
                }
              }
          }
          return places;
        } else if (data['status'] == 'ZERO_RESULTS') {
          // Return an empty list when there are no results
          return [];
        } else {
          print('API response status is not OK: ${data['status']}');
            return[];
          }
      } else {
        print('API request failed with status code: ${response.statusCode}');
        return [];
      }
    }
    catch (e) {
      print('API request error: $e');
      return [];
    }
  }
}
