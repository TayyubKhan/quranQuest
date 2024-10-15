import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart'; // Import GoogleFonts
import 'package:quranquest/core/themes/color_scheme.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  // Method to update the name in Firestore
  Future<void> _updateNameInFirestore(String newName) async {
    try {
      await FirebaseFirestore.instance
          .collection('users') // replace with your collection name
          .doc(FirebaseAuth.instance.currentUser!
              .uid) // replace with the specific document ID
          .update({'name': newName});
    } catch (e) {
      print('Error updating name: $e');
    }
  }

  Future<void> loadUserData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          _nameController.text = snapshot['name'];
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> resetPassword() async {
    String email = FirebaseAuth.instance.currentUser?.email ?? '';

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email address not found.')));
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset email sent to $email')));
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${error.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? 'Unknown';
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: darkColor),
        title: Text('Settings',
            style: GoogleFonts.nunito(color: const Color(0xff004d40))),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: ElevatedButton.icon(
              onPressed: resetPassword,
              icon: const Icon(Icons.lock_reset, color: Colors.white),
              label: Text('Reset Password',
                  style: GoogleFonts.nunito(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff004d40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: darkColor,
            ))
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: width * .1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Personal Information',
                              style: GoogleFonts.nunito(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: darkColor)),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Name',
                                  style: GoogleFonts.nunito(
                                      fontSize: 16, color: darkColor)),
                              SizedBox(
                                width: width * .05,
                                child: TextField(
                                  style: GoogleFonts.nunito(
                                      color: darkColor, fontSize: 16),
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none, isDense: true),
                                  readOnly: false,
                                  onChanged: (value) {
                                    _updateNameInFirestore(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Email',
                                  style: GoogleFonts.nunito(
                                      fontSize: 16, color: darkColor)),
                              Text(userEmail,
                                  style: GoogleFonts.nunito(
                                      fontSize: 16, color: darkColor)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
