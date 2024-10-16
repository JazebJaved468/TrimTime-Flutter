import 'package:uuid/uuid.dart';

const OPENING_TIME = 11;
const CLOSING_TIME = 23;

List<Map<String, dynamic>> generateTimeSlots(
    DateTime date, int openTime, int closeTime) {
  DateTime openingTime =
      DateTime(date.year, date.month, date.day, openTime, 0); // 11:00 AM
  DateTime closingTime =
      DateTime(date.year, date.month, date.day, closeTime, 0); // 11:00 PM
  List<Map<String, dynamic>> slots = [];
  DateTime currentTime = DateTime(
      date.year, date.month, date.day, openingTime.hour, openingTime.minute);
  var uuid = Uuid();

  while (currentTime.isBefore(DateTime(
      date.year, date.month, date.day, closingTime.hour, closingTime.minute))) {
    DateTime endTime = currentTime.add(Duration(minutes: 30));

    slots.add({
      'slotId': uuid.v4(),
      'start': currentTime.toIso8601String(),
      'end': endTime.toIso8601String(),
      'isBooked': false,
      'clientId': null,
      'updatedAt': null,
      'isAvailable': true,
    });

    currentTime = endTime;
  }

  return slots;
}

generate7DaysSlots(DateTime startingDay, int openingTime, int closingTime) {
  var availableSlots = {};
  for (var i = 0; i < 7; i++) {
    String day = (startingDay.add(Duration(days: i)).toIso8601String());
    availableSlots[day] = {
      'isAvailable': true,
      'hasBooking': false,
      'slots': generateTimeSlots(DateTime.parse(day), openingTime, closingTime),
    };
  }

  return availableSlots;
}
