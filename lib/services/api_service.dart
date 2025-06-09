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
    logger.i('Sending POST request to $url with body: ${jsonEncode({
          'code': code
        })}');

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
    final url =
        Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.runners}$runnerId');
    logger.i('Sending GET request to $url');

    final response = await http.get(url);

    logger.i('Received response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch student data');
    }
  }

  Future<void> saveMarker(
    Position position,
    String teacherId,
    String courseId, {
    required String name,
    required int type,
  }) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.addMarkers}');
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'latitude': position.latitude.toString(),
          'longitude': position.longitude.toString(),
          "point": {
            "srid": 4326,
            "type": "Point",
            "coordinates": [position.longitude, position.latitude]
          },
          'teacher': '/api/users/$teacherId',
          'courses': '/api/courses/$courseId',
          'name': name,
          'type': type,
        }),
        headers: {'Content-Type': 'application/ld+json'},
      );

      logger.i('Received response: ${response.statusCode} ${response.body}');

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception(
            'Failed to save marker: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      logger.i('Error : $e');
      throw Exception('Failed to save marker: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchMarkers(int teacherId) async {
    final url = Uri.parse(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.viewMarkers}?courseId=$teacherId');
    logger.i('Sending GET request to $url');

    final response = await http.get(url);

    logger.i('Received response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['member']);
    } else {
      throw Exception('Failed to fetch markers');
    }
  }

  Future<void> sendScan(Map<String, dynamic> data) async {
    final url = Uri.parse(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.scanQRCode}'); // À adapter si besoin
    logger.i('Sending POST request to $url with body: ${jsonEncode(data)}');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'runner_id': data['runner_id'],
        'marker_code': data['marker_code'],
        'scannedAt': data['scannedAt'],
        'point': {
          'srid': 4326,
          'type': 'Point',
          'coordinates': data['point']?['coordinates'] ?? [0, 0],
        },
      }),
    );

    logger.i('Received response: ${response.statusCode} ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de l\'envoi : ${response.statusCode}');
    }
    
  }
}
