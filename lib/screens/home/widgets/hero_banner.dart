import 'dart:async';
import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../widgets/app_image.dart';

class HeroBannerItem {
  final String title;
  final String subtitle;
  final String ctaText;
  final String tag;
  final List<Color> gradient;
  final IconData icon;
  final String imageUrl;

  const HeroBannerItem({
    required this.title,
    required this.subtitle,
    required this.ctaText,
    required this.tag,
    required this.gradient,
    required this.icon,
    required this.imageUrl,
  });
}

class HeroBanner extends StatefulWidget {
  final Function(String categoryId)? onSelectCategory;

  const HeroBanner({super.key, this.onSelectCategory});

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<HeroBannerItem> _banners = const [
    HeroBannerItem(
      title: 'Welcome to Gebeya',
      subtitle: 'Experience shopping reimagined. Premium local & modern curated goods.',
      ctaText: 'Shop New Arrivals',
      tag: 'NEW ARRIVALS',
      gradient: [Color(0xFF000000), Color(0xFF141418), Color(0xFF0A0A0C)],
      icon: Icons.storefront_rounded,
      imageUrl: 'https://images.unsplash.com/photo-1472851294608-062f824d29cc?auto=format&fit=crop&w=1200&q=80',
    ),
    HeroBannerItem(
      title: 'Ethiopian Specialty Coffee',
      subtitle: 'Direct from Yirgacheffe & Sidama highlands. Freshly roasted.',
      ctaText: 'Shop Coffee Collection',
      tag: 'UP TO 20% OFF',
      gradient: [Color(0xFF1F1612), Color(0xFF2C201A), Color(0xFF140E0B)],
      icon: Icons.coffee_rounded,
      imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=1200&q=80',
    ),
    HeroBannerItem(
      title: 'Cyber & Modern Tech',
      subtitle: 'Next-gen ANC audio, mechanical keyboards, and wearables.',
      ctaText: 'Shop Tech Deals',
      tag: 'TECH FLASH SALE',
      gradient: [Color(0xFF0C0C10), Color(0xFF161620), Color(0xFF08080C)],
      icon: Icons.headphones_rounded,
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=1200&q=80',
    ),
    HeroBannerItem(
      title: 'Smartphones & EV Gear',
      subtitle: 'iPhone 15 Pro, Galaxy S24 Ultra, portable chargers & auto gear.',
      ctaText: 'Explore Bestsellers',
      tag: 'JIJI BESTSELLERS',
      gradient: [Color(0xFF0F0F12), Color(0xFF18181D), Color(0xFF0A0A0D)],
      icon: Icons.phone_android_rounded,
      imageUrl: 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?auto=format&fit=crop&w=1200&q=80',
    ),
  ];

  void _handleBannerTap(int index) {
    if (widget.onSelectCategory == null) return;
    if (index == 0) {
      widget.onSelectCategory!('all');
    } else if (index == 1) {
      widget.onSelectCategory!('ethiopian_heritage');
    } else if (index == 2) {
      widget.onSelectCategory!('electronics');
    } else if (index == 3) {
      widget.onSelectCategory!('phones');
    }
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % _banners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 185,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return InkWell(
                onTap: () => _handleBannerTap(index),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.darkBorder,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.45),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Background photography
                        AppImage(
                          imageUrl: banner.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),

                        // Dark photo overlay (58% opacity) to darken background signage
                        Container(
                          color: Colors.black.withValues(alpha: 0.58),
                        ),

                        // High-contrast directional dark obsidian gradient scrim behind text
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.black.withValues(alpha: 0.96),
                                Colors.black.withValues(alpha: 0.90),
                                Colors.black.withValues(alpha: 0.50),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.50, 0.78, 1.0],
                            ),
                          ),
                        ),

                        // Subtle brand color wash
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                banner.gradient.first.withValues(alpha: 0.35),
                                Colors.transparent,
                                banner.gradient.last.withValues(alpha: 0.25),
                              ],
                            ),
                          ),
                        ),

                        // Content layout
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.gold,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.gold.withValues(alpha: 0.35),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  banner.tag,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    banner.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.3,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black,
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    banner.subtitle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.90),
                                      fontSize: 12,
                                      height: 1.3,
                                      shadows: const [
                                        Shadow(
                                          color: Colors.black87,
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      banner.ctaText,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: AppColors.gold,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 14,
                                    color: AppColors.gold,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (index) {
            final isCurrent = index == _currentPage;
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isCurrent ? 24 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isCurrent
                    ? AppColors.gold
                    : (isDark ? AppColors.darkBorder : AppColors.lightTextMuted.withValues(alpha: 0.4)),
                borderRadius: BorderRadius.circular(3),
                boxShadow: isCurrent && isDark
                    ? [
                        BoxShadow(
                          color: AppColors.gold.withValues(alpha: 0.4),
                          blurRadius: 6,
                        ),
                      ]
                    : null,
              ),
            );
          }),
        ),
      ],
    );
  }
}
