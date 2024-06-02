import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:trim_time/colors/custom_colors.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 630.0,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
            items: imgList.asMap().entries.map((entry) {
              int index = entry.key;
              String imgPath = entry.value;
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: CustomColors.gunmetal,
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          imgPath,
                          fit: BoxFit.cover,
                          height: 460,
                          width: double.infinity,
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            textList[index],
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'rubik'
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.map((url) {
              int index = imgList.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? CustomColors.peelOrange
                      : Colors.white.withOpacity(0.4),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 95),
          InkWell(
            splashColor: CustomColors.transparent,
            highlightColor: CustomColors.transparent,
            onTap: (){print("pressed");},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(borderRadius:BorderRadius.circular(25),color: CustomColors.peelOrange),
              width: 320,
              child: const Center(
            
                child:  Text(
                  "Next" ,style: TextStyle(color: Colors.white , fontFamily: 'dmsans'),
                ),
              ),
            ),
          )
        ],
      
      ),
    );
  }
}


