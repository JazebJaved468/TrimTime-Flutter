import 'package:flutter/material.dart';
import 'package:trim_time/colors/custom_colors.dart';

class Review extends StatelessWidget {
  const Review({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10, right: 10, left: 10),
        padding: EdgeInsets.all(8),
        width: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    // color: Colors.red,
                    child: Text(
                  'Marielle Wigington',
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: CustomColors.white),
                )),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
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
                        '5',
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
              margin: EdgeInsets.only(top: 10),
              child: Text(
                'This is my first time trying tthe service, but the results are very satisfying!!! 👍👍',
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 14,
                    color: CustomColors.white),
              ),
            )
          ],
        ));
  }
}
