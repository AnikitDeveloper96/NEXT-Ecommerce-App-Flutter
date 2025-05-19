import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nextecommerceapp/models/cartModel.dart';
import 'package:nextecommerceapp/models/product_model.dart';

class NextEcommerceDatabase {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference? _userCartCollection;
  CollectionReference? _userFavoritesCollection;

  // Creates or updates user document in 'users' collection.
  Future<void> createUserCollection(User user) async {
    try {
      final userDocRef = _firebaseFirestore.collection('users').doc(user.uid);
      final docSnapshot = await userDocRef.get();

      if (!docSnapshot.exists) {
        await userDocRef.set({
          'displayName': user.displayName,
          'email': user.email,
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        });
        print('User document created for ${user.email}');
      } else {
        await userDocRef.update({'lastLogin': FieldValue.serverTimestamp()});
        print(
          'User document already exists for ${user.email}, lastLogin updated',
        );
      }
    } catch (e) {
      print('Error creating/updating user document: $e');
    }
  }

  // Retrieves the currently logged-in user.
  Future<User?> getCurrentUser() async {
    try {
      return FirebaseAuth.instance.currentUser;
    } catch (e) {
      print('Failed to get current user: $e');
      return null;
    }
  }

  // Helper method to get the user's cart collection reference.
  CollectionReference _getUserCartCollection(String userId) {
    _userCartCollection ??= _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection("cart");
    return _userCartCollection!;
  }

  // Helper method to get the user's favorites collection reference.
  CollectionReference _getUserFavoritesCollection(String userId) {
    _userFavoritesCollection ??= _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection("favourites");
    return _userFavoritesCollection!;
  }

  // Adds a product to the user's cart or updates its quantity.
  Future<void> addToCart(Product product, int quantity) async {
    final user = await getCurrentUser();
    if (user == null) {
      print('User not logged in, cannot add to cart.');
      return;
    }

    try {
      final cartCollection = _getUserCartCollection(user.uid);
      final existingProduct =
          await cartCollection.doc(product.id.toString()).get();

      if (existingProduct.exists) {
        await cartCollection.doc(product.id.toString()).update({
          'productQuantity': FieldValue.increment(quantity),
        });
        print('Product quantity updated in cart: ${product.id}');
      } else {
        await cartCollection.doc(product.id.toString()).set({
          'product': product.toJson(),
          'productQuantity': quantity,
        });
        print('Product added to cart: ${product.id}');
      }
    } catch (e) {
      print('Failed to add to cart: $e');
    }
  }

  // Removes a product from the user's cart.
  Future<void> removeFromCart(Product product) async {
    final user = await getCurrentUser();
    if (user == null) {
      print('User not logged in, cannot remove from cart.');
      return;
    }

    try {
      final cartCollection = _getUserCartCollection(user.uid);
      await cartCollection.doc(product.id.toString()).delete();
      print('Product removed from cart: ${product.id}');
    } catch (e) {
      print('Failed to remove from cart: $e');
    }
  }

  // Retrieves all items from the user's cart.
  Future<List<CartModelForCheckout>> getCartItems() async {
    final user = await getCurrentUser();
    if (user == null) {
      print('User not logged in, cannot retrieve cart items.');
      return [];
    }

    try {
      final cartCollection = _getUserCartCollection(user.uid);
      final querySnapshot = await cartCollection.get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) {
          return CartModelForCheckout(product: Product(), productQuantity: 0);
        }
        final productData = data['product'] as Map<String, dynamic>?;
        final product =
            productData != null ? Product.fromJson(productData) : Product();
        final quantity = data['productQuantity'] as int? ?? 0;

        return CartModelForCheckout(
          product: product,
          productQuantity: quantity,
        );
      }).toList();
    } catch (e) {
      print('Failed to get cart items: $e');
      return [];
    }
  }

  // Adds a product to the user's favorites.
  Future<void> addToFavorites(Product product) async {
    final user = await getCurrentUser();
    if (user == null) {
      print('User not logged in, cannot add to favorites.');
      return;
    }

    try {
      final favCollection = _getUserFavoritesCollection(user.uid);
      final querySnapshot =
          await favCollection.where("id", isEqualTo: product.id).get();
      if (querySnapshot.docs.isNotEmpty) {
        print('Product already in favorites: ${product.id}');
        return;
      }

      await favCollection.add(product.toJson());
      print('Product added to favorites: ${product.id}');
    } catch (e) {
      print('Failed to add to favorites: $e');
    }
  }

  // Removes a product from the user's favorites.
  Future<void> removeFromFavorites(Product product) async {
    final user = await getCurrentUser();
    if (user == null) {
      print('User not logged in, cannot remove from favorites.');
      return;
    }

    try {
      final favCollection = _getUserFavoritesCollection(user.uid);
      final querySnapshot =
          await favCollection.where("id", isEqualTo: product.id).get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      print('Product removed from favorites: ${product.id}');
    } catch (e) {
      print('Failed to remove from favorites: $e');
    }
  }

  // Retrieves all products from the user's favorites.
  Future<List<Product>> getFavoriteProducts() async {
    final user = await getCurrentUser();
    if (user == null) {
      print('User not logged in, cannot retrieve favorites.');
      return [];
    }

    try {
      final favCollection = _getUserFavoritesCollection(user.uid);
      final querySnapshot = await favCollection.get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) {
          return Product();
        }
        return Product.fromJson(data);
      }).toList();
    } catch (e) {
      print('Failed to load favorites: $e');
      return [];
    }
  }
}
