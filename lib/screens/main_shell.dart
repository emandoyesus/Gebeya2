import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import 'cart/cart_screen.dart';
import 'explore/explore_screen.dart';
import 'home/home_screen.dart';
import 'profile/profile_screen.dart';
import 'wishlist/wishlist_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

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
      const ExploreScreen(),
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
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabSelected,
          selectedItemColor: isDark ? AppColors.primaryLight : AppColors.primary,
          unselectedItemColor: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
              activeIcon: Icon(Icons.search_rounded),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text(
                  '$cartCount',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 10),
                ),
                backgroundColor: AppColors.accent,
                textColor: Colors.black,
                child: const Icon(Icons.shopping_bag_outlined),
              ),
              activeIcon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text(
                  '$cartCount',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 10),
                ),
                backgroundColor: AppColors.accent,
                textColor: Colors.black,
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
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
