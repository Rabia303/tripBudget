import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'destination.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String searchQuery = '';
  String selectedSort = 'Date';

  List<Map<String, dynamic>> trips = [];
  List<Map<String, dynamic>> filteredTrips = [];

  final CollectionReference adminAddTrip =
      FirebaseFirestore.instance.collection('adminaddtrip');

  final List<String> assetImages = [
    'assets/tokyo.jpg',
    'assets/paris.jpg',
    'assets/newyork.jpg',
  ];

  @override
  void initState() {
    super.initState();
    fetchTrips();
  }

  Future<void> fetchTrips() async {
    QuerySnapshot snapshot = await adminAddTrip.get();
    setState(() {
      trips = snapshot.docs.map((doc) {
        return {
          'title': doc['tripName'] as String,
          'date': (doc['startDate'] as Timestamp).toDate().toString(),
          'image': getRandomImage(),
        };
      }).toList();
      filteredTrips = trips;
    });
  }

  String getRandomImage() {
    final random = Random();
    return assetImages[random.nextInt(assetImages.length)];
  }

  void updateFilteredTrips() {
    setState(() {
      filteredTrips = trips.where((trip) {
        return trip['title']!.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();

      if (selectedSort == 'Date') {
        filteredTrips.sort((a, b) => a['date']!.compareTo(b['date']!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF30333A),
        elevation: 0,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                _scaffoldKey.currentState!.openDrawer();
              },
              child: Image.asset(
                'assets/logo.png',
                height: 50,
              ),
            ),
            SizedBox(width: 10),
            Text(
              'Trip Budgeter',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Trips...',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[300],
                  suffixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  searchQuery = value;
                  updateFilteredTrips();
                },
              ),
            ),
            DropdownButton<String>(
              value: selectedSort,
              onChanged: (String? newValue) {
                setState(() {
                  selectedSort = newValue!;
                  updateFilteredTrips();
                });
              },
              items: <String>['Date', 'Budget', 'Location']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            _largeTopCard(),
            SizedBox(height: 20),
            Text(
              'Popular Destinations',
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            SizedBox(height: 10),
            _destinationRow(),
            SizedBox(height: 20),
            Text(
              'Recent Trips',
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            SizedBox(height: 10),
            _recentTripsList(),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      backgroundColor: Color(0xFF30333A),
    );
  }

  Widget _largeTopCard() {
    return GestureDetector(
      onTap: () {
        // Handle tap
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/11.jpg'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _destinationRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _destinationCard('Tokyo', 'assets/tokyo.jpg'),
          _destinationCard('Paris', 'assets/paris.jpg'),
          _destinationCard('New York', 'assets/newyork.jpg'),
        ],
      ),
    );
  }

  Widget _destinationCard(String destination, String imagePath) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   // context,
        //   // MaterialPageRoute(
        //   //   // builder: (context) => DestinationPage(context),
        //   // ),
        // );
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(imagePath),
            ),
            SizedBox(height: 5),
            Text(
              destination,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recentTripsList() {
    return Container(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: filteredTrips.map((trip) {
          return _tripCard(trip['title']!, trip['date']!, trip['image']!);
        }).toList(),
      ),
    );
  }

  Widget _tripCard(String title, String date, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/details');
      },
      child: Container(
        width: 160,
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Color(0xFF72676F),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                date,
                style: TextStyle(color: Colors.grey[400]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Color(0xFF505050),
      selectedItemColor: const Color.fromARGB(255, 54, 53, 53),
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money),
          label: 'Expense',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_walk),
          label: 'Trips',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.photo_album),
          label: 'Gallery',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          _showExpensePopup();
        } else if (index == 1) {
          _showTripsPopup();
        } else if (index == 2) {
          Navigator.pushNamed(context, '/gallery');
        } else if (index == 3) {
          _showProfilePopup();
        }
      },
    );
  }

  void _showExpensePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Expenses"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("My Expenses"),
                onTap: () {
                  Navigator.pushNamed(context, '/myexpenses');
                },
              ),
              ListTile(
                title: Text("Add Expense"),
                onTap: () {
                  Navigator.pushNamed(context, '/addexpense');
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _showTripsPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Trips"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Completed Trip"),
                onTap: () {
                  Navigator.pushNamed(context, '/completedTrips');
                },
              ),
              ListTile(
                title: Text("Active Trip"),
                onTap: () {
                  Navigator.pushNamed(context, '/activeTrips');
                },
              ),
              ListTile(
                title: Text("expense report "),
                onTap: () {
                  Navigator.pushNamed(context, '/report');
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _showProfilePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Add Profile"),
                onTap: () {
                  Navigator.pushNamed(context, '/addprofile');
                },
              ),
              ListTile(
                title: Text("Profile"),
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              Divider(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }
}

class AppDrawer extends StatelessWidget {
  List<Widget> _drawerItems(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {'icon': Icons.home, 'title': 'Home', 'route': '/'},
      {'icon': Icons.mail_outline, 'title': 'Contact Us', 'route': '/contact'},
      {'icon': Icons.info_outline, 'title': 'About Us', 'route': '/aboutus'},
      {'icon': Icons.photo_album, 'title': 'Gallery', 'route': '/gallery'},
      {'icon': Icons.details, 'title': 'Tour Trips', 'route': '/details'},
      {'icon': Icons.place, 'title': 'Destination', 'route': '/destination'},
      {'icon': Icons.report, 'title': 'Report', 'route': '/report'},
      // {
      //   'icon': Icons.report,
      //   'currency': 'Budget Tracking',
      //   'route': '/Budget_Tracking'
      // },
    ];

    return items.map((item) {
      return ListTile(
        leading: Icon(item['icon']),
        title: Text(item['title']),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, item['route']);
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 65, 66, 66),
            ),
            child: Text(
              'TRIP BUDEGTER',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                height: 7,
              ),
            ),
          ),
          ..._drawerItems(context),
        ],
      ),
    );
  }
}
