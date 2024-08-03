import 'package:flutter/material.dart';
import 'package:online_bank/data/services/user_firebase_services.dart';
import 'package:online_bank/ui/screens/home_screen/home_screen.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final userFirebaseServices = UserFirebaseServices();
  // File? _imageFile;

  bool isLoading = false;

  void submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });

      try {
        if (nameController.text.isNotEmpty) {
          await userFirebaseServices.addUser(nameController.text);
          setState(() {
            isLoading = false;
          });

          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return const HomeScreen();
            },
          ));
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        // Handle the error appropriately, e.g., show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2196F3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Fill Your Profile",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 40),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: nameController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                      filled: true,
                      fillColor: Colors.white24,
                      labelText: "Your full name",
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
                        return "Please enter your name";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isLoading
                        ? const CircularProgressIndicator()
                        : ZoomTapAnimation(
                            onTap: submit,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.90,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF42A5F5),
                                    Color(0xFF0D47A1)
                                  ],
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
                                  "Save",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
