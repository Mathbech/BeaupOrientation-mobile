import 'package:beauporientation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import '../widgets/polylines_layer.dart';
import '../widgets/marker_layer.dart';

class PathTrackingMap extends StatefulWidget {
  const PathTrackingMap({super.key});

  @override
  _PathTrackingMapState createState() => _PathTrackingMapState();
}

class _PathTrackingMapState extends State<PathTrackingMap> {
  late Location location;
  LocationData? currentLocation;
  late List<LatLng> path;
  bool isTracking = false;

  Future<void> initializeLocation() async {
    currentLocation = await location.getLocation(); // Assuming getLocation() is an async method
    setState(() {}); // Triggers a rebuild when currentLocation is ready
  }

  @override
  void initState() {
    super.initState();
    location = Location();

    initializeLocation();
    path = [];
    startLocationTracking();
  }

  void startLocationTracking() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.changeSettings(interval: 1000); // Update every second
    location.onLocationChanged.listen((LocationData locData) {
      setState(() {
        currentLocation = locData;
        path.add(LatLng(locData.latitude!, locData.longitude!));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Carte de suivi'),
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
              ],
            ),
    );
  }
}
