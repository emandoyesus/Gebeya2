import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_colors.dart';
import '../../../models/product.dart';
import '../../../providers/product_provider.dart';

class AddProductModal extends StatefulWidget {
  const AddProductModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddProductModal(),
    );
  }

  @override
  State<AddProductModal> createState() => _AddProductModalState();
}

class _AddProductModalState extends State<AddProductModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nameAmharicController = TextEditingController();
  final _priceController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  String _selectedCategory = 'electronics';
  bool _isFeatured = false;
  bool _isSaving = false;

  final List<Map<String, String>> _categories = const [
    {'id': 'electronics', 'name': 'Electronics (ኤሌክትሮኒክስ)'},
    {'id': 'ethiopian_heritage', 'name': 'Ethiopian Goods (የሀበሻ ባህላዊ)'},
    {'id': 'fashion', 'name': 'Fashion & Wear (ፋሽንና አልባሳት)'},
    {'id': 'home', 'name': 'Home & Living (የቤት ዕቃዎች)'},
    {'id': 'beauty', 'name': 'Beauty & Spices (ቅመማቅመም እና ውበት)'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _nameAmharicController.dispose();
    _priceController.dispose();
    _originalPriceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final price = double.parse(_priceController.text.trim());
      final origPrice = _originalPriceController.text.trim().isNotEmpty
          ? double.tryParse(_originalPriceController.text.trim())
          : null;

      final defaultImages = [
        _imageUrlController.text.trim().isNotEmpty
            ? _imageUrlController.text.trim()
            : 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80',
      ];

      final newProduct = Product(
        id: 'gebeya_custom_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        nameAmharic: _nameAmharicController.text.trim().isNotEmpty
            ? _nameAmharicController.text.trim()
            : _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: price,
        originalPrice: origPrice,
        rating: 5.0,
        reviewCount: 1,
        category: _selectedCategory,
        isFeatured: _isFeatured,
        inStock: true,
        imageUrls: defaultImages,
        specifications: {
          'Origin': 'Gebeya Store Merchant Upload',
          'Listed Date': 'Today',
        },
      );

      final success = await context.read<ProductProvider>().addProduct(newProduct);

      if (mounted) {
        setState(() => _isSaving = false);
        if (success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Product "${newProduct.name}" added to catalog! 🛍️'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to publish product. Please try again.'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_shopping_cart_rounded,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add New Product',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Upload product directly to your store inventory',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Form body
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product English Name
                    TextFormField(
                      controller: _nameController,
                      maxLength: 80,
                      decoration: const InputDecoration(
                        labelText: 'Product Name (English)',
                        hintText: 'e.g. Premium Sidama Coffee',
                        prefixIcon: Icon(Icons.label_outline_rounded),
                        counterText: '',
                      ),
                      validator: (val) => val == null || val.trim().isEmpty
                          ? 'Please enter product name'
                          : null,
                    ),
                    const SizedBox(height: 12),

                    // Product Amharic Name
                    TextFormField(
                      controller: _nameAmharicController,
                      maxLength: 80,
                      decoration: const InputDecoration(
                        labelText: 'የምርት ስም (በአማርኛ)',
                        hintText: 'ምሳሌ፡ የሲዳማ ስፔሻሊቲ ቡና',
                        prefixIcon: Icon(Icons.translate_rounded),
                        counterText: '',
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Category dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Product Category',
                        prefixIcon: Icon(Icons.category_outlined),
                      ),
                      items: _categories.map((c) {
                        return DropdownMenuItem(
                          value: c['id']!,
                          child: Text(c['name']!),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCategory = val);
                      },
                    ),
                    const SizedBox(height: 12),

                    // Price and Original Price Row
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _priceController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Price (ETB)',
                              hintText: 'e.g. 1850',
                              prefixIcon: Icon(Icons.payments_outlined),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Enter price';
                              }
                              if (double.tryParse(val.trim()) == null) {
                                return 'Valid number';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _originalPriceController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Original Price (Optional)',
                              hintText: 'e.g. 2200',
                              prefixIcon: Icon(Icons.discount_outlined),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Image URL
                    TextFormField(
                      controller: _imageUrlController,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        labelText: 'Image URL (Optional)',
                        hintText: 'https://images.unsplash.com/...',
                        prefixIcon: Icon(Icons.image_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      maxLength: 300,
                      decoration: const InputDecoration(
                        labelText: 'Product Description & Specs',
                        hintText: 'Detailed product features, materials, origin...',
                        prefixIcon: Icon(Icons.description_outlined),
                        counterText: '',
                      ),
                      validator: (val) => val == null || val.trim().isEmpty
                          ? 'Please enter product description'
                          : null,
                    ),
                    const SizedBox(height: 8),

                    // Featured toggle
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Mark as Featured & Trending',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Text(
                        'Displays product in the top Hot Deals banner carousel',
                        style: TextStyle(fontSize: 11),
                      ),
                      value: _isFeatured,
                      onChanged: (val) => setState(() => _isFeatured = val),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _isSaving ? null : _handleSubmit,
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.cloud_upload_outlined),
              label: Text(_isSaving ? 'Publishing Product...' : 'Publish Product to Store'),
            ),
          ),
        ],
      ),
    );
  }
}
