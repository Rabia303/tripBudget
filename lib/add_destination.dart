import 'package:flutter/material.dart';
import 'package:trip/firestore_firebase.dart';

class AddDestinationPage extends StatefulWidget {
  @override
  _AddDestinationPageState createState() => _AddDestinationPageState();
}

class _AddDestinationPageState extends State<AddDestinationPage> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreService _firestoreService = FirestoreService();

  String destinationName = '';
  String description = '';
  String selectedBestTime = '';
  String selectedActivity = '';
  String price = '';

  List<String> bestTimes = ['Winter', 'Summer', 'Spring', 'Autumn', 'All Year'];
  List<String> activities = ['Hiking', 'Boating', 'Skiing', 'Sightseeing', 'Shopping', 'Swimming'];

  Future<void> _saveDestination() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await _firestoreService.addDestination(
        destinationName,
        description,
        selectedBestTime,
        selectedActivity,
        price,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Destination added successfully!')),
      );

      await Future.delayed(Duration(seconds: 1));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Destination", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFF854F6C), // Dark color for the app bar
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Destination Name",
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Color(0xFF854F6C)), // Dark color for label
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a destination name';
                  }
                  return null;
                },
                onSaved: (value) {
                  destinationName = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Color(0xFF854F6C)),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  description = value!;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Best Time to Visit",
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Color(0xFF854F6C)),
                ),
                value: selectedBestTime.isNotEmpty ? selectedBestTime : null,
                items: bestTimes.map((String time) {
                  return DropdownMenuItem<String>(
                    value: time,
                    child: Text(time),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedBestTime = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the best time to visit';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Activities",
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Color(0xFF854F6C)),
                ),
                value: selectedActivity.isNotEmpty ? selectedActivity : null,
                items: activities.map((String activity) {
                  return DropdownMenuItem<String>(
                    value: activity,
                    child: Text(activity),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedActivity = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an activity';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Price (Packages)",
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Color(0xFF854F6C)),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price or package';
                  }
                  return null;
                },
                onSaved: (value) {
                  price = value!;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _saveDestination,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF854F6C), // Button color
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text('Submit', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
