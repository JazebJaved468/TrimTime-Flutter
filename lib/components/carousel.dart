import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trim_time/colors/custom_colors.dart';

class ImageCarousel extends StatefulWidget {
  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final CarouselController _controller = CarouselController();
  final List<String> imgList = [
    'assets/images/1.jpg',
    'assets/images/barberShop2.jpg',
    'assets/images/3.jpg',
  ];
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      alignment: Alignment.bottomCenter,
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
            // autoPlay: true,
            height: screenHeight / 3,
            aspectRatio: screenWidth / (screenHeight / 3),
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        Positioned(
          bottom: 20,
          child: AnimatedSmoothIndicator(
            activeIndex: _current,
            count: imgList.length,
            effect: ExpandingDotsEffect(
              dotWidth: 7.0,
              dotHeight: 6.0,
              activeDotColor: CustomColors.peelOrange,
              dotColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
