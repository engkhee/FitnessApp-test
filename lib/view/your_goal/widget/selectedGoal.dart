import 'package:fitnessapp/view/your_goal/SearchVideo.dart';
import 'package:flutter/material.dart';

class selectedGoal extends StatefulWidget {
  final String selectedGoalId;

  const selectedGoal({
    Key? key,
    required this.selectedGoalId,
  }) : super(key: key);

  @override
  _selectedGoalState createState() => _selectedGoalState();
}

class _selectedGoalState extends State<selectedGoal> {
  List<String> searchQueries = [];

  @override
  void initState() {
    super.initState();
    // Populate the searchQueries list based on the selectedGoalId
    searchQueries = getSearchQueriesForGoalId(widget.selectedGoalId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Selected Goal"),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.close),
          //   onPressed:
          // ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Selected Goal ID:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              widget.selectedGoalId,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              "Focus Area(s):",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchQueries.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(searchQueries[index]),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the video search page and pass searchQueries
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchVideo(searchQueries: searchQueries),
                  ),
                );
              },
              child: Text("Confirm"),
            ),
          ],
        ),
      ),
    );
  }

  List<String> getSearchQueriesForGoalId(String goalId) {
    switch (goalId) {
      case '1':
        return ['arm', 'shoulder'];
      case '2':
        return ['chest', 'back'];
      case '3':
        return ['ab'];
      case '4':
        return ['leg', 'glute'];
      default:
        return [];
    }
  }
}
