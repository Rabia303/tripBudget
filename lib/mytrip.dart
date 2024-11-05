// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class TripPage extends StatelessWidget {
//   final _firestore = FirebaseFirestore.instance;

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('My Trips'),
//           bottom: TabBar(
//             tabs: [
//               Tab(text: 'Active Trips'),
//               Tab(text: 'Completed Trips'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             ActiveTripsScreen(),
//             CompletedTripsScreen(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ActiveTripsScreen extends StatelessWidget {
//   final _firestore = FirebaseFirestore.instance;

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _firestore.collection('trips').snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Center(child: CircularProgressIndicator());
//         }

//         final trips = snapshot.data!.docs.where((trip) {
//           final tripData = trip.data() as Map<String, dynamic>?;

//           if (tripData != null &&
//               tripData.containsKey('startDate') &&
//               tripData.containsKey('endDate')) {
//             final startDate = (tripData['startDate'] as Timestamp).toDate();
//             final endDate = (tripData['endDate'] as Timestamp).toDate();
//             final now = DateTime.now();
//             return now.isAfter(startDate) && now.isBefore(endDate);
//           }
//           return false;
//         }).toList();

//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: ListView.builder(
//             itemCount: trips.length,
//             itemBuilder: (context, index) {
//               final tripData = trips[index].data() as Map<String, dynamic>?;
//               final startDate = (tripData?['startDate'] as Timestamp?)?.toDate();
//               final endDate = (tripData?['endDate'] as Timestamp?)?.toDate();

//               return Card(
//                 margin: EdgeInsets.symmetric(vertical: 8),
//                 child: ListTile(
//                   leading: Icon(Icons.airplanemode_active, color: Colors.amber[800]),
//                   title: Text(tripData?['tripName'] ?? 'N/A', style: TextStyle(fontWeight: FontWeight.bold)),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.location_on, color: Colors.grey),
//                           SizedBox(width: 4),
//                           Text(tripData?['destination'] ?? 'N/A'),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Icon(Icons.calendar_today, color: Colors.grey),
//                           SizedBox(width: 4),
//                           Text(startDate != null ? '${startDate.day}-${startDate.month}-${startDate.year}' : 'N/A'),
//                           SizedBox(width: 8),
//                           Icon(Icons.arrow_forward, color: Colors.grey),
//                           SizedBox(width: 4),
//                           Text(endDate != null ? '${endDate.day}-${endDate.month}-${endDate.year}' : 'N/A'),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }

// class CompletedTripsScreen extends StatelessWidget {
//   final _firestore = FirebaseFirestore.instance;

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _firestore.collection('trips').snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Center(child: CircularProgressIndicator());
//         }

//         final trips = snapshot.data!.docs.where((trip) {
//           final tripData = trip.data() as Map<String, dynamic>?;

//           if (tripData != null && tripData.containsKey('endDate')) {
//             final endDate = (tripData['endDate'] as Timestamp).toDate();
//             final now = DateTime.now();
//             return now.isAfter(endDate);
//           }
//           return false;
//         }).toList();

//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: ListView.builder(
//             itemCount: trips.length,
//             itemBuilder: (context, index) {
//               final tripData = trips[index].data() as Map<String, dynamic>?;
//               final startDate = (tripData?['startDate'] as Timestamp?)?.toDate();
//               final endDate = (tripData?['endDate'] as Timestamp?)?.toDate();

//               return Card(
//                 margin: EdgeInsets.symmetric(vertical: 8),
//                 child: ListTile(
//                   leading: Icon(Icons.check_circle, color: Colors.green),
//                   title: Text(tripData?['tripName'] ?? 'N/A', style: TextStyle(fontWeight: FontWeight.bold)),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.location_on, color: Colors.grey),
//                           SizedBox(width: 4),
//                           Text(tripData?['destination'] ?? 'N/A'),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Icon(Icons.calendar_today, color: Colors.grey),
//                           SizedBox(width: 4),
//                           Text(startDate != null ? '${startDate.day}-${startDate.month}-${startDate.year}' : 'N/A'),
//                           SizedBox(width: 8),
//                           Icon(Icons.arrow_forward, color: Colors.grey),
//                           SizedBox(width: 4),
//                           Text(endDate != null ? '${endDate.day}-${endDate.month}-${endDate.year}' : 'N/A'),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
