import 'dart:io';

// Firebase packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Flutter packages
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

// Custom widgets and services
import 'package:e_com_app/consts/my_validators.dart';
import 'package:e_com_app/screens/loading_manager.dart';
import 'package:e_com_app/services/my_app_method.dart';
import 'package:e_com_app/widgets/app_name_text.dart';
import 'package:e_com_app/widgets/subtitle_text.dart';
import 'package:e_com_app/widgets/title_text.dart';

// Other screens and widgets
import '../../root_screen.dart';
import '../../widgets/auth/pick_image_widget.dart';

class RegisterScreen extends StatefulWidget {
  static const routName = '/RegisterScreen';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers for text fields
  late final TextEditingController _nameController,
      _emailController,
      _passwordController,
      _confirmPasswordController;

  // Focus nodes for text fields
  late final FocusNode _nameFocusNode,
      _emailFocusNode,
      _passwordFocusNode,
      _confirmPasswordFocusNode;

  // Form key to manage form state
  late final _formKey = GlobalKey<FormState>();

  // Variable to toggle password visibility
  bool obscureText = true;

  // Loading state variable
  bool _isLoading = false;

  // User-selected image file
  XFile? _pickedImage;

  // Firebase authentication instance
  final auth = FirebaseAuth.instance;

  // Variable to store user image URL after upload
  String? userImageUrl;

  @override
  void initState() {
    // Initialize controllers for text fields
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    // Initialize focus nodes for text fields
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    // Dispose of controllers and focus nodes to free resources
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

    super.dispose();
  }

  // Function to handle the registration process
  Future<void> _registerFct() async {
    // Validate the form
    final isValid = _formKey.currentState!.validate();

    // Close the keyboard
    FocusScope.of(context).unfocus();

    // Check if an image is selected
    if (_pickedImage == null) {
      MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: "Make sure to pick up an image",
        fct: () {},
      );
      return;
    }

    // Proceed with registration if the form is valid
    if (isValid) {
      // Save the form data
      _formKey.currentState!.save();

      try {
        // Set loading state
        setState(() {
          _isLoading = true;
        });

        // Create a reference to Firebase Storage for user image
        final ref = FirebaseStorage.instance
            .ref()
            .child("usersImages")
            .child('${_emailController.text.trim()}.jpg');

        // Upload the user image to Firebase Storage
        await ref.putFile(File(_pickedImage!.path));

        // Get the download URL of the uploaded image
        userImageUrl = await ref.getDownloadURL();

        // Create a new user with email and password
        await auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Get the current user
        User? user = auth.currentUser;

        // Get the UID of the user
        final uid = user!.uid;

        // Add user data to Firestore
        await FirebaseFirestore.instance.collection("users").doc(uid).set({
          'userId': uid,
          'userName': _nameController.text,
          'userImage': userImageUrl,
          'userEmail': _emailController.text.toLowerCase(),
          'createdAt': Timestamp.now(),
          'userWish': [],
          'userCart': [],
        });

        // Show a success message
        Fluttertoast.showToast(
          msg: "An account has been created",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
        );

        // Navigate to the root screen
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, RootScreen.routName);
      } on FirebaseAuthException catch (error) {
        // Handle FirebaseAuth exceptions
        await MyAppMethods.showErrorORWarningDialog(
          context: context,
          subtitle: "An error has been occurred ${error.message}",
          fct: () {},
        );
      } catch (error) {
        // Handle other errors
        await MyAppMethods.showErrorORWarningDialog(
          context: context,
          subtitle: "An error has been occurred $error",
          fct: () {},
        );
      } finally {
        // Reset loading state
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Function to pick an image from the camera or gallery
  Future<void> localImagePicker() async {
    final ImagePicker picker = ImagePicker();

    // Show a dialog to choose camera, gallery, or remove
    await MyAppMethods.imagePickerDialog(
      context: context,
      cameraFCT: () async {
        // Pick an image from the camera
        _pickedImage = await picker.pickImage(source: ImageSource.camera);
        setState(() {});
      },
      galleryFCT: () async {
        // Pick an image from the gallery
        _pickedImage = await picker.pickImage(source: ImageSource.gallery);
        setState(() {});
      },
      removeFCT: () {
        // Remove the selected image
        setState(() {
          _pickedImage = null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    Size size = MediaQuery.of(context).size;

    // Gesture detector to close keyboard on tap
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      // Scaffold for the registration screen
      child: Scaffold(
        body: LoadingManager(
          isLoading: _isLoading,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 60.0,
                  ),
                  // App name text widget
                  const AppNameTextWidget(
                    fontSize: 30,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  // Welcome message text widgets
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitlesTextWidget(label: "Welcome"),
                        SubtitleTextWidget(label: "Your welcome message")
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  // Image picker widget
                  SizedBox(
                    height: size.width * 0.3,
                    width: size.width * 0.3,
                    child: PickImageWidget(
                      pickedImage: _pickedImage,
                      function: () async {
                        // Pick an image
                        await localImagePicker();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  // Registration form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Text form field for full name
                        TextFormField(
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            hintText: "Full name",
                            prefixIcon: Icon(
                              IconlyLight.message,
                            ),
                          ),
                          validator: (value) {
                            return MyValidators.displayNamevalidator(value);
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_emailFocusNode);
                          },
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        // Text form field for email
                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: "Email address",
                            prefixIcon: Icon(
                              IconlyLight.message,
                            ),
                          ),
                          validator: (value) {
                            return MyValidators.emailValidator(value);
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_passwordFocusNode);
                          },
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        // Text form field for password
                        TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            hintText: "*********",
                            prefixIcon: const Icon(
                              IconlyLight.lock,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                // Toggle password visibility
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: Icon(
                                obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          validator: (value) {
                            return MyValidators.passwordValidator(value);
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_confirmPasswordFocusNode);
                          },
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        // Text form field for confirming password
                        TextFormField(
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocusNode,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            hintText: "*********",
                            prefixIcon: const Icon(
                              IconlyLight.lock,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                // Toggle password visibility
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: Icon(
                                obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          validator: (value) {
                            return MyValidators.repeatPasswordValidator(
                                value: value,
                                password: _passwordController.text);
                          },
                          onFieldSubmitted: (value) {
                            // Register the user
                            _registerFct();
                          },
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        // Elevated button for user registration
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                            ),
                            icon: const Icon(IconlyLight.addUser),
                            label: const Text(
                              "Sign up",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            onPressed: () async {
                              // Register the user
                              _registerFct();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
