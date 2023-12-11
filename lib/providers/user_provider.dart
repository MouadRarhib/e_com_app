// Importing necessary packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:e_com_app/models/user_model.dart';

// UserProvider class that extends ChangeNotifier
class UserProvider with ChangeNotifier {
  // Instance variable to store user information
  UserModel? userModel;

  // Getter to retrieve the current user model
  UserModel? get getUserModel {
    return userModel;
  }

  // Method to fetch user information from Firestore
  Future<UserModel?> fetchUserInfo() async {
    // Obtain an instance of FirebaseAuth
    final FirebaseAuth auth = FirebaseAuth.instance;

    // Get the current authenticated user
    User? user = auth.currentUser;

    // Return null if no user is authenticated
    if (user == null) {
      return null;
    }

    // Extract the UID from the authenticated user
    var uid = user.uid;

    try {
      // Retrieve user document from Firestore using the UID
      final userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      // Extract user data from the document
      final userDocDict = userDoc.data();

      // Create a UserModel instance with the retrieved data
      userModel = UserModel(
        userId: userDoc.get("userId"),
        userName: userDoc.get("userName"),
        userImage: userDoc.get("userImage"),
        userEmail: userDoc.get('userEmail'),
        userCart:
            userDocDict!.containsKey("userCart") ? userDoc.get("userCart") : [],
        userWish:
            userDocDict.containsKey("userWish") ? userDoc.get("userWish") : [],
        createdAt: userDoc.get('createdAt'),
      );

      // Notify listeners that user information has been updated
      notifyListeners();

      // Return the user model
      return userModel;
    } on FirebaseException catch (error) {
      // Handle Firebase exceptions
      throw error.message.toString();
    } catch (error) {
      // Rethrow other exceptions
      rethrow;
    }
  }
}
