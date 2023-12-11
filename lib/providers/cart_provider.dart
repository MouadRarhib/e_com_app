import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e_com_app/models/cart_model.dart';
import 'package:e_com_app/services/my_app_method.dart';
import 'package:uuid/uuid.dart';

import '../models/product_model.dart';
import 'product_provider.dart';

/// A provider class for managing the user's shopping cart.
class CartProvider with ChangeNotifier {
  final Map<String, CartModel> _cartItems = {};

  /// Gets the map of cart items.
  Map<String, CartModel> get getCartItems {
    return _cartItems;
  }

  // Firebase
  final usersDB = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;

  /// Adds a product to the user's cart on Firebase.
  Future<void> addToCartFirebase({
    required String productId,
    required int qty,
    required BuildContext context,
  }) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: "No user found",
        fct: () {},
      );
      return;
    }
    final uid = user.uid;
    final cartId = const Uuid().v4();
    try {
      usersDB.doc(uid).update({
        'userCart': FieldValue.arrayUnion([
          {
            "cartId": cartId,
            'productId': productId,
            'quantity': qty,
          }
        ])
      });
      await fetchCart();
      Fluttertoast.showToast(msg: "Item has been added to cart");
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches the user's cart from Firebase.
  Future<void> fetchCart() async {
    User? user = _auth.currentUser;
    if (user == null) {
      log("the function has been called and the user is null");
      _cartItems.clear();
      return;
    }
    try {
      final userDoc = await usersDB.doc(user.uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey("userCart")) {
        return;
      }
      final leng = userDoc.get("userCart").length;
      for (int index = 0; index < leng; index++) {
        _cartItems.putIfAbsent(
          userDoc.get('userCart')[index]['productId'],
          () => CartModel(
            cartId: userDoc.get('userCart')[index]['cartId'],
            productId: userDoc.get('userCart')[index]['productId'],
            quantity: userDoc.get('userCart')[index]['quantity'],
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  /// Removes a cart item from Firebase.
  Future<void> removeCartItemFromFirebase({
    required String cartId,
    required String productId,
    required int qty,
  }) async {
    User? user = _auth.currentUser;
    try {
      await usersDB.doc(user!.uid).update({
        "userCart": FieldValue.arrayRemove([
          {
            "cartId": cartId,
            'productId': productId,
            'quantity': qty,
          }
        ])
      });
      _cartItems.remove(productId);
      await fetchCart();
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  /// Clears the user's cart on Firebase.
  Future<void> clearCartFromFirebase() async {
    User? user = _auth.currentUser;
    try {
      await usersDB.doc(user!.uid).update({"userCart": []});
      _cartItems.clear();
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  // Local
  /// Checks if a product is in the local cart.
  bool isProductInCart({required String productId}) {
    return _cartItems.containsKey(productId);
  }

  /// Adds a product to the local cart.
  void addProductToCart({required String productId}) {
    _cartItems.putIfAbsent(
      productId,
      () => CartModel(
        cartId: const Uuid().v4(),
        productId: productId,
        quantity: 1,
      ),
    );
    notifyListeners();
  }

  /// Updates the quantity of a product in the local cart.
  void updateQuantity({required String productId, required int quantity}) {
    _cartItems.update(
      productId,
      (item) => CartModel(
        cartId: item.cartId,
        productId: productId,
        quantity: quantity,
      ),
    );
    notifyListeners();
  }

  /// Calculates the total price of items in the local cart.
  double getTotal({required ProductProvider productProvider}) {
    double total = 0.0;
    _cartItems.forEach((key, value) {
      final ProductModel? getCurrProduct =
          productProvider.findByProdId(value.productId);
      if (getCurrProduct == null) {
        total += 0;
      } else {
        total += double.parse(getCurrProduct.productPrice) * value.quantity;
      }
    });
    return total;
  }

  /// Gets the total quantity of items in the local cart.
  int getQty() {
    int total = 0;
    _cartItems.forEach((key, value) {
      total += value.quantity;
    });
    return total;
  }

  /// Removes one item from the local cart.
  void removeOneItem({required String productId}) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  /// Clears the local cart.
  void clearLocalCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
