import 'package:flutter/material.dart';
import 'package:online_bank/data/services/auth_firebase_services.dart';
import 'package:online_bank/ui/screens/login_register_screens/register_screen.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailText = TextEditingController();
  final TextEditingController passwordText = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authHttpServices = FirebaseAuthServices();
  bool isLoading = false;
  String? password, email;

  void submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    setState(() {
      isLoading = true;
    });

    try {
      await _authHttpServices.loginUser(
        email: emailText.text,
        password: passwordText.text,
      );
    } catch (e) {
      String message = e.toString();
      if (e.toString().contains("INVALID_LOGIN_CREDENTIALS")) {
        message = "This email is not registered yet.";
      }
      if (e.toString().contains("Null check operator used on a null value")) {
        message = "Please enter both Email and Password.";
      }

      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailText.dispose();
    passwordText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2196F3),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 100),
              const Center(
                child: Text(
                  "Log in",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),
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
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      keyboardType: TextInputType.emailAddress,
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
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your email.";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        email = newValue;
                      },
                    ),
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
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your password.";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        password = newValue;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
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
                            "Log in",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 25),
              ZoomTapAnimation(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const SignupScreen();
                      },
                    ),
                  );
                },
                child: const Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFBBDEFB),
                    fontWeight: FontWeight.bold,
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
