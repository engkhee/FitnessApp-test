import 'package:flutter/material.dart';
import 'package:fitnessapp/view/your_goal/widget/WorkoutPlansWidget.dart';
import 'package:fitnessapp/view/your_goal/widget/TutorialVideosWidget.dart';

class RecommendedWorkoutsPage extends StatelessWidget {
  final List<String> selectedKeywords;

  const RecommendedWorkoutsPage({Key? key, required this.selectedKeywords, required String keywords}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recommended Workouts"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Recommended Workout Plans",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: WorkoutPlansWidget(searchQuery: selectedKeywords.join(" ")),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Recommended Tutorial Videos",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: TutorialVideosWidget(searchQuery: selectedKeywords.join(" ")),
          ),
        ],
      ),
    );
  }
}