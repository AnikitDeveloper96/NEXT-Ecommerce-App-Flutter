import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../blocs/bloc_event/favourite_event.dart';
import '../blocs/bloc_state/fav_state.dart';
import '../blocs/blocs/fav_bloc.dart';
import '../constant/colors.dart';
import '../constant/textstyle.dart';
import '../models/product_model.dart';
import '../routes.dart';

class ProductGrid extends StatefulWidget {
  final List<Product> products;
  final double screenWidth;
  final double screenHeight;
  final bool isFavoritesScreen;
  final bool isSearchScreen;
  final bool isHomeScreen;

  const ProductGrid({
    super.key,
    required this.products,
    required this.screenWidth,
    required this.screenHeight,
    this.isFavoritesScreen = false,
    this.isSearchScreen = false,
    this.isHomeScreen = false,
  });

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.screenWidth > 600 ? 3 : 2,
        mainAxisSpacing: widget.screenHeight * 0.02,
        crossAxisSpacing: widget.screenWidth * 0.02,
        childAspectRatio:
        widget.isSearchScreen || widget.isFavoritesScreen ? 0.75 : 0.6,
      ),
      itemCount: widget.products.length,
      itemBuilder: (context, index) {
        var product = widget.products[index];
        return _buildProductCard(
          context,
          product,
          widget.screenWidth,
          widget.screenHeight,
          isSearchScreen: widget.isSearchScreen,
          isFavoritesScreen: widget.isFavoritesScreen,
        );
      },
    );
  }

  Widget _buildProductCard(
      BuildContext context,
      Product product,
      double screenWidth,
      double screenHeight, {
        bool isSearchScreen = false,
        bool isFavoritesScreen = false,
      }) {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(opacity: value, child: child),
        );
      },
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            NextEcommerceAppRoutes.productDetailScreen,
            arguments: product, // pass product directly here
          );
        },
        child: Card(
          color: greyColor,
          clipBehavior: Clip.antiAlias,
          elevation: 6.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProductImage(
                    product,
                    screenHeight,
                    isSearchScreen,
                    isFavoritesScreen,
                  ),
                  _buildProductDetails(
                    context,
                    product,
                    screenWidth,
                    screenHeight,
                    isSearchScreen: isSearchScreen,
                    isFavoritesScreen: isFavoritesScreen,
                  ),
                ],
              ),
              if (!isSearchScreen)
                Positioned(
                  top: 10.0,
                  right: 10.0,
                  child: _buildFavoriteButton(product),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(
      Product product,
      double screenHeight,
      bool isSearchScreen,
      bool isFavoritesScreen,
      ) {
    double imageHeight =
        screenHeight * (isSearchScreen || isFavoritesScreen ? 0.25 : 0.2);
    return SizedBox(
      height: imageHeight,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: CachedNetworkImage(
          imageUrl: product.images?.first ?? "",
          fit: BoxFit.cover,
          placeholder: (_, __) => const ShimmerProductImage(),
          errorWidget: (_, __, ___) => const ImageErrorWidget(),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(Product product) {
    return BlocBuilder<FavoriteProductBloc, FavouriteProductState>(
      builder: (context, favState) {
        bool isFavorite = favState.favoriteItems.any(
              (item) => item.id == product.id,
        );

        return GestureDetector(
          onTap: () {
            context.read<FavoriteProductBloc>().add(
              isFavorite
                  ? RemoveFromFavorites(product)
                  : AddToFavorites(product),
            );
          },
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white.withOpacity(0.8),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey[600],
              size: 24,
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductDetails(
      BuildContext context,
      Product product,
      double screenWidth,
      double screenHeight, {
        bool isSearchScreen = false,
        bool isFavoritesScreen = false,
      }) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    product.title ?? "Product Name",
                    style: NextEcommerceAppTextStyles.producttitle.copyWith(
                      fontSize: 14,
                      fontWeight:
                      isSearchScreen || isFavoritesScreen
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price?.toStringAsFixed(2) ?? "0.00"}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Shimmer for product image
class ShimmerProductImage extends StatelessWidget {
  const ShimmerProductImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(color: Colors.white),
    );
  }
}

// Error widget for product image
class ImageErrorWidget extends StatelessWidget {
  const ImageErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.error_outline, size: 40, color: Colors.red),
      ),
    );
  }
}
