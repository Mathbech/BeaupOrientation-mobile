import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/colors.dart';

class CustomMarkerLayer extends StatelessWidget {
  final LatLng currentLocation;

  const CustomMarkerLayer({required this.currentLocation});

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: [
        Marker(
          width: 50.0,
          height: 50.0,
          point: LatLng(currentLocation.latitude, currentLocation.longitude),
          child: Icon(
            Icons.my_location,
            color: CustomColors.marker,
            size: 30.0,
          ),
        ),
      ],
    );
  }
}