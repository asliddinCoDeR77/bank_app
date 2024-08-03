import 'package:bloc/bloc.dart';
import 'package:online_bank/data/models/cart_model.dart';
import 'package:online_bank/data/repository/cart_repository.dart';
part 'cart_events.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvents, CartState> {
  final CartsRepository _cartsRepository;
  CartBloc({required CartsRepository cartsRepository})
      : _cartsRepository = cartsRepository,
        super(InitialState()) {
    on<AddCartEvent>(_addCartEvent);
    on<GetCartEvent>(_getCartEvent);
    on<TransactionCartEvent>(_oplataCartEvent);
  }

  void _getCartEvent(GetCartEvent event, Emitter emit) {
    emit(LoadingState());
    try {
      emit.forEach(
        _cartsRepository.getCart(),
        onData: (List<CartModel> carts) {
          return LoadedState(carts: carts);
        },
      );
    } catch (e) {
      print("Error get Carts Event");
      emit(ErrorState(e.toString()));
    }
  }

  void _addCartEvent(AddCartEvent event, Emitter emit) {
    emit(LoadingState());
    try {
      _cartsRepository.addCart(event.carts);
      emit(InitialState());
    } catch (e) {
      print("Error addCart Event");
      emit(ErrorState(e.toString()));
    }
  }

  void _oplataCartEvent(TransactionCartEvent event, Emitter emit) {}
}
