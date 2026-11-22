import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../auth/auth_screen.dart';
import '../checkout/widgets/delivery_pin_picker_modal.dart';
import '../merchant/merchant_dashboard_screen.dart';
import 'order_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  final Function(int tabIndex)? onNavigateTab;

  const ProfileScreen({super.key, this.onNavigateTab});

  void _showEditProfileDialog(BuildContext context, AuthProvider auth) {
    final user = auth.currentUser;
    if (user == null) return;

    final nameController = TextEditingController(text: user.fullName);
    final phoneController = TextEditingController(text: user.phoneNumber);
    final streetController = TextEditingController(text: user.defaultStreet);
    String selectedSubcity = user.defaultSubcity;

    final subcities = [
      'Bole',
      'Kazanchis',
      'Kirkos',
      'Lideta',
      'Yeka',
      'Arada',
      'Gulele',
      'Akaki-Kality',
      'Nifas Silk-Lafto',
      'Kolfe Keranio',
    ];

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.edit_outlined, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text('Edit Delivery Profile'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      maxLength: 60,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        counterText: '',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 20,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        counterText: '',
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: subcities.contains(selectedSubcity) ? selectedSubcity : subcities.first,
                      decoration: const InputDecoration(labelText: 'Subcity'),
                      items: subcities
                          .map((sc) => DropdownMenuItem(value: sc, child: Text(sc)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => selectedSubcity = val);
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: streetController,
                      maxLength: 140,
                      decoration: const InputDecoration(
                        labelText: 'Street Address',
                        counterText: '',
                      ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        DeliveryPinPickerModal.show(
                          context: context,
                          initialSubcity: selectedSubcity,
                          onLocationSelected: (point) {
                            setDialogState(() {
                              if (subcities.contains(point.subcity)) {
                                selectedSubcity = point.subcity;
                              }
                              streetController.text = '${point.landmark} (${point.description})';
                            });
                          },
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.pin_drop_rounded, size: 16, color: AppColors.primary),
                            SizedBox(width: 6),
                            Text(
                              'Pick Landmark or Map Pin',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await auth.updateProfile(
                      fullName: nameController.text.trim(),
                      phoneNumber: phoneController.text.trim(),
                      defaultSubcity: selectedSubcity,
                      defaultStreet: streetController.text.trim(),
                    );
                    if (context.mounted) {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile updated successfully!'),
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = context.watch<ThemeProvider>();
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    final orderCount = context.watch<OrderProvider>().orders.length;
    final wishlistCount = context.watch<WishlistProvider>().count;
    final cartCount = context.watch<CartProvider>().itemCount;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('My Account'),
        actions: [
          if (auth.isAuthenticated)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit Profile',
              onPressed: () => _showEditProfileDialog(context, auth),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
            // User Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: (isDark
                            ? AppColors.primaryLight
                            : AppColors.primary)
                        .withValues(alpha: 0.2),
                    child: Icon(
                      Icons.person_rounded,
                      size: 40,
                      color: isDark ? AppColors.primaryLight : AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.fullName ?? 'Guest Customer',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? 'Sign in to access your saved profile',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              size: 14,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                user != null
                                    ? '${user.phoneNumber} • ${user.defaultSubcity}'
                                    : 'Addis Ababa Delivery',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? AppColors.darkTextMuted
                                      : AppColors.lightTextMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Quick Stats Row
            Row(
              children: [
                _buildStatCard(
                  context,
                  '$orderCount',
                  'Orders',
                  Icons.receipt_long_rounded,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OrderHistoryScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  context,
                  '$wishlistCount',
                  'Saved',
                  Icons.favorite_rounded,
                  () {
                    onNavigateTab?.call(3);
                  },
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  context,
                  '$cartCount',
                  'In Cart',
                  Icons.shopping_bag_rounded,
                  () {
                    onNavigateTab?.call(1); // Cart is index 1
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Authentication Action Card (Switch Account or Sign In)
            Material(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.switch_account_rounded, color: AppColors.primary),
                    title: Text(auth.isAuthenticated ? 'Switch / Change Account' : 'Sign In or Register'),
                    subtitle: Text(
                      auth.isAuthenticated
                          ? 'Logged in as ${user?.email}'
                          : 'Sign in to sync your delivery address and orders',
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => AuthScreen.show(context),
                  ),
                  if (auth.isAuthenticated) ...[
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.logout_rounded, color: AppColors.error),
                      title: const Text('Sign Out', style: TextStyle(color: AppColors.error)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Sign Out of Gebeya?'),
                            content: const Text('You can sign back in anytime using your email or phone number.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.error,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () async {
                                  Navigator.pop(ctx);
                                  await auth.signOut();
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('You have signed out.'),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                },
                                child: const Text('Sign Out'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Delivery & Payment Settings
            Material(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.storefront_rounded, color: AppColors.accent),
                    title: const Text(
                      'Merchant Operations & Dispatch',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: const Text('Verify payments, dispatch orders & manage store'),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'STORE OWNER',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                    onTap: () => MerchantDashboardScreen.show(context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.history_rounded),
                    title: const Text('Order History & Tracking'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OrderHistoryScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: const Text('Saved Delivery Address'),
                    subtitle: Text(
                      user != null
                          ? '${user.defaultStreet}, ${user.defaultSubcity}'
                          : 'Bole Medhanialem, Addis Ababa',
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Row(
                            children: [
                              Icon(Icons.location_on, color: AppColors.primary),
                              SizedBox(width: 8),
                              Text('Default Delivery Address'),
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.fullName ?? 'Abebe Kebede',
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 4),
                              Text(user?.phoneNumber ?? '+251 91 123 4567'),
                              const SizedBox(height: 4),
                              Text(user?.defaultStreet ?? 'Bole Medhanialem, Olympia St.'),
                              Text('${user?.defaultSubcity ?? "Bole"} Subcity, Addis Ababa, Ethiopia'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                _showEditProfileDialog(context, auth);
                              },
                              child: const Text('Edit Address'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.account_balance_wallet_outlined),
                    title: const Text('Payment Methods'),
                    subtitle: const Text('Telebirr, CBE Birr, Chapa, Stripe'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Row(
                            children: [
                              Icon(Icons.payment_rounded, color: AppColors.primary),
                              SizedBox(width: 8),
                              Text('Payment Gateways'),
                            ],
                          ),
                          content: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(Icons.phone_android_rounded, color: AppColors.telebirr),
                                title: Text('Telebirr Direct'),
                                subtitle: Text('Connected • 091****567'),
                                contentPadding: EdgeInsets.zero,
                              ),
                              ListTile(
                                leading: Icon(Icons.account_balance_rounded, color: AppColors.cbeBirr),
                                title: Text('CBE Birr'),
                                subtitle: Text('Active Account Linked'),
                                contentPadding: EdgeInsets.zero,
                              ),
                              ListTile(
                                leading: Icon(Icons.credit_card_rounded, color: AppColors.stripe),
                                title: Text('Cards & Digital Wallets'),
                                subtitle: Text('Visa, Mastercard ready'),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Done'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Preferences
            Material(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: Icon(
                      isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      color: AppColors.accent,
                    ),
                    title: const Text('Dark Mode'),
                    subtitle: Text(isDark ? 'Midnight Obsidian OLED (Active)' : 'Clean Modern Light'),
                    value: isDark,
                    onChanged: (val) {
                      themeProvider.toggleTheme(val);
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.language_rounded),
                    title: const Text('Language / ቋንቋ'),
                    subtitle: const Text('English & Amharic (አማርኛ)'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Bilingual English & Amharic active'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.help_outline_rounded),
                    title: const Text('Help & Customer Support'),
                    subtitle: const Text('info@gebeya.et • 24/7 Hotline'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Row(
                            children: [
                              Icon(Icons.support_agent_rounded, color: AppColors.primary),
                              SizedBox(width: 8),
                              Text('Customer Support'),
                            ],
                          ),
                          content: const Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Gebeya Help Desk (Addis Ababa)',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height: 8),
                              Text('📞 Toll-Free Hotline: 8900'),
                              Text('📱 Mobile: +251 91 100 2233'),
                              Text('✉️ Email: support@gebeya.et'),
                              SizedBox(height: 8),
                              Text(
                                'Mon - Sat: 8:00 AM - 8:00 PM EAT',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // App branding footer
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Gebeya',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: isDark ? AppColors.primaryLight : AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'ገበያ',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'v1.2.0 • Ethiopian Digital Commerce',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Material(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isDark ? AppColors.primaryLight : AppColors.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
