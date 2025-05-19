// fav_state.dart
import 'package:nextecommerceapp/models/product_model.dart';

abstract class FavouriteProductState {
  List<Product> get favoriteItems;
}

class FavoriteInitial extends FavouriteProductState {
  @override
  List<Product> get favoriteItems => [];
}

class FavoriteUpdated extends FavouriteProductState {
  @override
  final List<Product> favoriteItems;

  FavoriteUpdated(this.favoriteItems);
}

class FavoriteError extends FavouriteProductState {
  final String error;
  FavoriteError(this.error);

  @override
  List<Product> get favoriteItems => [];
}

class FavoriteLoading extends FavouriteProductState {
  @override
  List<Product> get favoriteItems => [];
}
