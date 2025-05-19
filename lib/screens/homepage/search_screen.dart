// search_filter_page.dart
// Combined Search + Filter Page with Bloc

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nextecommerceapp/blocs/bloc_event/product_homepage.dart';
import 'package:nextecommerceapp/blocs/bloc_state/product_state.dart';
import 'package:nextecommerceapp/blocs/blocs/bloc_homepage.dart';
import 'package:nextecommerceapp/models/product_model.dart';
import 'package:nextecommerceapp/widgets/product_grid.dart';

class SearchFilterPage extends StatefulWidget {
  final Function(String) onThemeToggle;
  const SearchFilterPage({required this.onThemeToggle, super.key});

  @override
  State<SearchFilterPage> createState() => _SearchFilterPageState();
}

class _SearchFilterPageState extends State<SearchFilterPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String category = '';
  String brand = '';
  RangeValues priceRange = const RangeValues(0, 10000);

  final categoryOptions = ['All', 'Electronics', 'Fashion', 'Groceries'];
  final brandOptions = ['All', 'Apple', 'Samsung', 'Nike'];

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductBloc>(context).add(FetchProducts());
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _filterProducts);
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts =
          _allProducts.where((product) {
            final titleMatch = (product.title ?? '').toLowerCase().contains(
              query,
            );
            final tagMatch = (product.tags ?? []).any(
              (t) => t.toLowerCase().contains(query),
            );
            final matchCategory =
                category == '' ||
                category == 'All' ||
                product.category == category;
            final matchBrand =
                brand == '' || brand == 'All' || product.brand == brand;
            final matchPrice =
                (product.price ?? 0) >= priceRange.start &&
                (product.price ?? 0) <= priceRange.end;
            return (titleMatch || tagMatch) &&
                matchCategory &&
                matchBrand &&
                matchPrice;
          }).toList();
      _isSearching =
          query.isNotEmpty ||
          category != 'All' ||
          brand != 'All' ||
          priceRange != const RangeValues(0, 10000);
    });
  }

  Widget _buildChips(
    String label,
    List<String> options,
    String selected,
    void Function(String) onSelect,
  ) {
    return Row(
      children: [
        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w600)),
        ...options.map(
          (value) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(value),
              selected: selected == value,
              onSelected: (_) => onSelect(value),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title:
            _isSearching
                ? const Text('Search Results')
                : const Text('Product Explorer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => widget.onThemeToggle('toggle'),
          ),
        ],
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductLoaded) {
            setState(() {
              _allProducts = state.products;
              _filterProducts(); // Initial filter after products are loaded
            });
          } else if (state is ProductError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          }
        },
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search products',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      _buildChips('Category', categoryOptions, category, (val) {
                        setState(() => category = val);
                        _filterProducts();
                      }),
                      const SizedBox(width: 16),
                      _buildChips('Brand', brandOptions, brand, (val) {
                        setState(() => brand = val);
                        _filterProducts();
                      }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Text(
                        "Price Range: ",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Expanded(
                        child: RangeSlider(
                          values: priceRange,
                          min: 0,
                          max: 10000,
                          divisions: 50,
                          labels: RangeLabels(
                            '₹${priceRange.start.round()}',
                            '₹${priceRange.end.round()}',
                          ),
                          onChanged: (RangeValues values) {
                            setState(() {
                              priceRange = values;
                              _filterProducts();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child:
                      _isSearching && _filteredProducts.isEmpty
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off_rounded,
                                  size: 60,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'No products found matching your criteria',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                          : ProductGrid(
                            products: _filteredProducts,
                            screenWidth: screenWidth,
                            screenHeight:
                                MediaQuery.of(context).size.height * 0.7,
                            isSearchScreen: true,
                            isFavoritesScreen: false,
                            isHomeScreen: false,
                          ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _debounce?.cancel();
    super.dispose();
  }
}
