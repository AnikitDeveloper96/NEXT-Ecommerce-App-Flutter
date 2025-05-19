// favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextecommerceapp/blocs/bloc_event/favourite_event.dart';
import 'package:nextecommerceapp/blocs/bloc_state/fav_state.dart';
import 'package:nextecommerceapp/blocs/blocs/fav_bloc.dart';
import 'package:nextecommerceapp/widgets/product_grid.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteProductBloc()..add(LoadFavorites()),
      child: Scaffold(
        body: BlocBuilder<FavoriteProductBloc, FavouriteProductState>(
          builder: (context, state) {
            if (state is FavoriteError) {
              return Center(child: Text(state.error));
            }

            if (state is FavoriteLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final favoriteProducts = state.favoriteItems;
            if (favoriteProducts.isEmpty) {
              return const Center(child: Text('No favorites yet!'));
            }

            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: SingleChildScrollView(
                child: ProductGrid(
                  products: favoriteProducts,
                  screenWidth: MediaQuery.of(context).size.width,
                  screenHeight: MediaQuery.of(context).size.height,
                  isFavoritesScreen: true,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
