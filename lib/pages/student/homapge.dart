import 'package:beauporientation/widgets/custom_app_bar.dart';
import 'package:beauporientation/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class StudentHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Informations en dur pour les étudiants
    final int courseNumber = 1;
    final int runnerNumber = 42;
    final int beaconsToFind = 5;

    return Scaffold(
      appBar: CustomAppBar(title: 'Accueil Étudiant', showMenuButton: true),
      drawer: CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Course: $courseNumber', style: TextStyle(fontSize: 18)),
            Text('Numéro de Coureur: $runnerNumber', style: TextStyle(fontSize: 18)),
            Text('Nombre de Balises à trouver: $beaconsToFind', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
