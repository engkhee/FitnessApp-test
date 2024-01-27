import 'dart:math';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/admin/veriry_rule.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class NutritionistList extends StatefulWidget {
  static String routeName = "/NutritionistList";

  @override
  _Test2State createState() => _Test2State();
}

class _Test2State extends State<NutritionistList> {
  String _selectedCategory = 'Pending'; // Default selected category
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
          onPressed: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            'assets/icons/back_icon.png',
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              // Navigate to VerifyRule screen
              Navigator.pushNamed(context, VerifyRule.routeName);
            },
            child: Container(
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
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                                controller: _searchController,
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value.toLowerCase();
                                  });
                                },
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
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Set the selected category to 'Pending'
                        setState(() {
                          _selectedCategory = 'Pending';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: _selectedCategory == 'Pending' ? AppColors.secondaryColor1 : AppColors.adminpageColor1,
                        onPrimary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text('Pending'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Set the selected category to 'Approved'
                        setState(() {
                          _selectedCategory = 'Approved';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: _selectedCategory == 'Approved' ? AppColors.secondaryColor1 : AppColors.adminpageColor1,
                        onPrimary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text('Approved'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Set the selected category to 'Rejected'
                        setState(() {
                          _selectedCategory = 'Rejected';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: _selectedCategory == 'Rejected' ? AppColors.secondaryColor1 : AppColors.adminpageColor1,
                        onPrimary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text('Rejected'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Users_nutritionist').snapshots(),
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

                // Filter nutritionists based on the selected category and search query
                var filteredNutritionists = nutritionists.where((nutritionist) {
                  var status = nutritionist['status'] ?? 'Pending';
                  var name = nutritionist['name'] ?? '';
                  return status == _selectedCategory && name.toLowerCase().contains(_searchQuery);
                }).toList();

                return ListView.builder(
                  itemCount: filteredNutritionists.length,
                  itemBuilder: (context, index) {
                    var nutritionistData = filteredNutritionists[index].data();
                    var nutritionistName = nutritionistData['name'];
                    var status = nutritionistData['status'] ?? 'Pending'; // Default status is pending

                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 100.0,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to the nutritionist's details page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NutritionistDetails(filteredNutritionists[index]),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.adminpageColor3,
                            onPrimary: AppColors.blackColor,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 100.0,
                                child: Image.asset(
                                  'assets/icons/applicant_icon.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 20.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Applicant #${index + 1}',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Name: ${nutritionistName ?? 'N/A'}',
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                    Text(
                                      'Status: $status',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: getStatusColor(status),
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
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}

class NutritionistDetails extends StatefulWidget {
  final QueryDocumentSnapshot nutritionist;

  NutritionistDetails(this.nutritionist);

  @override
  _NutritionistDetailsState createState() => _NutritionistDetailsState();
}

class _NutritionistDetailsState extends State<NutritionistDetails> {
  String status = 'Pending'; // Default status
  bool _isLoading = false; // To handle loading state

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
                          '${widget.nutritionist['name'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    // Add other applicant details here...
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Phone number:',
                          style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${widget.nutritionist['phone'] ?? 'N/A'}',
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
                          '${widget.nutritionist['email'] ?? 'N/A'}',
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
                          '${widget.nutritionist['Ic'] ?? 'N/A'}',
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
                          '${widget.nutritionist['education'] ?? 'N/A'}',
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
                            launchCertificationLink(widget.nutritionist['certification']);
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Status:',
                          style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance.collection('Users_nutritionist').doc(widget.nutritionist.id).snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text(
                                'Loading...',
                                style: TextStyle(fontSize: 16.0, color: Colors.orange),
                              );
                            }
                            var nutritionistData = snapshot.data?.data();
                            var status = (nutritionistData as Map<String, dynamic>)?['status'] ?? 'Pending';
                            return Text(
                              status,
                              style: TextStyle(fontSize: 16.0, color: getStatusColor(status)),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    status = 'Approved'; // Update status to approved
                  });
                  // Call a function to update the status in Firestore
                  await updateStatus('Approved');
                  // Call a function to send approval code
                  sendApprovalCode(widget.nutritionist['email']);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[300], // Background color
                  onPrimary: Colors.black, // Text color
                  elevation: 3, // Button shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Button padding
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon(Icons.check_circle, color: Colors.white), // Icon
                    // SizedBox(width: 10), // Spacer
                    Text(
                      'Approve applicant',
                      style: TextStyle(fontSize: 16), // Text style
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    status = 'Rejected'; // Update status to rejected
                  });
                  // Call a function to update the status in Firestore
                  await updateStatus('Rejected');
                  // Call a function to send rejected email
                  sendRejectEmail(widget.nutritionist['email']);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red[300], // Background color
                  onPrimary: Colors.black, // Text color
                  elevation: 3, // Button shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Button padding
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon(Icons.cancel, color: Colors.white), // Icon
                    // SizedBox(width: 10), // Spacer
                    Text(
                      'Reject applicant',
                      style: TextStyle(fontSize: 16), // Text style
                    ),
                  ],
                ),
              )

            ],
          ),
        ],
      ),
    );
  }

  Future<Future<bool?>> _showConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to approve this applicant?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Dismiss dialog and return false
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Dismiss dialog and return true
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
  Color getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Future<void> updateStatus(String newStatus) async {
    await FirebaseFirestore.instance
        .collection('Users_nutritionist')
        .doc(widget.nutritionist.id)
        .update({'status': newStatus});
  }

  // Approve
  Future<void> sendApprovalCode(String recipientEmail) async {
    setState(() {
      _isLoading = true; // Set loading state
    });
    final code = 'FS${DateTime.now().year}'; // Generate unique code (year as prefix)
    // Replace the above line with your desired logic for generating the code

    // Prepare email content
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: recipientEmail,
      queryParameters: {
        'subject': 'Your Nutrtionist Application Approval Code ',
        'body': 'Dear Applicant,\n\nCongratulations! Your application has been approved. Here is your unique approval code: $code\n\nBest regards,\nAdmin Team',
      },
    );

    // Launch email client
    try {
      await launch(emailUri.toString());
    } catch (e) {
      print('Error launching email: $e');
      // Handle error if email client cannot be launched
    }

    setState(() {
      _isLoading = false; // Reset loading state
    });
  }

  // Reject
  Future<void> sendRejectEmail(String recipientEmail) async {
    setState(() {
      _isLoading = true; // Set loading state
    });

    // Prepare email content
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: recipientEmail,
      queryParameters: {
        'subject': 'Your Nutrtionist Application Reject Email',
        'body': 'Dear Applicant,\n\nWe regret to inform you that your application for the nutritionist position has been rejected. We appreciate your interest and effort. Best wishes,\nAdmin Team',
      },
    );

    // Launch email client
    try {
      await launch(emailUri.toString());
    } catch (e) {
      print('Error launching email: $e');
      // Handle error if email client cannot be launched
    }

    setState(() {
      _isLoading = false; // Reset loading state
    });
  }
  void launchCertificationLink(String? certificationLink) async {
    if (certificationLink != null && certificationLink.isNotEmpty) {
      if (await canLaunch(certificationLink)) {
        await launch(certificationLink);
      } else {
        print('Could not launch $certificationLink');
        // Handle error if the link cannot be launched
      }
    } else {
      print('Certification link is empty or null');
      // Handle the case where the certification link is empty or null
    }
  }


}

