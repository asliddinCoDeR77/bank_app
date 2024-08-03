import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_bank/data/repository/cart_repository.dart';
import 'package:online_bank/data/services/cart_firebase_services.dart';
import 'package:online_bank/firebase_options.dart';
import 'package:online_bank/logic/blocs/cart_bloc.dart';
import 'package:online_bank/ui/screens/home_screen/home_screen.dart';
import 'package:online_bank/ui/screens/login_register_screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final cartsRepository =
      CartsRepository(firebaseCartService: FirbaseCartService());
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            return CartBloc(cartsRepository: cartsRepository);
          },
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
