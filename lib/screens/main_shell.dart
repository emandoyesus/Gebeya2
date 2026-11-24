import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import 'cart/cart_screen.dart';
import 'home/home_screen.dart';
import 'profile/profile_screen.dart';
import 'wishlist/wishlist_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0; // Default to Home

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartCount = context.watch<CartProvider>().itemCount;
    final wishlistCount = context.watch<WishlistProvider>().count;

    final screens = [
      HomeScreen(onNavigateTab: _onTabSelected),
      CartScreen(onNavigateTab: _onTabSelected),
      WishlistScreen(onNavigateTab: _onTabSelected),
      ProfileScreen(onNavigateTab: _onTabSelected),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 240),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(_currentIndex),
          child: screens[_currentIndex],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1.2,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: _onTabSelected,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            letterSpacing: 0.1,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            letterSpacing: 0.1,
          ),
          selectedItemColor: isDark ? AppColors.sandDune : AppColors.primary,
          unselectedItemColor: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text(
                  '$cartCount',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 10),
                ),
                backgroundColor: isDark ? AppColors.sandDune : AppColors.primary,
                textColor: isDark ? AppColors.primary : AppColors.sandDune,
                child: const Icon(Icons.shopping_bag_outlined),
              ),
              activeIcon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text(
                  '$cartCount',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 10),
                ),
                backgroundColor: isDark ? AppColors.sandDune : AppColors.primary,
                textColor: isDark ? AppColors.primary : AppColors.sandDune,
                child: const Icon(Icons.shopping_bag_rounded),
              ),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: wishlistCount > 0,
                label: Text(
                  '$wishlistCount',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 10),
                ),
                backgroundColor: AppColors.error,
                textColor: Colors.white,
                child: const Icon(Icons.favorite_border_rounded),
              ),
              activeIcon: Badge(
                isLabelVisible: wishlistCount > 0,
                label: Text(
                  '$wishlistCount',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 10),
                ),
                backgroundColor: AppColors.error,
                textColor: Colors.white,
                child: const Icon(Icons.favorite_rounded),
              ),
              label: 'Wishlist',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
