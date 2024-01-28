import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/login/login_screen.dart';
import 'package:fitnessapp/view/profile/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompleteProfileScreen extends StatefulWidget {
  static String routeName = "/CompleteProfileScreen";

  @override
  _CompleteProfileScreenState createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  String? _selectedGender;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    var _userDataProvider = Provider.of<UserDataProvider>(context, listen: false);
    _userData = _userDataProvider.userData;
    print("User Data: $_userData");
  }

  final CollectionReference _userProfileCollection =
  FirebaseFirestore.instance.collection('User_profile_info');

  bool validateFields() {
    if (_selectedGender == null ||
        _dobController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _heightController.text.isEmpty) {
      // Display an error message or handle validation as needed
      return false;
    }
    return true;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked != null && picked != DateTime.now()) {
      String formattedDate = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      _dobController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    String userFname = _userData?['Fname'] ?? '';
    String userLname = _userData?['Lname'] ?? '';
    String userEmail = _userData?['Email'] ?? '';

    print("User Data: $_userData");

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 15, left: 15),
            child: Column(
              children: [
                Image.asset("assets/images/complete_profile.png", width: media.width),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Let’s complete your profile",
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "It will help us to know more about you!",
                  style: TextStyle(
                    color: AppColors.grayColor,
                    fontSize: 12,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightGrayColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Image.asset(
                          "assets/icons/gender_icon.png",
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                          color: AppColors.grayColor,
                        ),
                      ),
                      Expanded(
                        child: DropdownButton<String>(
                          value: _selectedGender,
                          items: ["Male", "Female"].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                          isExpanded: true,
                          hint: Text("Choose Gender"),
                        ),
                      ),
                      const SizedBox(width: 8)
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                // RoundTextField(
                //   controller: _dobController,
                //   hintText: "Date of Birth",
                //   icon: "assets/icons/calendar_icon.png",
                //   textInputType: TextInputType.text,
                //   onTap: () {
                //     _selectDate(context);
                //   },
                // ),
                //SizedBox(height: 15),
                RoundTextField(
                  controller: _weightController,
                  hintText: "Your Weight (kg)",
                  icon: "assets/icons/weight_icon.png",
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 15),
                RoundTextField(
                  controller: _heightController,
                  hintText: "Your Height (cm)",
                  icon: "assets/icons/swap_icon.png",
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightGrayColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Image.asset(
                          "assets/icons/calendar_icon.png",
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                          color: AppColors.grayColor,
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: AbsorbPointer(
                            child: TextField(
                              controller: _dobController,
                              decoration: const InputDecoration(
                                hintText: "Date of Birth",
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8)
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                RoundGradientButton(
                  title: "Next >",
                  onPressed: () async {
                    // Validate the fields before proceeding
                    if (!validateFields()) {
                      return;
                    }

                    // Get the user input
                    String dob = _dobController.text;
                    String weight = _weightController.text;
                    String height = _heightController.text;

                    // Calculate BMI
                    double weightInKg = double.tryParse(weight) ?? 0.0;
                    double heightInCm = double.tryParse(height) ?? 0.0;
                    double bmi = calculateBMI(weightInKg, heightInCm);
                    String bmiGroup = determineBMIGroup(bmi)??'';

                    await _userProfileCollection.add({
                      'fname': userFname,
                      'lname': userLname,
                      'email': userEmail,
                      'gender': _selectedGender,
                      'dob': dob,
                      'weight': weight,
                      'height': height,
                      'bmi': bmi.toString(),
                      'bmigroup': bmiGroup,
                    });

                    // Navigate to the next screen
                    Navigator.pushNamed(context, LoginScreen.routeName);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

double calculateBMI(double weightInKg, double heightInCM) {
  if (heightInCM > 0) {
    double bmi = weightInKg / ((heightInCM / 100) * (heightInCM / 100));
    return double.parse(bmi.toStringAsFixed(2));
  } else {
    return 0.00;
  }
}

//determine user's BMI Group
String? determineBMIGroup(double bmi) {
  if (bmi < 18.5) {
    return 'Underweight';
  } else if (bmi >= 18.5 && bmi <= 24.9) {
    return 'Normal';
  } else if (bmi >= 25) {
    return 'Overweight';
  }
}

