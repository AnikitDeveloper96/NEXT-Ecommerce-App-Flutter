import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextecommerceapp/blocs/bloc_state/cart_state.dart';

import '../../models/cartModel.dart';
import '../bloc_event/cart_event.dart';

class CartBloc extends Bloc<NextEcommerceCartsEvent, CartState> {
  List<CartModelForCheckout> cartItems = []; // Use List<CartModel>

  CartBloc() : super(CartInitialState()) {
    // ... (CartInitialEvent handler if needed)
    on<AddtoCartItemsEvent>((event, emit) {
      final existingProductIndex = cartItems.indexWhere(
        (item) => item.product.id == event.cartItem.id,
      );

      if (existingProductIndex == -1) {
        cartItems.add(
          CartModelForCheckout(product: event.cartItem, productQuantity: 1),
        );
      } else {
        cartItems[existingProductIndex].productQuantity++;
      }

      emit(CartUpdatedItemsState(List.from(cartItems)));
    });

    on<RemoveFromCartItemsEvent>((event, emit) {
      cartItems.removeWhere((item) => item.product.id == event.cartItem.id);
      emit(CartUpdatedItemsState(List.from(cartItems)));
    });

    on<UpdateCartItemsEvent>((event, emit) {
      final existingProductIndex = cartItems.indexWhere(
        (item) => item.product.id == event.product.id,
      );

      if (existingProductIndex != -1) {
        cartItems[existingProductIndex].productQuantity += event.quantity;
        if (cartItems[existingProductIndex].productQuantity <= 0) {
          cartItems.removeAt(existingProductIndex);
        }
      }

      emit(CartUpdatedItemsState(List.from(cartItems)));
    });

    on<ClearCartItemsEvent>((event, emit) {
      cartItems.clear();
      emit(CartUpdatedItemsState(List.from(cartItems)));
    });
  }
}
