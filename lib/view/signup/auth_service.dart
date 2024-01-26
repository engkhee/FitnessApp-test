import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import '../login/login_screen.dart';
import 'nutritionist_privacy_terms.dart';

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
  TextEditingController _emailController = TextEditingController();

  String selectedCountryCode = '+60'; // Default country code
  String selectedEducationLevel = 'Degree';


  @override
  Widget build(BuildContext context) {
    bool isTermsAccepted = false; // Track whether the terms are accepted

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Please Provide \ Your Details',
          style: TextStyle(
            fontSize: 18.0,
            letterSpacing: 1.8,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.adminpageColor1,
        leadingWidth: 40,
        leading: TextButton(
          onPressed: () {Navigator.pop(context);},
          child: Image.asset(
            'assets/icons/back_icon.png',
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextField(_nameController, 'Full name as per IC/Passport'),
              _buildTextField(_IcController, 'IC/Passport number'),
              _buildTextField(_emailController, 'Personal email'),
              _buildPhoneNumberField(),
              _buildEducationLevelField(),
              _buildTextField(_eduController, 'Education name'),
              _buildTextField(_certController,
                  'Certification link (eg: google drive link)'),
              SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isTermsAccepted = !isTermsAccepted;
                      });
                    },
                    icon: Icon(
                      isTermsAccepted
                          ? Icons.check_box_outline_blank_outlined
                          : Icons.check_box_outlined,

                      color: AppColors.adminpageColor4, // Customize the color
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to your terms and conditions screen
                        Navigator.pushNamed(context,
                            NutritionistTermsConditionsScreen.routeName);
                      },
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 13, color: AppColors.adminpageColor4),
                          children: [
                            TextSpan(text: 'By continuing you accept our '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Term of Use',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),

                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // if (isTermsAccepted) {
                    _submitForm();
                  Navigator.pushNamed(context, LoginScreen.routeName);
                  // } else {
                  //   // Show a message or handle the case where terms are not accepted
                  // }
                },
                style: ElevatedButton.styleFrom(
                  primary: AppColors.adminpageColor3,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Submit application',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTextField(TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.deepPurpleAccent),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2.0),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 1.0),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          DropdownButton<String>(
            value: selectedCountryCode,
            onChanged: (String? newValue) {
              setState(() {
                selectedCountryCode = newValue!;
              });
            },
            items: <String>[
              '+60',
              '+1',
              '+44',
              '+81'
            ] // Add more country codes as needed
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _phoneController,
              style: TextStyle(fontSize: 16),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone number',
                labelStyle: TextStyle(color: Colors.deepPurpleAccent),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.deepPurpleAccent, width: 2.0),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.deepPurpleAccent, width: 1.0),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationLevelField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),

      child: Row(
        children: [
          Text(
            'Education Level:',
            style: TextStyle(fontSize: 16, color: Colors.deepPurpleAccent),
          ),
          SizedBox(width: 8),
          DropdownButton<String>(
            value: selectedEducationLevel,
            onChanged: (String? newValue) {
              setState(() {
                selectedEducationLevel = newValue!;
              });
            },
            items: <String>[
              'Degree',
              'Master',
              'PhD'
            ] // Add more education levels as needed
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
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
    String email = _emailController.text;

    // Send data to Firestore
    FirebaseFirestore.instance.collection('nutritionist_registeration').add({
      'name': name,
      'Ic': Ic,
      'phone': phone,
      'education': edu,
      'certification': cert,
      'email':email,

    }).then((value) {
      // Clear input fields after successful submission
      _nameController.clear();
      _IcController.clear();
      _phoneController.clear();
      _eduController.clear();
      _certController.clear();
      _emailController.clear();

      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Application submitted successfully!'),
        ),
      );
    }).catchError((error) {
      // Handle errors if any
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting application. Please try again.'),
        ),
      );
      print('Error submitting application: $error');
    });
  }
}
