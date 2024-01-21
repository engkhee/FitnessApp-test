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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _buildCard(
                      onPressed: () {
                        // Link this button to the first page
                        Navigator.pushNamed(context, '/AddVideo2');
                      },
                      imageAsset: 'assets/images/dance2_icon.png',
                      buttonText: 'Add Dance Workout',
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildCard(
                      onPressed: () {
                        // Link this button to the second page
                        Navigator.pushNamed(context, '/AddVideo');
                      },
                      imageAsset: 'assets/images/fitness workout.png',
                      buttonText: 'Add Tutorial Videos',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _buildCard(
                      onPressed: () {
                        // Link this button to the first page
                        Navigator.pushNamed(context, '/AddVideo2');
                      },
                      imageAsset: 'assets/images/dance2_icon.png',
                      buttonText: 'Add Dance Workout',
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildCard(
                      onPressed: () {
                        // Link this button to the first page
                        Navigator.pushNamed(context, '/AddVideo2');
                      },
                      imageAsset: 'assets/images/dance2_icon.png',
                      buttonText: 'Add Dance Workout',
                    ),
                  ),
                ],
              ),
            ],
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
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: [
            Image.asset(
              imageAsset,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                buttonText,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

