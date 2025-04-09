import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  static const String _apiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

  Future<List<Map<String, dynamic>>> findNearbyHospitals(LatLng location) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?location=${location.latitude},${location.longitude}'
                '&radius=5000&type=hospital&key=$_apiKey')
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return _parsePlaces(data['results']);
    } else {
      throw Exception('Failed to load hospitals');
    }
  }

  Future<List<Map<String, dynamic>>> findNearbyDermatologists(LatLng location) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?location=${location.latitude},${location.longitude}'
                '&radius=5000&keyword=dermatologist&key=$_apiKey')
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return _parsePlaces(data['results']);
    } else {
      throw Exception('Failed to load dermatologists');
    }
  }

  List<Map<String, dynamic>> _parsePlaces(List<dynamic> places) {
    return places.map((place) {
      return {
        'name': place['name'],
        'address': place['vicinity'],
        'location': LatLng(
          place['geometry']['location']['lat'],
          place['geometry']['location']['lng'],
        ),
        'rating': place['rating']?.toDouble(),
        'open_now': place['opening_hours']?['open_now'],
      };
    }).toList();
  }
}
