import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/bloc_event/cart_event.dart';
import '../../blocs/bloc_event/favourite_event.dart';
import '../../blocs/bloc_state/cart_state.dart';
import '../../blocs/bloc_state/fav_state.dart';
import '../../blocs/blocs/cart_bloc.dart';
import '../../blocs/blocs/fav_bloc.dart';
import '../../models/cartModel.dart';
import '../../models/product_model.dart';
import '../../widgets/rating_review.dart' show RatingReviewsSection;
import '../../routes.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _currentImageIndex = 0;

  String capitalizeFirstLetter(String text) =>
      text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final Product product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title ?? ""),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, NextEcommerceAppRoutes.cartPage),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHeight * 0.4,
                  child: CarouselSlider.builder(
                    itemCount: product.images?.length ?? 0,
                    itemBuilder: (context, index, realIndex) => CachedNetworkImage(
                      imageUrl: product.images?[index] ?? "",
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (_, __, ___) =>
                      const Icon(Icons.error, size: 50, color: Colors.red),
                    ),
                    options: CarouselOptions(
                      viewportFraction: 1.0,
                      autoPlay: (product.images?.length ?? 0) > 1,
                      enlargeCenterPage: false,
                      onPageChanged: (index, reason) {
                        if (mounted) setState(() => _currentImageIndex = index);
                      },
                    ),
                  ),
                ),
                if ((product.images?.length ?? 0) > 1)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: product.images!.asMap().entries.map((entry) {
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentImageIndex == entry.key
                                ? Colors.black
                                : Colors.grey[300],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product.title ?? "",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: Text(
                              capitalizeFirstLetter(product.category ?? ""),
                              style: const TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        product.description ?? "",
                        style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
                      ),
                      const SizedBox(height: 20),
                      RatingReviewsSection(
                        reviews: product.reviews ?? [],
                        maxWidth: screenWidth * 0.9,
                      ),
                      const SizedBox(height: 80), // spacing for bottom bar
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
              ),
              child: Row(
                children: [
                  BlocBuilder<FavoriteProductBloc, FavouriteProductState>(
                    builder: (context, favState) {
                      bool isFavorite = favState.favoriteItems.contains(product);
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: () {
                            context.read<FavoriteProductBloc>().add(
                              isFavorite
                                  ? RemoveFromFavorites(product)
                                  : AddToFavorites(product),
                            );
                          },
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.black : Colors.grey,
                            size: 24,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: BlocBuilder<CartBloc, CartState>(
                      builder: (context, cartState) {
                        final cartItems = cartState is CartUpdatedItemsState
                            ? cartState.cartItems
                            : <CartModelForCheckout>[];
                        final productInCart = cartItems.firstWhere(
                              (item) => item.product.id == product.id,
                          orElse: () => CartModelForCheckout(product: product, productQuantity: 0),
                        );
                        return _buildAddToCartButton(cartProductInCart: productInCart, isSticky: true);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton({
    required CartModelForCheckout cartProductInCart,
    bool isSticky = false,
  }) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        if (cartProductInCart.productQuantity > 0) {
          return ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.white, size: 22),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () =>
                      context.read<CartBloc>().add(UpdateCartItemsEvent(cartProductInCart.product, -1)),
                ),
                Text(
                  '${cartProductInCart.productQuantity}',
                  style: const TextStyle(fontSize: 22, color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white, size: 22),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () =>
                      context.read<CartBloc>().add(UpdateCartItemsEvent(cartProductInCart.product, 1)),
                ),
              ],
            ),
          );
        } else {
          return ElevatedButton(
            onPressed: () =>
                context.read<CartBloc>().add(AddtoCartItemsEvent(cartProductInCart.product)),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              "Add to Cart",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            ),
          );
        }
      },
    );
  }
}
