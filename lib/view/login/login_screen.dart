import 'package:firebase_core/firebase_core.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';
import '../admin/admin_page.dart';
import '../dashboard/dashboard_screen.dart';
import '../profile/complete_profile_screen.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/LoginScreen";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
    );

    // Check if the logged-in user is the admin
    if (_emailController.text == 'admin@fitness.com' && _passwordController.text == 'admin123') {
      Navigator.pushNamed(context, AdminPage.routeName);
    }

  }


  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 25),
          child: Column(
            children: [
              SizedBox(
                width: media.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: media.width*0.23,
                    ),
                    const Text(
                      "Hey there,",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: media.width*0.01),
                    const Text(
                      "Welcome Back",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 20,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: media.width*0.05),
              RoundTextField(
                  // hintText: "Email",
                  // icon: "assets/icons/message_icon.png",
                  // textInputType: TextInputType.emailAddress),
                controller: _emailController,
                hintText: "Email",
                icon: "assets/icons/message_icon.png",
                textInputType: TextInputType.emailAddress,
              ),
              SizedBox(height: media.width*0.05),
              RoundTextField(
                // hintText: "Password",
                // icon: "assets/icons/lock_icon.png",
                // textInputType: TextInputType.text,
                // isObscureText: true,
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
              SizedBox(height: media.width*0.03),
              const Text("Forgot your password?",
                  style: TextStyle(
                    color: AppColors.grayColor,
                    fontSize: 10,
                  )),
              const Spacer(),
              RoundGradientButton(
              //   title: "Login",
              //   onPressed: () {
              //     Navigator.pushNamed(context, CompleteProfileScreen.routeName);
              //   },
              // ),
                title: "Login",
                onPressed: () {
                  _login(); // Call the login function
                  // Navigator.pushNamed(context,DashboardScreen.routeName);
                },
              ),
              SizedBox(height: media.width*0.01),
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
              const SizedBox(
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
              const SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SignupScreen.routeName);
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
                            text: "Don’t have an account yet? ",
                          ),
                          TextSpan(
                              text: "Register",
                              style: TextStyle(
                                  color: AppColors.secondaryColor1,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                        ]),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}