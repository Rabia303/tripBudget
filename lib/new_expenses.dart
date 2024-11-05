import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trip/model/expense.dart';

class NewExpenses extends StatefulWidget {
  const NewExpenses({super.key, required this.onAdd});
  final void Function(Expense expense) onAdd;

  @override
  State<NewExpenses> createState() => _NewExpensesState();
}

class _NewExpensesState extends State<NewExpenses> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  String _selectedCategory = '';

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, DateTime? initialDate, Function(DateTime) onDateSelected) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      initialDate: initialDate ?? now,
      lastDate: DateTime(now.year + 5), // Future dates allowed
    );
    if (pickedDate != null) {
      setState(() {
        onDateSelected(pickedDate);
      });
    }
  }

  Future<void> _submitExpenseData() async {
    final enteredAmount = int.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedStartDate == null ||
        _selectedEndDate == null ||
        _selectedCategory.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Invalid input'),
          content: Text('Please make sure a valid title, amount, start date, end date, category, and notes were entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('Create_Expense').add({
        'title': _titleController.text,
        'amount': enteredAmount,
        'startDate': _selectedStartDate!.toIso8601String(),
        'endDate': _selectedEndDate!.toIso8601String(),
        'category': _selectedCategory,
        'notes': _notesController.text,
      });

      widget.onAdd(
        Expense(
          title: _titleController.text,
          amount: enteredAmount,
          date: _selectedStartDate!, // Use start date
          category: _selectedCategory,
          notes: _notesController.text,
        ),
      );

      Navigator.pop(context);
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to add the expense. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        color: Color(0xFFE8F5E9), // Light green background
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Add New Expense',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF388E3C), // Dark green color
                      ),
                    ),
                    SizedBox(height: 24),
                    TextField(
                      controller: _titleController,
                      maxLength: 50,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(color: Color(0xFF388E3C)), // Dark green label
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(0xFF388E3C)!), // Dark green border
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Amount',
                              prefixText: 'RS ',
                              labelStyle: TextStyle(color: Color(0xFF388E3C)), // Dark green label
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFF388E3C)!), // Dark green border
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Start Date', style: TextStyle(color: Color(0xFF388E3C))),
                              TextButton(
                                onPressed: () => _selectDate(context, _selectedStartDate, (date) {
                                  _selectedStartDate = date;
                                }),
                                child: Text(
                                  _selectedStartDate == null
                                      ? 'Select Start Date'
                                      : '${_selectedStartDate!.day}-${_selectedStartDate!.month}-${_selectedStartDate!.year}',
                                  style: TextStyle(color: Color(0xFF388E3C)), // Dark green text
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('End Date', style: TextStyle(color: Color(0xFF388E3C))),
                              TextButton(
                                onPressed: () => _selectDate(context, _selectedEndDate, (date) {
                                  _selectedEndDate = date;
                                }),
                                child: Text(
                                  _selectedEndDate == null
                                      ? 'Select End Date'
                                      : '${_selectedEndDate!.day}-${_selectedEndDate!.month}-${_selectedEndDate!.year}',
                                  style: TextStyle(color: Color(0xFF388E3C)), // Dark green text
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _categoryController,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        labelStyle: TextStyle(color: Color(0xFF388E3C)), // Dark green label
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(0xFF388E3C)!), // Dark green border
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: 'Notes',
                        labelStyle: TextStyle(color: Color(0xFF388E3C)), // Dark green label
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(0xFF388E3C)!), // Dark green border
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _submitExpenseData,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Color(0xFF388E3C), // Dark green button
                          ),
                          child: Text('Save Expense'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
