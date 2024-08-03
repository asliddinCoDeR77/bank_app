import 'package:flutter/material.dart';
import 'package:online_bank/data/services/auth_firebase_services.dart';
import 'package:online_bank/data/services/user_firebase_services.dart';
import 'package:online_bank/ui/screens/login_register_screens/login_screen.dart';
import 'package:online_bank/ui/screens/login_register_screens/user_info_add.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController confirmPasswordText = TextEditingController();
  final TextEditingController emailText = TextEditingController();
  final TextEditingController passwordText = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authHttpServices = FirebaseAuthServices();
  final userFirebaseServices = UserFirebaseServices();

  bool isLoading = false;
  String? errorMessage;

  void submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      if (confirmPasswordText.text == passwordText.text) {
        await _authHttpServices.registerUser(
          email: emailText.text,
          password: passwordText.text,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const UserInfoScreen(),
          ),
        );
      } else {
        throw Exception('Passwords do not match');
      }
    } catch (e) {
      if (e.toString().contains('EMAIL_ALREADY_IN_USE')) {
        errorMessage =
            'The email address is already in use by another account.';
      } else if (e.toString().contains('WEAK_PASSWORD')) {
        errorMessage =
            'The password is too weak. Please enter a stronger password.';
      } else if (e.toString().contains('INVALID_EMAIL')) {
        errorMessage =
            'The email address is not valid. Please enter a valid email address.';
      } else {
        errorMessage =
            'An error occurred during registration. Please try again.';
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    confirmPasswordText.dispose();
    emailText.dispose();
    passwordText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2196F3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return const LoginScreen();
              },
            ));
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Sign up",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: emailText,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        filled: true,
                        fillColor: Colors.white24,
                        labelText: "name@gmail.com",
                        labelStyle: const TextStyle(color: Colors.white54),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email.";
                        }
                        if (!value.contains("@")) {
                          return "Please include '@' in the email.";
                        }
                        return null;
                      },
                    ),
                    if (errorMessage != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                    const SizedBox(height: 30),
                    const Text(
                      "Password",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: passwordText,
                      obscureText: true,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        filled: true,
                        fillColor: Colors.white24,
                        labelText: "Enter Password",
                        labelStyle: const TextStyle(color: Colors.white54),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password.";
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Confirm Password",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: confirmPasswordText,
                      obscureText: true,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        filled: true,
                        fillColor: Colors.white24,
                        labelText: "Confirm Password",
                        labelStyle: const TextStyle(color: Colors.white54),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please confirm your password.";
                        }
                        if (value != passwordText.text) {
                          return "Passwords do not match.";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              isLoading
                  ? const CircularProgressIndicator()
                  : ZoomTapAnimation(
                      onTap: submit,
                      child: Container(
                        width: 328,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF42A5F5), Color(0xFF0D47A1)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const LoginScreen();
                          },
                        ),
                      );
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        color: Color(0xFFBBDEFB),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
