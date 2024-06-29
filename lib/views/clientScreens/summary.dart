import 'package:flutter/material.dart';

class BookingSummary extends StatefulWidget {
  const BookingSummary({super.key});

  @override
  State<BookingSummary> createState() => _BookingSummaryState();
}

class _BookingSummaryState extends State<BookingSummary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Summary'),
      ),
      body: const Center(
        child: Text('Booking Summary'),
      ),
    );
  }
}
