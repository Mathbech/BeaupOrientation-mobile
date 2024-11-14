import 'package:flutter/material.dart';
import '../routing/routes.dart';

class CustomDrawer extends StatelessWidget {
  bool isProf =
      false; // votre logique pour déterminer si l'utilisateur est un professeur
  bool isEleve =
      true;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Accueil'),
            onTap: () {
              if (isProf) {
                Navigator.pushNamed(context, AppRoutes.profHome);
              } else if (isEleve) {
                Navigator.pushNamed(context, AppRoutes.eleveHome);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text('Carte'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.pathTrackingMap);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Paramètres'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.settings);
            },
          ),
        ],
      ),
    );
  }
}
