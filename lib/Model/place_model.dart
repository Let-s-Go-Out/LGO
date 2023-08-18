import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

//place model 수정
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

    distance = distanceCalculation(placeLat, placeLng);
    latlng = LatLng(placeLat, placeLng);
  }

  double distanceCalculation(double lat, double lng) {
    final geo = GeolocatorPlatform.instance;

    //사용자 설정 출발지 위치 좌표 >> controller.model.nowPLatLng 값
    //수정
    double originLat = 37.591054;
    double originLng = 127.022626;

    double result = geo.distanceBetween(originLat, originLng, lat, lng);

    return result;
  }

  get distanceFromOrigin => distance;
  get location => latlng;
}

class PlacesApi {
  static const String _apiKey = 'AIzaSyBrK8RWyR1_3P7M7yjNiJ8xyXTAuFpeLlM';
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
          int i =0;
          for (var placeData in data['results']) {
            if(i<10) {
              i++;
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
                    for (var photoData in detailsData['result']['photos']) {
                      final photoReference = photoData['photo_reference'];
                      final photoUrl = 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=120&photoreference=$photoReference&key=$_apiKey';
                      photoUrls.add(photoUrl);
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
            }else{
              break;
            }
          }
          return places;
        } else {
          print('API response status is not OK: ${data['status']}');
          if('${data['status']}' == 'ZERO_RESULTS'){
            Future.delayed(Duration(seconds: 1), () {
              print('Delayed print after 1 second');
            });
            return[];
          }
          return [];
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
