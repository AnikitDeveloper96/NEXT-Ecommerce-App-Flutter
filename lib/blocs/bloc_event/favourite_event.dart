// favourite_event.dart
import 'package:nextecommerceapp/models/product_model.dart';

abstract class FavouriteProductEvent {}

class LoadFavorites extends FavouriteProductEvent {}

class AddToFavorites extends FavouriteProductEvent {
  final Product product;
  AddToFavorites(this.product);
}

class RemoveFromFavorites extends FavouriteProductEvent {
  final Product product;
  RemoveFromFavorites(this.product);
}
