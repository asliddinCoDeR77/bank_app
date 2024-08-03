part of "cart_bloc.dart";

sealed class CartEvents {}

final class AddCartEvent extends CartEvents {
  final CartModel carts;
  AddCartEvent({required this.carts});
}

final class GetCartEvent extends CartEvents {}

final class TransactionCartEvent extends CartEvents {}
