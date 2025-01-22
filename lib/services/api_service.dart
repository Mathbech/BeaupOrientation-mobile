import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../shared/api/api_endpoints.dart';
import '../shared/runner.dart';

class ApiService {
  final logger = Logger();

  Future<Runner?> loginWithCode(String code) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.login}');
    logger.i('Sending POST request to $url with body: ${jsonEncode({'code': code})}');
    
    final response = await http.post(
      url,
      body: jsonEncode({'code': code}),
      headers: {'Content-Type': 'application/json'},
    );

    logger.i('Received response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Runner.fromJson(data);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> fetchStudentData(int runnerId) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.runners}$runnerId');
    logger.i('Sending GET request to $url');

    final response = await http.get(url);

    logger.i('Received response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch student data');
    }
  }

  Future<void> saveMarker(Position position, String address, String city, String zipCode, String country, int teacherId) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.addMarkers}');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'latitude': position.latitude.toString(),
          'longitude': position.longitude.toString(),
          'address': address,
          'city': city,
          'zipCode': zipCode,
          'country': country,
          // 'qrCode': qrCode,
          'teacher': teacherId,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to save marker: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to save marker: $e');
    }
  }
}
