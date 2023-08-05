import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PlacesSearchScreen extends StatefulWidget {
  @override
  _PlacesSearchScreenState createState() => _PlacesSearchScreenState();
}

class _PlacesSearchScreenState extends State<PlacesSearchScreen> {
  String _apiKey = 'AIzaSyAIeZMzg3xE5dYXgiWNoIjDE34R0SzTAzE';
  String _searchQuery = '';
  List<dynamic> _searchResults = [];

  void _onSearchButtonPressed() async {
    List<dynamic> results = await searchPlaces(_apiKey, _searchQuery);
    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Places Search'),
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (value) => _searchQuery = value,
            onSubmitted: (value) => _onSearchButtonPressed(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                dynamic place = _searchResults[index];
                String name = place['name'];
                String category = getPlaceCategory(place);

                return ListTile(
                  title: Text(name),
                  subtitle: Text(category),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<dynamic>> searchPlaces(String apiKey, String query) async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$apiKey'));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      return decodedData['results'];
    } else {
      throw Exception('Failed to load places');
    }
  }

  String getPlaceCategory(dynamic place) {
    // 장소 유형(카테고리)을 추출하는 함수를 작성합니다.
    // 예를 들어, "types" 필드에서 가장 첫 번째 유형을 추출하는 방식으로 구현해보겠습니다.
    if (place.containsKey('types') && place['types'] is List) {
      List<dynamic> types = place['types'];
      if (types.isNotEmpty) {
        return types.first;
      }
    }
    return 'Unknown Category';
  }
}
