import 'package:beauporientation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import '../services/location_service.dart';
import '../services/api_service.dart';
import '../widgets/polylines_layer.dart';
import '../widgets/marker_layer.dart';
import '../widgets/custom_drawer.dart';

class PathTrackingMap extends StatefulWidget {
  const PathTrackingMap({super.key});

  @override
  _PathTrackingMapState createState() => _PathTrackingMapState();
}

class _PathTrackingMapState extends State<PathTrackingMap> {
  final LocationService _locationService = LocationService();
  final ApiService _apiService = ApiService();

  LocationData? currentLocation;
  late List<LatLng> path;
  List<LatLng> markerPoints = [];

  @override
  void initState() {
    super.initState();
    path = [];
    _initializeLocationTracking();
    _fetchMarkers();
  }

  Future<void> _initializeLocationTracking() async {
    bool locationGranted =
        await _locationService.checkAndRequestLocationPermission();

    if (locationGranted) {
      _locationService.startLocationTracking()?.listen((locData) {
        setState(() {
          currentLocation = locData;
          path.add(LatLng(locData.latitude!, locData.longitude!));
        });
      });
    } else {
      print("Autorisation de localisation refusée");
    }
  }

  Future<void> _fetchMarkers() async {
    try {
      final courseId = 1;
      final markers = await _apiService.fetchMarkers(courseId);
      setState(() {
        markerPoints = markers
            .where((m) => m['latitude'] != null && m['longitude'] != null)
            .map<LatLng>((m) => LatLng(
                  double.tryParse(m['latitude'].toString()) ?? 0.0,
                  double.tryParse(m['longitude'].toString()) ?? 0.0,
                ))
            .toList();
      });
    } catch (e) {
      print('Erreur lors du chargement des marqueurs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Carte de suivi', showMenuButton: true),
      drawer: CustomDrawer(),
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!),
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                ),
                CustomPolylineLayer(path: path),
                CustomMarkerLayer(
                  currentLocation: LatLng(
                    currentLocation!.latitude!,
                    currentLocation!.longitude!,
                  ),
                ),
                MarkerLayer(
                  markers: markerPoints
                      .map((point) => Marker(
                            point: point,
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 32,
                            ),
                          ))
                      .toList(),
                ),

              ],
            ),
    );
  }

  @override
  void dispose() {
    _locationService.stopLocationTracking();
    super.dispose();
  }
}
