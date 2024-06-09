import 'package:flutter/material.dart';
import 'package:trim_time/controller/date_time.dart';
import 'package:trim_time/controller/firestore.dart';
import 'package:intl/intl.dart';
import 'package:trim_time/controller/local_storage.dart';
import 'package:trim_time/utilities/constants/constants.dart';

class SampleProvider with ChangeNotifier {
  bool invalidateHomeDataInitializtion = false;
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
  String clientGender = 'male'; // used in client registeration screen
  String barberGender = 'male'; // used in barber registeration screen
  int barberOpeningTime = OPENING_TIME; // used in barber registeration screen
  int barberClosingTime = CLOSING_TIME; // used in barber registeration screen
  Map<String, dynamic> selectedBarber = {};
  String selectedService = '';
  late String selectedServiceName = getSelectedServiceName();
  DateTime selectedDate = DateTime.now();
  Map selectedSlot = {};
  late List slotsToShow = getSlotsToShow();

  updateBarberOpeningTime(int value) {
    barberOpeningTime = value;
    notifyListeners();
  }

  updateBarberClosingTime(int value) {
    barberClosingTime = value;
    notifyListeners();
  }

  updateClientGEnder(String value) {
    clientGender = value;
    notifyListeners();
  }

  updateBarberGender(String value) {
    barberGender = value;
    notifyListeners();
  }

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

  createBooking() async {
    int responseCode = -1; // 0 for success, -1 for failure

    Map<String, dynamic> response = await createBookingInFirestore(
      barberId: selectedBarber['uid'],
      clientId: uid,
      serviceId: selectedService,
      slot: selectedSlot,
      date: selectedDate.toIso8601String(),
      amount: getTotalPrice(),
    );

    updateUserDataInLocalStorage(
        data: await getUserDataFromFirestore(
            userData['uid'], userData['isClient']));

    if (response['status'] == 0) {
      responseCode = 0;
      userData['bookings'].add(response['bookingId']);

      selectedBarber['availability'].forEach((date, info) {
        var fomattedDate =
            DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
        var selectedDateFormatted =
            DateFormat('dd-MM-yyyy').format(selectedDate);

        if (selectedDateFormatted == fomattedDate) {
          if (selectedBarber['availability'][date]['isAvailable']) {
            {
              selectedBarber['availability'][date]['slots'].forEach((slot) {
                if (slot['slotId'] == selectedSlot['slotId']) {
                  slot['isBooked'] = true;
                }
              });
            }
          }
        }
      });

      selectedSlot = {};
      selectedService = '';
      updateSlotsToShow();
      notifyListeners();
    } else {
      responseCode = -1;
    }

    return responseCode;
  }

  getTotalPrice() {
    int totalPrice = 0;

    if (selectedService != '') {
      int servicePrice = selectedBarber['services'][selectedService]['price'];
      totalPrice = (servicePrice + GST_PERCENTAGE * (servicePrice)).round();
    }

    return totalPrice;
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

  getSelectedServicePrice() {
    int price = 0;

    if (selectedService != '') {
      price = selectedBarber['services'][selectedService]['price'];
    }

    return price;
  }

  getSelectedServiceName() {
    String serviceName = '';
    if (selectedService == '1') {
      serviceName = 'Haircut';
    } else if (selectedService == '2') {
      serviceName = 'Shave';
    } else if (selectedService == '3') {
      serviceName = 'Beard Trim';
    } else if (selectedService == '4') {
      serviceName = 'Massage';
    }

    return serviceName;
  }

  getSlotsToShow() {
    List tempSlotsList = [];

    selectedBarber['availability'].forEach((date, info) {
      var fomattedDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
      var selectedDateFormatted = DateFormat('dd-MM-yyyy').format(selectedDate);

      if (selectedDateFormatted == fomattedDate) {
        if (selectedBarber['availability'][date]['isAvailable']) {
          {
            selectedBarber['availability'][date]['slots'].forEach((slot) {
              if (slot['isAvailable'] && slot['isBooked'] == false) {
                tempSlotsList.add(slot);
              }
            });
          }
        } else {
          tempSlotsList = [];
        }
      }
    });

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
      // print('user data favourites -----> ${userData['favourites']}');
      if (userData['favourites'].contains(barber['uid'])) {
        // print('true');
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
  late List<Map<String, dynamic>> allBookings = [];

  late List cancelledBookingsClient = getCancelledBookingsClient();
  late List upcomingBookingsClient = getUpcomingBookingsClient();
  late List completedBookingsClient = getCompletedBookingsClient();

  updateAllBookings() async {
    allBookings = await getAllBookingsFromFireStore(clientId: userData['uid']);
  }

  List getCompletedBookingsClient() {
    List tempData = [];

    for (var booking in allBookings) {
      if (booking['isCompleted']) {
        tempData.add(booking);
      }
    }

    return tempData;
  }

  List getUpcomingBookingsClient() {
    print('gettin ucmoing bookings again');
    List tempData = [];

    for (var booking in allBookings) {
      if (userData['bookings'].contains(booking['id'])) {
        if (booking['isCancelled'] == false &&
            booking['isCompleted'] == false) {
          tempData.add(booking);
        }
        // print('true');
      }
    }

    return tempData;
  }

  updateUpcomingBookingsClient() {
    // updateAllBookings();
    upcomingBookingsClient = getUpcomingBookingsClient();
    notifyListeners();
  }

  List getCancelledBookingsClient() {
    List tempData = [];

    for (var booking in allBookings) {
      if (booking['isCancelled']) {
        tempData.add(booking);
      }
    }

    return tempData;
  }

  void setAllBarbers(List<Map<String, dynamic>> data) {
    allBarbers = data;
    // notifyListeners();
  }

  setAllBookings(List<Map<String, dynamic>> data) {
    allBookings = data;
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
    // print("user data favourites -----> ${userData['favourites']}");

    userData['favourites'].remove(barberId);
    notifyListeners();
  }

  addBarberToFavourites(String barberId) {
    // print('user data in state -----> $userData');
    int index = allBarbers.indexWhere((element) => element['uid'] == barberId);
    allBarbers[index]['isFavourite'] = true;

    // print("user data favourites -----> ${userData['favourites']}");
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
