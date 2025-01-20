import 'dart:convert';
import 'package:http/http.dart' as http;
import '../shared/api/api_endpoints.dart';
import '../shared/runner.dart';
import '../shared/api/api_response.dart';

class ApiService {
  Future<Runner?> loginWithCode(String code) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.login}');
    final response = await http.post(
      url,
      body: jsonEncode({'code': code}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        return Runner.fromJson(data);
      } else {
        throw Exception(data['message']);
      }
    } else {
      throw Exception('Failed to login');
    }
  }
}
