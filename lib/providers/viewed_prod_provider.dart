// Importing necessary packages
import 'package:flutter/material.dart';
import 'package:e_com_app/models/viewed_prod_model.dart';
import 'package:uuid/uuid.dart';

// ViewedProdProvider class that extends ChangeNotifier
class ViewedProdProvider with ChangeNotifier {
  // Map to store viewed product items with their IDs
  final Map<String, ViewedProdModel> _viewedProdItems = {};

  // Getter to retrieve the viewed product items map
  Map<String, ViewedProdModel> get getviewedProdItems {
    return _viewedProdItems;
  }

  // Method to add a product to the viewed history
  void addProductToHistory({required String productId}) {
    // Use putIfAbsent to add the product to the map if it doesn't exist
    _viewedProdItems.putIfAbsent(
      productId,
      () => ViewedProdModel(
        id: const Uuid().v4(),
        productId: productId,
      ),
    );

    // Notify listeners that the viewed product items have been updated
    notifyListeners();
  }
}
