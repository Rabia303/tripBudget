import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:trip/firestore_firebase.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final FirestoreService _firestore = FirestoreService();
  DateTimeRange? selectedDateRange;
  String? selectedCategory;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  Stream<QuerySnapshot> getFilteredExpenses() {
    Query query = _firestore.createExpense.where('userId', isEqualTo: currentUser!.uid);

    if (selectedDateRange != null) {
      query = query
          .where('time', isGreaterThanOrEqualTo: Timestamp.fromDate(selectedDateRange!.start))
          .where('time', isLessThanOrEqualTo: Timestamp.fromDate(selectedDateRange!.end));
    }

    if (selectedCategory != null && selectedCategory!.isNotEmpty && selectedCategory != 'All') {
      query = query.where('category', isEqualTo: selectedCategory);
    }

    return query.snapshots();
  }

  void generateReportPdf(List<QueryDocumentSnapshot> expenses) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Expense Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text('Category: ${selectedCategory ?? 'All'}'),
              pw.Text(
                  'Date Range: ${selectedDateRange?.start.toString().substring(0, 10)} - ${selectedDateRange?.end.toString().substring(0, 10)}'),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text('Title', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Category', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Notes', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                  ...expenses.map((expense) {
                    var data = expense.data() as Map<String, dynamic>;
                    return pw.TableRow(
                      children: [
                        pw.Text(data['title']),
                        pw.Text('${data['amount']}'),
                        pw.Text(data['category']),
                        pw.Text(data['notes']),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ],
          );
        },
      ),
    );

    // Print the PDF
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expense List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 161, 158, 147),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color.fromARGB(255, 158, 150, 139), const Color.fromARGB(255, 155, 152, 145)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final DateTimeRange? picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDateRange = picked;
                      });
                    }
                  },
                  icon: Icon(Icons.date_range),
                  label: Text('Select Date Range'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    backgroundColor: const Color.fromARGB(255, 177, 174, 168),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                DropdownButton<String>(
                  value: selectedCategory,
                  hint: Text('Select Category'),
                  onChanged: (newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                  items: <String>['All', 'Travel', 'Food', 'Misc']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  dropdownColor: Colors.amber[50],
                  icon: Icon(Icons.arrow_drop_down, color: const Color.fromARGB(255, 80, 79, 75)),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getFilteredExpenses(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                var expenseList = snapshot.data!.docs;

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(const Color.fromARGB(255, 139, 137, 128)),
                      columns: const [
                        DataColumn(label: Text('Title', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Amount (RS)', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Category', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Notes', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: expenseList.map((doc) {
                        var data = doc.data() as Map<String, dynamic>;
                        return DataRow(
                          cells: [
                            DataCell(Text(data['title'])),
                            DataCell(Text('${data['amount']}')),
                            DataCell(Text(data['category'])),
                            DataCell(Text(data['notes'])),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                final expensesSnapshot = await getFilteredExpenses().first;
                if (expensesSnapshot.docs.isNotEmpty) {
                  generateReportPdf(expensesSnapshot.docs);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No expenses available for report generation!')),
                  );
                }
              },
              icon: Icon(Icons.picture_as_pdf),
              label: Text('Generate Report (PDF)'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                backgroundColor: const Color.fromARGB(255, 143, 153, 163),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
