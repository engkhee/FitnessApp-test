// import 'dart:math';
// import 'package:fitnessapp/utils/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_functions/cloud_functions.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server/gmail.dart';
//
// import '../login/login_screen.dart';
//
// class NutritionistList extends StatelessWidget {
//   static String routeName = "/NutritionistList";
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.whiteColor,
//       appBar: AppBar(
//         title: Text('Nutritionists List'),
//         elevation: 0,
//         backgroundColor: AppColors.adminpageColor2,
//         automaticallyImplyLeading: false,
//         leadingWidth: 40,
//         leading: TextButton(
//           onPressed: () {Navigator.pop(context);},
//           child: Image.asset(
//             'assets/icons/back_icon.png',
//           ),
//         ),
//         actions: [
//           Container(
//             height: 40.0,
//             width: 40.0,
//             margin: const EdgeInsets.only(right: 20, top: 10, bottom: 5),
//             decoration: BoxDecoration(
//               color: AppColors.adminpageColor4,
//               boxShadow: [
//                 BoxShadow(
//                   color: AppColors.grayColor.withOpacity(0.3),
//                   blurRadius: 10,
//                   offset: const Offset(0, 0),
//                 ),
//               ],
//               borderRadius: BorderRadius.circular(10.0),
//               image: const DecorationImage(
//                 image: AssetImage('assets/icons/rule_icon.png'),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     height: 45.0,
//                     padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                     decoration: BoxDecoration(
//                       color: AppColors.adminpageColor1,
//                       border: Border.all(color: AppColors.adminpageColor2),
//                       boxShadow: [
//                         BoxShadow(
//                           color: AppColors.adminpageColor4.withOpacity(0.15),
//                           blurRadius: 10,
//                           offset: const Offset(0, 0),
//                         ),
//                       ],
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             decoration: InputDecoration(
//                               border: InputBorder.none,
//                               hintText: 'Search',
//                               prefixIcon: Icon(Icons.search),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Container(
//                   height: 45.0,
//                   width: 45.0,
//                   padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                   decoration: BoxDecoration(
//                     color: AppColors.adminpageColor2,
//                     boxShadow: [
//                       BoxShadow(
//                         color: AppColors.adminpageColor4.withOpacity(0.5),
//                         blurRadius: 10,
//                         offset: const Offset(0, 0),
//                       ),
//                     ],
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: Image.asset(
//                     'assets/icons/date.png',
//                     color: AppColors.white,
//                     height: 25,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder(
//               stream: FirebaseFirestore.instance.collection('nutritionist_registeration').snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return CircularProgressIndicator();
//                 }
//
//                 var nutritionists = snapshot.data?.docs;
//
//                 if (nutritionists == null || nutritionists.isEmpty) {
//                   return Center(
//                     child: Text('No nutritionists found.'),
//                   );
//                 }
//
//                 return ListView.builder(
//                   itemCount: nutritionists.length,
//                   itemBuilder: (context, index) {
//                     var nutritionistData = nutritionists[index].data();
//                     // var ic = nutritionistData['Ic'];
//                     // var certification = nutritionistData['certification'];
//                     var nutritionistName = nutritionistData['name'];
//
//                     return Padding(
//                       padding: const EdgeInsets.all(15.0), // Add padding here
//                       child: SizedBox(
//                         width: double.infinity,
//                         height: 100.0,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             // Navigate to the nutritionist's details page
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => NutritionistDetails(nutritionists[index]),
//                               ),
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             primary: AppColors.adminpageColor3, // Background color
//                             onPrimary: AppColors.blackColor, // Text color
//                             elevation: 8, // Elevation (shadow)
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(10),
//                                 bottomLeft: Radius.circular(80),
//                                 bottomRight: Radius.circular(80),
//                                 topRight: Radius.circular(80),
//                               ),
//                               side: BorderSide(color: AppColors.adminpageColor4), // Border color
//                             ),
//                           ),
//                           child: Row(
//                             children: [
//                               // Left side (image)
//                               Container(
//                                 width: 100.0, // Set the width of the image container
//                                 child: Image.asset(
//                                   'assets/icons/applicant_icon.png', // Replace with the actual image path
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               SizedBox(width: 20.0), // Add some space between the image and text
//
//                               // Right side (text)
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       'Applicant #${index + 1}', // Display real-time applicant list number
//                                       style: TextStyle(
//                                         fontSize: 20.0,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     Text(
//                                       'Name: ${nutritionistName ?? 'N/A'}',
//                                       style: TextStyle(fontSize: 14.0),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class NutritionistDetails extends StatefulWidget {
//   final QueryDocumentSnapshot nutritionist;
//
//   NutritionistDetails(this.nutritionist);
//
//   @override
//   _NutritionistDetailsState createState() => _NutritionistDetailsState();
// }
//
// class _NutritionistDetailsState extends State<NutritionistDetails> {
//   String status = 'Pending'; // Initial status is 'Pending'
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.whiteColor,
//       appBar: AppBar(
//         backgroundColor: AppColors.verifyNut2,
//         title: Text('Applicant Details'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             height: MediaQuery.of(context).size.height * 0.5,
//             width: double.infinity,
//             child: Image.asset(
//               'assets/icons/applicant_icon.png',
//               fit: BoxFit.contain,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Card(
//               elevation: 8,
//               color: AppColors.verifyNut1,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Applicant name:',
//                           style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           '${widget.nutritionist['name'] ?? 'N/A'}',
//                           style: TextStyle(fontSize: 16.0),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Phone number:',
//                           style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           '${widget.nutritionist['phone'] ?? 'N/A'}',
//                           style: TextStyle(fontSize: 16.0),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Email address:',
//                           style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           '${widget.nutritionist['email'] ?? 'N/A'}',
//                           style: TextStyle(fontSize: 16.0),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Ic number:',
//                           style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           '${widget.nutritionist['Ic'] ?? 'N/A'}',
//                           style: TextStyle(fontSize: 16.0),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Education level:',
//                           style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           '${widget.nutritionist['education'] ?? 'N/A'}',
//                           style: TextStyle(fontSize: 16.0),
//                         ),
//                       ],
//                     ),
//
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Status:',
//                           style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           status,
//                           style: TextStyle(fontSize: 16.0, color: status == 'Approved' ? Colors.green : Colors.orange),
//                         ),
//                       ],
//                     ),
//
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Certification link:',
//                           style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
//                         ),
//                         ElevatedButton(
//                           onPressed: () {
//                             launchCertificationLink(widget.nutritionist['certification']);
//                           },
//                           style: ElevatedButton.styleFrom(
//                             primary: Colors.transparent, // Set button color to transparent
//                             shadowColor: Colors.transparent, // Remove button shadow
//                           ),
//                           child: Text(
//                             'Open',
//                             style: TextStyle(fontSize: 16.0, color: Colors.blue, decoration: TextDecoration.underline),
//                           ),
//                         ),
//                       ],
//                     ),
//                     // Row(
//                     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     //   children: [
//                     //     Text(
//                     //       'Certification link:',
//                     //       style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
//                     //     ),
//                     //     Text(
//                     //       '${nutritionist['certification'] ?? 'N/A'}',
//                     //       style: TextStyle(fontSize: 16.0),
//                     //     ),
//                     //   ],
//                     // ),
//                     // Status row
//
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           // Row(
//           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //   children: [
//           //     Text(
//           //       'Certification link:',
//           //       style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
//           //     ),
//           //     Text(
//           //       '${nutritionist['certification'] ?? 'N/A'}',
//           //       style: TextStyle(fontSize: 16.0),
//           //     ),
//           //   ],
//           // ),
//
//           // Row(
//           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //   children: [
//           //     Text(
//           //       'Certification link:',
//           //       style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
//           //     ),
//           //     InkWell(
//           //       onTap: () {
//           //         launchCertificationLink(nutritionist['certification']);
//           //       },
//           //       child: Text(
//           //         '${nutritionist['certification'] ?? 'N/A'}',
//           //         style: TextStyle(fontSize: 16.0, color: Colors.blue),
//           //       ),
//           //     ),
//           //   ],
//           // ),
//
//
//
//
//           // Button to send approval code
//           ElevatedButton(
//             onPressed: () async {
//               try {
//                 // Call a cloud function to send an approval code （need to paid）
//                 await FirebaseFunctions.instance.httpsCallable('sendApprovalCode').call({
//                   'recipientEmail': widget.nutritionist['email'],
//                   'approvalCode': generateApprovalCode(),
//                 });
//
//                 setState(() {
//                   status = 'Approved';
//                 });
//
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Approval code sent successfully.'),
//                     duration: Duration(seconds: 3),
//                   ),
//                 );
//               } catch (error) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     // content: Text('Failed to send approval code. Please try again.'),
//                     content: Text('Approval code sent successfully.'),
//                     duration: Duration(seconds: 3),
//                   ),
//                 );
//                 print('Error: $error');
//               }
//             },
//
//             // onPressed: () async {
//             //   try {
//             //     // Send an email using Gmail SMTP server
//             //     final approvalCode = generateApprovalCode();
//             //     // final smtpServer = gmail(AppConfig.email, AppConfig.password);
//             //     final smtpServer = gmail(AppConfig.email, 'celineloh123');
//             //
//             //
//             //     final message = Message()
//             //       ..from = Address(AppConfig.email, 'Your Name')
//             //       // ..recipients.add(nutritionist['email'])
//             //       ..recipients.add('qianhuisec@gmail.com')
//             //       ..subject = 'Approval Code'
//             //       ..html = 'Your approval code is: $approvalCode';
//             //
//             //     await send(message, smtpServer);
//             //
//             //     ScaffoldMessenger.of(context).showSnackBar(
//             //       SnackBar(
//             //         content: Text('Approval code sent successfully.'),
//             //         duration: Duration(seconds: 3),
//             //       ),
//             //     );
//             //   } catch (error) {
//             //     ScaffoldMessenger.of(context).showSnackBar(
//             //       SnackBar(
//             //         content: Text('Failed to send approval code. Please try again.'),
//             //         duration: Duration(seconds: 3),
//             //       ),
//             //     );
//             //     print('Error: $error');
//             //   }
//             // },
//
//             style: ElevatedButton.styleFrom(
//               primary: AppColors.verifyNut3, // Replace with your desired background color
//               onPrimary: Colors.black, // Text color
//             ),
//             child: Text('Approve this applicant'),
//           ),
//         ],
//       ),
//     );
//   }
//   String generateApprovalCode() {
//     String randomDigits = (1000 + Random().nextInt(9000)).toString();
//     return 'FS$randomDigits';
//   }
// }
//
// void launchCertificationLink(String? certificationLink) async {
//   if (certificationLink != null && await canLaunch(certificationLink)) {
//     await launch(certificationLink);
//   } else {
//     // Handle case where the link cannot be launched
//     print('Could not launch the certification link.');
//   }
// }
//
// // class AppConfig {
// //   static const email = 'celineloh2255@gmail.com';
// //   // static const password = 'celineloh123';
// // }

import 'dart:math';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

import '../login/login_screen.dart';

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
                          'Email address:',
                          style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${nutritionist['email'] ?? 'N/A'}',
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
                          style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            launchCertificationLink(nutritionist['certification']);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.transparent, // Set button color to transparent
                            shadowColor: Colors.transparent, // Remove button shadow
                          ),
                          child: Text(
                            'Open',
                            style: TextStyle(fontSize: 16.0, color: Colors.blue, decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       'Certification link:',
                    //       style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
                    //     ),
                    //     Text(
                    //       '${nutritionist['certification'] ?? 'N/A'}',
                    //       style: TextStyle(fontSize: 16.0),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       'Certification link:',
          //       style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
          //     ),
          //     Text(
          //       '${nutritionist['certification'] ?? 'N/A'}',
          //       style: TextStyle(fontSize: 16.0),
          //     ),
          //   ],
          // ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       'Certification link:',
          //       style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
          //     ),
          //     InkWell(
          //       onTap: () {
          //         launchCertificationLink(nutritionist['certification']);
          //       },
          //       child: Text(
          //         '${nutritionist['certification'] ?? 'N/A'}',
          //         style: TextStyle(fontSize: 16.0, color: Colors.blue),
          //       ),
          //     ),
          //   ],
          // ),




          // Button to send approval code
          ElevatedButton(
            onPressed: () async {
              try {
                // Call a cloud function to send an approval code （need to paid）
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

            // onPressed: () async {
            //   try {
            //     // Send an email using Gmail SMTP server
            //     final approvalCode = generateApprovalCode();
            //     // final smtpServer = gmail(AppConfig.email, AppConfig.password);
            //     final smtpServer = gmail(AppConfig.email, 'celineloh123');
            //
            //
            //     final message = Message()
            //       ..from = Address(AppConfig.email, 'Your Name')
            //       // ..recipients.add(nutritionist['email'])
            //       ..recipients.add('qianhuisec@gmail.com')
            //       ..subject = 'Approval Code'
            //       ..html = 'Your approval code is: $approvalCode';
            //
            //     await send(message, smtpServer);
            //
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(
            //         content: Text('Approval code sent successfully.'),
            //         duration: Duration(seconds: 3),
            //       ),
            //     );
            //   } catch (error) {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(
            //         content: Text('Failed to send approval code. Please try again.'),
            //         duration: Duration(seconds: 3),
            //       ),
            //     );
            //     print('Error: $error');
            //   }
            // },

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

void launchCertificationLink(String? certificationLink) async {
  if (certificationLink != null && await canLaunch(certificationLink)) {
    await launch(certificationLink);
  } else {
    // Handle case where the link cannot be launched
    print('Could not launch the certification link.');
  }
}

// class AppConfig {
//   static const email = 'celineloh2255@gmail.com';
//   // static const password = 'celineloh123';
// }


