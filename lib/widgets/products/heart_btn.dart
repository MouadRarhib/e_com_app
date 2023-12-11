import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../../providers/wishlist_provider.dart';
import '../../services/my_app_method.dart';

// HeartButtonWidget: A widget for displaying a heart icon that interacts with the wishlist
class HeartButtonWidget extends StatefulWidget {
  const HeartButtonWidget({
    super.key,
    this.size = 22,
    this.color = Colors.transparent,
    required this.productId,
  });

  // The size of the heart icon
  final double size;

  // The color of the container surrounding the heart icon
  final Color color;

  // The unique identifier of the product associated with the heart icon
  final String productId;

  @override
  State<HeartButtonWidget> createState() => _HeartButtonWidgetState();
}

class _HeartButtonWidgetState extends State<HeartButtonWidget> {
  // A flag to track the loading state of the button
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Access the WishlistProvider using Provider
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.color,
      ),
      child: IconButton(
        style: IconButton.styleFrom(
          shape: const CircleBorder(),
        ),
        onPressed: () async {
          // Toggle the loading state
          setState(() {
            isLoading = true;
          });

          try {
            // Check if the product is already in the wishlist
            if (wishlistProvider.getWishlistItems
                .containsKey(widget.productId)) {
              // Remove the product from the wishlist
              wishlistProvider.removeWishlistItemFromFirebase(
                wishlistId:
                    wishlistProvider.getWishlistItems[widget.productId]!.id,
                productId: widget.productId,
              );
            } else {
              // Add the product to the wishlist
              wishlistProvider.addToWishlistFirebase(
                  productId: widget.productId, context: context);
            }

            // Fetch the updated wishlist
            await wishlistProvider.fetchWishlist();
          } catch (e) {
            // Show an error dialog if an exception occurs
            MyAppMethods.showErrorORWarningDialog(
              context: context,
              subtitle: e.toString(),
              fct: () {},
            );
          } finally {
            // Reset the loading state
            setState(() {
              isLoading = false;
            });
          }
        },
        // Display either a loading indicator or the heart icon based on the loading state
        icon: isLoading
            ? const CircularProgressIndicator()
            : Icon(
                // Display the heart icon in either filled (red) or outlined (grey) based on the product's presence in the wishlist
                wishlistProvider.isProductInWishlist(
                        productId: widget.productId)
                    ? IconlyBold.heart
                    : IconlyLight.heart,
                size: widget.size,
                color: wishlistProvider.isProductInWishlist(
                        productId: widget.productId)
                    ? Colors.red
                    : Colors.grey,
              ),
      ),
    );
  }
}
