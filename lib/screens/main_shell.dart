import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    if (_currentIndex != index) {
      HapticFeedback.selectionClick();
      setState(() => _currentIndex = index);
    }
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
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.40)
                  : Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 6),
            child: Row(
              children: [
                Expanded(
                  child: _buildNavItem(
                    index: 0,
                    label: 'Home',
                    activeIcon: Icons.home_rounded,
                    inactiveIcon: Icons.home_outlined,
                    isDark: isDark,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    index: 1,
                    label: 'Cart',
                    activeIcon: Icons.shopping_bag_rounded,
                    inactiveIcon: Icons.shopping_bag_outlined,
                    badgeCount: cartCount,
                    badgeColor: AppColors.accent,
                    badgeTextColor: Colors.black,
                    isDark: isDark,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    index: 2,
                    label: 'Wishlist',
                    activeIcon: Icons.favorite_rounded,
                    inactiveIcon: Icons.favorite_border_rounded,
                    badgeCount: wishlistCount,
                    badgeColor: AppColors.error,
                    badgeTextColor: Colors.white,
                    isDark: isDark,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    index: 3,
                    label: 'Account',
                    activeIcon: Icons.person_rounded,
                    inactiveIcon: Icons.person_outline_rounded,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData activeIcon,
    required IconData inactiveIcon,
    required bool isDark,
    int badgeCount = 0,
    Color badgeColor = AppColors.accent,
    Color badgeTextColor = Colors.black,
  }) {
    final isSelected = _currentIndex == index;
    final activeColor = isDark ? AppColors.accent : AppColors.primary;
    final unselectedColor =
        isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    return Semantics(
      button: true,
      label: label,
      selected: isSelected,
      child: InkResponse(
        onTap: () => _onTabSelected(index),
        radius: 36,
        containedInkWell: false,
        highlightShape: BoxShape.rectangle,
        splashColor: activeColor.withOpacity(0.12),
        highlightColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated Top Accent Pill Bar
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                height: 3,
                width: isSelected ? 24 : 0,
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: activeColor.withOpacity(0.6),
                            blurRadius: 6,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
              ),

              // Icon container with active capsule highlight & badge
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark
                          ? AppColors.accent.withOpacity(0.12)
                          : AppColors.primary.withOpacity(0.08))
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? (isDark
                            ? AppColors.accent.withOpacity(0.25)
                            : AppColors.primary.withOpacity(0.18))
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    AnimatedScale(
                      scale: isSelected ? 1.08 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutBack,
                      child: Icon(
                        isSelected ? activeIcon : inactiveIcon,
                        size: 22,
                        color: isSelected ? activeColor : unselectedColor,
                      ),
                    ),
                    if (badgeCount > 0)
                      Positioned(
                        top: -5,
                        right: -10,
                        child: AnimatedScale(
                          scale: 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.5,
                              vertical: 1.5,
                            ),
                            decoration: BoxDecoration(
                              color: badgeColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: badgeColor.withOpacity(0.4),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              badgeCount > 99 ? '99+' : '$badgeCount',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: badgeTextColor,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 3),

              // Animated Label
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? activeColor : unselectedColor,
                  letterSpacing: isSelected ? 0.2 : 0,
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
