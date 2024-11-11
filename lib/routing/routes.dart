import 'package:beauporientation/pages/prof_login.dart';
import 'package:beauporientation/pages/selection_page.dart';
import 'package:beauporientation/pages/student_login.dart';
import 'package:flutter/material.dart';
import '../pages/map.dart';

class AppRoutes {
  static const String home = '/';
  static const String pathTrackingMap = '/Map';
  static const String settings = '/settings';
  static const String profLogin = '/profLogin';
  static const String studentLogin = '/studentLogin';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => SelectionPage(),
      profLogin: (context) => ProfLoginPage(),
      studentLogin: (context) => StudentLoginPage(),
      pathTrackingMap: (context) => const PathTrackingMap(),
    };
  }


  static Widget buildPageWithoutBackButton(Widget page) {
    return WillPopScope(
      onWillPop: () async => false,
      child: page,
    );
  }
}
