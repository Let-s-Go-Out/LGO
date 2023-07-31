import 'dart:convert';

class Place {
  final String name;
  final String placeId;

  Place({required this.name, required this.placeId});
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

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<Place> places = [];

      if (data['status'] == 'OK') {
        for (var placeData in data['results']) {
          final placeName = placeData['name'];
          final placeId = placeData['place_id'];
          places.add(Place(name: placeName, placeId: placeId));
        }
      }
      return places;
    } else {
      throw Exception('Failed to load places');
    }
  }
}