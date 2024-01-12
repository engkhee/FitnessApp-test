import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnessapp/common_widgets/round_textfield.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../login/login_screen.dart';

class AuthService extends StatefulWidget {
  static String routeName = "/AuthService";
  const AuthService({Key? key}) : super(key: key);

  @override
  _AuthService createState() => _AuthService();
}

class _AuthService extends State<AuthService> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _IcController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _eduController = TextEditingController();
  TextEditingController _certController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Please provide further information',
          style: TextStyle(
            color: AppColors.blackColor,
            fontSize: 16,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Full Name as per IC/Passport'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _IcController,
              decoration: InputDecoration(labelText: 'IC/Passport number'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone number'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _eduController,
              decoration: InputDecoration(labelText: 'Education level'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _certController,
              decoration: InputDecoration(labelText: 'Certification link'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _submitForm();
                Navigator.pushNamed(context,LoginScreen.routeName);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    // Get values from controllers
    String name = _nameController.text;
    String Ic = _IcController.text;
    String phone = _phoneController.text;
    String edu = _eduController.text;
    String cert = _certController.text;

    // Send data to Firebase
    FirebaseFirestore.instance.collection('nutritionist_registeration').add({
      'name': name,
      'Ic': Ic,
      'phone': phone,
      'education': edu,
      'certification': cert,
    });

    // Clear input fields
    _nameController.clear();
    _IcController.clear();
    _phoneController.clear();
    _eduController.clear();
    _certController.clear();

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Application submitted successfully!'),
      ),
    );
  }
}
