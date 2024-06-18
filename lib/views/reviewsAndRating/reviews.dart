import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:trim_time/colors/custom_colors.dart';

class ReviewsAndRating extends StatefulWidget {
  const ReviewsAndRating({super.key});

  @override
  State<ReviewsAndRating> createState() => _ReviewsAndRatingState();
}

class _ReviewsAndRatingState extends State<ReviewsAndRating> {
  double rating = 0;
  final myController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.gunmetal,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(12),
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
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: Image.asset('assets/images/review1.png'),
                        height: 200,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        // color: Colors.brown,
                        child: Text(
                          'Your Opinion Matters!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          'We hope you loved your new look. We’d love to hear your thoughts!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 15,
                            fontWeight: FontWeight.w100,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: RatingBar.builder(
                          initialRating: 0,
                          minRating: 1,
                          unratedColor: Colors.grey,
                          itemCount: 5,
                          itemSize: 50,
                          itemPadding: EdgeInsets.symmetric(horizontal: 3),
                          updateOnDrag: true,
                          itemBuilder: (context, index) {
                            return Icon(
                              Icons.star,
                              color: CustomColors.peelOrange,
                            );
                          },
                          onRatingUpdate: (value) {
                            rating = value;
                            log('star: $rating');
                            log(myController.text);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Share your experience',
                            hintStyle:
                                TextStyle(color: Colors.grey.withOpacity(0.5)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.peelOrange),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.peelOrange),
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                          controller: myController,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(30), // Margin around the button
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        // color: CustomColors.peelOrange,
                        borderRadius: BorderRadius.circular(50),
                        border: Border(
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
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: CustomColors.peelOrange,
                            fontFamily: 'Poppins',
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
