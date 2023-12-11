// Importing necessary packages and files
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/product_model.dart';

// ProductProvider class that extends ChangeNotifier
class ProductProvider with ChangeNotifier {
  // List to store ProductModel objects
  final List<ProductModel> _products = [];

  // Getter for the list of products
  List<ProductModel> get getProducts {
    return _products;
  }

  // Method to find a product by its ID
  ProductModel? findByProdId(String productId) {
    // Check if the list is empty or does not contain the product with the specified ID
    if (_products.where((element) => element.productId == productId).isEmpty) {
      return null;
    }
    // Return the first product with the specified ID
    return _products.firstWhere((element) => element.productId == productId);
  }

  // Method to filter products by category
  List<ProductModel> findByCategory({required String ctgName}) {
    // Create a list of products that match the specified category name (case-insensitive)
    List<ProductModel> ctgList = _products
        .where((element) => element.productCategory
            .toLowerCase()
            .contains(ctgName.toLowerCase()))
        .toList();
    return ctgList;
  }

  // Method to search products based on a search query
  List<ProductModel> searchQuery(
      {required String searchText, required List<ProductModel> passedList}) {
    // Create a list of products that contain the search text in their titles (case-insensitive)
    List<ProductModel> searchList = passedList
        .where((element) => element.productTitle
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();
    return searchList;
  }

  // Firestore collection reference for products
  final productDB = FirebaseFirestore.instance.collection("products");

  // Method to fetch products from Firestore
  Future<List<ProductModel>> fetchProducts() async {
    try {
      // Retrieve products ordered by "createdAt" in ascending order
      await productDB
          .orderBy("createdAt", descending: false)
          .get()
          .then((productsSnapshot) {
        // Clear the existing list of products
        _products.clear();
        // Iterate through the retrieved documents and populate the products list
        for (var element in productsSnapshot.docs) {
          _products.insert(0, ProductModel.fromFirestore(element));
        }
      });
      // Notify listeners of the change
      notifyListeners();
      // Return the list of products
      return _products;
    } catch (error) {
      // If an error occurs, rethrow it
      rethrow;
    }
  }

  // Method to fetch products as a stream from Firestore
  Stream<List<ProductModel>> fetchProductsStream() {
    try {
      // Return a stream that maps the snapshot to the list of products
      return productDB.snapshots().map((snapshot) {
        // Clear the existing list of products
        _products.clear();
        // Iterate through the snapshot documents and populate the products list
        for (var element in snapshot.docs) {
          _products.insert(0, ProductModel.fromFirestore(element));
        }
        // Return the list of products as a stream
        return _products;
      });
    } catch (e) {
      // If an error occurs, rethrow it
      rethrow;
    }
  }
}
