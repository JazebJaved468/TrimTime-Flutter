import 'package:flutter/material.dart';
import 'package:trim_time/views/checkout/checkout.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Map<String, dynamic>? paymentIntentData;
  String amountToPay = '20'; // Default amount to pay

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Tutorial'),
      ),
      body: Center(
        child: InkWell(
          onTap: () async {
            await StripePaymentHandle().MakePayment();
          },
          child: Container(
            height: 50,
            width: 200,
            color: Colors.green,
            child: Center(
              child: Text(
                'Pay $amountToPay PKR', // Display amount here
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
  