import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Admintrip extends StatefulWidget {
  @override
  _AdmintripState createState() => _AdmintripState();
}

class _AdmintripState extends State<Admintrip> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;

  String tripName = '';
  String destination = '';
  String country = '';
  String details = '';
  double budget = 0.0;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  
  // Default image URL
  final String defaultImageUrl = 'assets/12.jpg'; // Change this to your asset image path

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
    }
  }

  Future<void> _createTrip() async {
    try {
      await _firestore.collection('trips').add({
        'tripName': tripName,
        'country': country,
        'details': details,
        'budget': budget,
        'imageUrl': defaultImageUrl, // Use the default image URL
        'startDate': startDate,
        'endDate': endDate,
        'userId': loggedInUser!.uid,
      });
      // Clear fields after submission if needed
      tripName = '';
      destination = '';
      country = '';
      details = '';
      budget = 0.0;
      setState(() {}); // Refresh UI
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Trip'),
        backgroundColor: Colors.amber[800],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) {
                tripName = value;
              },
              decoration: InputDecoration(
                labelText: 'Trip Name',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) {
                destination = value;
              },
              decoration: InputDecoration(
                labelText: 'Destination',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) {
                country = value;
              },
              decoration: InputDecoration(
                labelText: 'Country',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) {
                details = value;
              },
              decoration: InputDecoration(
                labelText: 'Details',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Display the default image
            Image.asset(
              defaultImageUrl,
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) {
                budget = double.tryParse(value) ?? 0.0;
              },
              decoration: InputDecoration(
                labelText: 'Budget',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createTrip,
              child: Text('Create Trip'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[800],
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
