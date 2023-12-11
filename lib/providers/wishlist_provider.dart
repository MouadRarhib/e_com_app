// Importing necessary packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e_com_app/models/wishlist_model.dart';
import 'package:uuid/uuid.dart';

import '../services/my_app_method.dart';

// WishlistProvider class that extends ChangeNotifier
class WishlistProvider with ChangeNotifier {
  // Map to store wishlist items with their IDs
  final Map<String, WishlistModel> _wishlistItems = {};

  // Getter to retrieve the wishlist items map
  Map<String, WishlistModel> get getWishlistItems {
    return _wishlistItems;
  }

  // Method to check if a product is in the wishlist
  bool isProductInWishlist({required String productId}) {
    return _wishlistItems.containsKey(productId);
  }

  // Firebase
  final usersDB = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;

  // Method to add a product to the wishlist in Firebase
  Future<void> addToWishlistFirebase(
      {required String productId, required BuildContext context}) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      // Show an error or warning dialog if no user is found
      MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: "No user found",
        fct: () {},
      );
      return;
    }
    final uid = user.uid;
    final wishlistId = const Uuid().v4();
    try {
      // Update the user document in Firestore with the new wishlist item
      usersDB.doc(uid).update({
        'userWish': FieldValue.arrayUnion([
          {
            "wishlistId": wishlistId,
            'productId': productId,
          }
        ])
      });
      Fluttertoast.showToast(msg: "Item has been added to Wishlist");
    } catch (e) {
      rethrow;
    }
  }

  // Method to fetch wishlist items from Firebase
  Future<void> fetchWishlist() async {
    User? user = _auth.currentUser;
    if (user == null) {
      _wishlistItems.clear();
      return;
    }
    try {
      final userDoc = await usersDB.doc(user.uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey("userWish")) {
        return;
      }
      final leng = userDoc.get("userWish").length;
      for (int index = 0; index < leng; index++) {
        _wishlistItems.putIfAbsent(
          userDoc.get('userWish')[index]['productId'],
          () => WishlistModel(
            id: userDoc.get('userWish')[index]['wishlistId'],
            productId: userDoc.get('userWish')[index]['productId'],
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  // Method to remove a wishlist item from Firebase
  Future<void> removeWishlistItemFromFirebase({
    required String wishlistId,
    required String productId,
  }) async {
    User? user = _auth.currentUser;
    try {
      // Update the user document in Firestore to remove the wishlist item
      await usersDB.doc(user!.uid).update({
        "userWish": FieldValue.arrayRemove([
          {
            'wishlistId': wishlistId,
            'productId': productId,
          }
        ])
      });
      _wishlistItems.remove(productId);
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  // Method to clear the entire wishlist from Firebase
  Future<void> clearWishlistFromFirebase() async {
    User? user = _auth.currentUser;
    try {
      // Update the user document in Firestore to clear the wishlist
      await usersDB.doc(user!.uid).update({"userWish": []});
      _wishlistItems.clear();
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  // Local methods

  // Method to add or remove a product from the local wishlist
  void addOrRemoveFromWishlist({required String productId}) {
    if (_wishlistItems.containsKey(productId)) {
      _wishlistItems.remove(productId);
    } else {
      _wishlistItems.putIfAbsent(
        productId,
        () => WishlistModel(
          id: const Uuid().v4(),
          productId: productId,
        ),
      );
    }

    notifyListeners();
  }

  // Method to clear the entire local wishlist
  void clearLocalWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }
}
