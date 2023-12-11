import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importing custom widgets and providers
import 'package:e_com_app/providers/user_provider.dart';
import 'package:e_com_app/widgets/subtitle_text.dart';
import 'package:e_com_app/widgets/title_text.dart';
import 'package:uuid/uuid.dart';

// Importing providers related to the shopping cart and products
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';
import '../../services/my_app_method.dart';

class CartBottomCheckout extends StatelessWidget {
  const CartBottomCheckout({super.key, required this.function});
  final Function function;

  @override
  Widget build(BuildContext context) {
    // Accessing providers
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    // Building the widget
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: const Border(
          top: BorderSide(width: 1, color: Colors.grey),
        ),
      ),
      child: SizedBox(
        height: kBottomNavigationBarHeight + 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Displaying total number of products and items
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: TitlesTextWidget(
                        label:
                            "Total (${cartProvider.getCartItems.length} products/${cartProvider.getQty()} Items)",
                      ),
                    ),
                    SubtitleTextWidget(
                      label:
                          "${cartProvider.getTotal(productProvider: productProvider).toStringAsFixed(2)}\$",
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
              // Checkout button
              ElevatedButton(
                onPressed: () async {
                  // Execute the provided function on button press
                  await function();
                },
                child: const Text("Checkout"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
