// Importing the CategoriesModel from the correct path
import 'package:e_com_app/models/categories_model.dart';

// Importing the AssetsManager service
import '../services/assets_manager.dart';

// Class to define various constants used in the app
class AppConstants {
  // Sample product image URL
  static const String productImageUrl =
      'https://i.ibb.co/8r1Ny2n/20-Nike-Air-Force-1-07.png';

  // List of banner images
  static List<String> bannersImages = [
    AssetsManager.banner1,
    AssetsManager.banner2,
  ];

  // List of predefined category models
  static List<CategoryModel> categoriesList = [
    CategoryModel(
      id: "Phones",
      image: AssetsManager.mobiles,
      name: "Phones",
    ),
    CategoryModel(
      id: "Laptops",
      image: AssetsManager.pc,
      name: "Laptops",
    ),
    CategoryModel(
      id: "Electronics",
      image: AssetsManager.electronics,
      name: "Electronics",
    ),
    CategoryModel(
      id: "Watches",
      image: AssetsManager.watch,
      name: "Watches",
    ),
    CategoryModel(
      id: "Clothes",
      image: AssetsManager.fashion,
      name: "Clothes",
    ),
    CategoryModel(
      id: "Shoes",
      image: AssetsManager.shoes,
      name: "Shoes",
    ),
    CategoryModel(
      id: "", // You might want to provide a unique identifier here
      image: AssetsManager.book,
      name: "Books",
    ),
    CategoryModel(
      id: "Cosmetics",
      image: AssetsManager.cosmetics,
      name: "Cosmetics",
    ),
  ];
}
