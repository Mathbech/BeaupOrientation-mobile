
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import '../theme/theme.dart';

class PathTrackingMap extends StatefulWidget {
  const PathTrackingMap({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PathTrackingMapState createState() => _PathTrackingMapState();
}

class _PathTrackingMapState extends State<PathTrackingMap> {
  late Location location;
  late LocationData currentLocation;
  late List<LatLng> path;
  bool isTracking = false;

  @override
  void initState() {
    super.initState();
    location = Location();
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
      appBar: AppBar(
        title: const Text('Beaup\'orientation'),
        backgroundColor: Color(CustomTheme.primaryColor.value),
      ),
      // ignore: unnecessary_null_comparison
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(currentLocation.latitude!, currentLocation.longitude!),
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: path,
                      strokeWidth: 4.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 50.0,
                      height: 50.0,
                      point: LatLng(currentLocation.latitude!, currentLocation.longitude!),
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.red,
                        size: 30.0,
                      ),
                    ),
                  ],
                ),
              ]
            ),
    );
  }
}
