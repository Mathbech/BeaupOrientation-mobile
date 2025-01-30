import 'package:beauporientation/services/api_service.dart';
import 'package:beauporientation/theme/colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import '../../services/marker_add_service.dart';

class AddMarkerPage extends StatefulWidget {
  const AddMarkerPage({super.key});

  @override
  _AddMarkerPageState createState() => _AddMarkerPageState();
}

class _AddMarkerPageState extends State<AddMarkerPage> {
  final List<String> _markers = [];
  final MarkerAddService _markerAddService = MarkerAddService();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchMarkers();
  }

  Future<void> _fetchMarkers() async {
    try {
      List<Map<String, dynamic>> markers = await _apiService.fetchMarkers();
      setState(() {
        _markers.clear();
        for (var marker in markers) {
          _markers.add('Lat: ${marker['latitude']}, Lng: ${marker['longitude']}, Marker ID: ${marker['id']}');
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Une erreur s\'est produite lors de la récupération des balises'),
          backgroundColor: CustomColors.error,
        ),
      );
    }
  }

  Future<void> _addMarker() async {
    try {
      Position position = await _markerAddService.determinePosition();
      String teacherId = '2'; // Remplacez par l'ID réel du professeur

      await _markerAddService.saveMarker(position, teacherId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Marker saved successfully!'),
          backgroundColor: CustomColors.success,
        ),
      );

      _fetchMarkers(); // Refresh the markers list after adding a new marker
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Une erreur s\'est produite'),
          backgroundColor: CustomColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Balisage', showMenuButton: true),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _addMarker,
              child: Text('Ajouter un marqueur'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _markers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_markers[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
