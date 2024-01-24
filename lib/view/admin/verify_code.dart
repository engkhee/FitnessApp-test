import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'nutritionist.dart';

class VerifyCode extends StatelessWidget {
  static String routeName = "/VerifyCode";

  @override
  Widget build(BuildContext context) {
    return VerificationScreen(); // Show verification screen initially
  }
}

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify your status'),
        backgroundColor: AppColors.adminpageColor1,
        leadingWidth: 40,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen (or exit the app)
          },
          child: Image.asset(
            'assets/icons/back_icon.png',
          ),
        ),
        actions: [
          // Notification icon in the right corner
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Add the code to handle notifications
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Notifications'),
                    content: Container(
                      width: double.maxFinite,
                      child: ListView(
                        children: [
                          ListTile(
                            title: Text('Hey there, your status has been verified...'),
                            subtitle: Text('Verification Code: FS2024 \n Please do not share your verification code'),
                          ),
                          // Add more ListTiles for additional notifications
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),

        ],
      ),

      body: SingleChildScrollView( // Wrap with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image taking up 2/3 of the screen size
              Container(
                height: MediaQuery.of(context).size.height * 1 / 2,
                child: Image.asset(
                  'assets/icons/verify_icon.png', // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(height: 20),
              // Verification code functionality
              TextField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: 'Enter Your Verification Code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.blue, // You can customize the border color
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.blue, // You can customize the border color when focused
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.grey, // You can customize the border color when not focused
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                ),
              ),

              SizedBox(height: 20),
              // Verification code functionality
              TextField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: 'Enter Your Verification Code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.blue, // You can customize the border color
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.blue, // You can customize the border color when focused
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.grey, // You can customize the border color when not focused
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Validate the entered code
                  if (_codeController.text.startsWith('FS') &&
                      _codeController.text.length == 6) {
                    Navigator.pop(context); // Close the verification screen
                    Navigator.pushNamed(context, NutritionistPage.routeName); // Show the dashboard
                  } else {
                    // Show an error message or dialog for an invalid code
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Invalid Code'),
                        content: Text('Please enter a valid verification code.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 5, // Add shadow effect
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Rounded corners
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Center(
                    child: Text(
                      'Verify',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
