import 'package:beauporientation/widgets/custom_app_bar.dart';
import 'package:beauporientation/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';



class TeacherHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Liste d'exemple d'étudiants pour les professeurs
    final List<String> studentsOnActiveCourse = ['Étudiant A', 'Étudiant B', 'Étudiant C'];

    return Scaffold(
      appBar: CustomAppBar(title: 'Accueil Profeseur', showMenuButton: true),
      drawer: CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Étudiants sur la course active:', style: TextStyle(fontSize: 18)),
            ...studentsOnActiveCourse.map((student) => Text(student)).toList(),
          ],
        ),
      ),
    );
  }
}