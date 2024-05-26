import 'package:flutter/material.dart';

class SampleProvider extends ChangeNotifier {
  int activeBarbers = 0;

  void incrementActiveBarbers() {
    activeBarbers++;
    notifyListeners();
  }
}
