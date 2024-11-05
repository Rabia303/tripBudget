import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class adminaddtrip extends StatefulWidget {
  @override
  _adminaddtripState createState() => _adminaddtripState();
}

class _adminaddtripState extends State<adminaddtrip> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;
  String tripName = '';
  String destination = '';
  double budget = 0.0;
  String details = '';
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
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
              TextField(
              onChanged: (value) {
                details = value;
              },
              decoration: InputDecoration(
                labelText: 'details',
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
                budget = double.parse(value);
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
              onPressed: () async {
                try {
                  await _firestore.collection('adminaddtrip').add({
                    'tripName': tripName,
                    'destination': destination,
                    'budget': budget,
                    'startDate': startDate,
                    'endDate': endDate,
                    'userId': loggedInUser!.uid,
                  });
                  Navigator.pop(context);
                } catch (e) {
                  print(e);
                }
              },
              child: Text('Create Trip'),
              style: ElevatedButton.styleFrom(
                iconColor: Colors.amber[800],
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
