import 'package:flutter/material.dart';



class TeacherHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Liste d'exemple d'étudiants pour les professeurs
    final List<String> studentsOnActiveCourse = ['Étudiant A', 'Étudiant B', 'Étudiant C'];

    return Scaffold(
      appBar: AppBar(title: Text('Accueil Professeur')),
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