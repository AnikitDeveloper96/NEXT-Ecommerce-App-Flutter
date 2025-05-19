import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextecommerceapp/blocs/bloc_event/cart_event.dart';
import 'package:nextecommerceapp/blocs/bloc_state/cart_state.dart';
import 'package:nextecommerceapp/blocs/blocs/cart_bloc.dart';
import 'package:nextecommerceapp/models/cartModel.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartInitialState || state is CartUpdatedItemsState) {
            final cartItems =
                state is CartInitialState
                    ? <CartModelForCheckout>[]
                    : (state as CartUpdatedItemsState).cartItems;

            if (cartItems.isEmpty) {
              return const Center(child: Text('Your cart is empty.'));
            }

            double totalPrice = 0;
            for (var item in cartItems) {
              totalPrice += (item.product.price ?? 0) * item.productQuantity;
            }

            double gst = totalPrice * 0.18; // Assuming 18% GST

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return ListTile(
                        leading: Image.network(
                          item.product.images?.isNotEmpty == true
                              ? item.product.images!.first
                              : '',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  const Icon(Icons.image_not_supported),
                        ),
                        title: Text(item.product.title ?? ''),
                        subtitle: Text('Price: \$${item.product.price ?? 0}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (item.productQuantity > 1) {
                                  context.read<CartBloc>().add(
                                    UpdateCartItemsEvent(item.product, -1),
                                  );
                                } else {
                                  context.read<CartBloc>().add(
                                    RemoveFromCartItemsEvent(item.product),
                                  );
                                }
                              },
                            ),
                            Text('${item.productQuantity}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                context.read<CartBloc>().add(
                                  UpdateCartItemsEvent(item.product, 1),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Subtotal: \$${totalPrice.toStringAsFixed(2)}'),
                      Text('GST (18%): \$${gst.toStringAsFixed(2)}'),
                      Text(
                        'Total: \$${(totalPrice + gst).toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to checkout or payment screen
                          // For example:
                          // Navigator.pushNamed(context, '/checkout');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Proceed to Checkout'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
