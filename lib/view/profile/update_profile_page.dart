import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../common_widgets/round_button.dart';
import '../../utils/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  late TextEditingController firstnameController;
  late TextEditingController lastnameController;
  late TextEditingController weightController;
  late TextEditingController heightController;
  late TextEditingController dobController;
  late TextEditingController genderController;
  late TextEditingController bmiController;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      String formattedDate =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      dobController.text = formattedDate;
    }
  }

  @override
  void initState() {
    super.initState();
    firstnameController = TextEditingController();
    lastnameController = TextEditingController();
    weightController = TextEditingController();
    heightController = TextEditingController();
    dobController = TextEditingController();
    genderController = TextEditingController();
    bmiController = TextEditingController();

    // Fetch user data from Firestore when the page initializes
    fetchUserInfo();
  }

  void fetchUserInfo() async {
    try {
      String userEmail = FirebaseAuth.instance.currentUser?.email ?? "";
      // Assuming Firestore collections are named "user_info" and "personal_info"
      // Replace with your actual collection names
      // Check if the user is authenticated
      if (userEmail.isNotEmpty) {
        // Query 'User_profile_info' collection based on the user's email
        final personalInfoQuery = await FirebaseFirestore.instance
            .collection('User_profile_info')
            .where('email', isEqualTo: userEmail)
            .get();

        // Check if the document exists before accessing its data
        if (personalInfoQuery.docs.isNotEmpty) {
          // Access the first document (assuming there is only one matching document)
          var personalInfoDoc = personalInfoQuery.docs.first;

          // Update variables with fetched data
          setState(() {
            firstnameController.text = personalInfoDoc.get('fname') ?? "";
            lastnameController.text = personalInfoDoc.get('lname') ?? "";
            weightController.text = personalInfoDoc.get('weight') ?? "null";
            heightController.text = personalInfoDoc.get('height') ?? "null";
            dobController.text = personalInfoDoc.get('dob') ?? "";
            genderController.text = personalInfoDoc.get('gender') ?? "";
            bmiController.text = personalInfoDoc.get('bmi') ?? "";
          });
        } else {
          print("User or personal information document does not exist.");
        }
      } else {
        print("User is not authenticated.");
      }
    } catch (e) {
      print("Error fetching user information: $e");
    }
  }

  void updateUserDataInFirestore() {
    try {
      // Update data in 'User_profile_info' collection
      FirebaseFirestore.instance
          .collection('User_profile_info')
          .where('email', isEqualTo: currentUser.email)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          // Update the document with the desired fields
          doc.reference.update({
            'fname': firstnameController.text,
            'lname': lastnameController.text,
            'weight': weightController.text,
            'height': heightController.text,
            'dob': dobController.text,
          });
        });
      }).catchError((error) {
        print('Error updating user data: $error');
      });

      // Update data in 'users_public_user' collection
      FirebaseFirestore.instance.collection('Users_public_user').doc(currentUser.uid).update({
        'firstName': firstnameController.text,
        'lastName': lastnameController.text,
        // Add other fields as needed
      });

      // Show a success message or navigate to a different screen
      // based on your application's flow.
      print('User data updated successfully!');
      _showUpdateConfirmationDialog();
    } catch (error) {
      // Handle errors, e.g., show an error message to the user.
      print('Error updating user data: $error');
    }
  }

  void _showUpdateConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Profile Updated"),
          content: Text("Please restart the application for the changes to take effect."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.keyboard_double_arrow_left_outlined),
        ),
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: AppColors.blackColor,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        "assets/images/user.png",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.yellow,
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Form(
                child: Column(
                  children: [
                    _buildReadOnlyTextField("Email", readOnly: true, controller: TextEditingController(text: currentUser.email!)),
                    const SizedBox(height: 10),
                    _buildEditableTextField("First Name", firstnameController),
                    const SizedBox(height: 10),
                    _buildEditableTextField("Last Name", lastnameController),
                    const SizedBox(height: 10),
                    _buildReadOnlyTextField("Gender", readOnly: true, controller: genderController),
                    const SizedBox(height: 10),
                    _buildEditableTextField("Weight", weightController, TextInputType.numberWithOptions(decimal: true)),
                    const SizedBox(height: 10),
                    _buildEditableTextField("Height", heightController, TextInputType.numberWithOptions(decimal: true)),
                    const SizedBox(height: 25),
                    _buildReadOnlyTextField("BMI", readOnly: true, controller: bmiController),
                    const SizedBox(height: 25),
                    _buildDateOfBirthField(),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: RoundButton(
                        title: "Edit Profile",
                        onPressed: () {
                          updateUserDataInFirestore();
                          // Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyTextField(String label, {bool readOnly = false, required TextEditingController controller}) {
    return InkWell(
      onTap: () {
        if (readOnly) {
          _showReadOnlyMessage(label);
        }
      },
      child: TextFormField(
        readOnly: readOnly,
        controller: controller,
        decoration: InputDecoration(
          label: Text(label, style: TextStyle(color: Colors.lightBlue),),
          prefixIcon: _getPrefixIcon(label),
        ),
      ),
    );
  }

  void _showReadOnlyMessage(String field) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Read-Only Field"),
          content: Text("$field is a read-only field."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEditableTextField(String label, TextEditingController controller, [TextInputType? keyboardType]) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        label: Text(label),
        prefixIcon: _getPrefixIcon(label),
      ),
    );
  }

  Widget _buildDateOfBirthField() {
    return Container(
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
                  controller: dobController,
                  decoration: InputDecoration(
                    hintText: "Date of Birth",
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getPrefixIcon(String label) {
    switch (label) {
      case "Email":
        return Icon(Icons.email);
      case "First Name":
        return Icon(Icons.person);
      case "Last Name":
        return Icon(Icons.person);
      case "Gender":
        return Icon(Icons.people);
      case "Weight":
        return Icon(Icons.monitor_weight_outlined);
      case "Height":
        return Icon(Icons.height_outlined);
      case "BMI":
        return Icon(Icons.calculate);
      default:
        return Icon(Icons.info);
    }
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfilePage(),
    );
  }
}
