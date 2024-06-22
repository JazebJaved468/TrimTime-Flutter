import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/providers/sample_provider.dart';

class ReviewsAndRating extends StatefulWidget {
  const ReviewsAndRating({super.key, required this.bookingData});
  final Map bookingData;

  @override
  State<ReviewsAndRating> createState() => _ReviewsAndRatingState();
}

class _ReviewsAndRatingState extends State<ReviewsAndRating> {
  int rating = 4;
  final myController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SampleProvider sampleProvider =
        Provider.of<SampleProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: CustomColors.gunmetal,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: Image.asset('assets/images/review1.png'),
                        height: 200,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                        // color: Colors.brown,
                        child: const Text(
                          'Your Opinion Matters!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            // fontFamily: 'Raleway',
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        child: const Text(
                          'We hope you loved your new look. We’d love to hear your thoughts!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            // fontFamily: 'Raleway',
                            fontSize: 15,
                            fontWeight: FontWeight.w100,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: RatingBar.builder(
                          initialRating: rating.toDouble(),
                          minRating: 1,
                          unratedColor: Colors.grey,
                          itemCount: 5,
                          itemSize: 50,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 3),
                          updateOnDrag: true,
                          itemBuilder: (context, index) {
                            return const Icon(
                              Icons.star,
                              color: CustomColors.peelOrange,
                            );
                          },
                          onRatingUpdate: (value) {
                            rating = value.toInt();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Share your experience',
                            hintStyle:
                                TextStyle(color: Colors.grey.withOpacity(0.5)),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.peelOrange),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.peelOrange),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          controller: myController,
                        ),
                      ),
                    ],
                  ),
                ),
                Consumer<SampleProvider>(builder: (context, provider, child) {
                  return Container(
                    margin:
                        const EdgeInsets.all(30), // Margin around the button
                    child: GestureDetector(
                      onTap: () async {
                        provider.setRateBarberCIP(true);

                        // Add your logic here
                        // log('star: $rating');
                        // log(myController.text);
                        await provider.rateBarberByProvider(
                            rating: rating,
                            review: myController.text,
                            barberId: widget.bookingData['barberId'],
                            bookingId: widget.bookingData['id']);

                        provider.setRateBarberCIP(false);

                        if (mounted) {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          // color: CustomColors.peelOrange,
                          borderRadius: BorderRadius.circular(50),
                          border: const Border(
                            top: BorderSide(
                              color: CustomColors.peelOrange,
                            ), // Top border
                            bottom: BorderSide(
                              color: CustomColors.peelOrange,
                            ), // Bottom border
                            left: BorderSide(
                              color: CustomColors.peelOrange,
                            ), // Left border
                            right: BorderSide(
                              color: CustomColors.peelOrange,
                            ), // Right border
                          ),
                        ),
                        child: Center(
                          child: provider.rateBarberCIP
                              ? const SpinKitFadingCircle(
                                  color: CustomColors.peelOrange,
                                  size: 30,
                                )
                              : Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: CustomColors.peelOrange,
                                    // fontFamily: 'Poppins',
                                    fontSize: 15,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
