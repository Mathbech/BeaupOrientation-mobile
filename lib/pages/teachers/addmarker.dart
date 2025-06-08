import 'package:flutter/material.dart';
import 'package:beauporientation/providers/teacherid_provider.dart';
import 'package:beauporientation/providers/course_provider.dart';
import 'package:beauporientation/services/api_service.dart';
import 'package:beauporientation/theme/colors.dart';
import 'package:geolocator/geolocator.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../../services/marker_service.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

class AddMarkerPage extends StatefulWidget {
  const AddMarkerPage({super.key});

  @override
  _AddMarkerPageState createState() => _AddMarkerPageState();
}

class _AddMarkerPageState extends State<AddMarkerPage> {
  final List<String> _markers = [];
  final MarkerService _markerService = MarkerService();
  final ApiService _apiService = ApiService();
  final Logger _logger = Logger();

  final TextEditingController _nameController = TextEditingController();
  String _selectedType = 'Intermédiaire';

  final List<String> _markerTypes = ['Départ', 'Arrivée', 'Intermédiaire'];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchMarkers();
  }

  Future<void> _fetchMarkers() async {
    try {
      final courseId =
          Provider.of<CourseProvider>(context, listen: false).courseId;
      List<Map<String, dynamic>> markers =
          await _apiService.fetchMarkers(courseId);
      setState(() {
        _markers.clear();
        for (var marker in markers) {
          _markers
              .add('Lat: ${marker['latitude']}, Lng: ${marker['longitude']}');
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Une erreur s\'est produite lors de la récupération des balises'),
          backgroundColor: CustomColors.error,
        ),
      );
    }
  }

  Future<void> _addMarker() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez entrer un nom pour le marqueur'),
          backgroundColor: CustomColors.error,
        ),
      );
      return;
    }
    try {
      final teacherId =
          Provider.of<TeacherProvider>(context, listen: false).teacherId;
      final courseId =
          Provider.of<CourseProvider>(context, listen: false).courseId;

      Position position = await _markerService.determinePosition();

      await _markerService.saveMarker(
        position,
        teacherId.toString(),
        courseId.toString(),
        name: _nameController.text,
        type: _selectedType,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Marker saved successfully!'),
          backgroundColor: CustomColors.success,
        ),
      );

      _nameController.clear();
      setState(() {
        _selectedType = 'Intermédiaire'; // <-- Fix: use uppercase "I"
      });

      _fetchMarkers(); // Refresh the markers list
    } catch (e, stackTrace) {
      _logger.e('Erreur dans _addMarker', error: e, stackTrace: stackTrace);
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
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nom du marqueur',
              ),
            ),
            DropdownButton<String>(
              value: _selectedType,
              items: _markerTypes
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
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
