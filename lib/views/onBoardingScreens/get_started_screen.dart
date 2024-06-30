import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trim_time/controller/local_storage.dart';
import 'package:trim_time/views/sign_in/sign_in.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final List<String> imgList = [
      'assets/images/brb1.jpg',
      'assets/images/brb2.jpg',
      'assets/images/brb3.jpg',
    ];

    final List<String> textList = [
      'Find Barbers and Salons Easily in Your Hands',
      'Book your Favorite Barber and Salon Quickly',
      'Come be Handsome and Beautiful with us right now!',
    ];

    return Scaffold(
      backgroundColor: CustomColors.gunmetal,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragEnd: (details) {
          if (details.velocity.pixelsPerSecond.dx > 0) {
            _controller.previousPage();
          } else if (details.velocity.pixelsPerSecond.dx < 0) {
            _controller.nextPage();
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                children: [
                  CarouselSlider(
                    items: imgList
                        .map((item) => Container(
                              child: Center(
                                child: Image.asset(
                                  item,
                                  fit: BoxFit.cover,
                                  width: screenWidth,
                                ),
                              ),
                            ))
                        .toList(),
                    carouselController: _controller,
                    options: CarouselOptions(
                      height: screenHeight * .53,
                      aspectRatio: screenWidth / (screenHeight / 3),
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                      enableInfiniteScroll: false,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                    child: Text(
                      textList[_current],
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'rubik',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // const SizedBox(height: 50),
                  // AnimatedSmoothIndicator(
                  //   activeIndex: _current,
                  //   count: imgList.length,
                  //   effect: const ExpandingDotsEffect(
                  //     dotWidth: 7.0,
                  //     dotHeight: 6.0,
                  //     activeDotColor: CustomColors.peelOrange,
                  //     dotColor: Colors.white,
                  //   ),
                  // )
                  //     ],
                  //   ),
                  // ),
                  // // SizedBox(height: screenHeight * 0.14),
                  // Container(
                  //   margin: EdgeInsets.only(bottom: 20),
                  //   child: InkWell(
                  //     splashColor: CustomColors.transparent,
                  //     highlightColor: CustomColors.transparent,
                  //     onTap: () {
                  //       if (_current < 2) {
                  //         _controller.nextPage();
                  //       } else {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(builder: (context) => SignIn()),
                  //         );
                  //       }
                  //     },
                  //     child: Container(
                  //       padding: const EdgeInsets.symmetric(vertical: 15),
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(25),
                  //         color: CustomColors.peelOrange,
                  //       ),
                  //     ),
                  const SizedBox(height: 50),
                  AnimatedSmoothIndicator(
                    activeIndex: _current,
                    count: imgList.length,
                    effect: const ExpandingDotsEffect(
                      dotWidth: 7.0,
                      dotHeight: 6.0,
                      activeDotColor: CustomColors.peelOrange,
                      dotColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.14),
                  // InkWell(
                  //   splashColor: CustomColors.transparent,
                  //   highlightColor: CustomColors.transparent,
                  //   onTap: () async {
                  //     if (_current < 2) {
                  //       _controller.nextPage();
                  //     } else {
                  //       await updateBooleanDataInLocalStorage(
                  //           key: 'isFirstVisit', value: false);
                  //       Navigator.of(context).pushAndRemoveUntil(
                  //           MaterialPageRoute(builder: (context) => SignIn()),
                  //           (Route route) => false);
                  //     }
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(vertical: 15),
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(25),
                  //       color: CustomColors.peelOrange,
                  //     ),
                  //     width: screenWidth * .85,
                  //     child: Center(
                  //       child: Text(
                  //         _current < 2 ? "Next" : "Get Started",
                  //         style: TextStyle(
                  //             color: Colors.white, fontFamily: 'dmsans'),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            InkWell(
              splashColor: CustomColors.transparent,
              highlightColor: CustomColors.transparent,
              onTap: () async {
                if (_current < 2) {
                  _controller.nextPage();
                } else {
                  await updateBooleanDataInLocalStorage(
                      key: 'isFirstVisit', value: false);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => SignIn()),
                      (Route route) => false);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: CustomColors.peelOrange,
                ),
                width: screenWidth * .85,
                child: Center(
                  child: Text(
                    _current < 2 ? "Next" : "Get Started",
                    style: TextStyle(
                      color: Colors.white,
                      // fontFamily: 'dmsans'
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
