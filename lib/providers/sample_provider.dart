import 'package:flutter/material.dart';
import 'package:trim_time/controller/firestore.dart';

class SampleProvider with ChangeNotifier {
  late String uid;
  late Map<String, dynamic> userData;
  bool gender = true;
  int activeBarbers = 0;
  late Map<String, dynamic> barberAvailability;

  late List inAppfavouriteList = getInAppFavouriteList();

  bool? isProvidingHaircut = false;
  bool? isProvidingShave = false;
  bool? isProvidingBeardTrim = false;
  bool? isProvidingMassage = false;

  Map<String, dynamic> selectedBarber = {};

  getInAppFavouriteList() {
    List tempData = [];
    print('favorites in fucntion -----> $allBarbers');

    for (var barber in allBarbers) {
      print('user data favourites -----> ${userData['favourites']}');
      if (userData['favourites'].contains(barber['uid'])) {
        print('true');
        tempData.add(barber);
      }
    }

    print('temp list ----> $tempData');
    return tempData;

    // return allBarbers
    //     .where((element) => userData['favourites'].contains(element['uid']))
    //     .toList();
    // notifyListeners();
  }

  updateInAppFavouriteList() {
    inAppfavouriteList = getInAppFavouriteList();
    notifyListeners();
  }

// CIP : CAll IN PROGRESS
  bool updateSlotsCIP = false;
  bool updateDaysCIP = false;
  bool signInCIP = false;

  late List<Map<String, dynamic>> allBarbers = [];
  late List haircutFilterBarbers = getHaircutFilterBarbers();
  late List shaveFilterBarbers = getShaveFilterBarbers();
  late List beardTrimFilterBarbers = getBeardTrimFilterBarbers();
  late List massageFilterBarbers = getMassageFilterBarbers();

  void setAllBarbers(List<Map<String, dynamic>> data) {
    allBarbers = data;
    // notifyListeners();
  }

  List getHaircutFilterBarbers() {
    List tempData = [];

    for (var barber in allBarbers) {
      if (barber['services']['1']['isProviding']) {
        tempData.add(barber);
      }
    }

    return tempData;
  }

  List getMassageFilterBarbers() {
    List tempData = [];

    for (var barber in allBarbers) {
      if (barber['services']['4']['isProviding']) {
        tempData.add(barber);
      }
    }

    return tempData;
  }

  List getShaveFilterBarbers() {
    List tempData = [];

    for (var barber in allBarbers) {
      if (barber['services']['2']['isProviding']) {
        tempData.add(barber);
      }
    }

    return tempData;
    // notifyListeners();
  }

  List getBeardTrimFilterBarbers() {
    List tempData = [];

    for (var barber in allBarbers) {
      if (barber['services']['3']['isProviding']) {
        tempData.add(barber);
      }
    }

    return tempData;
    // notifyListeners();
  }

  removeBarberFromFavourites(String barberId) {
    int index = allBarbers.indexWhere((element) => element['uid'] == barberId);
    allBarbers[index]['isFavourite'] = false;
    print("user data favourites -----> ${userData['favourites']}");

    userData['favourites'].remove(barberId);
    notifyListeners();
  }

  addBarberToFavourites(String barberId) {
    // print('user data in state -----> $userData');
    int index = allBarbers.indexWhere((element) => element['uid'] == barberId);
    allBarbers[index]['isFavourite'] = true;

    print("user data favourites -----> ${userData['favourites']}");
    userData['favourites'].add(barberId);
    notifyListeners();
  }

  setSelectedBarber(String barberId) {
    selectedBarber =
        allBarbers.firstWhere((element) => element['uid'] == barberId);

    // notifyListeners();
  }

  void incrementActiveBarbers() {
    activeBarbers++;
    notifyListeners();
  }

  void setUserData(Map<String, dynamic> data) {
    userData = data;
    // notifyListeners();
  }

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
