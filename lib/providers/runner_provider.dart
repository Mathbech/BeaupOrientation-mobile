import 'package:flutter/material.dart';
import '../shared/runner.dart';

class RunnerProvider with ChangeNotifier {
  Runner? _runner;

  Runner? get runner => _runner;

  void setRunner(Runner runner) {
    _runner = runner;
    notifyListeners();
  }
}