
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trip/firestore_firebase.dart'; 
import 'package:random_string/random_string.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  XFile? selectedImageWeb;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  String? userId;
  bool isImageUpdated = false; // Track if the user wants to update the image
  String? existingImageUrl; // To store the existing image URL

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    if (userId != null) {
      DocumentSnapshot profileData = await FirestoreService().getProfileByUserId(userId!);
      if (profileData.exists) {
        nameController.text = profileData['Name'] ?? '';
        emailController.text = profileData['email'] ?? '';
        phoneController.text = profileData['phone'] ?? '';
        locationController.text = profileData['location'] ?? '';
        existingImageUrl = profileData['Image']; // Get existing image URL
      }
    }
  }

  Future<void> getImage() async {
    var pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = kIsWeb ? null : File(pickedFile.path); // Only use File on non-web
        selectedImageWeb = kIsWeb ? pickedFile : null;
        isImageUpdated = true; // User wants to update the image
      });
    }
  }

  uploadProfile() async {
    try {
      // Collect the image URL to use based on user choice
      String imageUrlToUse = isImageUpdated
          ? await uploadNewImage() // Upload new image if updated
          : existingImageUrl ?? ""; // Use existing URL if not updated

      if (nameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          locationController.text.isNotEmpty) {

        await updateProfileData(imageUrlToUse);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please fill in all fields.")),
        );
      }
    } catch (e) {
      print("Error uploading profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload profile details.")),
      );
    }
  }

  Future<String> uploadNewImage() async {
    String addId = randomAlphaNumeric(10);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child("profileImage").child(addId);

    UploadTask task;
    if (kIsWeb) {
      task = firebaseStorageRef.putData(
        await selectedImageWeb!.readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      );
    } else {
      task = firebaseStorageRef.putFile(selectedImage!);
    }

    var snapshot = await task.whenComplete(() {});
    return await snapshot.ref.getDownloadURL(); // Return new image URL
  }

  Future<void> updateProfileData(String downloadUrl) async {
    Map<String, dynamic> profileData = {
      "Name": nameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "location": locationController.text,
      "Image": downloadUrl,
    };
    try {
      await FirestoreService().updateProfile(profileData, userId!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text("Profile updated successfully!", style: TextStyle(fontSize: 20.0)),
        ),
      );
      // Reset the image selection
      selectedImage = null;
      selectedImageWeb = null;
      isImageUpdated = false; // Reset the image update flag
      fetchProfileData(); // Refresh data
    } catch (e) {
      print("Error updating profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.redAccent, content: Text("Failed to update profile.")),
      );
    }
  }

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
    } else if (existingImageUrl != null) {
      return Image.network(
        existingImageUrl!,
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
        title: Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: getImage,
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
              _buildTextField("Your Name", nameController),
              SizedBox(height: 20.0),
              _buildTextField("Email", emailController),
              SizedBox(height: 20.0),
              _buildTextField("Phone", phoneController, keyboardType: TextInputType.number),
              SizedBox(height: 20.0),
              _buildTextField("Location", locationController),
              SizedBox(height: 40.0),
              GestureDetector(
                onTap: uploadProfile,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xff4b0b8a),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text(
                    "Update",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Colors.blueGrey[300])),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color(0xFFececf8)),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(border: InputBorder.none),
          ),
        ),
      ],
    );
  }
}
