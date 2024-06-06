import 'package:flutter/material.dart';

class SampleProvider with ChangeNotifier {
  late String uid;
  int activeBarbers = 0;
  bool gender = true;
  late Map<String, dynamic> barberAvailability;

  bool? isProvidingHaircut = false;
  bool? isProvidingShave = false;
  bool? isProvidingBeardTrim = false;
  bool? isProvidingMassage = false;

// CIP : CAll IN PROGRESS
  bool updateSlotsCIP = false;
  bool updateDaysCIP = false;
  bool signInCIP = false;

  void incrementActiveBarbers() {
    activeBarbers++;
    notifyListeners();
  }

  // void setUserData(Map<String, dynamic> data) {
  //   userData = data;
  //   notifyListeners();
  // }

  void setUserId({required String userId}) {
    uid = userId;
    notifyListeners();
  }

  void changeGender() {
    gender = !gender;
    notifyListeners();
  }

  void setIsProvidingHaircut(bool value) {
    isProvidingHaircut = value;
    notifyListeners();
  }

  void setIsProvidingShave(bool value) {
    isProvidingShave = value;
    notifyListeners();
  }

  void setIsProvidingBeardTrim(bool value) {
    isProvidingBeardTrim = value;
    notifyListeners();
  }

  void setIsProvidingMassage(bool value) {
    isProvidingMassage = value;
    notifyListeners();
  }

  updateBarberSlotsAvailability(
      {required String day, required int slotIndex, required bool value}) {
    barberAvailability[day]['slots'][slotIndex]['isAvailable'] = value;

    notifyListeners();
  }

  updateBarberDaysAvailability({required String day, required bool value}) {
    barberAvailability[day]['isAvailable'] = value;

    notifyListeners();
  }

  setUpdateSlotsCIP(bool value) {
    updateSlotsCIP = value;
    notifyListeners();
  }

  setUpdateDaysCIP(bool value) {
    updateDaysCIP = value;
    notifyListeners();
  }

  setSignInCIP(bool value) {
    signInCIP = value;
    notifyListeners();
  }

  // barberAvailability = '';

  // notifyListeners();
}
