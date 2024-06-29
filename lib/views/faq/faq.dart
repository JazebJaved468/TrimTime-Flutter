import 'package:flutter/material.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/components/CustomAppBar.dart';
import 'package:trim_time/utilities/constants/constants.dart';

class FAQScreen extends StatelessWidget {
  FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.gunmetal,
      appBar: CustomAppBar(
        title: 'Frequently Asked Questions',
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
      body: Container(
        margin: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: faqItems.length,
          itemBuilder: (context, index) {
            return FAQItemView(
                question: faqItems[index].question,
                answer: faqItems[index].answer);
          },
        ),
      ),
    );
  }
}

class FAQ {
  final String question;
  final String answer;

  FAQ({required this.question, required this.answer});
}

class FAQItemView extends StatelessWidget {
  const FAQItemView({super.key, required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        splashColor: CustomColors.transparent,
        highlightColor: CustomColors.transparent,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: ExpansionTile(
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          collapsedBackgroundColor: CustomColors.charcoal,
          tilePadding: EdgeInsetsGeometry.lerp(
            EdgeInsets.symmetric(horizontal: 16),
            EdgeInsets.all(0),
            0,
          ),
          childrenPadding: EdgeInsetsGeometry.lerp(
            EdgeInsets.all(0),
            EdgeInsets.all(0),
            0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: CustomColors.charcoal,
          iconColor: CustomColors.white,
          collapsedIconColor: CustomColors.white.withOpacity(0.5),
          title: Text(
            question,
            style: TextStyle(
              color: CustomColors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                answer,
                style: TextStyle(
                    color: CustomColors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
