import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trip/firestore_firebase.dart';

class BudgetTrackingPage extends StatefulWidget {
  @override
  _BudgetTrackingPageState createState() => _BudgetTrackingPageState();
}

class _BudgetTrackingPageState extends State<BudgetTrackingPage> {
  final FirestoreService _firestore = FirestoreService();
  double totalBudget = 2750.0;
  double totalExpenses = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  void _fetchExpenses() {
    _firestore.getExpense().listen((snapshot) {
      double expensesTotal = 0.0;

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        double amount = data['amount'].toDouble();
        expensesTotal += amount;
      }

      setState(() {
        totalExpenses = expensesTotal;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double difference = totalBudget - totalExpenses;

    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Tracking'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Budget Overview
              Card(
                elevation: 5,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      BudgetInfoRow(
                        label: 'Total Budget',
                        value: '\$${totalBudget.toStringAsFixed(2)}',
                        valueColor: Colors.green,
                      ),
                      BudgetInfoRow(
                        label: 'Total Expenses',
                        value: '\$${totalExpenses.toStringAsFixed(2)}',
                        valueColor: Colors.red,
                      ),
                      BudgetInfoRow(
                        label: 'Difference',
                        value: '\$${difference.toStringAsFixed(2)}',
                        valueColor: difference >= 0 ? Colors.green : Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget for Budget Info Row
class BudgetInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  BudgetInfoRow({required this.label, required this.value, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: valueColor),
          ),
        ],
      ),
    );
  }
}
