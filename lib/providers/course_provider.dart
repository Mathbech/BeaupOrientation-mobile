import 'package:flutter/material.dart';

class CourseProvider with ChangeNotifier {
  int _courseId = 0;

  int get courseId => _courseId;

  void setCourseId(int courseId) {
    _courseId = courseId;
    notifyListeners();
  }
}