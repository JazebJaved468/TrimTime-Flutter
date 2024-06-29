import 'package:trim_time/utilities/constants/constants.dart';

String capitalizeFirstLetterOfEachWord(String input) {
  return input.split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1);
  }).join(' ');
}

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;

  // Find the first space in the string
  int firstSpaceIndex = input.indexOf(' ');

  if (firstSpaceIndex == -1) {
    // If there's no space, capitalize the entire input as it's a single word
    return input[0].toUpperCase() + input.substring(1);
  }

  // Capitalize the first word and append the rest of the string
  String firstWord = input.substring(0, firstSpaceIndex);
  String restOfString = input.substring(firstSpaceIndex);
  return firstWord[0].toUpperCase() + firstWord.substring(1) + restOfString;
}

Map<String, int> calculatePercentages(int amount) {
  int amountToPay = (amount * ADVANCE_PAYMENT_PERCENTAGE / 100).round(); // 40%
  int remainingAmount =
      (amount * (100 - ADVANCE_PAYMENT_PERCENTAGE) / 100).round(); // 60%

  return {
    'amountToPay': amountToPay,
    'remainingAmount': remainingAmount,
  };
}
