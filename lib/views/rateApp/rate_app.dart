import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/components/CustomAppBar.dart';
import 'package:trim_time/providers/sample_provider.dart';

class RateApp extends StatefulWidget {
  const RateApp({super.key});

  @override
  State<RateApp> createState() => _RateAppState();
}

class _RateAppState extends State<RateApp> {
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
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: CustomColors.gunmetal,
      appBar: CustomAppBar(
        title: 'Rating',
        leftIcon: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: CustomColors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Container(
          // color: Colors.amberAccent,
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Container(
              // color: Colors.pink,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // const SizedBox(
                        //   height: 30,
                        // ),
                        Container(
                          // child: Image.asset('assets/images/review1.png'),
                          child: SvgPicture.asset(
                              'assets/images/svgs/rateApp.svg'),
                          height: 250,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          // color: Colors.brown,
                          margin: const EdgeInsets.only(bottom: 4),
                          child: const Text(
                            'Rate Our App',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                // fontFamily: 'Raleway',
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Container(
                          child: const Text(
                            'Your feedback helps us improve!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              // fontFamily: 'Raleway',
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
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
                              hintText: 'Love the app? Share your thoughts!',
                              hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.5)),
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
                  Consumer<AppProvider>(builder: (context, provider, child) {
                    return Container(
                      margin: const EdgeInsets.only(
                          left: 30,
                          right: 30,
                          top: 90), // Margin around the button
                      child: GestureDetector(
                        onTap: () async {
                          provider.setRateBarberCIP(true);

                          // Add your logic here
                          // log('star: $rating');
                          // log(myController.text);

                          await provider.rateAppByProvider(
                            rating: rating,
                            review: myController.text,
                            isClient: appProvider
                                .localDataInProvider['userData']['isClient'],
                            userId: appProvider.localDataInProvider['userData']
                                ['uid'],
                          );

                          provider.setRateBarberCIP(false);

                          myController.clear();

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
                                : const Text(
                                    'Submit',
                                    style: const TextStyle(
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
      ),
    );
  }
}
