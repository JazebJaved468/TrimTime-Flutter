import 'package:shared_preferences/shared_preferences.dart';
import 'package:trim_time/controller/firestore.dart';
import 'package:trim_time/controller/local_storage.dart';
import 'package:trim_time/controller/login.dart';

initializeApp() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isFirstVisit = prefs.getBool('isFirstVisit');
  late Map<String, dynamic> localData;

  if (isFirstVisit == null) {
    updateBooleanDataInLocalStorage(key: 'isFirstVisit', value: true);
  } else {
    localData = await getDataFromLocalStorage();

    print('local data in initializeApp: $localData');

    if (localData['uid'] != null) {
      updateUserDataInLocalStorage(
          data: await getUserDataFromFirestore(
              localData['uid'], localData['isClient']));
    }
  }
}
