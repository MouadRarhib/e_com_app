import 'package:flutter/material.dart';

/// Utility class for various form field validators
class MyValidators {
  /// Validates display names
  static String? displayNamevalidator(String? displayName) {
    // Check if the display name is null or empty
    if (displayName == null || displayName.isEmpty) {
      return 'Display name cannot be empty';
    }
    // Check if the display name length is within the allowed range
    if (displayName.length < 3 || displayName.length > 20) {
      return 'Display name must be between 3 and 20 characters';
    }

    return null; // Return null if the display name is valid
  }

  /// Validates email addresses
  static String? emailValidator(String? value) {
    // Check if the email value is empty
    if (value!.isEmpty) {
      return 'Please enter an email';
    }
    // Check if the email follows the standard email format
    if (!RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
        .hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Validates passwords
  static String? passwordValidator(String? value) {
    // Check if the password value is empty
    if (value!.isEmpty) {
      return 'Please enter a password';
    }
    // Check if the password length is at least 6 characters
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  /// Validates repeated passwords
  static String? repeatPasswordValidator({String? value, String? password}) {
    // Check if the repeated password matches the original password
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}
