import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CustomPolylineLayer extends StatelessWidget {
  final List<LatLng> path;

  const CustomPolylineLayer({required this.path});

  @override
  Widget build(BuildContext context) {
    return PolylineLayer(
      polylines: [
        Polyline(
          points: path,
          strokeWidth: 4.0,
          color: Colors.blue,
        ),
      ],
    );
  }
}
