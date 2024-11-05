import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ActiveTripsScreen extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // Get the current logged-in user
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Active Trips', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF854F6C), // Darker color for the app bar
      ),
      body: user == null
          ? Center(child: Text('Please log in to view your active trips'))
          : StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('trips')
                  .where('userId', isEqualTo: user.uid) // Filter by the user's ID
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                // Filter trips that are active (startDate <= now < endDate)
                final trips = snapshot.data!.docs.where((trip) {
                  final tripData = trip.data() as Map<String, dynamic>?;

                  if (tripData != null &&
                      tripData.containsKey('startDate') &&
                      tripData.containsKey('endDate')) {
                    final startDate = (tripData['startDate'] as Timestamp).toDate();
                    final endDate = (tripData['endDate'] as Timestamp).toDate();
                    final now = DateTime.now();
                    return now.isAfter(startDate) && now.isBefore(endDate); // Active trips
                  }
                  return false;
                }).toList();

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(Color(0xFFFBE4D8)), // Light pink for heading
                    columns: [
                      DataColumn(
                          label: Text('Trip Name', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF854F6C)))),
                      DataColumn(
                          label: Text('Destination', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF854F6C)))),
                      DataColumn(
                          label: Text('Start Date', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF854F6C)))),
                      DataColumn(
                          label: Text('End Date', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF854F6C)))),
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
