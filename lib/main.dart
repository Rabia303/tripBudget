import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trip/Completed_trips.dart';
import 'package:trip/active_trip.dart';
import 'package:trip/add_expense.dart';
import 'package:trip/add_profile.dart';
import 'package:trip/admin_login.dart';
import 'package:trip/buget_traking.dart';
import 'package:trip/contact.dart';
import 'package:trip/create_trip.dart';
import 'package:trip/destination.dart';
import 'add_expense.dart';
import 'package:trip/details.dart';
import 'package:trip/gallery.dart';
import 'package:trip/home.dart';
import 'package:trip/login.dart';
import 'package:trip/mytrip.dart';
import 'package:trip/new_expenses.dart';
import 'package:trip/profile.dart';
import 'package:trip/register.dart';
import 'package:trip/splashscreen.dart';
import 'package:trip/tour_trips.dart';
import 'package:trip/welcomePage.dart';
import 'firebase_options.dart';
import 'adminPanel.dart';
import 'aboutus.dart';
import 'report.dart';
import 'expense_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'add_expense.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> requestNotificationPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle the message received
      print('Message received: ${message.notification?.title}');
      // Optionally, show a dialog or a snack bar with the notification
    });
    print('User granted permission: ${settings.authorizationStatus}');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trip Budgeter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeOrAdminScreen(),
      routes: {
        '/home': (context) => HomePage(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/profile': (context) => ProfilePage(),
      '/addprofile': (context) => AddProfile(),
        '/create_trip': (context) => CreateTripScreen(),
        '/AdminPanel': (context) => AdminPanel(),
        '/admin_login': (context) => AdminLogin(),
        '/contact': (context) => ContactPage(),
        '/myexpenses': (context) => ListExpense(),
        '/destination': (context) => DestinationPage(),
        '/addexpense': (context) => AddExpenseScreen(tripId: 'id'),
        '/aboutus': (context) => AboutUsPage(),
        '/activeTrips': (context) => ActiveTripsScreen(),
        '/completedTrips': (context) => CompletedTripsScreen(),
        '/tourtrips': (context) => TourTrips(),
        '/details': (context) => TripDetails(),
        '/report': (context) => Report(),
        '/gallery': (context) => GalleryPage(),
        '/Budget_Tracking': (context) => BudgetTrackingPage(),
        'addexpense': (context) => AddExpenseScreen(tripId: 'id'),
        '/createExpense': (context) => NewExpenses(
              onAdd: (expense) {
                print(
                    'Expense Added: ${expense.title}, Amount: ${expense.amount}');
              },
            ),
      },
    );
  }
}

class HomeOrAdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get logical width and height from MediaQuery
    double logicalWidth = MediaQuery.of(context).size.width;
    double logicalHeight = MediaQuery.of(context).size.height;

    print('Logical width: $logicalWidth, Logical height: $logicalHeight');

    if (logicalWidth >= 1440 && logicalHeight >= 770) {
      return AdminLogin();
    }

    return SplashScreen();
  }
}
