import 'dart:ui';
import 'package:fitnessapp/view/admin/developer_chat_room.dart';
import 'package:flutter/material.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class Developer {
  final String name;
  final String role;
  final String email;

  Developer(this.name, this.role, this.email);
}

class ContactDeveloper extends StatefulWidget {
  static String routeName = "/ContactDeveloper";

  @override
  _ContactDeveloperState createState() => _ContactDeveloperState();
}

class _ContactDeveloperState extends State<ContactDeveloper> {
  final List<Developer> developers = [
    Developer('Go Eng Khee', 'Flutter Developer', 'fitnessapp@gmail.com'),
    Developer('Ng Wen Ping', 'UI/UX Designer', 'fitnessapp@gmail.com'),
    Developer('Lam Qian Hui', 'Backend Developer', 'fitnessapp@gmail.com'),
    Developer('Soh Yen San', 'QA Engineer', 'fitnessapp@gmail.com'),
  ];

  String selectedCategory = 'Features';
  TextEditingController commentController = TextEditingController();
  List<String> history = [];
  bool showHistory = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Developer'),
        backgroundColor: AppColors.adminpageColor2,
        leadingWidth: 40,
        leading: TextButton(
          onPressed: () {Navigator.pop(context);},
          child: Image.asset(
            'assets/icons/back_icon.png',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Text(
            //   'Suggestions or Comments:',
            //   style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            // ),
            // SizedBox(height: 8.0),
            // Row(
            //   children: [
            //     Text('Category: '),
            //     DropdownButton<String>(
            //       value: selectedCategory,
            //       onChanged: (value) {
            //         setState(() {
            //           selectedCategory = value!;
            //         });
            //       },
            //       items: ['Features', 'Maintenance', 'Design', 'Other']
            //           .map<DropdownMenuItem<String>>(
            //             (String value) => DropdownMenuItem<String>(
            //           value: value,
            //           child: Text(value),
            //         ),
            //       )
            //           .toList(),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 8.0),
            // TextField(
            //   controller: commentController,
            //   maxLines: 5,
            //   decoration: InputDecoration(
            //     hintText: 'Type your suggestions or comments here...',
            //     border: OutlineInputBorder(),
            //   ),
            // ),
            // SizedBox(height: 16.0),
            // ElevatedButton(
            //   onPressed: () {
            //     history.add(commentController.text);
            //     commentController.clear();
            //     setState(() {});
            //   },
            //   style: ElevatedButton.styleFrom(
            //     primary: AppColors.adminpageColor1,
            //     onPrimary: AppColors.blackColor,
            //     elevation: 8,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(50.0),
            //       side: BorderSide(color: AppColors.adminpageColor4),
            //     ),
            //   ),
            //   child: Text('Submit'),
            // ),
            // SizedBox(height: 24.0),

            Text(
              'Fitness system developers:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: developers.length,
                itemBuilder: (context, index) {
                  Developer developer = developers[index];
                  return ListTile(
                    title: Text(developer.name),
                    subtitle: Text('${developer.role}\n${developer.email}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, DeveloperChatRoom.routeName);
                        // _launchEmail(developer.name);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.adminpageColor3,
                        onPrimary: AppColors.blackColor,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          side: BorderSide(color: AppColors.adminpageColor4),
                        ),
                      ),
                      child: Text('Chat'),
                    ),
                  );
                },
              ),
            ),
            // SizedBox(height: 24.0),
            // ElevatedButton(
            //   onPressed: () {
            //     setState(() {
            //       showHistory = !showHistory;
            //     });
            //   },
            //   style: ElevatedButton.styleFrom(
            //     primary: AppColors.adminpageColor2,
            //     onPrimary: AppColors.blackColor,
            //     elevation: 8,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(50.0),
            //       side: BorderSide(color: AppColors.adminpageColor4),
            //     ),
            //   ),
            //   child: Text(showHistory ? 'Hide History' : 'View History'),
            // ),
            //Display the history list
            // if (showHistory)
              // Expanded(
              //   child: SingleChildScrollView(
              //     child: Column(
              //       children: [
              //         SizedBox(height: 8.0),
              //         Text(
              //           'History:',
              //           style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              //         ),
              //         SizedBox(height: 8.0),
              //         // Display the list of past comments in the history
              //         ListView.builder(
              //           shrinkWrap: true,
              //           physics: NeverScrollableScrollPhysics(),
              //           itemCount: history.length,
              //           itemBuilder: (context, index) {
              //             return ListTile(
              //               title: Text('Comment ${index + 1}'),
              //               subtitle: Text(history[index]),
              //             );
              //           },
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final String recipientEmail = 'fitnesssystemdeveloper@gmail.com';
                final String subject = 'Admin of Fitness Pro System';
                final String content = 'Hi developer,...'; // Add your content here

                final Uri emailUri = Uri(
                  scheme: 'mailto',
                  path: recipientEmail,
                  queryParameters: {
                    'subject': subject,
                    'body': content,
                  },
                );
                try {
                  await launch(emailUri.toString());
                } catch (e) {
                  print('Error launching email: $e');
                  // Handle error if email client cannot be launched
                }
              },
              style: ElevatedButton.styleFrom(
                primary: AppColors.adminpageColor1,
                onPrimary: AppColors.blackColor,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  side: BorderSide(color: AppColors.adminpageColor4),
                ),
              ),
              child: Text('Email Us'),
            ),
          ],
        ),
      ),
    );
  }
}
