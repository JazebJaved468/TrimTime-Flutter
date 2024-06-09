import 'package:flutter/material.dart';
import 'package:trim_time/controller/firestore.dart';
import 'package:intl/intl.dart';

class SampleProvider with ChangeNotifier {
  late String uid;
  late Map<String, dynamic> userData;
  bool signInCIP = false;
  bool gender = true;
  int activeBarbers = 0;
  late Map<String, dynamic> barberAvailability;

  late List inAppfavouriteList = getInAppFavouriteList();

  bool? isProvidingHaircut = false;
  bool? isProvidingShave = false;
  bool? isProvidingBeardTrim = false;
  bool? isProvidingMassage = false;

// CIP : CAll IN PROGRESS
  bool updateSlotsCIP = false;
  bool updateDaysCIP = false;
  bool createBookingCIP = false;

  // Client side States
  Map<String, dynamic> selectedBarber = {};
  String selectedService = '';
  DateTime selectedDate = DateTime.now();
  Map selectedSlot = {};
  late List slotsToShow = getSlotsToShow();

  getBarberServicesForBarberProfile() {
    String serviceName = '';
    List tempList = [];
    Map<String, dynamic> servicesFromDb = selectedBarber['services'];
    servicesFromDb.forEach((key, value) {
      if (value['isProviding']) {
        if (key == '1') {
          serviceName = 'Haircut';
        } else if (key == '2') {
          serviceName = 'Shave';
        } else if (key == '3') {
          serviceName = 'Beard Trim';
        } else if (key == '4') {
          serviceName = 'Massage';
        }

        tempList.add({
          'serviceName': serviceName,
          'price': value['price'],
          'serviceId': key,
        });
      }
    });

    print('\ntemp list of services ----> $tempList  ');

    return tempList;
  }

  updateSelectedSlot(Map slot) {
    selectedSlot = slot;
    notifyListeners();
  }

  updateSelectedDate(DateTime date) {
    selectedDate = date;
    selectedSlot = {};
    notifyListeners();
  }

  updateSlotsToShow() {
    slotsToShow = getSlotsToShow();
    notifyListeners();
  }

  getSlotsToShow() {
    List tempSlotsList = [];

    print('in updaet slots to show func');

    print('selected date ----> ${selectedDate.toIso8601String()}');

    selectedBarber['availability'].forEach((date, info) {
      // print('date ----> $date');
      var fomattedDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
      var selectedDateFormatted = DateFormat('dd-MM-yyyy').format(selectedDate);

      if (selectedDateFormatted == fomattedDate) {
        // print('date matched');
        if (selectedBarber['availability'][date]['isAvailable']) {
          {
            selectedBarber['availability'][date]['slots'].forEach((slot) {
              if (slot['isAvailable'] && slot['isBooked'] == false) {
                tempSlotsList.add(slot);
              }
            });
            // print('barber available on that day ----> $date');
            // barberAvailability = info;
          }
          // barberAvailability = info;
        } else {
          tempSlotsList = [];
        }
        // if (slot['isAvailable'] && slot['isBooked'] == false) {
        //   tempSlotsList.add(slot);
        // }

        //  slotsToShow = tempSlotsList;

        // print('slots list length ----> ${tempSlotsList.length}');
      }
    });

    // bool isAvailable = selectedBarber['availability']
    //     [selectedDate.toIso8601String()]['isAvailable'];

    // print('is available on taht day ----> $isAvailable');

    // if (isAvailable) {
    //   slotsToShow = [];
    // } else {

    //   for (var slot in selectedBarber['availability']
    //       [selectedDate.toIso8601String()]['slots']) {
    //     if (slot['isAvailable'] && slot['isBooked'] == false) {
    //       tempSlotsList.add(slot);
    //     }
    //   }

    //   slotsToShow = tempSlotsList;
    // }
    // slotsToShow = tempSlotsList;
    // notifyListeners();
    return tempSlotsList;
  }

  updateSelectedService(String serviceId) {
    if (selectedService == serviceId) {
      selectedService = '';
    } else {
      selectedService = serviceId;
    }

    print('selected service from provider----> $selectedService');
    notifyListeners();
  }

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

  setCreateBookingCIP(bool value) {
    createBookingCIP = value;
    print('create booking ----> $createBookingCIP ');
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
