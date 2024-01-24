import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';
import 'package:fitnessapp/view/login/login_screen.dart';

class UserRegistration extends StatefulWidget {
  static String routeName = "/UserRegistration";

  const UserRegistration({Key? key}) : super(key: key);

  @override
  State<UserRegistration> createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  bool isCheck = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  TextEditingController? _dobController;
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String? _selectedGender;

  final CollectionReference _usersPublicUserCollection =
  FirebaseFirestore.instance.collection('Public_user');

  @override
  void initState() {
    super.initState();
    _dobController = TextEditingController();
  }

  Future<void> _register(String userType) async {
    try {
      // Create user with email and password
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Get the current user
      User? user = _auth.currentUser;

      // Check if the user is not null before proceeding
      if (user != null) {
        // Store user data in Firestore
        Map<String, dynamic> userData = {
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'email': _emailController.text,
          'gender': _selectedGender,
          'dob': _dobController!.text,
          'weight': _weightController.text,
          'height': _heightController.text,

        };

        // Use the correct collection name ('Public_user' in your case)
        await FirebaseFirestore.instance
            .collection('Public_user')
            .doc(user.uid)  // Use user.uid instead of user!.uid
            .set(userData)
            .catchError((error) {
          print("Firestore error: $error");
        });

        print("Registration successful!");
      } else {
        print("User is null");
      }
    } catch (error) {
      print("Error during registration: $error");
      // Handle the error (display a message, log, etc.)
    }
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
      String formattedDate =
          "${picked.day}/${picked.month}/${picked.year}";
      _dobController!.text = formattedDate;
    }
  }

  Object calculateBMI(double weightInKg, double heightInCM) {
    if (heightInCM > 0) {
      return (weightInKg / ((heightInCM / 100) * (heightInCM / 100)))
          .toStringAsFixed(2);
    } else {
      return 0.00;
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
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
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Welcome to the fitness application",
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Create an Account",
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 20,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                RoundTextField(
                  controller: _firstNameController,
                  hintText: "First Name",
                  icon: "assets/icons/profile_icon.png",
                  textInputType: TextInputType.name,
                ),
                const SizedBox(
                  height: 15,
                ),
                RoundTextField(
                  controller: _lastNameController,
                  hintText: "Last Name",
                  icon: "assets/icons/profile_icon.png",
                  textInputType: TextInputType.name,
                ),
                const SizedBox(
                  height: 15,
                ),
                RoundTextField(
                  controller: _emailController,
                  hintText: "Email",
                  icon: "assets/icons/message_icon.png",
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 15,
                ),
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
                const SizedBox(
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
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        "By continuing you accept our Privacy Policy and\nTerm of Use",
                        style: TextStyle(
                          color: AppColors.grayColor,
                          fontSize: 10,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                          text: "Already have an account? ",
                        ),
                        TextSpan(
                          text: "Login",
                          style: TextStyle(
                            color: AppColors.secondaryColor1,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Image.asset(
                  "assets/images/complete_profile.png",
                  width: media.width,
                ),
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
                          hint: const Text("Choose Gender"),
                        ),
                      ),
                      const SizedBox(width: 8)
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: TextFormField(
                    controller: _dobController,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    decoration: InputDecoration(
                      hintText: "Date of Birth",
                      icon: Image.asset(
                        "assets/icons/calendar_icon.png",
                        width: 20,
                        height: 20,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                const SizedBox(height: 15),
                RoundTextField(
                  controller: _weightController,
                  hintText: "Your Weight in kg",
                  icon: "assets/icons/weight_icon.png",
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 15),
                RoundTextField(
                  controller: _heightController,
                  hintText: "Your Height in cm",
                  icon: "assets/icons/swap_icon.png",
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 15),
                RoundGradientButton(
                  title: "Next >",
                  onPressed: () async {
                    String dob = _dobController?.text ?? '';
                    String weight = _weightController.text;
                    String height = _heightController.text;

                    double weightInKg = double.tryParse(weight) ?? 0.0;
                    double heightInCM = double.tryParse(height) ?? 0.0;
                    Object bmi = calculateBMI(weightInKg, heightInCM);

                    await _usersPublicUserCollection.add({
                      'gender': _selectedGender,
                      'dob': dob,
                      'weight': weight,
                      'height': height,
                      'bmi': bmi.toString(),
                    });

                    Navigator.pushNamed(context, LoginScreen.routeName); // replace with the correct route
                  },
                ),
                const SizedBox(height: 15),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
