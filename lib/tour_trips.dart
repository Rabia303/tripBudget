import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TourTrips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tour Trips'),
        backgroundColor: Colors.amber[800],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getTripsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final trips = snapshot.data!.docs;
          return ListView.builder(
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                elevation: 4, // Adding elevation for shadow effect
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip['tripName'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[800], // Color for trip name
                        ),
                      ),
                      SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12), // Rounded image
                        child: Image.asset(
                          'assets/11.jpg',
                          height: 120,
                          width: double.infinity, // Full width image
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Budget: \$${trip['budget']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green[700], // Color for budget
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Details: ${trip['details']}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Stream<QuerySnapshot> getTripsStream() {
    return FirebaseFirestore.instance.collection('trips').snapshots();
  }
}
