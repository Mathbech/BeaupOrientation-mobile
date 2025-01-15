import 'package:beauporientation/pages/login.dart';
import 'package:beauporientation/pages/student/homapge.dart';
import 'package:beauporientation/pages/teachers/homepage.dart';
import 'package:flutter/material.dart';
import '../pages/map.dart';

class AppRoutes {
  static const String home = '/';
  static const String pathTrackingMap = '/Map';
  static const String settings = '/settings';
  static const String profHome = '/profHome';
  static const String eleveHome = '/eleveHome';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => LoginPage(),
      pathTrackingMap: (context) => const PathTrackingMap(),
      profHome: (context) => TeacherHomePage(),
      eleveHome: (context) => StudentHomePage(),
    };
  }


  static Widget buildPageWithoutBackButton(Widget page) {
    return WillPopScope(
      onWillPop: () async => false,
      child: page,
    );
  }
}
