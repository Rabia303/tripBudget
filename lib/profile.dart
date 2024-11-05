


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trip/edit_profile.dart'; 

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController locationController;

  bool isLoading = true;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    locationController = TextEditingController();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    if (currentUser != null) {
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('Profiles')
            .doc(currentUser!.uid)
            .get();

        if (snapshot.exists) {
          setState(() {
            userData = snapshot.data() as Map<String, dynamic>;
            nameController.text = userData!['Name'] ?? '';
            emailController.text = userData!['email'] ?? '';
            phoneController.text = userData!['phone'] ?? '';
            locationController.text = userData!['location'] ?? '';
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            userData = null;
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: (Color(0xFF2D2D2D)),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Your Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : currentUser == null
              ? Center(child: Text('Please log in to view your profile.', style: TextStyle(color: Colors.white)))
              : userData == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('No profile details found.', style: TextStyle(color: Colors.white)),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              // Option to add new profile details
                              updateProfile(); 
                            },
                            child: Text('Add Profile Details', style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF1C1C1C), Color(0xFF2D2D2D)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: CircleAvatar(
                                radius: screenSize.width * 0.15,
                                backgroundImage: userData?['Image'] != null
                                    ? NetworkImage(userData!['Image'])
                                    : AssetImage('assets/images/profileimg.jpg')
                                        as ImageProvider,
                              ),
                            ),
                            SizedBox(height: 20),
                            buildEditableInfoCard(
                              label: 'Name',
                              controller: nameController,
                              screenSize: screenSize,
                            ),
                            buildEditableInfoCard(
                              label: 'Email',
                              controller: emailController,
                              screenSize: screenSize,
                            ),
                            buildEditableInfoCard(
                              label: 'Phone',
                              controller: phoneController,
                              screenSize: screenSize,
                            ),
                            buildEditableInfoCard(
                              label: 'Location',
                              controller: locationController,
                              screenSize: screenSize,
                            ),
                            SizedBox(height: 40),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenSize.width * 0.1,
                                    vertical: 15,
                                  ),
                                ),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfile(),
                                    ),
                                  );
                                  // Fetch updated profile data after returning from EditProfile
                                  fetchProfileData();
                                },
                                child: Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                    fontSize: screenSize.width * 0.04,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
    );
  }

  Widget buildEditableInfoCard({
    required String label,
    required TextEditingController controller,
    required Size screenSize,
  }) {
    return Card(
      color: Color(0xFF2D2D2D),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: TextFormField(
          controller: controller,
          readOnly: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  void updateProfile() {
    // Handle profile update logic here
  }
}
