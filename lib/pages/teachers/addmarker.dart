import 'package:geolocator/geolocator.dart';
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

  Future<void> _addMarker() async {
    Position position = await _markerAddService.determinePosition();
    String address = await _markerAddService.getAddressFromLatLng(position);

    setState(() {
      _markers.add('Balise ${_markers.length + 1}: $address');
    });
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