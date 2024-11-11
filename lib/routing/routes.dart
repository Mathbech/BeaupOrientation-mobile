import 'package:flutter/material.dart';
import '../pages/map.dart';

class AppRoutes {
  static const String home = '/';
  static const String pathTrackingMap = '/pathTrackingMap';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const PathTrackingMap(),
    };
  }
}
