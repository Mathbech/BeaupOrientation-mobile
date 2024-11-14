import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';

class SelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Sélectionnez votre profil', showMenuButton: true),
      drawer: CustomDrawer(),  // Utilise le Drawer personnalisé
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profLogin');
              },
              child: Text('Connexion professeurs'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/studentLogin');
              },
              child: Text('Connexion Étudiants'),
            ),
          ],
        ),
      ),
    );
  }
}
