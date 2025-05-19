import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextecommerceapp/blocs/bloc_event/favourite_event.dart';
import 'package:nextecommerceapp/models/product_model.dart' show Product;
import 'package:nextecommerceapp/widgets/product_grid.dart' show ProductGrid;
import '../../blocs/bloc_state/product_state.dart';
import '../../blocs/blocs/bloc_homepage.dart';
import '../../constant/assets_images.dart';
import '../../constant/textstyle.dart';
import '../../routes.dart' show NextEcommerceAppRoutes;
import '../../widgets/animation.dart';
import '../../blocs/blocs/fav_bloc.dart'; //import fav bloc
import 'package:shimmer/shimmer.dart';

class MyHomePage extends StatefulWidget {
  final User? user;
  const MyHomePage({super.key, this.user});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final NextEcommerceAppTextStyles textStyles = NextEcommerceAppTextStyles();
  final List<String> bannerImages = [
    NextEcommerceAssetImages().bannerOneHomepage,
    NextEcommerceAssetImages().bannertwoHomepage,
  ];
  int _currentImageIndex = 0;

  void _goToNextImage() {
    setState(() {
      _currentImageIndex = (_currentImageIndex + 1) % bannerImages.length;
    });
  }

  void _goToPreviousImage() {
    setState(() {
      if (_currentImageIndex > 0) _currentImageIndex--;
    });
  }

  String capitalizeFirstLetter(String text) =>
      text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create:
          (context) =>
              FavoriteProductBloc()
                ..add(LoadFavorites()), // Initialize FavoriteProductBloc
      child: Scaffold(
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return _buildShimmerLoading(screenWidth, screenHeight);
            } else if (state is ProductLoaded) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBannerSection(screenWidth, screenHeight),
                      SizedBox(height: screenHeight * 0.02),
                      _buildSectionTitle("Shop by Categories"),
                      SizedBox(height: screenHeight * 0.02),
                      _buildCategoryGrid(
                        state.products,
                        screenWidth,
                        screenHeight,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      _buildSectionTitle("New Arrivals"),
                      SizedBox(height: screenHeight * 0.02),
                      state.products.isEmpty
                          ? const Center(
                            child: Text(
                              'No products found.',
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                          : ProductGrid(
                            products: state.products,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            isFavoritesScreen: false,
                            isHomeScreen: true,
                            isSearchScreen: false,
                          ),
                    ],
                  ),
                ),
              );
            } else if (state is ProductError) {
              return const Center(child: Text("Failed to load products"));
            } else {
              return const Center(child: Text('No products found.'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildShimmerLoading(double screenWidth, double screenHeight) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShimmerBanner(screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.02),
              Container(
                width: screenWidth * 0.4,
                height: 20,
                color: Colors.white,
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildShimmerCategoryGrid(screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.02),
              Container(
                width: screenWidth * 0.4,
                height: 20,
                color: Colors.white,
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildShimmerProductGrid(screenWidth, screenHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerBanner(double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth,
      height: screenHeight * 0.25,
      color: Colors.white,
    );
  }

  Widget _buildShimmerCategoryGrid(double screenWidth, double screenHeight) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: screenWidth > 600 ? 3 : 2,
        mainAxisSpacing: screenHeight * 0.02,
        crossAxisSpacing: screenWidth * 0.02,
        childAspectRatio: 1.5,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenWidth * 0.02),
            color: Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildShimmerProductGrid(double screenWidth, double screenHeight) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: screenHeight * 0.02,
        crossAxisSpacing: screenWidth * 0.02,
        childAspectRatio: 0.7,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(color: Colors.white);
      },
    );
  }

  Widget _buildBannerSection(double screenWidth, double screenHeight) {
    return SizedBox(
      height: screenHeight * 0.25,
      child: Stack(
        children: [
          BannerAnimation(
            imagePath: bannerImages[_currentImageIndex],
            screenHeight: screenHeight,
            screenWidth: screenWidth,
          ),
          Positioned(
            top: screenHeight * 0.05,
            right: screenWidth * 0.05,
            child: Container(
              color: Colors.white.withOpacity(0.5),
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: Text(
                "This\nseason’s\nlatest",
                style: NextEcommerceAppTextStyles.bannerText,
                textAlign: TextAlign.left,
              ),
            ),
          ),
          if (_currentImageIndex > 0)
            Positioned(
              left: screenWidth * 0.05,
              top: screenHeight * 0.1,
              child: GestureDetector(
                onTap: _goToPreviousImage,
                child: _buildArrowIcon(Icons.arrow_back, screenWidth),
              ),
            ),
          Positioned(
            right: screenWidth * 0.05,
            top: screenHeight * 0.1,
            child: GestureDetector(
              onTap: _goToNextImage,
              child: _buildArrowIcon(Icons.arrow_forward, screenWidth),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrowIcon(IconData icon, double screenWidth) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withOpacity(0.6),
      ),
      padding: EdgeInsets.all(screenWidth * 0.03),
      child: Icon(icon, color: Colors.white, size: screenWidth * 0.08),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: NextEcommerceAppTextStyles.headerText);
  }

  final List<String> categoryImages = [
    NextEcommerceAssetImages().categoryOne,
    NextEcommerceAssetImages().categoryTwo,
    NextEcommerceAssetImages().categoryThree,
    NextEcommerceAssetImages().categoryFour,
  ];

  Widget _buildCategoryGrid(
    List<Product> products,
    double screenWidth,
    double screenHeight,
  ) {
    final categories =
        products
            .map((product) => product.category)
            .whereType<String>()
            .toSet()
            .toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: screenWidth > 600 ? 3 : 2,
        mainAxisSpacing: screenHeight * 0.02,
        crossAxisSpacing: screenWidth * 0.02,
        childAspectRatio: 1.5,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final categoryProducts =
            products
                .where((product) => product.category == categories[index])
                .toList();

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
              categoryProducts.isEmpty
                  ? Container()
                  : Navigator.pushNamed(
                    context,
                    NextEcommerceAppRoutes.categoryProductDetailScreen,
                    arguments: {
                      'categoryName': categories[index],
                      'categoryProducts': [categoryProducts],
                    },
                  );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(screenWidth * 0.02),
                image: DecorationImage(
                  image: AssetImage(categoryImages[index]),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  color: Colors.black54,
                ),
                child: Center(
                  child: Text(
                    capitalizeFirstLetter(categories[index]),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
