import 'package:beauporientation/widgets/custom_app_bar.dart';
import 'package:beauporientation/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/runner_provider.dart';

class StudentHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Récupérez les données directement depuis le Provider
    final runner = Provider.of<RunnerProvider>(context, listen: false).runner;

    if (runner == null) {
      // Gérer le cas où le runner est null (par exemple, rediriger vers une autre page)
      return Scaffold(
        appBar: CustomAppBar(title: 'Erreur', showMenuButton: true),
        body: Center(child: Text('Aucun coureur trouvé')),
      );
    }

    final courseNumber = runner.course; // Exemple : Assurez-vous que ces champs existent
    final runnerNumber = runner.name;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Coureur: $runnerNumber',
        showMenuButton: true,
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Course: $courseNumber', style: TextStyle(fontSize: 18)),
            Text('Numéro de Coureur: $runnerNumber', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
