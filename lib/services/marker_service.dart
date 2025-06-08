import 'package:geolocator/geolocator.dart';
import 'api_service.dart';

class MarkerService {
  final ApiService _apiService = ApiService();

  // Détermine la position actuelle
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  // Enregistre la balise via une API
  Future<void> saveMarker(
    Position position,
    String teacherId,
    String courseId, {
    required String name,
    required String type,
  }) async {
    // Conversion du type texte en chiffre pour l'API
    int typeInt;
    switch (type) {
      case 'Départ':
        typeInt = 1;
        break;
      case 'Intermédiaire':
        typeInt = 2;
        break;
      case 'Arrivée':
        typeInt = 3;
        break;
      default:
        typeInt = 2; // Valeur par défaut
    }

    await _apiService.saveMarker(
      position,
      teacherId,
      courseId,
      name: name,
      type: typeInt, // On passe le chiffre en string si besoin
    );
  }
}
