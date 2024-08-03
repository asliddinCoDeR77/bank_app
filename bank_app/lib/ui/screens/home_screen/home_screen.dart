import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_bank/data/services/auth_firebase_services.dart';
import 'package:online_bank/logic/blocs/cart_bloc.dart';
import 'package:online_bank/ui/widgets/add_cart_widget.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final authFirebaseServices = FirebaseAuthServices();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBEB8B8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF080808),
        centerTitle: true,
        title: const Text(
          "Carts Screen",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              authFirebaseServices.logoutUser();
              setState(() {});
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        bloc: context.read<CartBloc>()..add(GetCartEvent()),
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ErrorState) {
            return const Center(
              child: Text(
                "Error Loading Cards!",
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          }
          if (state is LoadedState) {
            final cart = state.carts;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  cart.isEmpty
                      ? const Center(
                          child: Text(
                            "No Cards Available...",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 250,
                          child: PageView.builder(
                            itemCount: cart.length,
                            itemBuilder: (context, index) {
                              final carts = cart[index];
                              return AnimatedBuilder(
                                animation: _controller,
                                builder: (context, child) {
                                  return FadeTransition(
                                    opacity: _fadeAnimation,
                                    child: ScaleTransition(
                                      scale: _scaleAnimation,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            image: const DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/back.jpg"),
                                              fit: BoxFit.cover,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 10,
                                                offset: Offset(0, 5),
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.all(20),
                                          height: 250,
                                          width: 330,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "QWERTY BANK",
                                                style: TextStyle(
                                                  fontSize: 23,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                carts.cartName,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    height: 65,
                                                    child: Image.asset(
                                                      "assets/images/card.png",
                                                      height: 40,
                                                      width: 55,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        carts.balance,
                                                        style: const TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      const Text(
                                                        "USD",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Transform.rotate(
                                                    angle: 33,
                                                    child: const Icon(
                                                      Icons.wifi,
                                                      size: 33,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                carts.cartNumber,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                carts.axpiryDate,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ZoomTapAnimation(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => const CardInfoDialog(),
          );
        },
        child: Container(
          width: 300,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 78, 87, 156),
                Color.fromARGB(255, 48, 79, 254)
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
              "Add Cart",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
