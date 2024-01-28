import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';
import '../admin/admin_page.dart';
import '../admin/verify_code.dart';
import '../dashboard/dashboard_screen.dart';
import '../signup/register.dart';

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
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      // Show an error message if email or password is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter both email and password.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if the logged-in user is the admin
      if (email == 'admin@fitness.com' && password == 'admin123') {
        Navigator.pushNamed(context, AdminPage.routeName);
      } else {
        // Navigate to the user dashboard
        Navigator.pushNamed(context, DashboardScreen.routeName);
      }
    } catch (e) {
      // Handle login errors here (e.g., invalid credentials)
      print("Login failed: $e");
      // You can show an error message to the user if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            height: media.height, // Add height constraint
            child: Column(
              children: [
                SizedBox(
                  width: media.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: media.width * 0.23,
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
                      SizedBox(height: media.width * 0.01),
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
                SizedBox(height: media.width * 0.05),
                RoundTextField(
                  controller: _emailController,
                  hintText: "Email",
                  icon: "assets/icons/message_icon.png",
                  textInputType: TextInputType.emailAddress,
                ),
                SizedBox(height: media.width * 0.05),
                RoundTextField(
                  controller: _passwordController,
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
                      ),
                    ),
                  ),
                ),
                SizedBox(height: media.width * 0.03),
                const Text(
                  "Forgot your password?",
                  style: TextStyle(
                    color: AppColors.grayColor,
                    fontSize: 10,
                  ),
                ),
                const Spacer(),
                RoundGradientButton(
                  title: "Login as user",
                  onPressed: _login,
                ),
                RoundGradientButton(
                  title: "Login as nutritionist",
                  onPressed: () {
                    Navigator.pushNamed(context, VerifyCode.routeName);
                  },
                ),
                SizedBox(height: media.width * 0.01),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RegisterPage.routeName);
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        const TextSpan(
                          text: "Don’t have an account yet? ",
                        ),
                        TextSpan(
                          text: "Register",
                          style: TextStyle(
                            color: AppColors.secondaryColor1,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
