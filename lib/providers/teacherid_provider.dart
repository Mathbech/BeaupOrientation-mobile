import 'package:flutter/material.dart';

class TeacherProvider with ChangeNotifier {
  int? _teacherId;

  int? get teacherId => _teacherId;

  void setTeacherId(int teacherId) {
    _teacherId = teacherId;
    notifyListeners();
  }
}