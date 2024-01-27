import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class VerifyRule extends StatelessWidget {
  static const String routeName = "/VerifyRule";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verify Nutritionist Rules',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.adminpageColor4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
    child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Admin!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'To verify a nutritionist, follow the rules, steps, and requirements below:',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rules:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '1. Valid Certification:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '   Nutritionists must provide proof of valid certification from a recognized institution.',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '2. Experience:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '   Nutritionists must have a minimum of 2 years of experience in the field.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Steps:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '1. Review Certification:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '   Examine the certification provided by the nutritionist to ensure it is valid and from a recognized institution.',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '2. Check Experience:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '   Verify that the nutritionist has a minimum of 2 years of experience in the field by reviewing their work history or credentials.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Requirements:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Ensure all verification steps are documented and recorded.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Once the verification is completed:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '1.If the nutritionist is approved, press the approve button by sending email with approval code.',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '2.If not, reject the application by sending a rejection email to the applicant.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
