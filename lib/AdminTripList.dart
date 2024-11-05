// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:trip/firestore_firebase.dart';
// import 'package:flutter/material.dart';


// class Admintriplist extends StatefulWidget {
//   const Admintriplist({super.key});

//   @override
//   State<Admintriplist> createState() => _AdmintriplistState();
// }

// class _AdmintriplistState extends State<Admintriplist> {
//   final TextEditingController _textEditingController = TextEditingController();
//   final firestoreService _firestore = firestoreService();
//   void OpenModal({String? docId}) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         content: TextField(
//           controller: _textEditingController,
//         ),
//         actions: [
//           ElevatedButton(
//             onPressed: () {
//               if(docId == null){
//                   _firestore.addStudent(_textEditingController.text);
//               }else{
//                 _firestore.updateStudent(docId, _textEditingController.text);
//               }
             
//               _textEditingController.clear();
//               Navigator.pop(context);
//             },
//             child: Text('ADD'),
//           )
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Student Data'),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: OpenModal,
//         child: Icon(Icons.add),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _firestore.getStudent(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             List StudentList = snapshot.data!.docs;
//             return ListView.builder(
//                 itemCount: StudentList.length,
//                 itemBuilder: (context, index) {
            
//                   DocumentSnapshot document = StudentList[index];
//                   String docId = document.id;
                  
//                   Map<String, dynamic> data =
//                       document.data() as Map<String, dynamic>;
//                   String StudentText = data['studentName'];
//                   //display as a ListTile
//                   return ListTile(
//                     title: Text(StudentText),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           onPressed: () => OpenModal(docId: docId),
//                           icon: Icon(Icons.edit),
//                         ),
//                          IconButton(
//                       onPressed: () => _firestore.deleteStudent(docId),
//                       icon: Icon(Icons.delete),
//                     ),
//                       ],
//                     ),
                   
//                   );
//                 });
//           } else {
//             return Text('No Students');
//           }
//         },
//       ),
//     );
//   }
// }
