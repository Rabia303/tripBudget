import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TripDetails extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Details', style: TextStyle(color: Colors.black)),
        backgroundColor: Color(0xFFFBE4D8), // Light color for the app bar
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('trips').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final trips = snapshot.data!.docs;
          if (trips.isEmpty) {
            return Center(child: Text('No trips available.'));
          }
          return ListView.builder(
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Trip Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            'assets/19.jpg', // Update with your image path
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 20),
                        // Trip Title
                        Text(
                          trip['tripName'] ?? 'N/A',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF854F6C), // Updated text color
                          ),
                        ),
                        SizedBox(height: 10),
                        // Destination and Budget
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Destination: ${trip['destination'] ?? 'N/A'}',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              '\$${trip['budget'] ?? 'N/A'}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.green[800], // Better color for budget
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        // Trip Description
                        Text(
                          'Details:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF854F6C), // Updated text color
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          trip['details'] ?? 'No details available.',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        SizedBox(height: 20),
                        // Book Now button
                        ElevatedButton(
                          onPressed: () {
                            _bookTrip(trip.id, context); // Call function to handle booking
                          },
                          child: Text('BOOK NOW'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amberAccent, // Light color for button
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // Rounded button
                            ),
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
    );
  }

  // Function to book the trip and save user's email in Firestore
  Future<void> _bookTrip(String tripId, BuildContext context) async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userEmail = user.email ?? 'Unknown';
      String userName = user.displayName ?? 'Unknown User';

      try {
        // Add user's email to the trip's bookings subcollection
        await _firestore.collection('trips').doc(tripId).collection('bookings').add({
          'email': userEmail,
          'bookedAt': Timestamp.now(),
        });

        // Add user's name and email to the 'booking_done' collection
        await _firestore.collection('booking_done').add({
          'name': userName,
          'email': userEmail,
          'tripId': tripId,
          'bookedAt': Timestamp.now(),
        });

        // Show success popup
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Trip booked successfully!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the popup
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        // Show error popup if the booking fails
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to book trip: $e'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the popup
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Show error if no user is logged in
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to be logged in to book a trip.')),
      );
    }
  }
}