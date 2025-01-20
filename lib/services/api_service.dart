import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../shared/api/api_endpoints.dart';
import '../shared/runner.dart';
import '../shared/api/api_response.dart';

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
}
