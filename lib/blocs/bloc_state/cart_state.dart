// Corrected CartState classes
import '../../models/cartModel.dart';

abstract class CartState {}

class CartInitialState extends CartState {} // Corrected typo

// class CartItemsExsistedInCart extends CartState { // Corrected typo
//   final Product cartItem;

//   CartItemsExsistedInCart(this.cartItem);
// }

class CartUpdatedItemsState extends CartState {
  // Better naming consistency
  final List<CartModelForCheckout> cartItems;

  CartUpdatedItemsState(this.cartItems);
}
