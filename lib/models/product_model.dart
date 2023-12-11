import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Represents a product with various details
class ProductModel with ChangeNotifier {
  final String productId, // Unique identifier for the product
      productTitle, // Title/name of the product
      productPrice, // Price of the product
      productCategory, // Category to which the product belongs
      productDescription, // Description of the product
      productImage, // URL/path to the product image
      productQuantity; // Quantity of the product in stock
  Timestamp? createdAt; // Timestamp indicating when the product was created

  // Constructor for creating an instance of ProductModel
  ProductModel({
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.productCategory,
    required this.productDescription,
    required this.productImage,
    required this.productQuantity,
    this.createdAt,
  });

  // Factory method to create a ProductModel instance from Firestore document
  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    // Creating a ProductModel instance using data from Firestore document
    return ProductModel(
      productId: data['productId'],
      productTitle: data['productTitle'],
      productPrice: data['productPrice'],
      productCategory: data['productCategory'],
      productDescription: data['productDescription'],
      productImage: data['productImage'],
      productQuantity: data['productQuantity'],
      createdAt: data['createdAt'],
    );
  }
}
