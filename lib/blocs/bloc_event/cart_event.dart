// CartEvent classes (no changes needed here, but included for completeness)
import '../../models/product_model.dart' show Product;

abstract class NextEcommerceCartsEvent {}

class CartInitialEvent extends NextEcommerceCartsEvent {}

class AddtoCartItemsEvent extends NextEcommerceCartsEvent {
  final Product cartItem;
  AddtoCartItemsEvent(this.cartItem);
}

class RemoveFromCartItemsEvent extends NextEcommerceCartsEvent {
  final Product cartItem;
  RemoveFromCartItemsEvent(this.cartItem);
}

class ClearCartItemsEvent
    extends NextEcommerceCartsEvent {} // No need to pass cartItems here

/// Addd CART ITEMS
class UpdateCartItemsEvent extends NextEcommerceCartsEvent {
  Product product;
  int quantity;
  UpdateCartItemsEvent(this.product, this.quantity);
}

class ItemProductAlreadyInCart extends NextEcommerceCartsEvent {
  final Product cartItem;
  ItemProductAlreadyInCart(this.cartItem);
}
