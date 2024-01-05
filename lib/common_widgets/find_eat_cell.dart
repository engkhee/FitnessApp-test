import 'round_button.dart';
import 'package:flutter/material.dart';

import 'package:fitnessapp/utils/app_colors.dart';

class FindEatCell extends StatelessWidget {
  final Map fObj;
  final int index;

  // Corrected constructor
  const FindEatCell({Key? key, required this.index, required this.fObj})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    bool isEvent = index % 2 == 0;
    return Container(
      margin: const EdgeInsets.all(8),
      width: media.width * 0.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isEvent
              ? [
            AppColors.primaryColor2.withOpacity(0.5),
            AppColors.primaryColor1.withOpacity(0.5)
          ]
              : [
            AppColors.secondaryColor2.withOpacity(0.5),
            AppColors.secondaryColor1.withOpacity(0.5)
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(75),
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                fObj["image"].toString(),
                width: media.width * 0.3,
                height: media.width * 0.25,
                fit: BoxFit.contain,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              fObj["name"],
              style: const TextStyle(
                color: AppColors.blackColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              fObj["number"],
              style: const TextStyle(color: AppColors.grayColor, fontSize: 12),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              width: 90,
              height: 25,
              child: RoundButton(
                fontSize: 12,
                type: isEvent
                    ? RoundButtonType.bgGradient
                    : RoundButtonType.bgSGradient,
                title: "Select",
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
