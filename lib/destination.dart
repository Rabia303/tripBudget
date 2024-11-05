// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class DestinationPage extends StatelessWidget {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   DestinationPage(BuildContext context);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Destinations', style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         backgroundColor: Color(0xFF854F6C), // Updated color
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _firestore.collection('destinations').orderBy('timestamp', descending: true).snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('No destinations available.'));
//           }

//           var destinations = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: destinations.length,
//             itemBuilder: (context, index) {
//               var destination = destinations[index];

//               return Card(
//                 margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                 elevation: 8,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Row(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.asset(
//                           'assets/15.jpg',
//                           width: 100,
//                           height: 100,
//                           fit: BoxFit.cover, // Correctly placed here
//                         ),
//                       ),
//                       SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               destination['destinationName'] ?? 'N/A',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 20,
//                                 color: Color(0xFF854F6C), // Updated text color
//                               ),
//                             ),
//                             SizedBox(height: 6),
//                             Text(
//                               destination['description'] ?? 'N/A',
//                               style: TextStyle(fontSize: 16, color: Colors.black87),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             SizedBox(height: 4),
//                             Text(
//                               'Best Time: ${destination['bestTime'] ?? "N/A"}',
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                             Text(
//                               'Activities: ${destination['activity'] ?? "N/A"}',
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                             Text(
//                               'Price: ${destination['price'] ?? "N/A"}',
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DestinationPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DestinationPage(); // No parameters

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Destinations', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFF854F6C), // Updated color
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('destinations').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No destinations available.'));
          }

          var destinations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              var destination = destinations[index];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/15.jpg',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover, // Correctly placed here
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              destination['destinationName'] ?? 'N/A',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Color(0xFF854F6C), // Updated text color
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              destination['description'] ?? 'N/A',
                              style: TextStyle(fontSize: 16, color: Colors.black87),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Best Time: ${destination['bestTime'] ?? "N/A"}',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              'Activities: ${destination['activity'] ?? "N/A"}',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              'Price: ${destination['price'] ?? "N/A"}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
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
}
