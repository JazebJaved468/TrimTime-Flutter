import 'package:flutter/material.dart';
import 'package:trim_time/colors/custom_colors.dart';

class Review extends StatelessWidget {
  const Review(
      {super.key,
      required this.ClientName,
      required this.review,
      required this.rating,
      required this.isLastReview});

  final String ClientName;
  final String review;
  final int rating;
  final bool isLastReview;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.only(right: 16, left: 16),
            padding:
                const EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        // color: Colors.red,
                        child: Text(
                      '$ClientName',
                      style: TextStyle(
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,

                          // fontWeight: FontWeight.bold,
                          color: CustomColors.white),
                    )),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                        border: Border.all(color: CustomColors.peelOrange),
                      ),
                      width: 60,
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.star,
                            color: CustomColors.peelOrange,
                            size: 15,
                          ),
                          Text(
                            '$rating',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: CustomColors.peelOrange),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    '$review',
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 14,
                        color: CustomColors.white),
                  ),
                ),
              ],
            )),
        !isLastReview
            ? Container(
                margin: const EdgeInsets.only(left: 16, right: 16),
                child: const Divider(
                  height: 0,
                  color: CustomColors.charcoal,
                ),
              )
            : Container(),
      ],
    );
  }
}
