import 'package:geolocator/geolocator.dart';
import 'api_service.dart';

class ScanService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> sendScan({
    required String runnerId,
    required String markerCode,
    required Position position,
  }) async {
    final data = {
      "runner_id": runnerId,
      "marker_code": markerCode,
      "scannedAt": DateTime.now().toUtc().toIso8601String(),
      "point": {
        "srid": 4326,
        "type": "Point",
        "coordinates": [position.longitude, position.latitude]
      }
    };

    return await _apiService.sendScan(data);
  }
}
