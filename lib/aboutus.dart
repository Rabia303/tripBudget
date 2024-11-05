import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF854F6C), // Dark color for the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Trip Budgeter!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF854F6C), // Dark color for title
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Trip Budgeter is your ultimate travel companion. We help you manage your trips and expenses effortlessly, ensuring you stay within your budget and enjoy your travels to the fullest.',
              style: TextStyle(fontSize: 16, color: Color(0xFF854F6C)), // Dark color for text
            ),
            SizedBox(height: 20),
            _buildSectionTitle('Our Mission'),
            SizedBox(height: 5),
            Text(
              'To empower travelers to plan their trips efficiently and economically.',
              style: TextStyle(fontSize: 16, color: Color(0xFF854F6C)),
            ),
            SizedBox(height: 20),
            _buildSectionTitle('Contact Us'),
            SizedBox(height: 5),
            Text(
              'Email: support@tripbudgeter.com\nPhone: +1 (123) 456-7890',
              style: TextStyle(fontSize: 16, color: Color(0xFF854F6C)),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF854F6C), // Button color
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Back to Home',
                  style: TextStyle(fontSize: 18, color: Colors.white), // Button text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF854F6C), // Dark color for section titles
      ),
    );
  }
}
