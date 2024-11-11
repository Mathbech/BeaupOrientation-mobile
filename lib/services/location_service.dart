import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  final Location _location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  Stream<LocationData>? _locationStream;

  // Vérifie et demande les permissions, puis démarre le suivi de la localisation
  Future<bool> checkAndRequestLocationPermission() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return false; // Service de localisation désactivé
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false; // Permission non accordée
      }
    }

    return true; // Autorisation de localisation accordée
  }

  // Commence à suivre la localisation
  Stream<LocationData>? startLocationTracking({int interval = 1000}) {
    _location.changeSettings(interval: interval); // Intervalle de mise à jour
    _locationStream = _location.onLocationChanged;
    return _locationStream;
  }

  // Stoppe le suivi de la localisation
  void stopLocationTracking() {
    _locationStream = null;
  }
}
