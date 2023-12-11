import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:e_com_app/providers/product_provider.dart';
import 'package:e_com_app/providers/wishlist_provider.dart';
import 'package:e_com_app/screens/home_screen.dart';
import 'package:e_com_app/screens/profile_screen.dart';
import 'package:e_com_app/screens/search_screen.dart';

import 'providers/cart_provider.dart';
import 'providers/user_provider.dart';
import 'screens/cart/cart_screen.dart';

// RootScreen: The main screen of the application that includes a bottom navigation bar
class RootScreen extends StatefulWidget {
  // Static route name for the root screen
  static const routName = '/RootScreen';

  // Constructor to create the RootScreen widget
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late PageController controller;
  int currentScreen = 0;
  bool isLoadingProds = true;
  List<Widget> screens = [
    const HomeScreen(),
    const SearchScreen(),
    const CartScreen(),
    const ProfileScreen()
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the PageController with an initial page
    controller = PageController(
      initialPage: currentScreen,
    );
  }

  // Function to fetch products and user information asynchronously
  Future<void> fetchFCT() async {
    // Obtain instances of various providers
    final productsProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final wishlistProvider =
        Provider.of<WishlistProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      // Fetch products and user information concurrently
      await Future.wait({
        productsProvider.fetchProducts(),
        userProvider.fetchUserInfo(),
      });

      // Fetch cart and wishlist information concurrently
      await Future.wait({
        cartProvider.fetchCart(),
        wishlistProvider.fetchWishlist(),
      });
    } catch (error) {
      // Log any errors that occur during the fetching process
      log(error.toString());
    } finally {
      // Set the loading state to false after fetching is complete
      setState(() {
        isLoadingProds = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    // Fetch data only if it is still loading
    if (isLoadingProds) {
      fetchFCT();
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold widget with a PageView for the main content and a bottom navigation bar
    return Scaffold(
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentScreen,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 2,
        height: kBottomNavigationBarHeight,
        onDestinationSelected: (index) {
          // Set the current screen index and jump to the selected page
          setState(() {
            currentScreen = index;
          });
          controller.jumpToPage(currentScreen);
        },
        // Define navigation bar destinations with icons and labels
        destinations: [
          const NavigationDestination(
            selectedIcon: Icon(IconlyBold.home),
            icon: Icon(IconlyLight.home),
            label: "Home",
          ),
          const NavigationDestination(
            selectedIcon: Icon(IconlyBold.search),
            icon: Icon(IconlyLight.search),
            label: "Search",
          ),
          NavigationDestination(
            selectedIcon: const Icon(IconlyBold.bag2),
            icon: Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                // Display a badge with the cart item count
                return Badge(
                  backgroundColor: Colors.blue,
                  label: Text(cartProvider.getCartItems.length.toString()),
                  child: const Icon(IconlyLight.bag2),
                );
              },
            ),
            label: "Cart",
          ),
          const NavigationDestination(
            selectedIcon: Icon(IconlyBold.profile),
            icon: Icon(IconlyLight.profile),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
