import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:nextecommerceapp/models/product_model.dart';
import 'package:nextecommerceapp/screens/homepage/product_detail_screen.dart';
import 'package:nextecommerceapp/screens/homepage/category_product_details.dart';
import 'package:nextecommerceapp/screens/cart/checkout_page.dart';
import 'package:nextecommerceapp/screens/homepage/favourite_screen.dart';
import 'package:nextecommerceapp/screens/mainhomepage.dart';
import 'package:nextecommerceapp/screens/onboardingscreens/onboarding_screen.dart';
import 'package:nextecommerceapp/screens/onboardingscreens/welcome_screen.dart';
import 'package:nextecommerceapp/screens/homepage/homepage.dart';

class NextEcommerceAppRoutes {
  static const String onboarding = "/onboardingscreen";
  static const String splashscreen = '/splashscreen';
  static const String mainhomepage = '/mainhomepage';
  static const String homepage = '/homepage';
  static const String welcomeScreen = "/welcomescreen";
  static const String signupScreen = '/signupscreen';
  static const String categoryProductDetailScreen = '/categoryProductDetailScreen';
  static const String productDetailScreen = '/productDetailScreen';
  static const String favouriteScreen = '/favouritescreen';
  static const String cartPage = '/cartpage';
  static const String searchScreen = '/searchScreen';

  static Map<String, WidgetBuilder> get routes => {
    onboarding: (context) => OnboardingScreen(),
    welcomeScreen: (context) => WelcomeScreen(),
    signupScreen: (context) => SignupScreen(),
    mainhomepage: (context) => MainHomePage(
      user: ModalRoute.of(context)?.settings.arguments as User?,
    ),
    homepage: (context) => MyHomePage(
      user: ModalRoute.of(context)?.settings.arguments as User?,
    ),
    categoryProductDetailScreen: (context) => CategoryProductsScreen(),
    productDetailScreen: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Product) {
        return ProductDetailsScreen(product: args);
      }
      return const Scaffold(
        body: Center(child: Text("Error: Product not found.")),
      );
    },
    favouriteScreen: (context) => FavoritesScreen(),
    cartPage: (context) => CartPage(),
  };
}
