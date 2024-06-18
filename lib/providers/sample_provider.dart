import 'package:flutter/material.dart';
import 'package:trim_time/controller/date_time.dart';
import 'package:trim_time/controller/firestore.dart';
import 'package:intl/intl.dart';
import 'package:trim_time/controller/initialization.dart';
import 'package:trim_time/controller/local_storage.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/utilities/constants/constants.dart';
import 'package:trim_time/views/barberScreens/home_barber.dart';
import 'package:trim_time/views/barberScreens/registeration_barber.dart';
import 'package:trim_time/views/clientScreens/registration_client.dart';
import 'package:trim_time/views/homescreenclient/homescreenclient.dart';

class SampleProvider with ChangeNotifier {
  // General States
  bool isAppInitialLoading = true;
  Map localDataInProvider = {};
  late String uid;
  late Map<String, dynamic> userData;
  late bool isClient;
  bool gender = true;

  // CIP : CAll IN PROGRESS
  bool updateSlotsCIP = false;
  bool updateDaysCIP = false;
  bool createBookingCIP = false;
  bool signInCIP = false;

  // Barber side States
  late Map<String, dynamic> barberAvailability;
  bool? isProvidingHaircut = false;
  bool? isProvidingShave = false;
  bool? isProvidingBeardTrim = false;
  bool? isProvidingMassage = false;
  String barberGender = 'male'; // used in barber registeration screen
  int barberOpeningTime = OPENING_TIME; // used in barber registeration screen
  int barberClosingTime = CLOSING_TIME; // used in barber registeration screen

  // Client side States
  String clientGender = 'male'; // used in client registeration screen
  bool rateBarberCIP = false;
  bool isSlotTileExpanded = false;

  // Client : CLient Booking Flow States
  Map<String, dynamic> selectedBarber = {};
  String selectedService = '';
  late String selectedServiceName = getSelectedServiceName();
  DateTime selectedDate = DateTime.now();
  Map selectedSlot = {};
  late List slotsToShow = getSlotsToShow();

  // Client : Barbers Listing
  late List<Map<String, dynamic>> allBarbers = [];
  late List haircutFilterBarbers = getHaircutFilterBarbers();
  late List shaveFilterBarbers = getShaveFilterBarbers();
  late List beardTrimFilterBarbers = getBeardTrimFilterBarbers();
  late List massageFilterBarbers = getMassageFilterBarbers();

  // Client :  Bookings
  late List<Map<String, dynamic>> allClientBookings = [];
  late List cancelledBookingsClient = getCancelledBookingsClient();
  late List upcomingBookingsClient = getUpcomingBookingsClient();
  late List completedBookingsClient = getCompletedBookingsClient();
  late List popularBarbers = [];

  // Client : Favourites
  late List inAppfavouriteList = getInAppFavouriteList();

  // -------------------------------------------------- Functions --------------------------------------------------

  initializeAppByProvider() async {
    print(
        '-----------------> Provider : App Initialization <-----------------');
    await initializeApp();
    localDataInProvider = await getDataFromLocalStorage();
    // setIsAppInitialLoading(false);

    uid = localDataInProvider['uid'] ?? '';
    userData = localDataInProvider['userData'];
    isClient = localDataInProvider['isClient'] ?? true;

    if (uid != null && uid != '') {
      if (isClient) {
        setAllBarbers(await getAllBarbersFromFireStore());
        setAllClientlBookings(
            await getAllClientBookingsFromFireStore(clientId: uid));
        setPopularBarbers(await getPopularBarbersFromFireStore());
        updateInAppFavouriteList();
        updateUpcomingBookingsClient();
        updateCompletedBookingsClient();
        updateCancelledBookingsClient();
      }
    }
    setIsAppInitialLoading(false);
    print('local data in provider ----> $localDataInProvider');
  }

  handleLoginByProvider(
      {required BuildContext context, required bool isClient}) async {
    Map<String, dynamic> response = await signInWithGoogle(isClient: isClient);

    if (response['user'] != null) {
      final localDataInProvider = await getDataFromLocalStorage();
      ;

      final isRegistered = localDataInProvider['userData']['isRegistered'];

      if (response['existsInOtherCategory']) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Account ALready exists in ${isClient ? 'barber' : 'client'} category'),
        ));
        await signOut();
      } else if (response['existsInItsOwnCategory'] && isClient) {
        await initializeAppByProvider();
        if (isRegistered) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ClientRegistrationPage(
                      photoURL: localDataInProvider['userData']['photoURL'],
                      phoneNumber: localDataInProvider['userData']
                          ['phoneNumber'],
                      email: localDataInProvider['userData']['email'],
                      fullName: localDataInProvider['userData']['name'],
                      gender: localDataInProvider['userData']['gender'],
                      // shouldNavigate: true,
                    )),
          );
        }
      } else if (response['existsInItsOwnCategory'] && !isClient) {
        await initializeAppByProvider();
        if (isRegistered) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BarberHomePage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => BarberRegistrationPage(
                      photoURL: localDataInProvider['userData']['photoURL'],
                      phoneNumber: localDataInProvider['userData']
                          ['phoneNumber'],
                      email: localDataInProvider['userData']['email'],
                      fullName: localDataInProvider['userData']['name'],
                      gender: localDataInProvider['userData']['gender'],
                      openingTime: localDataInProvider['userData']
                          ['openingTime'],
                      closingTime: localDataInProvider['userData']
                          ['closingTime'],
                      services: localDataInProvider['userData']['services'],
                      uid: localDataInProvider['uid'],
                    )),
          );
        }
      } else if (!response['existsInItsOwnCategory']) {
        await initializeAppByProvider();
        if (isClient) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ClientRegistrationPage(
                      photoURL: localDataInProvider['userData']['photoURL'],
                      phoneNumber: localDataInProvider['userData']
                          ['phoneNumber'],
                      email: localDataInProvider['userData']['email'],
                      fullName: localDataInProvider['userData']['name'],
                      gender: localDataInProvider['userData']['gender'],
                      // shouldNavigate: true,
                    )),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => BarberRegistrationPage(
                      photoURL: localDataInProvider['userData']['photoURL'],
                      phoneNumber: localDataInProvider['userData']
                          ['phoneNumber'],
                      email: localDataInProvider['userData']['email'],
                      fullName: localDataInProvider['userData']['name'],
                      gender: localDataInProvider['userData']['gender'],
                      openingTime: localDataInProvider['userData']
                          ['openingTime'],
                      closingTime: localDataInProvider['userData']
                          ['closingTime'],
                      services: localDataInProvider['userData']['services'],
                      uid: localDataInProvider['uid'],
                    )),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error in login. Please try again.'),
      ));
    }
  }

  handleLogoutByProvider() async {
    await signOut();
    resetAllClientBookings();
    resetUpcomingBookingsClient();
    resetCompletedBookingsClient();
    resetCancelledBookingsClient();
    resetInAppFavouriteList();
    resetLocalDataInProvider();
    resetAllBarbers();
  }

  rateBarberByProvider(
      {required String barberId,
      required int rating,
      required String review,
      required String bookingId}) async {
    // int responseCode = -1; // 0 for success, -1 for failure

    await rateBarberInFirestore(
        barberId: barberId,
        clientId: uid,
        bookingId: bookingId,
        rating: rating,
        review: review);

    completedBookingsClient.forEach((booking) {
      if (booking['id'] == bookingId) {
        booking['isRated'] = true;
        // print(booking);
      }
      notifyListeners();
    });
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

    if (response['status'] == 0) {
      responseCode = 0;
      updateUserDataInLocalStorageByProvider();
      // userData['bookings'].add(response['bookingId']);

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

  removeBarberFromFavourites(String barberId) async {
    int index = allBarbers.indexWhere((element) => element['uid'] == barberId);
    allBarbers[index]['isFavourite'] = false;

    localDataInProvider['userData']['favourites'].remove(barberId);

    notifyListeners();
    updateInAppFavouriteList();
    updateClientFavoritesInFirestore(
        clientId: uid,
        favouritesList: localDataInProvider['userData']['favourites']);

    await updateUserDataInLocalStorageByProvider();
  }

  addBarberToFavourites(String barberId) async {
    int index = allBarbers.indexWhere((element) => element['uid'] == barberId);
    allBarbers[index]['isFavourite'] = true;

    localDataInProvider['userData']['favourites'].add(barberId);
    notifyListeners();

    updateInAppFavouriteList();
    updateClientFavoritesInFirestore(
        clientId: uid,
        favouritesList: localDataInProvider['userData']['favourites']);

    await updateUserDataInLocalStorageByProvider();
  }

  // -------------------------------------------------- Updaters  --------------------------------------------------

  updatePopularBarbers() {
    popularBarbers = getPopularBarbers();

    notifyListeners();
  }

  updateSelectedService(String serviceId) {
    if (selectedService == serviceId) {
      selectedService = '';
    } else {
      selectedService = serviceId;
    }
    notifyListeners();
  }

  updateUpcomingBookingsClient() {
    upcomingBookingsClient = getUpcomingBookingsClient();
    notifyListeners();
  }

  updateCompletedBookingsClient() {
    completedBookingsClient = getCompletedBookingsClient();
    notifyListeners();
  }

  updateCancelledBookingsClient() {
    cancelledBookingsClient = getCancelledBookingsClient();
    notifyListeners();
  }

  void changeGender() {
    gender = !gender;
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

  updateAllClientBookings() async {
    allClientBookings = await getAllClientBookingsFromFireStore(clientId: uid);
    notifyListeners();
  }

  updateInAppFavouriteList() {
    inAppfavouriteList = getInAppFavouriteList();
    notifyListeners();
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

  updateUserDataInLocalStorageByProvider() async {
    await updateUserDataInLocalStorage(
        data: await getUserDataFromFirestore(uid, isClient));

    localDataInProvider = await getDataFromLocalStorage();

    print('updated user data in provider ----> $localDataInProvider');
    notifyListeners();
  }

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

  // -------------------------------------------------- Getters  --------------------------------------------------

  getPopularBarbers() async {
    // List tempData = [];
    return await getPopularBarbersFromFireStore();
    // for (var barber in allBarbers) {
    //   if (barber['isPopular']) {
    //     tempData.add(barber);
    //   }
    // }

    // return tempData;
  }

  int getTotalPrice() {
    int totalPrice = 0;

    if (selectedService != '') {
      int servicePrice = selectedBarber['services'][selectedService]['price'];
      totalPrice = (servicePrice + GST_PERCENTAGE * (servicePrice)).toInt();
    }

    return totalPrice;
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
  }

  List getBeardTrimFilterBarbers() {
    List tempData = [];

    for (var barber in allBarbers) {
      if (barber['services']['3']['isProviding']) {
        tempData.add(barber);
      }
    }

    return tempData;
  }

  List getCancelledBookingsClient() {
    List tempData = [];

    for (var booking in allClientBookings) {
      if (booking['isCancelled']) {
        tempData.add(booking);
      }
    }

    return tempData;
  }

  List getCompletedBookingsClient() {
    List tempData = [];

    for (var booking in allClientBookings) {
      if (booking['isCompleted']) {
        tempData.add(booking);
      }
    }

    return tempData;
  }

  List getUpcomingBookingsClient() {
    List tempData = [];

    for (var booking in allClientBookings) {
      if (localDataInProvider['userData']['bookings'].contains(booking['id'])) {
        if (booking['isCancelled'] == false &&
            booking['isCompleted'] == false) {
          tempData.add(booking);
        }
      }
    }

    return tempData;
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

  getInAppFavouriteList() {
    List tempData = [];

    for (var barber in allBarbers) {
      if (localDataInProvider['userData']['favourites']
          .contains(barber['uid'])) {
        tempData.add(barber);
      }
    }

    print('No. Of favourites  ----> ${tempData.length}');
    return tempData;
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

    return tempList;
  }

  // --------------------------------------------------Setters  --------------------------------------------------
  setIsSlotTileExpanded(bool value) {
    isSlotTileExpanded = value;
    notifyListeners();
  }

  setLocalDataInProvider(Map data) {
    print(
        '-----------------> Provider : Setting Local Data <-----------------');
    localDataInProvider = data;
  }

  void setAllBarbers(List<Map<String, dynamic>> data) {
    allBarbers = data;
  }

  setPopularBarbers(List data) async {
    popularBarbers = data;
    print('popuplar barbers in provider --------------> $popularBarbers');
    // notifyListeners();
  }

  setAllClientlBookings(List<Map<String, dynamic>> data) {
    allClientBookings = data;
  }

  setIsAppInitialLoading(bool value) {
    isAppInitialLoading = value;
    print('Initial Loading ----> $isAppInitialLoading');
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

  setRateBarberCIP(bool value) {
    rateBarberCIP = value;
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

  setSelectedBarber(String barberId) {
    selectedBarber =
        allBarbers.firstWhere((element) => element['uid'] == barberId);
  }

  void setUserData(Map<String, dynamic> data) {
    userData = data;
  }

  void setUserId({required String userId}) {
    uid = localDataInProvider['uid'];
  }

  // --------------------------------------------------Resetters  --------------------------------------------------

  resetSelectedSlot() {
    selectedSlot = {};
  }

  resetIsSlotTileExpanded() {
    isSlotTileExpanded = false;
  }

  resetAllClientBookings() {
    allClientBookings = [];
  }

  resetInAppFavouriteList() {
    inAppfavouriteList = [];
  }

  resetUpcomingBookingsClient() {
    upcomingBookingsClient = [];
  }

  resetCompletedBookingsClient() {
    completedBookingsClient = [];
  }

  resetCancelledBookingsClient() {
    cancelledBookingsClient = [];
  }

  resetLocalDataInProvider() {
    localDataInProvider = {};
  }

  resetAllBarbers() {
    allBarbers = [];
  }

  // ---------------------------------------------------- Rough Work ----------------------------------------

  int activeBarbers = 0;
  void incrementActiveBarbers() {
    activeBarbers++;
    notifyListeners();
  }
}
