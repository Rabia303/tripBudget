import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FirestoreService {
  // final CollectionReference usersCollection =
  //     FirebaseFirestore.instance.collection('users');

  // Future<void> addUserData(String uid, String email, String password,
  //     String Name){
  //   return usersCollection.doc(uid).set({
  //     'email': email,
  //     'password': password,
  //     'fullName': Name,
  //   });
  // }

   Future addUserData(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

//profile 

  
  // Add profile with user ID
  Future addProfile(Map<String, dynamic> userInfoMap, String userId) async {
    return await FirebaseFirestore.instance
        .collection("Profiles")
        .doc(userId) // Use user ID as document ID
        .set(userInfoMap);
  }

  // Fetch user-specific profile by userId
  Future<DocumentSnapshot> getProfileByUserId(String userId) async {
    return await FirebaseFirestore.instance
        .collection('Profiles')
        .doc(userId)
        .get();
  }

  // Update profile data
  Future updateProfile(Map<String, dynamic> userInfoMap, String userId) async {
    return await FirebaseFirestore.instance
        .collection('Profiles')
        .doc(userId)
        .update(userInfoMap);
  }

  final CollectionReference addExpenses =
      FirebaseFirestore.instance.collection('addexpenses');

  Future<void> AddExpenseScreen(
      String fullName, String address, String preferredCurrency) {
    return addExpenses.add({
      'fullName': fullName,
      'address': address,
      'preferredCurrency': preferredCurrency,
    });
  }

  final CollectionReference createTrip =
      FirebaseFirestore.instance.collection('trips');

  Future<void> addCreateTrip(String userId, String tripName, String destination,
      double budget, DateTime startDate, DateTime endDate) {
    return createTrip.add({
      'userId': userId, // Add the userId field
      'tripName': tripName,
      'destination': destination,
      'budget': budget,
      'startDate': startDate,
      'endDate': endDate,
    });
  }

  Stream<QuerySnapshot> getTrips() {
    return createTrip.snapshots();
  }

  final CollectionReference contact =
      FirebaseFirestore.instance.collection('add_Contact');

  Future<void> addContact(String name, String email, String message) {
    return contact.add({
      'name': name,
      'email': email,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> contacts() {
    return contact.orderBy('timestamp', descending: true).snapshots();
  }

  final CollectionReference adminAddTrip =
      FirebaseFirestore.instance.collection('adminaddtrip');

  Future<void> addAdminAddTrip(String tripName, double budget, String details) {
    return adminAddTrip.add({
      'tripName': tripName,
      'budget': budget,
      'details': details,
      'startDate': DateTime.now(),
      'endDate': DateTime.now(),
    });
  }

  Stream<QuerySnapshot> getTripsStream() {
    return FirebaseFirestore.instance.collection('trips').snapshots();
  }

  final CollectionReference createExpense =
      FirebaseFirestore.instance.collection('Create_Expense');

  Future<void> CreateExpenses(
      String title, int amount, String category, String notes) {
    return createExpense.add({
      'title': title,
      'amount': amount,
      'category': category,
      'notes': notes,
      'time': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getExpense() {
    try {
      return createExpense.snapshots();
    } catch (e) {
      print('Error fetching expenses: $e');

      return Stream.empty();
    }
  }

  Future<void> updateExpenses(
      String docId, String title, int amount, String category, String notes) {
    return createExpense.doc(docId).update({
      'title': title,
      'amount': amount,
      'category': category,
      'notes': notes,
      'time': Timestamp.now(),
    });
  }

  Future<void> deleteExpenses(String docId) {
    return createExpense.doc(docId).delete();
  }

  final CollectionReference categoryAdmin =
      FirebaseFirestore.instance.collection('add_Category');

  Future<void> add_Category(String name) {
    return categoryAdmin.add({
      'name': name,
    });
  }

  Stream<QuerySnapshot> getCategoryAdmin() {
    return categoryAdmin.snapshots();
  }

  final CollectionReference AddCategoryExpense =
      FirebaseFirestore.instance.collection('AddCategoryExpense');

  Future<void> Add_CategoryExpense(String name) {
    return AddCategoryExpense.add({
      'name': name,
    });
  }

  Stream<QuerySnapshot> getExpenseCategory() {
    return AddCategoryExpense.snapshots();
  }

  final CollectionReference destinationsCollection =
      FirebaseFirestore.instance.collection('destinations');
  Future<void> addDestination(String name, String description, String bestTime,
      String activity, String price) {
    return destinationsCollection.add({
      'destinationName': name,
      'description': description,
      'bestTime': bestTime,
      'activity': activity,
      'price': price,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getDestinations() {
    return destinationsCollection
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}

class TripService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getTripById(String docId) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('trips').doc(docId).get();
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print("Error fetching trip: $e");
    }
    return null; // Return null if trip not found or error occurs
  }
}

Future<void> sendNotification(String title, String body) async {
  final response = await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization':
          'key=BEBZFu2vJ77D-Zez6JxMOpUe4toYZYkA_1JW7wwNexuRst5VDnDV73igw8Bv5W9iD9ZKCIEE-fSZPGrAvHtSBB8', // Replace with your FCM server key
    },
    body: jsonEncode({
      "to": "/topics/all", // Or use a specific device token
      "notification": {
        "title": title,
        "body": body,
      },
    }),
  );

  if (response.statusCode == 200) {
    print('Notification sent successfully!');
  } else {
    print('Failed to send notification: ${response.body}');
  }




}
