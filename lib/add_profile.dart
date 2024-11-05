import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:trip/firestore_firebase.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProfile extends StatefulWidget {
  const AddProfile({super.key});

  @override
  State<AddProfile> createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  XFile? selectedImageWeb;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  bool isProfileAdded = false; // Flag to check if profile is already added
  bool isLoading = true; // Flag to show loading indicator

  @override
  void initState() {
    super.initState();
    checkProfileStatus(); // Check if profile exists when page loads
  }

  // Check if the profile is already added for the user
  Future<void> checkProfileStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var profileDoc = await FirebaseFirestore.instance
          .collection('Profiles')
          .doc(user.uid)
          .get();
      if (profileDoc.exists) {
        setState(() {
          isProfileAdded = true;
        });
      }
    }
    setState(() {
      isLoading = false; // Hide loading indicator after checking profile
    });
  }

  Future<void> getImage() async {
    var pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        setState(() {
          selectedImageWeb = pickedFile;
        });
      } else {
        setState(() {
          selectedImage = File(pickedFile.path);
        });
      }
    }
  }

  // Upload item to Firebase storage
  uploadItem() async {
    try {
      User? user = FirebaseAuth.instance.currentUser; // Get current user
      if (user != null &&
          (selectedImage != null || selectedImageWeb != null) &&
          nameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          locationController.text.isNotEmpty) {
        
        String addId = randomAlphaNumeric(10);
        Reference firebaseStorageref =
            FirebaseStorage.instance.ref().child("profileImage").child(addId);

        UploadTask task;
        if (kIsWeb) {
          task = firebaseStorageref.putData(
            await selectedImageWeb!.readAsBytes(),
            SettableMetadata(contentType: 'image/jpeg'),
          );
        } else {
          task = firebaseStorageref.putFile(selectedImage!);
        }

        var snapshot = await task.whenComplete(() {});
        var downloadUrl = await snapshot.ref.getDownloadURL();

        // Include user ID in profile data
        await _uploadProfileData(downloadUrl, user.uid);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please fill in all fields and select an image.")),
        );
      }
    } catch (e) {
      print("Error uploading item: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload Profile details.")),
      );
    }
  }

  // Upload profile data to Firestore
  Future<void> _uploadProfileData(String downloadUrl, String userId) async {
    Map<String, dynamic> profileData = {
      "userId": userId,  
      "Name": nameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "location": locationController.text,
      "Image": downloadUrl,
    };
    try {
      await FirestoreService().addProfile(profileData, userId); 
      selectedImage = null;
      selectedImageWeb = null;
      nameController.text = "";
      emailController.text = "";
      phoneController.text = "";
      locationController.text = "";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Profile Details have been uploaded successfully!",
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      );
      setState(() {
        isProfileAdded = true; // Mark profile as added after successful upload
      });
    } catch (e) {
      print("Error uploading Profile data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text("Failed to upload Profile details.")),
      );
    }
  }

  // Display image based on platform
  Widget displayImage() {
    if (kIsWeb && selectedImageWeb != null) {
      return Image.network(
        selectedImageWeb!.path,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    } else if (selectedImage != null) {
      return Image.file(
        selectedImage!,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    } else {
      return Icon(Icons.camera_alt_outlined);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: Text(
          "Add Profile Details",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      body: isLoading // Show loading indicator while checking profile status
          ? Center(child: CircularProgressIndicator())
          : isProfileAdded
              ? Center(
                  child: Text(
                    "Profile details have already been added.",
                    style: TextStyle(fontSize: 20.0, color: Colors.green),
                  ),
                )
              : SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Upload the Profile Image",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.blueGrey[300],
                          ),
                        ),
                        SizedBox(height: 20.0),
                        GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Center(
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 1.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: displayImage(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          "Your Name",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.blueGrey[300],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Color(0xFFececf8),
                          ),
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          "Email",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.blueGrey[300],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Color(0xFFececf8),
                          ),
                          child: TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          "Phone",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.blueGrey[300],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Color(0xFFececf8),
                          ),
                          child: TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          "Location",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.blueGrey[300],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Color(0xFFececf8),
                          ),
                          child: TextField(
                            controller: locationController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        GestureDetector(
                          onTap: () {
                            uploadItem();
                          },
                          child: Center(
                            child: Container(
                              height: 50.0,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                  colors: [Colors.blueAccent, Colors.lightBlue],
                                ),
                              ),
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
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
}
