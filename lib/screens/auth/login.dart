// Importing necessary packages and custom widgets
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e_com_app/consts/my_validators.dart';
import 'package:e_com_app/screens/auth/forgot_password.dart';
import 'package:e_com_app/screens/auth/register.dart';
import 'package:e_com_app/screens/loading_manager.dart';
import 'package:e_com_app/widgets/app_name_text.dart';
import 'package:e_com_app/widgets/auth/google_btn.dart';
import 'package:e_com_app/widgets/subtitle_text.dart';
import 'package:e_com_app/widgets/title_text.dart';

import '../../root_screen.dart';
import '../../services/my_app_method.dart';

// LoginScreen class that extends StatefulWidget
class LoginScreen extends StatefulWidget {
  static const routName = '/LoginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// _LoginScreenState class that extends the state of LoginScreen
class _LoginScreenState extends State<LoginScreen> {
  // Initializing necessary controllers, focus nodes, keys, and variables
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool _isLoading = false;

  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // Function to handle the login process
  Future<void> _loginFct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      try {
        setState(() {
          _isLoading = true;
        });

        // Attempt to sign in with email and password
        await auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        Fluttertoast.showToast(
          msg: "Login Successful",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
        );

        // Navigate to the main screen after successful login
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, RootScreen.routName);
      } on FirebaseAuthException catch (error) {
        // Handle Firebase authentication exceptions
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
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: LoadingManager(
          isLoading: _isLoading,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Logo and App Name
                  const SizedBox(
                    height: 60.0,
                  ),
                  const AppNameTextWidget(
                    fontSize: 30,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: TitlesTextWidget(label: "Welcome back"),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),

                  // Login Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email TextFormField
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

                        // Password TextFormField
                        TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
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
                            _loginFct();
                          },
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),

                        // Forgot Password Link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, ForgotPasswordScreen.routeName);
                            },
                            child: const SubtitleTextWidget(
                              label: "Forgot password?",
                              textDecoration: TextDecoration.underline,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const Icon(Icons.login),
                            label: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            onPressed: () async {
                              _loginFct();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),

                        // Social Media Login Options
                        SubtitleTextWidget(
                          label: "OR connect using".toUpperCase(),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: kBottomNavigationBarHeight + 10,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // Google Button
                                const Expanded(
                                  flex: 2,
                                  child: SizedBox(
                                    height: kBottomNavigationBarHeight,
                                    child: FittedBox(
                                      child: GoogleButton(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),

                                // Guest (Anonymous) Login Button
                                Expanded(
                                  child: SizedBox(
                                    height: kBottomNavigationBarHeight,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        "Guest",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      onPressed: () async {
                                        Navigator.pushReplacementNamed(
                                            context, RootScreen.routName);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),

                        // Sign Up Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SubtitleTextWidget(
                              label: "Don't have an account?",
                            ),
                            TextButton(
                              child: const SubtitleTextWidget(
                                label: "Sign up",
                                textDecoration: TextDecoration.underline,
                                fontStyle: FontStyle.italic,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, RegisterScreen.routName);
                              },
                            ),
                          ],
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
