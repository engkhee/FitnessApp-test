import 'package:flutter/material.dart';

class NutritionistTermsConditionsScreen extends StatelessWidget {
  static const String routeName = "/NutritionistTermsConditionsScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms and Conditions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Our App!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'By using this app, you agree to comply with and be bound by the following terms and conditions. If you disagree with any part of these terms and conditions, please do not use our app.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '1. Use of the App:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'a. You agree to use the app for lawful purposes only and in a manner that does not violate any applicable laws or regulations.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'b. Unauthorized use of this app may give rise to a claim for damages and/or be a criminal offense.',
              style: TextStyle(fontSize: 16),
            ),
            // Add more sections of your terms and conditions as needed
          ],
        ),
      ),
    );
  }
}
