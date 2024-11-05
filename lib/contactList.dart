import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactListPage extends StatelessWidget {
  final CollectionReference contactCollection = FirebaseFirestore.instance.collection('contacts');

  Stream<QuerySnapshot> getContacts() {
    return contactCollection.orderBy('timestamp', descending: true).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact List', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF854F6C), // Dark color for the app bar
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No contacts available.'));
          }

          final contacts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: Color(0xFFFBE4D8), // Light background color for cards
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ${contact['name']}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF854F6C)),
                      ),
                      SizedBox(height: 4),
                      Text('Email: ${contact['email']}', style: TextStyle(color: Colors.black87)),
                      SizedBox(height: 4),
                      Text('Message: ${contact['message']}', style: TextStyle(color: Colors.black54)),
                      SizedBox(height: 4),
                      Text(
                        'Submitted on: ${contact['timestamp']?.toDate().toLocal().toString() ?? 'N/A'}',
                        style: TextStyle(color: Colors.grey),
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
