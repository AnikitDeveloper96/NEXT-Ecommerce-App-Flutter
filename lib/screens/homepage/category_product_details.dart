import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import for BlocProvider.of
import 'package:nextecommerceapp/blocs/bloc_event/favourite_event.dart'; // Import favorite events
import 'package:nextecommerceapp/blocs/bloc_state/fav_state.dart';
import 'package:nextecommerceapp/blocs/blocs/fav_bloc.dart'; // Import your FavoriteProductBloc
import 'package:nextecommerceapp/routes.dart';
import '../../constant/colors.dart';
import '../../constant/textstyle.dart';
import '../../models/product_model.dart';

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({super.key});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String categoryName = args['categoryName'] as String;
    final List<List<Product>> categoryProducts =
        args['categoryProducts'] as List<List<Product>>;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          capitalizeFirstLetter(categoryName),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body:
          categoryProducts.isEmpty
              ? const Center(
                child: Text(
                  'No products found.',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : ListView.builder(
                itemCount: categoryProducts.length,
                itemBuilder: (context, index) {
                  final products = categoryProducts[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.02),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: screenWidth > 600 ? 3 : 2,
                                mainAxisSpacing: screenHeight * 0.03,
                                crossAxisSpacing: screenWidth * 0.04,
                                childAspectRatio: 0.55,
                              ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return _buildProductGrid(
                              context,
                              products[index],
                              screenWidth,
                              screenHeight,
                            );
                          },
                        ),
                        SizedBox(height: screenHeight * 0.02),
                      ],
                    ),
                  );
                },
              ),
    );
  }

  Widget _buildProductGrid(
      BuildContext context,
      Product product,
      double screenWidth,
      double screenHeight,
      ) {
    return Card(
      color: greyColor,
      clipBehavior: Clip.antiAlias,
      elevation: 6.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () {
            Navigator.pushNamed(
              context,
              NextEcommerceAppRoutes.productDetailScreen,
              arguments: product, // Pass Product directly, not wrapped in Map
            );

        },
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: product.images?.first ?? "",
                      fit: BoxFit.cover,
                      height: screenHeight * 0.2,
                      width: double.infinity,
                      placeholder:
                          (_, __) =>
                      const Center(child: CircularProgressIndicator()),
                      errorWidget:
                          (_, __, ___) => const Icon(
                        Icons.error,
                        size: 50,
                        color: Colors.red,
                      ),
                    ),
                    Positioned(
                      top: 8.0, // Further adjusted top position for better spacing
                      right: 8.0, // Further adjusted right position for better spacing
                      child: GestureDetector(
                        onTap: () {
                          final favoriteBloc =
                          BlocProvider.of<FavoriteProductBloc>(context);
                          final isFavorite = favoriteBloc.state.favoriteItems
                              .contains(product);
                          favoriteBloc.add(
                            isFavorite
                                ? RemoveFromFavorites(product)
                                : AddToFavorites(product),
                          );
                        },
                        child: CircleAvatar(
                          radius: 20, // Slightly larger radius for better touch area
                          backgroundColor: Colors.white70,
                          child: BlocBuilder<FavoriteProductBloc,
                              FavouriteProductState>(
                            builder: (context, favState) {
                              final isFavorite =
                              favState.favoriteItems.contains(product);
                              return Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                isFavorite ? Colors.black : Colors.grey[600],
                                size: 22, // Slightly larger icon for better visibility
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(screenWidth * 0.02),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                        child: Text(
                          product.title ?? "Product Name",
                          style: NextEcommerceAppTextStyles.producttitle
                              .copyWith(fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        "SHOP NOW",
                        style: NextEcommerceAppTextStyles.shopnow
                            .copyWith(fontSize: 12),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Divider(
                        color: Colors.black,
                        thickness: 1,
                        indent: screenWidth * 0.15,
                        endIndent: screenWidth * 0.15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String capitalizeFirstLetter(String text) =>
      text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
}
