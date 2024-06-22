import 'dart:convert';
import 'package:currency_converter/currency.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:currency_converter/currency_converter.dart';

class StripePaymentHandle {
  Map<String, dynamic>? paymentIntent;

  Future<void> MakePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'INR');

      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  billingDetails: const BillingDetails(
                      name: 'Daniyal Lodhi',
                      email: 'daniyal@gmail.com',
                      phone: '03161018559',
                      address: Address(
                          city: 'Karachi',
                          country: 'PK',
                          line1: '',
                          line2: '',
                          postalCode: 'XXXXXXX',
                          state: 'Sindh')),
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  primaryButtonLabel: "Pay ${amount}.00 PKR",
                  merchantDisplayName: 'Trim-Time'))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  displayPaymentSheet() async {
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet();

      Fluttertoast.showToast(msg: 'Payment successfully completed');
    } on Exception catch (e) {
      if (e is StripeException) {
        Fluttertoast.showToast(
            msg: 'Error from Stripe: ${e.error.localizedMessage}');
      } else {
        Fluttertoast.showToast(msg: 'Unforeseen error: ${e}');
      }
    }
  }

  //create Payment Intent
  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      String convertedAmount = await calculateAmount(amount);

      Map<String, dynamic> body = {
        'amount': convertedAmount,
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer sk_test_51NU517SBDQj9WtJX4rAgzOh9hnKg40cQIEBNKmEYgD7Sy4DAkdnDagYRXSVRQ16q1ZlY9HfKsS0LoISALGZ8v6Hv00cyBPNt8a',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  //calculate Amount
  Future<String> calculateAmount(String amount) async {
    try {
      // Parse the input amount to a double
      final double calculatedAmount = double.parse(amount);

      // Perform the currency conversion asynchronously
      var inrConvertedTotalAmount = await CurrencyConverter.convert(
        from: Currency.pkr,
        to: Currency.inr,
        amount: calculatedAmount,
      );

      // Check if the conversion result is not null
      if (inrConvertedTotalAmount != null) {
        // Convert the amount to the smallest currency unit (integer)
        int amountInSmallestUnit = (inrConvertedTotalAmount * 100).toInt();

        // Print the converted amount
        print("Converted amount in smallest currency unit is:");
        print(amountInSmallestUnit);

        // Return the converted amount as a string
        return amountInSmallestUnit.toString();
      } else {
        throw Exception("Conversion result is null");
      }
    } catch (e) {
      // Handle any errors that occur during parsing or conversion
      print("Error during calculation or conversion: $e");
      return "Error"; // or handle the error appropriately
    }
  }
}
