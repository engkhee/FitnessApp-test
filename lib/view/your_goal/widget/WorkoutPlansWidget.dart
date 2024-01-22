import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutPlansWidget extends StatelessWidget {
  const WorkoutPlansWidget({Key? key, required String searchQuery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('workout_plans').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          var plans = snapshot.data!.docs;

          return ListView.builder(
            itemCount: plans.length,
            itemBuilder: (context, index) {
              var plan = plans[index].data() as Map<String, dynamic>;

              return Card(
                child: InkWell(
                  onTap: () {
                    // Handle plan tap
                  },
                  child: ListTile(
                    title: Text(plan['title']),
                    subtitle: Text(plan['description']),
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

// Usage in another file:
// WorkoutPlansWidget() // Place this widget where you want to display workout plans.
