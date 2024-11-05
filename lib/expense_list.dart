import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trip/firestore_firebase.dart';

class ListExpense extends StatefulWidget {
  const ListExpense({super.key});

  @override
  State<ListExpense> createState() => _ListExpenseState();
}

class _ListExpenseState extends State<ListExpense> {
  final FirestoreService _firestore = FirestoreService();


  void OpenModal({String? docId, Map<String, dynamic>? existingData}) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController notesController = TextEditingController();

    if (existingData != null) {
      titleController.text = existingData['title'];
      amountController.text = existingData['amount'].toString();
      categoryController.text = existingData['category'];
      notesController.text = existingData['notes'];
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: titleController, decoration: InputDecoration(labelText: 'Title')),
              TextField(controller: amountController, decoration: InputDecoration(labelText: 'Amount'), keyboardType: TextInputType.number),
              TextField(controller: categoryController, decoration: InputDecoration(labelText: 'Category')),
              TextField(controller: notesController, decoration: InputDecoration(labelText: 'Notes')),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docId == null) {
                _firestore.CreateExpenses(
                  titleController.text,
                  int.parse(amountController.text),
                  categoryController.text,
                  notesController.text,
                );
              } else {
                _firestore.updateExpenses(
                  docId,
                  titleController.text,
                  int.parse(amountController.text),
                  categoryController.text,
                  notesController.text,
                );
              }
              Navigator.pop(context);
            },
            child: Text(docId == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense List', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/NewExpenses'),
        child: Icon(Icons.add),
        backgroundColor: Colors.amber,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.getExpense(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          var expenseList = snapshot.data!.docs;

         
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(Colors.amber[80]),
                  columns: const [
                    DataColumn(label: Text('Title', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Amount (RS)', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Category', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Notes', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: expenseList.map((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    return DataRow(
                      cells: [
                        DataCell(Text(data['title'])),
                        DataCell(Text('${data['amount']}')),
                        DataCell(Text(data['category'])),
                        DataCell(Text(data['notes'])),
                        DataCell(
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => OpenModal(docId: doc.id, existingData: data),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _firestore.deleteExpenses(doc.id),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
