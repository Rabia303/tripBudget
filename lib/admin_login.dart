import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminLogin extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<AdminLogin> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[800], 
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Admin Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Access your powerful admin tools and manage the application with ease. Please log in to continue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 40),
           
                _buildTextField(
                  hintText: 'Email Address',
                  onChanged: (value) => email = value,
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                 _buildTextField(
                  hintText: 'Password',
                  onChanged: (value) => password = value,
                  obscureText: true,
                ),
                const SizedBox(height: 30),
               
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent[700], 
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  onPressed: () async {
                    try {
                      await _auth.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );

                    
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Success!'),
                            content: const Text('You have successfully logged in. Welcome to the admin dashboard.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); 
                                  Navigator.pushNamed(context, '/AdminPanel'); 
                                },
                                child: const Text('Continue'),
                              ),
                            ],
                          );
                        },
                      );
                    } catch (e) {
                     
                      print(e);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login Error: $e')),
                      );
                    }
                  },
                  child: const Text(
                    'Log In',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
             
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/admin_register');
                  },
                  child: const Text(
                    'New here? Create an Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String hintText, required Function(String) onChanged, required bool obscureText}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2), 
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
      ),
      child: TextField(
        onChanged: onChanged,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }
}
