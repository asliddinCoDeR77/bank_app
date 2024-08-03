import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('USER_NOT_FOUND');
      } else if (e.code == 'wrong-password') {
        throw Exception('WRONG_PASSWORD');
      } else {
        throw Exception('LOGIN_ERROR');
      }
    } catch (e) {
      print("Error in loginUser: $e");
      throw Exception('UNEXPECTED_ERROR');
    }
  }

  Future<void> registerUser({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('EMAIL_ALREADY_IN_USE');
      } else if (e.code == 'weak-password') {
        throw Exception('WEAK_PASSWORD');
      } else if (e.code == 'invalid-email') {
        throw Exception('INVALID_EMAIL');
      } else {
        throw Exception('REGISTER_ERROR');
      }
    } catch (e) {
      print("Error in registerUser: $e");
      throw Exception('UNEXPECTED_ERROR');
    }
  }

  Future<void> logoutUser() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      print("Error in logoutUser: $e");
      throw Exception('LOGOUT_ERROR');
    } catch (e) {
      print("Error in logoutUser: $e");
      throw Exception('UNEXPECTED_ERROR');
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw Exception('INVALID_EMAIL');
      } else if (e.code == 'user-not-found') {
        throw Exception('USER_NOT_FOUND');
      } else {
        throw Exception('RESET_PASSWORD_ERROR');
      }
    } catch (e) {
      print("Error in resetPassword: $e");
      throw Exception('UNEXPECTED_ERROR');
    }
  }
}