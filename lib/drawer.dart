import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppDrawer extends StatelessWidget {
  final Color primaryColor = Colors.lightBlue[300]!; 
  final Color backgroundColor = Colors.white; 
  final Color textColor = Colors.black; 
  final Color secondaryTextColor = Colors.grey[700]!; 
  final Color iconColor = Colors.black; 

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      child: Container(
        color: backgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/logo.png',
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Trip Budgeter',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06, 
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: primaryColor,
              ),
            ),
            ..._drawerItems(context), 
            Divider(color: secondaryTextColor),
            _buildLogoutItem(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _drawerItems(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {'icon': Icons.airplanemode_active, 'title': 'My Trip', 'route': '/mytrip'},
      {'icon': Icons.receipt_long, 'title': 'My Expenses', 'route': '/myexpenses'},
      {'icon': Icons.add_circle, 'title': 'Add Expense', 'route': '/createExpense'},
      {'icon': Icons.person_outline, 'title': 'Profile', 'route': '/profile'},
      {'icon': Icons.mail_outline, 'title': 'Contact Us', 'route': '/contactus'},
      {'icon': Icons.info_outline, 'title': 'About Us', 'route': '/aboutus'},
      {'icon': Icons.directions_run, 'title': 'Active Trips', 'route': '/activeTrips'},
      {'icon': Icons.check_circle_outline, 'title': 'Completed Trips', 'route': '/completedTrips'},
      {'icon': Icons.photo_album, 'title': 'Gallery', 'route': '/gallery'},
      {'icon': Icons.details, 'title': 'Details', 'route': '/details'},
      {'icon': Icons.tour, 'title': 'Tour Trips', 'route': '/tourtrips'},
      {'icon': Icons.place, 'title': 'Destination', 'route': '/destination'},
    ];

    return items.map((item) {
      return _buildDrawerItem(context, item['icon'], item['title'], item['route']);
    }).toList();
  }

  ListTile _buildDrawerItem(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(color: secondaryTextColor),
      ),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }

  ListTile _buildLogoutItem(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.logout, color: Colors.red),
      title: Text(
        'Logout',
        style: TextStyle(color: Colors.red),
      ),
      onTap: () async {
        await FirebaseAuth.instance.signOut();
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false); 
      },
    );
  }
}