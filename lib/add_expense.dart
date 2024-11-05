import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddExpenseScreen extends StatefulWidget {
  final String tripId;

  AddExpenseScreen({required this.tripId});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;
  String category = '';
  double amount = 0.0;
  String notes = '';
  DateTime date = DateTime.now();

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
        title: Text('Add Expense', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.tealAccent, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Log Your Expense',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 20),
              _buildTextField('Category', (value) => category = value),
              SizedBox(height: 20),
              _buildTextField(
                'Amount',
                (value) => amount = double.tryParse(value) ?? 0.0,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              _buildTextField('Notes', (value) => notes = value),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _addExpense,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text('Add Expense'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextField _buildTextField(String label, Function(String) onChanged, {TextInputType? keyboardType}) {
    return TextField(
      onChanged: onChanged,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.tealAccent),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }

  void _addExpense() async {
    try {
      await _firestore.collection('expenses').add({
        'category': category,
        'amount': amount,
        'notes': notes,
        'date': date,
        'tripId': widget.tripId,
        'userId': loggedInUser!.uid,
      });
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }
}
