import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/view/signup/auth_service.dart';
import 'package:flutter/material.dart';
import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';
import '../login/login_screen.dart';
import '../profile/complete_profile_screen.dart';

class SignupScreen extends StatefulWidget {
  static String routeName = "/SignupScreen";

  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isCheck = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _icNumberController = TextEditingController();

  // Future<void> _register() async {
  //   {
  //     await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: _emailController.text,
  //       password: _passwordController.text,
  //     );
  //
  //   }
  // }

  Future<void> _register() async {
    try {
      // Create user with email and password
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Get the current user
      User? user = _auth.currentUser;

      // Store user data in Firestore
      await FirebaseFirestore.instance.collection('Users').doc(user!.uid).set({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
        'icNumber': _icNumberController.text,
      });

      print("Registration successful!");
    } catch (error) {
      print("Error during registration: $error");
      // Handle the error (display a message, log, etc.)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Welcome to fitness application",
                  style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 16,
                ),
                ),
                SizedBox(height: 5),
                Text(
                  "Create an Account",
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 20,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                RoundTextField(
                  controller: _firstNameController,
                  hintText: "First Name",
                  icon: "assets/icons/profile_icon.png",
                  textInputType: TextInputType.name,
                ),
                SizedBox(
                  height: 15,
                ),
                RoundTextField(
                    controller: _lastNameController,
                    hintText: "Last Name",
                    icon: "assets/icons/profile_icon.png",
                    textInputType: TextInputType.name),
                SizedBox(
                  height: 15,
                ),
                RoundTextField(
                  controller: _icNumberController,
                  hintText: "IC Number",
                  icon: "assets/icons/ic_number_icon.png",
                  textInputType: TextInputType.number, // Assuming IC number is numeric
                ),
                SizedBox(
                  height: 15,
                ),
                // RoundTextField(
                //     hintText: "Email",
                //     icon: "assets/icons/message_icon.png",
                //     textInputType: TextInputType.emailAddress),
                // Update the Email TextField
                RoundTextField(
                  controller: _emailController, // Add this line
                  hintText: "Email",
                  icon: "assets/icons/message_icon.png",
                  textInputType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 15,
                ),
                // RoundTextField(
                //   hintText: "Password",
                //   icon: "assets/icons/lock_icon.png",
                //   textInputType: TextInputType.text,
                //   isObscureText: true,

                // Update the Password TextField
                RoundTextField(
                  controller: _passwordController, // Add this line
                  hintText: "Password",
                  icon: "assets/icons/lock_icon.png",
                  textInputType: TextInputType.text,
                  isObscureText: true,
                  rightIcon: TextButton(
                      onPressed: () {},
                      child: Container(
                          alignment: Alignment.center,
                          width: 20,
                          height: 20,
                          child: Image.asset(
                            "assets/icons/hide_pwd_icon.png",
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                            color: AppColors.grayColor,
                          ))),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isCheck = !isCheck;
                          });
                        },
                        icon: Icon(
                          isCheck
                              ? Icons.check_box_outline_blank_outlined
                              : Icons.check_box_outlined,
                          color: AppColors.grayColor,
                        )),
                    Expanded(
                      child: Text(
                          "By continuing you accept our Privacy Policy and\nTerm of Use",
                          style: TextStyle(
                            color: AppColors.grayColor,
                            fontSize: 10,
                          )),
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                // RoundGradientButton(
                //   title: "Register as user",
                //   onPressed: () {
                //     Navigator.pushNamed(context, CompleteProfileScreen.routeName);
                //   },
                // ),
                // Update the Register Button
                RoundGradientButton(
                  title: "Register as user",
                  onPressed: () {
                    _register(); // Call the register function
                    Navigator.pop(context);
                  },
                ),

                RoundGradientButton(
                  title: "Register as nutritionist",
                  onPressed: () {
                    _register(); // Call the register function
                    Navigator.pushNamed(context, AuthService.routeName);
                  },
                ),


                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                          width: double.maxFinite,
                          height: 1,
                          color: AppColors.grayColor.withOpacity(0.5),
                        )),
                    Text("  Or  ",
                        style: TextStyle(
                            color: AppColors.grayColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400)),
                    Expanded(
                        child: Container(
                          width: double.maxFinite,
                          height: 1,
                          color: AppColors.grayColor.withOpacity(0.5),
                        )),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {

                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.primaryColor1.withOpacity(0.5), width: 1, ),
                        ),
                        child: Image.asset("assets/icons/google_icon.png",width: 20,height: 20,),
                      ),
                    ),
                    SizedBox(width: 30,),
                    GestureDetector(
                      onTap: () {

                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.primaryColor1.withOpacity(0.5), width: 1, ),
                        ),
                        child: Image.asset("assets/icons/facebook_icon.png",width: 20,height: 20,),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                          children: [
                            const TextSpan(
                              text: "Already have an account? ",
                            ),
                            TextSpan(
                                text: "Login",
                                style: TextStyle(
                                    color: AppColors.secondaryColor1,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800)),
                          ]),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


