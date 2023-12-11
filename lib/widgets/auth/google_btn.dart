import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';

import '../../root_screen.dart';
import '../../services/my_app_method.dart';

// GoogleButton: A button widget for signing in with Google
class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  // Handles the Google sign-in process
  Future<void> _goolgeSignIn({required BuildContext context}) async {
    // Initialize GoogleSignIn
    final googleSignIn = GoogleSignIn();

    // Attempt to sign in with Google
    final googleAccount = await googleSignIn.signIn();

    // If the sign-in is successful
    if (googleAccount != null) {
      // Retrieve Google authentication details
      final googleAuth = await googleAccount.authentication;

      // If Google authentication details are valid
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          // Sign in to Firebase with Google credentials
          final authResults = await FirebaseAuth.instance
              .signInWithCredential(GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          ));

          // If the user is a new user, add user data to Firestore
          if (authResults.additionalUserInfo!.isNewUser) {
            await FirebaseFirestore.instance
                .collection("users")
                .doc(authResults.user!.uid)
                .set({
              'userId': authResults.user!.uid,
              'userName': authResults.user!.displayName,
              'userImage': authResults.user!.photoURL,
              'userEmail': authResults.user!.email,
              'createdAt': Timestamp.now(),
              'userWish': [],
              'userCart': [],
            });
          }

          // Navigate to the RootScreen after successful sign-in
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            Navigator.pushReplacementNamed(context, RootScreen.routName);
          });
        } on FirebaseException catch (error) {
          // Handle Firebase exceptions and show error dialog
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await MyAppMethods.showErrorORWarningDialog(
              context: context,
              subtitle: "An error has occurred: ${error.message}",
              fct: () {},
            );
          });
        } catch (error) {
          // Handle other exceptions and show error dialog
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await MyAppMethods.showErrorORWarningDialog(
              context: context,
              subtitle: "An error has occurred: $error",
              fct: () {},
            );
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Return an ElevatedButton with Google sign-in functionality
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(12),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      icon: const Icon(
        Ionicons.logo_google,
        color: Colors.red,
      ),
      label: const Text(
        "Sign in with Google",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
      ),
      onPressed: () async {
        // Trigger Google sign-in process
        _goolgeSignIn(context: context);
      },
    );
  }
}
