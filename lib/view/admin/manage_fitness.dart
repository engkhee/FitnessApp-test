import 'package:flutter/material.dart';
import 'package:fitnessapp/utils/app_colors.dart';

class ManageFitness extends StatelessWidget {
  static String routeName = "/ManageFitness";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Fitness',
        ),
        backgroundColor: AppColors.adminpageColor2,
        leadingWidth: 40,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            'assets/icons/back_icon.png',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCard(
                  onPressed: () {
                    Navigator.pushNamed(context, '/AddVideo2');
                  },
                  imageAsset: 'assets/images/dance_workout.jpg',
                  buttonText: 'Add Dance Workout',
                ),
                SizedBox(height: 24),
                _buildCard(
                  onPressed: () {
                    Navigator.pushNamed(context, '/AddVideo');
                  },
                  imageAsset: 'assets/images/workout.jpg',
                  buttonText: 'Add Tutorial Videos',
                ),
                SizedBox(height: 24),
                _buildCard(
                  onPressed: () {
                    Navigator.pushNamed(context, '/AddVideo3');
                  },
                  imageAsset: 'assets/images/workout4.jpg',
                  buttonText: 'Add Steps Workout Tutorials',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required VoidCallback onPressed,
    required String imageAsset,
    required String buttonText,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: [
            Image.asset(
              imageAsset,
              height: 240, // Adjust the height as needed
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                buttonText,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
