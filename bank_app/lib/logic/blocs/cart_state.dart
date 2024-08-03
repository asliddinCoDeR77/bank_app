part of "cart_bloc.dart";

sealed class CartState {}

final class InitialState extends CartState {}

final class LoadingState extends CartState {}

final class LoadedState extends CartState {
  final List<CartModel> carts;
  LoadedState({required this.carts});
}

final class ErrorState extends CartState {
  final String message;
  ErrorState(this.message);
}
