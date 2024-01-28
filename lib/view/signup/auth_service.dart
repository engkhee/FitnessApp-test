import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  TextEditingController _passwordController = TextEditingController();

  String selectedCountryCode = '+60';
  String selectedEducationLevel = 'Degree';

  @override
  Widget build(BuildContext context) {
    bool isTermsAccepted = false;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Please Provide Your Details',
          style: TextStyle(
            fontSize: 18.0,
            letterSpacing: 1.8,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.adminpageColor1,
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextField(_nameController, 'Full name as per IC/Passport'),
              _buildTextField(_IcController, 'IC/Passport number'),
              _buildTextField(_emailController, 'Personal email'),
              _buildTextField(_passwordController, 'Password', isPassword: true),
              _buildPhoneNumberField(),
              _buildEducationLevelField(),
              _buildTextField(_eduController, 'Education name'),
              _buildTextField(_certController, 'Supporting document (eg: certification link)'),
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
                      isTermsAccepted ? Icons.check_box_outline_blank_outlined : Icons.check_box_outlined,
                      color: AppColors.adminpageColor4,
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, NutritionistTermsConditionsScreen.routeName);
                      },
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 13, color: AppColors.adminpageColor4),
                          children: [
                            TextSpan(text: 'By continuing you accept our '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(decoration: TextDecoration.underline),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Term of Use',
                              style: TextStyle(decoration: TextDecoration.underline),
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
                onPressed: _submitForm,
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

  Widget _buildTextField(TextEditingController controller, String labelText, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
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
            ]
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
                  borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2.0),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 1.0),
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
            ]
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

  void _submitForm() async {
    // Get values from controllers
    String name = _nameController.text;
    String Ic = _IcController.text;
    String phone = _phoneController.text;
    String edu = _eduController.text;
    String cert = _certController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      // Create user with email and password using Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the generated user ID
      String userId = userCredential.user!.uid;

      // Send data to Firestore
      await FirebaseFirestore.instance.collection('Users_nutritionist').doc(userId).set({
        'name': name,
        'Ic': Ic,
        'phone': phone,
        'education': edu,
        'certification': cert,
        'email': email,
        'status': 'Pending', // Default status
      });

      // Clear input fields after successful submission
      _nameController.clear();
      _IcController.clear();
      _phoneController.clear();
      _eduController.clear();
      _certController.clear();
      _emailController.clear();
      _passwordController.clear();

      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Application submitted successfully!'),
        ),
      );

      // Navigate to the desired screen
      Navigator.pushNamed(context, LoginScreen.routeName);
    } catch (error) {
      // Handle registration errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting application. Please try again.'),
        ),
      );
      print('Error submitting application: $error');
    }
  }
}