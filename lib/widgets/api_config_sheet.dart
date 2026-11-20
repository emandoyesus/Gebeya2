import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/product_provider.dart';
import '../services/api_service.dart';

class ApiConfigSheet extends StatefulWidget {
  const ApiConfigSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ApiConfigSheet(),
    );
  }

  @override
  State<ApiConfigSheet> createState() => _ApiConfigSheetState();
}

class _ApiConfigSheetState extends State<ApiConfigSheet> {
  late TextEditingController _urlController;
  late TextEditingController _stripeKeyController;
  late ApiDataSource _selectedSource;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    final provider = context.read<ProductProvider>();
    _selectedSource = provider.currentDataSource;
    _urlController = TextEditingController(text: provider.nextJsBaseUrl);
    _stripeKeyController = TextEditingController(text: provider.stripeApiKey);
  }

  @override
  void dispose() {
    _urlController.dispose();
    _stripeKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<ProductProvider>();

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 16,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.cloud_sync_rounded, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'API & Backend Connection',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Configure live inventory and Next.js backend',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
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

          const SizedBox(height: 20),

          // Status Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: provider.isOnline
                  ? AppColors.primary.withOpacity(0.08)
                  : AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: provider.isOnline
                    ? AppColors.primary.withOpacity(0.3)
                    : AppColors.accent.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  provider.isOnline ? Icons.check_circle_rounded : Icons.offline_bolt_rounded,
                  size: 18,
                  color: provider.isOnline ? AppColors.primary : AppColors.accent,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.isOnline
                            ? 'Connected to Live API'
                            : 'Running on Local / Cached Mode',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: provider.isOnline ? AppColors.primary : AppColors.accentDark,
                        ),
                      ),
                      if (provider.lastSyncedAt != null)
                        Text(
                          'Last synced: ${provider.lastSyncedAt!.hour.toString().padLeft(2, '0')}:${provider.lastSyncedAt!.minute.toString().padLeft(2, '0')}:${provider.lastSyncedAt!.second.toString().padLeft(2, '0')} (${provider.products.length} products)',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Select Data Source',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),

          // Source Options
          _buildSourceOption(
            context: context,
            source: ApiDataSource.cloudLive,
            title: 'Live Cloud Store (REST API)',
            subtitle: 'Real live e-commerce API + Ethiopian heritage catalog',
            icon: Icons.public_rounded,
          ),
          _buildSourceOption(
            context: context,
            source: ApiDataSource.nextJsBackend,
            title: 'Next.js App Backend (dan-seng repo)',
            subtitle: 'Connect to http://localhost:3000/api/products',
            icon: Icons.developer_mode_rounded,
          ),
          _buildSourceOption(
            context: context,
            source: ApiDataSource.stripeApi,
            title: 'Direct Stripe REST API',
            subtitle: 'Fetch live products via Stripe v1/products API',
            icon: Icons.credit_card_rounded,
          ),
          _buildSourceOption(
            context: context,
            source: ApiDataSource.offlineCache,
            title: 'Offline / Built-in Catalog',
            subtitle: 'Fast local storage without external network calls',
            icon: Icons.phone_android_rounded,
          ),

          // Next.js URL input if selected
          if (_selectedSource == ApiDataSource.nextJsBackend) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Next.js Server Base URL',
                hintText: 'http://localhost:3000 or http://10.0.2.2:3000',
                prefixIcon: const Icon(Icons.link_rounded, size: 20),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              children: [
                _presetButton('Web: localhost:3000', 'http://localhost:3000'),
                _presetButton('Android: 10.0.2.2:3000', 'http://10.0.2.2:3000'),
              ],
            ),
          ],

          // Stripe API Key input if selected
          if (_selectedSource == ApiDataSource.stripeApi) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _stripeKeyController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Stripe Secret / Restricted Key',
                hintText: 'sk_test_...',
                prefixIcon: const Icon(Icons.key_rounded, size: 20),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],

          const SizedBox(height: 20),

          // Apply & Sync Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isSyncing
                  ? null
                  : () async {
                      setState(() => _isSyncing = true);
                      if (_selectedSource == ApiDataSource.nextJsBackend) {
                        await provider.setNextJsBaseUrl(_urlController.text);
                      } else if (_selectedSource == ApiDataSource.stripeApi) {
                        await provider.setStripeApiKey(_stripeKeyController.text);
                      }
                      await provider.setDataSource(_selectedSource);

                      if (mounted) {
                        setState(() => _isSyncing = false);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              provider.isOnline
                                  ? 'Synced ${provider.products.length} live products successfully!'
                                  : 'Loaded ${provider.products.length} products from offline cache.',
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: provider.isOnline ? AppColors.primary : AppColors.accentDark,
                          ),
                        );
                      }
                    },
              icon: _isSyncing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.sync_rounded),
              label: Text(_isSyncing ? 'Connecting & Syncing...' : 'Save & Sync Catalog'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceOption({
    required BuildContext context,
    required ApiDataSource source,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedSource == source;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: isSelected
            ? AppColors.primary.withOpacity(0.08)
            : (isDark ? AppColors.darkCard : AppColors.lightCard),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              _selectedSource = source;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected ? AppColors.primary : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: isSelected ? AppColors.primary : null,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Radio<ApiDataSource>(
                  value: source,
                  groupValue: _selectedSource,
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedSource = val);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _presetButton(String label, String url) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 10)),
      padding: EdgeInsets.zero,
      onPressed: () {
        setState(() {
          _urlController.text = url;
        });
      },
    );
  }
}
