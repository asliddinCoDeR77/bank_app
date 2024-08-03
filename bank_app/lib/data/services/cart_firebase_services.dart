import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_bank/data/models/cart_model.dart';

class FirbaseCartService {
  final _cartCollection = FirebaseFirestore.instance.collection("carts");

  Stream<List<CartModel>> getCart() {
    //birinchi return'da collection ichiga kiryabmiz (table)
    return _cartCollection.snapshots().map((querySnapshot) {
      //ikkinchi return da collection ichidagi hujjatlarga kiryabmiz(rows)
      return querySnapshot.docs.map((doc) {
        //uchinchi return da bitta hujjatni (row)
        //Book obyektiga aylantiryapmiz
        return CartModel.fromMap(doc.data());
      }).toList();
    });
  }

  Future<void> addCart(CartModel cart) async {
    try {
      await _cartCollection.add(cart.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // Future<void> oplataCart(double summa) async {
  //   try {
  //     await _cartCollection.
  //   } catch (e) {
      
  //   }
  // }

}