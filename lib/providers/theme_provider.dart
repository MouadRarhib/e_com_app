// Importing necessary packages
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ThemeProvider class that extends ChangeNotifier
class ThemeProvider with ChangeNotifier {
  // Constant key for storing theme status in SharedPreferences
  static const THEME_STATUS = "THEME_STATUS";

  // Boolean variable to track the current theme status (default is false for light theme)
  bool _darkTheme = false;

  // Getter to retrieve the current theme status
  bool get getIsDarkTheme => _darkTheme;

  // Constructor for ThemeProvider
  ThemeProvider() {
    // Initialize the theme status by calling the getTheme method
    getTheme();
  }

  // Method to set the dark theme status and update SharedPreferences
  Future<void> setDarkTheme({required bool themeValue}) async {
    // Obtain an instance of SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Set the theme status in SharedPreferences
    prefs.setBool(THEME_STATUS, themeValue);

    // Update the local variable representing the theme status
    _darkTheme = themeValue;

    // Notify listeners that the theme status has changed
    notifyListeners();
  }

  // Method to get the theme status from SharedPreferences
  Future<bool> getTheme() async {
    // Obtain an instance of SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the theme status from SharedPreferences, default to false if not available
    _darkTheme = prefs.getBool(THEME_STATUS) ?? false;

    // Notify listeners that the theme status has been retrieved
    notifyListeners();

    // Return the current theme status
    return _darkTheme;
  }
}
