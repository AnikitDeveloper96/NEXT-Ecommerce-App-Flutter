import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

import '../../models/product_model.dart';
import '../bloc_event/product_homepage.dart';
import '../bloc_state/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<FetchProducts>(_fetchProducts);
  }

  Future<void> _fetchProducts(
      FetchProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final response =
          await http.get(Uri.parse('https://dummyjson.com/products'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final productsJson = data['products'] as List<dynamic>;
        final products =
            productsJson.map((json) => Product.fromJson(json)).toList();
        emit(ProductLoaded(products)); // Pass List<Product>
      } else {
        emit(ProductError('Failed to fetch products'));
      }
    } catch (e) {
      emit(ProductError('Error: $e'));
    }
  }
}
