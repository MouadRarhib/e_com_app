import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_com_app/models/viewed_prod_model.dart';
import 'package:e_com_app/providers/viewed_prod_provider.dart';
import 'package:e_com_app/widgets/subtitle_text.dart';

import '../../consts/app_constants.dart';
import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';
import '../../screens/inner_screens/product_details.dart';
import '../../services/my_app_method.dart';
import 'heart_btn.dart';

// LatestArrivalProductsWidget: Widget to display latest arrival products
class LatestArrivalProductsWidget extends StatelessWidget {
  const LatestArrivalProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the device screen size
    Size size = MediaQuery.of(context).size;

    // Access various providers
    final productsModel = Provider.of<ProductModel>(context);
    final viewedProvider = Provider.of<ViewedProdProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          // Add the product to the viewed products history
          viewedProvider.addProductToHistory(
              productId: productsModel.productId);

          // Navigate to the product details screen
          await Navigator.pushNamed(
            context,
            ProductDetails.routName,
            arguments: productsModel.productId,
          );
        },
        child: SizedBox(
          width: size.width * 0.45,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FancyShimmerImage(
                    imageUrl: productsModel.productImage,
                    width: size.width * 0.28,
                    height: size.width * 0.28,
                  ),
                ),
              ),
              const SizedBox(
                width: 7,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Title
                    Text(
                      productsModel.productTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Buttons for Heart and Add to Cart
                    FittedBox(
                      child: Row(
                        children: [
                          // Heart Button for Wishlist
                          HeartButtonWidget(productId: productsModel.productId),
                          // Add to Cart Button
                          IconButton(
                            onPressed: () async {
                              if (cartProvider.isProductInCart(
                                  productId: productsModel.productId)) {
                                return;
                              }
                              try {
                                // Add product to the cart
                                await cartProvider.addToCartFirebase(
                                    productId: productsModel.productId,
                                    qty: 1,
                                    context: context);
                              } catch (error) {
                                // Show an error dialog if an exception occurs
                                MyAppMethods.showErrorORWarningDialog(
                                    context: context,
                                    subtitle: error.toString(),
                                    fct: () {});
                              }
                            },
                            icon: Icon(
                              cartProvider.isProductInCart(
                                      productId: productsModel.productId)
                                  ? Icons.check
                                  : Icons.add_shopping_cart_rounded,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Product Price
                    FittedBox(
                      child: SubtitleTextWidget(
                        label: "${productsModel.productPrice}\$",
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
