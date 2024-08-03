import 'dart:convert';

class CartModel {
  final String id;
  final String cartName;
  final String cartNumber;
  final String axpiryDate;
  final String balance;

  CartModel({
    required this.id,
    required this.cartName,
    required this.cartNumber,
    required this.axpiryDate,
    required this.balance,
  });

  Map<String, dynamic> toMap() {
    final carts = <String, dynamic>{};

    carts.addAll({"cart-id": id});
    carts.addAll({"cart-name": cartName});
    carts.addAll({"cart-number": cartNumber});
    carts.addAll({"cart-axpiryDate": axpiryDate});
    carts.addAll({"cart-balance": balance});

    return carts;
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map["cart-id"],
      cartName: map["cart-name"],
      cartNumber: map["cart-number"],
      axpiryDate: map["cart-axpiryDate"],
      balance: map["cart-balance"],
    );
  }
  String toJson() => json.encode(toMap());

  factory CartModel.fromJson(String source) => CartModel.fromMap(json.decode(source));

  @override
  String toString() {
    return "CartModel(id: $id, cartName: $cartName, cartNumber: $cartNumber, axpiryDate: $axpiryDate, balance: $balance)";
  }
}
