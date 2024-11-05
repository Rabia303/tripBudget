import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddCategoryExpense extends StatefulWidget {
  @override
  _AddCategoryExpenseState createState() => _AddCategoryExpenseState();
}

class _AddCategoryExpenseState extends State<AddCategoryExpense> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String cat = '';
  

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
                cat = value;
              },
              decoration: InputDecoration(
                labelText: 'category',
                filled: true,
                fillColor: Colors.white, 
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 16),
           
            ElevatedButton(
              onPressed: () async {
                try {
                  await _firestore.collection('cat').add({
                   'cat':cat,
                  });
                  Navigator.pop(context);
                } catch (e) {
                  print(e);
                }
              },
              child: Text('Create category Currency'),
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
