import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/components/CustomAppBar.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class SupportAndFeedback extends StatefulWidget {
  const SupportAndFeedback({super.key});

  @override
  State<SupportAndFeedback> createState() => _SupportAndFeedbackState();
}

class _SupportAndFeedbackState extends State<SupportAndFeedback> {
  int rating = 4;
  final myController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  final link = const WhatsAppUnilink(
    phoneNumber: '+92-(307)0075922',
    text:
        "Hello, I'm interested in your services. Can you provide me with more information?",
  );

  @override
  Widget build(BuildContext context) {
    SampleProvider sampleProvider =
        Provider.of<SampleProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: CustomColors.gunmetal,
      appBar: CustomAppBar(
        title: 'Customer Support',
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
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const SizedBox(
                        //   height: 30,
                        // ),
                        Container(
                          // child: Image.asset('assets/images/review1.png'),
                          child: SvgPicture.asset(
                              'assets/images/svgs/customerSupport.svg'),
                          height: 250,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          // color: Colors.brown,
                          margin: const EdgeInsets.only(bottom: 4),
                          child: const Text(
                            "We're here to help",
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
                            'Submit Your Queries to our support team Now!',
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

                        // const SizedBox(
                        //   height: 30,
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 30),
                        //   child: TextFormField(
                        //     decoration: InputDecoration(
                        //       hintText: 'Love the app? Share your thoughts!',
                        //       hintStyle: TextStyle(
                        //           color: Colors.grey.withOpacity(0.5)),
                        //       focusedBorder: const UnderlineInputBorder(
                        //         borderSide:
                        //             BorderSide(color: CustomColors.peelOrange),
                        //       ),
                        //       enabledBorder: const UnderlineInputBorder(
                        //         borderSide:
                        //             BorderSide(color: CustomColors.peelOrange),
                        //       ),
                        //     ),
                        //     style: const TextStyle(color: Colors.white),
                        //     controller: myController,
                        //   ),
                        // ),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: const Text(
                              'Contact Us:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                // fontFamily: 'Raleway',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(left: 30),
                            child: const Text(
                              'Email: support@example.com',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                // fontFamily: 'Raleway',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(left: 30),
                            child: const Text(
                              'Phone: +92(307)0075922',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                // fontFamily: 'Raleway',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Consumer<SampleProvider>(builder: (context, provider, child) {
                    return Container(
                      margin: const EdgeInsets.only(
                          left: 30,
                          right: 30,
                          top: 60), // Margin around the button
                      child: GestureDetector(
                        onTap: () async {
                          try {
                            await launchUrlString('$link');
                          } catch (err) {
                            print('error -----> $err');
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 140,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(50),
                            // border: const Border(
                            //   top: BorderSide(
                            //     color: Colors.green,
                            //   ), // Top border
                            //   bottom: BorderSide(
                            //     color: Colors.green,
                            //   ), // Bottom border
                            //   left: BorderSide(
                            //     color: Colors.green,
                            //   ), // Left border
                            //   right: BorderSide(
                            //     color: Colors.green,
                            //   ), // Right border
                            // ),
                          ),
                          child: Center(
                            child: provider.rateBarberCIP
                                ? const SpinKitFadingCircle(
                                    color: CustomColors.peelOrange,
                                    size: 30,
                                  )
                                : Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/svgs/whatsapp.svg',
                                        color: CustomColors.white,
                                        width: 20,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        'Whatsapp',
                                        style: TextStyle(
                                          color: CustomColors.white,
                                          // fontFamily: 'Poppins',
                                          fontSize: 15,
                                        ),
                                      )
                                    ],
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
