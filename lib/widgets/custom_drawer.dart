import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/runner_provider.dart';
import '../routing/routes.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final runner = Provider.of<RunnerProvider>(context).runner;
    final bool isProf = runner?.isTeacher ?? false;
    final bool isEleve = runner != null && !runner.isTeacher;

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
              } else {
                return;
              }
            },
          ),
          if (isProf) ...[
            ListTile(
              leading: Icon(Icons.school),
              title: Text('Teacher Section'),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.addMarker);
              },
            ),
          ],

          ListTile(
            leading: Icon(Icons.map),
            title: Text('Carte'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.pathTrackingMap);
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.settings),
          //   title: Text('Paramètres'),
          //   onTap: () {
          //     Navigator.pushNamed(context, AppRoutes.settings);
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Déconnexion'),
            onTap: () {
              // Logique de déconnexion
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
