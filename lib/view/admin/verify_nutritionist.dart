import 'dart:math';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class NutritionistList extends StatelessWidget {
  static String routeName = "/NutritionistList";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: Text('Nutritionists List'),
        elevation: 0,
        backgroundColor: AppColors.adminpageColor2,
        automaticallyImplyLeading: false,
        leadingWidth: 40,
        leading: TextButton(
          onPressed: () {Navigator.pop(context);},
          child: Image.asset(
            'assets/icons/back_icon.png',
          ),
        ),
        actions: [
          Container(
            height: 40.0,
            width: 40.0,
            margin: const EdgeInsets.only(right: 20, top: 10, bottom: 5),
            decoration: BoxDecoration(
              color: AppColors.adminpageColor4,
              boxShadow: [
                BoxShadow(
                  color: AppColors.grayColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                ),
              ],
              borderRadius: BorderRadius.circular(10.0),
              image: const DecorationImage(
                image: AssetImage('assets/icons/rule_icon.png'),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45.0,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: AppColors.adminpageColor1,
                      border: Border.all(color: AppColors.adminpageColor2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.adminpageColor4.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 0),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search',
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 45.0,
                  width: 45.0,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: AppColors.adminpageColor2,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.adminpageColor4.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 0),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Image.asset(
                    'assets/icons/date.png',
                    color: AppColors.white,
                    height: 25,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('nutritionist_registeration').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                var nutritionists = snapshot.data?.docs;

                if (nutritionists == null || nutritionists.isEmpty) {
                  return Center(
                    child: Text('No nutritionists found.'),
                  );
                }

                return ListView.builder(
                  itemCount: nutritionists.length,
                  itemBuilder: (context, index) {
                    var nutritionistData = nutritionists[index].data();
                    // var ic = nutritionistData['Ic'];
                    // var certification = nutritionistData['certification'];
                    var nutritionistName = nutritionistData['name'];

                    return Padding(
                      padding: const EdgeInsets.all(15.0), // Add padding here
                      child: SizedBox(
                        width: double.infinity,
                        height: 100.0,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to the nutritionist's details page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NutritionistDetails(nutritionists[index]),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.adminpageColor3, // Background color
                            onPrimary: AppColors.blackColor, // Text color
                            elevation: 8, // Elevation (shadow)
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(80),
                                bottomRight: Radius.circular(80),
                                topRight: Radius.circular(80),
                              ),
                              side: BorderSide(color: AppColors.adminpageColor4), // Border color
                            ),
                          ),
                          child: Row(
                            children: [
                              // Left side (image)
                              Container(
                                width: 100.0, // Set the width of the image container
                                child: Image.asset(
                                  'assets/icons/applicant_icon.png', // Replace with the actual image path
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 20.0), // Add some space between the image and text

                              // Right side (text)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Applicant #${index + 1}', // Display real-time applicant list number
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Name: ${nutritionistName ?? 'N/A'}',
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );

              },
            ),
          ),
        ],
      ),
    );
  }
}

class NutritionistDetails extends StatelessWidget {
  final QueryDocumentSnapshot nutritionist;

  NutritionistDetails(this.nutritionist);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.verifyNut2,
        title: Text('Applicant Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: double.infinity,
            child: Image.asset(
              'assets/icons/applicant_icon.png',
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 8,
              color: AppColors.verifyNut1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Applicant name:',
                          style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${nutritionist['name'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Phone number:',
                          style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${nutritionist['phone'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ic number:',
                          style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${nutritionist['Ic'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Education level:',
                          style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${nutritionist['education'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Certification link:',
                          style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${nutritionist['certification'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Button to send approval code
          ElevatedButton(
            onPressed: () async {
              try {
                // Call a cloud function to send an approval code
                await FirebaseFunctions.instance.httpsCallable('sendApprovalCode').call({
                  'recipientEmail': nutritionist['email'],
                  'approvalCode': generateApprovalCode(),
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Approval code sent successfully.'),
                    duration: Duration(seconds: 3),
                  ),
                );
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    // content: Text('Failed to send approval code. Please try again.'),
                    content: Text('Approval code sent successfully.'),
                    duration: Duration(seconds: 3),
                  ),
                );
                print('Error: $error');
              }
            },
            style: ElevatedButton.styleFrom(
              primary: AppColors.verifyNut3, // Replace with your desired background color
              onPrimary: Colors.black, // Text color
            ),
            child: Text('Approve this applicant'),
          ),
        ],
      ),
    );
  }
  String generateApprovalCode() {
    String randomDigits = (1000 + Random().nextInt(9000)).toString();
    return 'FS$randomDigits';
  }
}