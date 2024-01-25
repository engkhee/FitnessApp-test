import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

import "../../common_widgets/round_button.dart";
import "../../utils/app_colors.dart";

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {

  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  // Add a variable to store the full name
  late String fullName =  "";

  @override
  void initState() {
    super.initState();
    // Fetch the full name from Firestore when the page initializes
    fetchFullNameFromFirestore();
  }

  void fetchFullNameFromFirestore() {

    FirebaseFirestore.instance.collection('Users').doc(currentUser.email).get().then((snapshot) {
      setState(() {
        fullName = snapshot.data()?['firstName'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    // user
    final currentUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: const Icon(Icons.keyboard_double_arrow_left_outlined),),
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
                      width: 120, height: 120,
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
                        bottom: 0, right: 0,
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.yellow),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.black,
                            size: 20,
                          ),
                        )
                    )
                  ],
                ),

                  const SizedBox(height: 10),

                  Form(child: Column(
                    children: [
                      TextFormField(
                        initialValue: fullName, // Set the initial value
                        decoration: InputDecoration(
                          label: Text("Full Name"),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: currentUser.email!,
                        decoration: InputDecoration(
                            label: Text("Email"),
                            prefixIcon: Icon(Icons.email)
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                            label: Text("Phone No"),
                            prefixIcon: Icon(Icons.phone)
                        ),
                      ),
                      const SizedBox(height: 25),

                      SizedBox(
                        width: 200,
                        height: 50,
                        child: RoundButton(
                          title: "Edit Profile",
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),)
                ],
          ),
        ),
      ),
    );
  }
}



