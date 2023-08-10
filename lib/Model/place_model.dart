import 'dart:convert';

import 'package:http/http.dart';

class Place {
  final String name;
  final String placeId;
  final double placeLat;
  final double placeLng;
  final List<String> types;
  final List<String> photos;
  final List<String> photosLink;

  Place({
    required this.name,
    required this.placeId,
    required this.placeLat,
    required this.placeLng,
    required this.types,
    required this.photos,
    required this.photosLink,});
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
          final placePhoto = List<String>.from(placeData['photos']['photo_reference']);

          places.add(
            Place(
              name: placeName,
              placeId: placeId,
              placeLat: placeLat,
              placeLng: placeLng,
              types: placeTypes,
              photos: placePhoto,
              photosLink: placePhoto,
            ),
          );
          print(placeName);
        }
      }
      int i = 1;
      for (var place in places) {
        var photoReference = places[i].photos;
        final Uri uri = Uri.parse('https://maps.googleapis.com/maps/api/place/photo?key=$_apiKey&maxwidth=400&photoreference=$photoReference');

        final response = await get(uri);
        if (response.statusCode == 200) {
          // 사진의 URL을 가져와서 리스트에 추가
          places[i].photosLink.add(response.request!.url.toString());
        }
        i++;
      }
      return places;
    } else {
      throw Exception('Failed to load places');
    }
  }

//   static Future<Place> getPlaceDetails(String placeId) async {
//     final Uri uri = Uri.parse('https://maps.googleapis.com/maps/api/place/details/json?key=$_apiKey&place_id=$placeId');
//
//     final response = await get(uri);
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//
//       if (data['status'] == 'OK') {
//         final placeData = data['result'];
//         final placeName = placeData['name'];
//         final placeId = placeData['place_id'];
//         final placeLat = placeData['geometry']['location']['lat'];
//         final placeLng = placeData['geometry']['location']['lng'];
//         final placeTypes = List<String>.from(placeData['types']);
//         final List<String> photoReferences = List<String>.from(placeData['photos'])
//             .map((photo) => photo['photo_reference'])
//             .toList();
//
//         // 사진 URL을 가져오는 함수
//         List<String> photos = await getPlacePhotos(photoReferences);
//
//         return Place(
//           name: placeName,
//           placeId: placeId,
//           placeLat: placeLat,
//           placeLng: placeLng,
//           types: placeTypes,
//           photos: photos,
//         );
//       }
//     }
//     throw Exception('Failed to get place details');
//   }
//
//   static Future<List<String>> getPlacePhotos(List<String> photoReferences) async {
//     List<String> photos = [];
//
//     for (var photoReference in photoReferences) {
//       final Uri uri = Uri.parse('https://maps.googleapis.com/maps/api/place/photo?key=$_apiKey&maxwidth=400&photoreference=$photoReference');
//
//       final response = await get(uri);
//       if (response.statusCode == 200) {
//         // 사진의 URL을 가져와서 리스트에 추가
//         photos.add(response.request!.url.toString());
//       }
//     }
//
//     return photos;
//   }
}