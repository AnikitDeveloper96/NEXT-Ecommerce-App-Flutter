import 'product_model.dart';

class CartModelForCheckout {
  Product product;
  int productQuantity;

  CartModelForCheckout({required this.product, this.productQuantity = 1});
}
