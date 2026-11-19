import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/product_provider.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/product_card.dart';
import '../home/widgets/category_chips.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final currentQuery = context.read<ProductProvider>().searchQuery;
    _searchController.text = currentQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSortBottomSheet(BuildContext context, ProductProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Sort Products By',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 12),
                _buildSortOption(
                  context,
                  'Featured & Popular',
                  ProductSortOption.featured,
                  provider,
                  isDark,
                ),
                _buildSortOption(
                  context,
                  'Price: Low to High',
                  ProductSortOption.priceLowToHigh,
                  provider,
                  isDark,
                ),
                _buildSortOption(
                  context,
                  'Price: High to Low',
                  ProductSortOption.priceHighToLow,
                  provider,
                  isDark,
                ),
                _buildSortOption(
                  context,
                  'Highest Customer Rating',
                  ProductSortOption.topRated,
                  provider,
                  isDark,
                ),
                _buildSortOption(
                  context,
                  'Product Name (A - Z)',
                  ProductSortOption.nameAsc,
                  provider,
                  isDark,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    String label,
    ProductSortOption option,
    ProductProvider provider,
    bool isDark,
  ) {
    final isSelected = provider.sortOption == option;
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected
              ? (isDark ? AppColors.primaryLight : AppColors.primary)
              : null,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle_rounded,
              color: isDark ? AppColors.primaryLight : AppColors.primary,
            )
          : null,
      onTap: () {
        provider.setSortOption(option);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final productProvider = context.watch<ProductProvider>();
    final products = productProvider.filteredProducts;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Explore & Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort_rounded),
            onPressed: () => _showSortBottomSheet(context, productProvider),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search input bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => productProvider.setSearchQuery(val),
              decoration: InputDecoration(
                hintText: 'Search products by name or category...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          productProvider.setSearchQuery('');
                        },
                      )
                    : null,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Categories filter chips
          const CategoryChips(),

          const SizedBox(height: 12),

          // Search feedback count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${products.length} results',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showSortBottomSheet(context, productProvider),
                  icon: const Icon(Icons.tune_rounded, size: 16),
                  label: const Text('Sort', style: TextStyle(fontSize: 13)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Product Results
          Expanded(
            child: products.isEmpty
                ? EmptyStateWidget(
                    icon: Icons.search_off_rounded,
                    title: 'No matching products',
                    subtitle:
                        'We couldn\'t find anything matching "${_searchController.text}". Try searching for coffee, headphones, or fashion items.',
                    buttonText: 'Clear Filters',
                    onButtonPressed: () {
                      _searchController.clear();
                      productProvider.setSearchQuery('');
                      productProvider.setCategory('all');
                    },
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    itemCount: products.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.60,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemBuilder: (context, index) {
                      return ProductCard(
                        product: products[index],
                        heroTag: 'explore_${products[index].id}',
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
