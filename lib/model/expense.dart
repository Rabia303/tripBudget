// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:uuid/uuid.dart';

// final uuid = Uuid();
// final formatter = DateFormat.yMd();
// enum Category { Meals, travel, Accommodation, work,Entertainment }

// const categoryIcons = {
//   Category.Meals: Icons.lunch_dining,
//   Category.travel: Icons.flight,
//   Category.Accommodation: Icons.home,
//   Category.work: Icons.work,
//   Category.Entertainment: Icons.tv_rounded,
// };

// class Expense {
//   Expense(
//       {required this.title,
//       required this.amount,
//       required this.date,
//       required this.category})
//       : id = uuid.v4();
//   final String id;
//   final String title;
//   final int amount;
//   final DateTime date;
//   final Category category;

//   String get formattedDate {
//     return formatter.format(date);
//   }
  
// }


// class ExpenseBucket {
//   const ExpenseBucket({
//     required this.category,
//     required this.expenses,
//   });
//   ExpenseBucket.forCategory(List<Expense> allExpenses, this.category): expenses = allExpenses.where((expense)=> expense.category == category).toList();
//   final Category category;
//   final List<Expense> expenses;
//   int get totalExpenses {
//     int sum = 0;
//     for (final expense in expenses) {
//       sum = sum + expense.amount;
//     }
//     return sum;
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();
final formatter = DateFormat.yMd();



class Expense {
  final String title;
  final int amount;
  final DateTime date;
  final String category;
  final String notes; // Add the 'notes' field

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.notes, // Add this line
  });

  // If you are converting data from Firestore, make sure to include the 'notes' field
  factory Expense.fromFirestore(Map<String, dynamic> data) {
    return Expense(
      title: data['title'] ?? '',
      amount: data['amount'] ?? 0,
      date: DateTime.parse(data['date']),
      category: data['category'] ?? '',
      notes: data['notes'] ?? '',  // Include 'notes' field
    );
  }

  // You might also want to include 'notes' in the toMap method if you need it.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'notes': notes,  // Include 'notes' field
    };
  }
}


class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final String category;
  final List<Expense> expenses;

  int get totalExpenses {
    int sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
