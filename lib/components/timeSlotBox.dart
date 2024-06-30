import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/providers/sample_provider.dart';

class TimeSlot extends StatelessWidget {
  final bool isSelected;

  final Map slot;

  const TimeSlot({Key? key, required this.isSelected, required this.slot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    String slotId = slot['slotId'];
    String start = DateFormat('hh : mm').format(DateTime.parse(slot['start']));
    String end = DateFormat('hh : mm').format(DateTime.parse(slot['end']));

    return InkWell(
      onTap: () {
        appProvider.updateSelectedSlot(slot);
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        width: 120,
        height: 39,
        decoration: BoxDecoration(
          color:
              isSelected ? CustomColors.peelOrange : CustomColors.transparent,
          borderRadius: const BorderRadius.all(
            Radius.circular(50),
          ),
          border: Border.all(color: CustomColors.peelOrange),
        ),
        child: Center(
          child: Text(
            '${start} - ${end}',
            style: TextStyle(
              color: isSelected ? CustomColors.white : CustomColors.peelOrange,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
