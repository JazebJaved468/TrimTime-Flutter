import 'package:flutter/material.dart';

class SampleProvider extends ChangeNotifier {
  var userData = {};
  int activeBarbers = 0;
  bool gender = true;

  void incrementActiveBarbers() {
    activeBarbers++;
    notifyListeners();
  }

  void setUserData(Map<String, dynamic> data) {
    userData = data;
    notifyListeners();
  }

  void changeGender() {
    gender = !gender;
    notifyListeners();
  }
}
