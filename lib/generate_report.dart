// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_share/flutter_share.dart'; // Add this dependency for sharing

// class GenerateReportScreen extends StatefulWidget {
//   final String tripId;

//   GenerateReportScreen({required this.tripId});

//   @override
//   _GenerateReportScreenState createState() => _GenerateReportScreenState();
// }

// class _GenerateReportScreenState extends State<GenerateReportScreen> {
//   final _firestore = FirebaseFirestore.instance;
//   final _auth = FirebaseAuth.instance;
//   User? loggedInUser;
//   List<Map<String, dynamic>> expenses = [];

//   @override
//   void initState() {
//     super.initState();
//     getCurrentUser();
//     getExpenses();
//   }

//   void getCurrentUser() async {
//     try {
//       final user = _auth.currentUser;
//       if (user != null) {
//         loggedInUser = user;
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   void getExpenses() async {
//     try {
//       var expenseData = await _firestore
//           .collection('expenses')
//           .where('tripId', isEqualTo: widget.tripId)
//           .get();
//       setState(() {
//         expenses = expenseData.docs.map((doc) => doc.data()).toList();
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> generateReport() async {
//     String csvData = "Category,Amount,Date\n"; // CSV header

//     for (var expense in expenses) {
//       csvData += "${expense['category']},${expense['amount']},${expense['date'].toDate()}\n";
//     }

//     // Share the CSV file
//     await FlutterShare.share(
//       title: 'Expense Report',
//       text: 'Here is your expense report.',
//       linkUrl: null,
//       chooserTitle: 'Share Report',
//       // filePath: null, // You can save it as a file if needed
//     );

//     // For demonstration, you could print or log the CSV data
//     print(csvData);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Generate Report'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: expenses.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(expenses[index]['category']),
//                     subtitle: Text('Amount: \$${expenses[index]['amount']}'),
//                     trailing: Text('Date: ${expenses[index]['date'].toDate()}'),
//                   );
//                 },
//               ),
//             ),
//             ElevatedButton(
//               onPressed: generateReport,
//               child: Text('Download Report'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
