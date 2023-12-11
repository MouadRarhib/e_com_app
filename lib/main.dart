import 'package:e_com_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_com_app/providers/product_provider.dart';
import 'package:e_com_app/providers/theme_provider.dart';
import 'package:e_com_app/screens/inner_screens/viewed_recently.dart';

import 'consts/theme_data.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/user_provider.dart';
import 'providers/viewed_prod_provider.dart';
import 'providers/wishlist_provider.dart';
import 'root_screen.dart';
import 'screens/auth/forgot_password.dart';
import 'screens/auth/login.dart';
import 'screens/auth/register.dart';
import 'screens/inner_screens/orders/orders_screen.dart';
import 'screens/inner_screens/product_details.dart';
import 'screens/inner_screens/wishlist.dart';
import 'screens/search_screen.dart';

void main() {
  runApp(const MyApp());
}

// MyApp: Main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Build method for the root of the application
  @override
  Widget build(BuildContext context) {
    // Initialize Firebase and check for its initialization status
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          // If Firebase is still initializing, show a loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          // If there's an error during Firebase initialization, display an error message
          else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: SelectableText(
                    "An error has been occurred ${snapshot.error}"),
              ),
            );
          }
          // If Firebase initialization is successful, proceed with the MultiProvider setup
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => ThemeProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => ProductProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => CartProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => WishlistProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => ViewedProdProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => UserProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => OrdersProvider(),
              ),
            ],
            // Consumer to manage theme changes and MaterialApp with routing and theme settings
            child: Consumer<ThemeProvider>(
              builder: (
                context,
                themeProvider,
                child,
              ) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Shop Smart AR',
                  theme: Styles.themeData(
                      isDarkTheme: themeProvider.getIsDarkTheme,
                      context: context),
                  home: const RootScreen(),
                  routes: {
                    ProductDetails.routName: (context) =>
                        const ProductDetails(),
                    WishlistScreen.routName: (context) =>
                        const WishlistScreen(),
                    ViewedRecentlyScreen.routName: (context) =>
                        const ViewedRecentlyScreen(),
                    RegisterScreen.routName: (context) =>
                        const RegisterScreen(),
                    LoginScreen.routName: (context) => const LoginScreen(),
                    OrdersScreenFree.routeName: (context) =>
                        const OrdersScreenFree(),
                    ForgotPasswordScreen.routeName: (context) =>
                        const ForgotPasswordScreen(),
                    SearchScreen.routeName: (context) => const SearchScreen(),
                    RootScreen.routName: (context) => const RootScreen(),
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
