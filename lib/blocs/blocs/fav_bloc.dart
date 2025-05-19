import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextecommerceapp/blocs/bloc_event/favourite_event.dart';
import 'package:nextecommerceapp/blocs/bloc_state/fav_state.dart';
import 'package:nextecommerceapp/models/product_model.dart';
import 'package:nextecommerceapp/screens/db_firestore/ecommerce_db_firestore.dart';

class FavoriteProductBloc extends Bloc<FavouriteProductEvent, FavouriteProductState> {
  final NextEcommerceDatabase _database = NextEcommerceDatabase();

  FavoriteProductBloc() : super(FavoriteInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
    // Only load favorites if a user is logged in
    _loadInitialFavorite();
  }

  Future<void> _onLoadFavorites(
      LoadFavorites event,
      Emitter<FavouriteProductState> emit,
      ) async {
    try {
      emit(FavoriteLoading());
      final favoriteProducts = await _database.getFavoriteProducts();
      emit(FavoriteUpdated(favoriteProducts));
    } catch (e) {
      emit(FavoriteError('Failed to load favorites: $e'));
    }
  }

  Future<void> _onAddToFavorites(
      AddToFavorites event,
      Emitter<FavouriteProductState> emit,
      ) async {
    try {
      await _database.addToFavorites(event.product);
      final updatedFavorites = List<Product>.from(state.favoriteItems)..add(event.product);
      emit(FavoriteUpdated(updatedFavorites));
    } catch (e) {
      emit(FavoriteError('Failed to add to favorites: $e'));
    }
  }

  Future<void> _onRemoveFromFavorites(
      RemoveFromFavorites event,
      Emitter<FavouriteProductState> emit,
      ) async {
    try {
      await _database.removeFromFavorites(event.product);
      final updatedFavorites = List<Product>.from(state.favoriteItems)..remove(event.product);
      emit(FavoriteUpdated(updatedFavorites));
    } catch (e) {
      emit(FavoriteError('Failed to remove from favorites: $e'));
    }
  }

  Future<void> _loadInitialFavorite() async {
    // Skip loading if no user is logged in to avoid unnecessary Firebase calls
    if (await _database.getCurrentUser() == null) {
      emit(FavoriteUpdated([]));
      return;
    }
    try {
      emit(FavoriteLoading());
      final favoriteProducts = await _database.getFavoriteProducts();
      emit(FavoriteUpdated(favoriteProducts));
    } catch (e) {
      emit(FavoriteError('Failed to load favorites: $e'));
    }
  }
}