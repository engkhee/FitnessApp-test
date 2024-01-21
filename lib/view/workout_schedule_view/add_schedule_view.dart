import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/utils/common.dart';
import 'package:fitnessapp/view/workour_detail_view/widgets/icon_title_next_row.dart';
import 'package:fitnessapp/common_widgets/round_gradient_button.dart';

class AddScheduleView extends StatefulWidget {
  final DateTime date;

  const AddScheduleView({Key? key, required this.date}) : super(key: key);

  @override
  State<AddScheduleView> createState() => _AddScheduleViewState();
}

class _AddScheduleViewState extends State<AddScheduleView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.lightGrayColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              "assets/icons/closed_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Add Schedule",
          style: TextStyle(
            color: AppColors.blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              // Handle more button tap
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.lightGrayColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                "assets/icons/more_icon.png",
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.whiteColor,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/icons/date.png",
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  dateToString(widget.date, formatStr: "E, dd MMMM yyyy"),
                  style: TextStyle(color: AppColors.grayColor, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "Time",
              style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: media.width * 0.35,
              child: CupertinoDatePicker(
                onDateTimeChanged: (newDate) {
                  // Handle date-time changes
                },
                initialDateTime: DateTime.now(),
                use24hFormat: false,
                minuteInterval: 1,
                mode: CupertinoDatePickerMode.time,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Details Workout",
              style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            // You may want to implement functionality for the following widgets
            IconTitleNextRow(
              icon: "assets/icons/choose_workout.png",
              title: "Choose Workout",
              time: "Upperbody",
              color: AppColors.lightGrayColor,
              onPressed: () {
                // Handle Choose Workout button tap
              },
            ),
            const SizedBox(height: 10),
            IconTitleNextRow(
              icon: "assets/icons/difficulity_icon.png",
              title: "Difficulty",
              time: "Beginner",
              color: AppColors.lightGrayColor,
              onPressed: () {
                // Handle Difficulty button tap
              },
            ),
            const SizedBox(height: 10),
            IconTitleNextRow(
              icon: "assets/icons/repetitions.png",
              title: "Custom Repetitions",
              time: "",
              color: AppColors.lightGrayColor,
              onPressed: () {
                // Handle Custom Repetitions button tap
              },
            ),
            const SizedBox(height: 10),
            IconTitleNextRow(
              icon: "assets/icons/repetitions.png",
              title: "Custom Weights",
              time: "",
              color: AppColors.lightGrayColor,
              onPressed: () {
                // Handle Custom Weights button tap
              },
            ),
            Spacer(),
            RoundGradientButton(
              title: "Save",
              onPressed: () {
                // Handle Save button tap
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
