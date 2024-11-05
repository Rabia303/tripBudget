import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CompletedTripsScreen extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // Get the current logged-in user
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Trips'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: user == null
          ? Center(child: Text('Please log in to view your trips'))
          : StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('trips')
                  .where('userId', isEqualTo: user.uid) // Filter by the user's ID
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                // Filter trips that have been completed (endDate in the past)
                final trips = snapshot.data!.docs.where((trip) {
                  final tripData = trip.data() as Map<String, dynamic>?;

                  if (tripData != null && tripData.containsKey('endDate')) {
                    final endDate = (tripData['endDate'] as Timestamp).toDate();
                    final now = DateTime.now();
                    return now.isAfter(endDate); // Completed trips
                  }
                  return false;
                }).toList();

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(Colors.lightBlue[100]),
                    columns: [
                      DataColumn(label: Text('Trip Name', style: TextStyle(color: Colors.black))),
                      DataColumn(label: Text('Destination', style: TextStyle(color: Colors.black))),
                      DataColumn(label: Text('Start Date', style: TextStyle(color: Colors.black))),
                      DataColumn(label: Text('End Date', style: TextStyle(color: Colors.black))),
                    ],
                    rows: trips.map((trip) {
                      final tripData = trip.data() as Map<String, dynamic>?;
                      final startDate = (tripData?['startDate'] as Timestamp?)?.toDate();
                      final endDate = (tripData?['endDate'] as Timestamp?)?.toDate();

                      return DataRow(cells: [
                        DataCell(Text(tripData?['tripName'] ?? 'N/A')),
                        DataCell(Text(tripData?['destination'] ?? 'N/A')),
                        DataCell(Text(startDate != null
                            ? '${startDate.day}-${startDate.month}-${startDate.year}'
                            : 'N/A')),
                        DataCell(Text(endDate != null
                            ? '${endDate.day}-${endDate.month}-${endDate.year}'
                            : 'N/A')),
                      ]);
                    }).toList(),
                  ),
                );
              },
            ),
    );
  }
}
