
import 'package:online_bank/data/models/cart_model.dart';
import 'package:online_bank/data/services/cart_firebase_services.dart';

class CartsRepository {
  final FirbaseCartService _firebaseCartService;

  CartsRepository({required FirbaseCartService firebaseCartService})
      : _firebaseCartService = firebaseCartService;

  Stream<List<CartModel>> getCart() {
    return _firebaseCartService.getCart();
  }

  Future<void> addCart(CartModel cart) async {
    await _firebaseCartService.addCart(cart);
  }

}