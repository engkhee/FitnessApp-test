// import 'package:fitnessapp/utils/app_colors.dart';
// import 'package:fitnessapp/view/your_goal/your_goal_screen.dart';
// import 'package:flutter/material.dart';
//
// import '../../common_widgets/round_gradient_button.dart';
// import '../../common_widgets/round_textfield.dart';
//
// class CompleteProfileScreen extends StatefulWidget {
//   static String routeName = "/CompleteProfileScreen";
//   const CompleteProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   _CompleteProfileScreenState createState() => _CompleteProfileScreenState();
// }
//
// class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
//   final TextEditingController _dobController = TextEditingController();
//   final TextEditingController _weightController = TextEditingController();
//   final TextEditingController _heightController = TextEditingController();
//
//   String _selectedGender = ''; // Variable to hold the selected gender
//
//   @override
//   Widget build(BuildContext context) {
//     var media = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: AppColors.whiteColor,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.only(right: 15, left: 15),
//             child: Column(
//               children: [
//                 Image.asset("assets/images/complete_profile.png", width: media.width),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Text(
//                   "Let’s complete your profile",
//                   style: TextStyle(
//                     color: AppColors.blackColor,
//                     fontSize: 20,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 SizedBox(height: 5),
//                 Text(
//                   "It will help us to know more about you!",
//                   style: TextStyle(
//                     color: AppColors.grayColor,
//                     fontSize: 12,
//                     fontFamily: "Poppins",
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 SizedBox(height: 25),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: AppColors.lightGrayColor,
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         alignment: Alignment.center,
//                         width: 50,
//                         height: 50,
//                         padding: const EdgeInsets.symmetric(horizontal: 15),
//                         child: Image.asset(
//                           "assets/icons/gender_icon.png",
//                           width: 20,
//                           height: 20,
//                           fit: BoxFit.contain,
//                           color: AppColors.grayColor,
//                         ),
//                       ),
//                       Expanded(
//                         // child: DropdownButtonHideUnderline(
//                         //   child: DropdownButton(
//                         //     value: _selectedGender,
//                         //     items: ["Male", "Female"].map((name) {
//                         //     return DropdownMenuItem(
//                         //     value: name,
//                         //     child: Text(
//                         //     name,
//                         //         style: const TextStyle(color: AppColors.grayColor, fontSize: 14),
//                         //       ),
//                         //     );
//                         //     })
//                         //         .toList(),
//                         //     onChanged: (value) {
//                         //       setState(() {
//                         //         _selectedGender = value.toString();
//                         //       });
//                         //     },
//                         //     isExpanded: true,
//                         //     hint: Text(
//                         //       "Choose Gender",
//                         //       style: const TextStyle(color: AppColors.grayColor, fontSize: 12),
//                         //     ),
//                         //   ),
//                         // ),
//                         child:DropdownButton<String>(
//                           value: _selectedGender,
//                           items: ["Male", "Female"].map((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                           onChanged: (String? value) {
//                             setState(() {
//                               _selectedGender = value!;
//                             });
//                           },
//                           isExpanded: true,
//                           hint: Text("Choose Gender"),
//                         )
//
//                       ),
//                       SizedBox(width: 8)
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 15),
//                 RoundTextField(
//                   controller: _dobController,
//                   hintText: "Date of Birth",
//                   icon: "assets/icons/calendar_icon.png",
//                   textInputType: TextInputType.text,
//                 ),
//                 SizedBox(height: 15),
//                 RoundTextField(
//                   controller: _weightController,
//                   hintText: "Your Weight",
//                   icon: "assets/icons/weight_icon.png",
//                   textInputType: TextInputType.text,
//                 ),
//                 SizedBox(height: 15),
//                 RoundTextField(
//                   controller: _heightController,
//                   hintText: "Your Height",
//                   icon: "assets/icons/swap_icon.png",
//                   textInputType: TextInputType.text,
//                 ),
//                 SizedBox(height: 15),
//                 RoundGradientButton(
//                   title: "Next >",
//                   onPressed: () {
//                     // Get the user input
//                     String dob = _dobController.text;
//                     String weight = _weightController.text;
//                     String height = _heightController.text;
//
//                     // Use the values as needed, and navigate to the next screen
//                     Navigator.pushNamed(context, YourGoalScreen.routeName);
//                   },
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:fitnessapp/utils/app_colors.dart';
// import 'package:fitnessapp/view/login/login_screen.dart';
// import 'package:fitnessapp/view/your_goal/your_goal_screen.dart';
// import 'package:flutter/material.dart';
//
// import '../../common_widgets/round_gradient_button.dart';
// import '../../common_widgets/round_textfield.dart';
//
// class CompleteProfileScreen extends StatefulWidget {
//   static String routeName = "/CompleteProfileScreen";
//   const CompleteProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   _CompleteProfileScreenState createState() => _CompleteProfileScreenState();
// }
//
// class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
//   final TextEditingController _dobController = TextEditingController();
//   final TextEditingController _weightController = TextEditingController();
//   final TextEditingController _heightController = TextEditingController();
//
//   String? _selectedGender; // Use nullable type
//
//   @override
//   Widget build(BuildContext context) {
//     var media = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: AppColors.whiteColor,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.only(right: 15, left: 15),
//             child: Column(
//               children: [
//                 Image.asset("assets/images/complete_profile.png", width: media.width),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Text(
//                   "Let’s complete your profile",
//                   style: TextStyle(
//                     color: AppColors.blackColor,
//                     fontSize: 20,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 SizedBox(height: 5),
//                 Text(
//                   "It will help us to know more about you!",
//                   style: TextStyle(
//                     color: AppColors.grayColor,
//                     fontSize: 12,
//                     fontFamily: "Poppins",
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 SizedBox(height: 25),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: AppColors.lightGrayColor,
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         alignment: Alignment.center,
//                         width: 50,
//                         height: 50,
//                         padding: const EdgeInsets.symmetric(horizontal: 15),
//                         child: Image.asset(
//                           "assets/icons/gender_icon.png",
//                           width: 20,
//                           height: 20,
//                           fit: BoxFit.contain,
//                           color: AppColors.grayColor,
//                         ),
//                       ),
//                       Expanded(
//                         child: DropdownButton<String>(
//                           value: _selectedGender,
//                           items: ["Male", "Female"].map((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                           onChanged: (String? value) {
//                             setState(() {
//                               _selectedGender = value;
//                             });
//                           },
//                           isExpanded: true,
//                           hint: Text("Choose Gender"),
//                         ),
//                       ),
//                       SizedBox(width: 8)
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 15),
//                 RoundTextField(
//                   controller: _dobController,
//                   hintText: "Date of Birth",
//                   icon: "assets/icons/calendar_icon.png",
//                   textInputType: TextInputType.text,
//                 ),
//                 SizedBox(height: 15),
//                 RoundTextField(
//                   controller: _weightController,
//                   hintText: "Your Weight",
//                   icon: "assets/icons/weight_icon.png",
//                   textInputType: TextInputType.text,
//                 ),
//                 SizedBox(height: 15),
//                 RoundTextField(
//                   controller: _heightController,
//                   hintText: "Your Height",
//                   icon: "assets/icons/swap_icon.png",
//                   textInputType: TextInputType.text,
//                 ),
//                 SizedBox(height: 15),
//                 RoundGradientButton(
//                   title: "Next >",
//                   onPressed: () {
//                     // Get the user input
//                     String dob = _dobController.text;
//                     String weight = _weightController.text;
//                     String height = _heightController.text;
//
//                     // Use the values as needed, and navigate to the next screen
//                     // Navigator.pushNamed(context, YourGoalScreen.routeName);
//                     Navigator.pushNamed(context, LoginScreen.routeName);
//                   },
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/login/login_screen.dart';
import 'package:flutter/material.dart';
import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompleteProfileScreen extends StatefulWidget {
  static String routeName = "/CompleteProfileScreen";
  final Map<String, dynamic>? userData;

  const CompleteProfileScreen({Key? key, this.userData}) : super(key: key);

  @override
  _CompleteProfileScreenState createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {

  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  String? _selectedGender; // Use nullable type

  final CollectionReference _userProfileCollection = FirebaseFirestore.instance.collection('User_profile_info');

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    String userFname = widget.userData?['Fname'] ?? '';
    String userLname = widget.userData?['Lname'] ?? '';
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 15, left: 15),
            child: Column(
              children: [
                Image.asset("assets/images/complete_profile.png", width: media.width),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Let’s complete your profile",
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "It will help us to know more about you!",
                  style: TextStyle(
                    color: AppColors.grayColor,
                    fontSize: 12,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 25),
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
                      SizedBox(width: 8)
                    ],
                  ),
                ),
                SizedBox(height: 15),
                RoundTextField(
                  controller: _dobController,
                  hintText: "Date of Birth",
                  icon: "assets/icons/calendar_icon.png",
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 15),
                RoundTextField(
                  controller: _weightController,
                  hintText: "Your Weight",
                  icon: "assets/icons/weight_icon.png",
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 15),
                RoundTextField(
                  controller: _heightController,
                  hintText: "Your Height",
                  icon: "assets/icons/swap_icon.png",
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 15),
            RoundGradientButton(
              title: "Next >",
              onPressed: () async {
                // Get the user input
                String dob = _dobController.text;
                String weight = _weightController.text;
                String height = _heightController.text;

                // Calculate BMI
                double weightInKg = double.tryParse(weight) ?? 0.0;
                double heightInMeter = double.tryParse(height) ?? 0.0;
                double bmi = calculateBMI(weightInKg, heightInMeter);

                // Store the user profile information including BMI and user details in Firestore
                await _userProfileCollection.add({
                  'fname': userFname,
                  'lname': userLname,
                  'gender': _selectedGender,
                  'dob': dob,
                  'weight': weight,
                  'height': height,
                  'bmi': bmi.toString(),
                });
                // Navigate to the next screen
                // Navigator.pushNamed(context, YourGoalScreen.routeName);
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
double calculateBMI(double weightInKg, double heightInMeter) {
  // BMI formula: BMI = weight (kg) / (height (m) * height (m))
  if (heightInMeter > 0) {
    return weightInKg / (heightInMeter * heightInMeter);
  } else {
    return 0.0;
  }
}




