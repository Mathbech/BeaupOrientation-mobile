import 'package:beauporientation/widgets/custom_app_bar.dart';
import 'package:beauporientation/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../providers/runner_provider.dart';

class StudentHomePage extends StatelessWidget {
  Future<Map<String, dynamic>> fetchStudentData(BuildContext context) async {
    final runner = Provider.of<RunnerProvider>(context, listen: false).runner;
    if (runner == null) {
      throw Exception('Runner not found');
    }

    // Remplacez cette ligne par l'appel API réel pour obtenir les données de l'étudiant
    final data = await ApiService().fetchStudentData(runner.id);

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Accueil Étudiant', showMenuButton: true),
      drawer: CustomDrawer(),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchStudentData(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Aucune donnée disponible'));
          }

          final data = snapshot.data!;
          final courseNumber = data['course'];
          final runnerNumber = data['id'];

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Course: $courseNumber', style: TextStyle(fontSize: 18)),
                Text('Numéro de Coureur: $runnerNumber', style: TextStyle(fontSize: 18)),
              ],
            ),
          );
        },
      ),
    );
  }
}
