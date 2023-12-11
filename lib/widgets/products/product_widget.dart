import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_com_app/screens/inner_screens/product_details.dart';
import 'package:e_com_app/services/my_app_method.dart';
import 'package:e_com_app/widgets/subtitle_text.dart';
import 'package:e_com_app/widgets/title_text.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/viewed_prod_provider.dart';
import 'heart_btn.dart';

// ProductWidget: Widget for displaying individual products
class ProductWidget extends StatefulWidget {
  const ProductWidget({
    super.key,
    required this.productId,
  });

  // The unique identifier of the product
  final String productId;

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    // Access various providers
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrProduct = productProvider.findByProdId(widget.productId);
    final cartProvider = Provider.of<CartProvider>(context);
    final viewedProvider = Provider.of<ViewedProdProvider>(context);
    Size size = MediaQuery.of(context).size;

    // Return an empty SizedBox if the product is not found
    if (getCurrProduct == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: GestureDetector(
        onTap: () async {
          // Add the product to the viewed products history
          viewedProvider.addProductToHistory(
              productId: getCurrProduct.productId);

          // Navigate to the product details screen
          await Navigator.pushNamed(
            context,
            ProductDetails.routName,
            arguments: getCurrProduct.productId,
          );
        },
        child: Column(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: FancyShimmerImage(
                imageUrl: getCurrProduct.productImage,
                width: double.infinity,
                height: size.height * 0.22,
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            // Product Title and Heart Button
            Row(
              children: [
                Flexible(
                  flex: 5,
                  child: TitlesTextWidget(
                    label: getCurrProduct.productTitle,
                    maxLines: 2,
                    fontSize: 18,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: HeartButtonWidget(productId: getCurrProduct.productId),
                ),
              ],
            ),
            const SizedBox(
              height: 15.0,
            ),
            // Product Price and Add to Cart Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Product Price
                  Flexible(
                    flex: 3,
                    child: SubtitleTextWidget(
                      label: "${getCurrProduct.productPrice}\$",
                    ),
                  ),
                  // Add to Cart Button
                  Flexible(
                    child: Material(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.lightBlue,
                      child: InkWell(
                        splashColor: Colors.red,
                        borderRadius: BorderRadius.circular(16.0),
                        onTap: () async {
                          if (cartProvider.isProductInCart(
                              productId: getCurrProduct.productId)) {
                            return;
                          }
                          try {
                            // Add product to the cart
                            await cartProvider.addToCartFirebase(
                                productId: getCurrProduct.productId,
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            cartProvider.isProductInCart(
                                    productId: getCurrProduct.productId)
                                ? Icons.check
                                : Icons.add_shopping_cart_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
