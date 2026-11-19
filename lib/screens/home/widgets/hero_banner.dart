import 'dart:async';
import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';

class HeroBannerItem {
  final String title;
  final String subtitle;
  final String amharicTitle;
  final String tag;
  final List<Color> gradient;
  final IconData icon;

  const HeroBannerItem({
    required this.title,
    required this.subtitle,
    required this.amharicTitle,
    required this.tag,
    required this.gradient,
    required this.icon,
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
      title: 'እንኳን ወደ ገበያ በደህና መጡ',
      subtitle: 'Experience shopping reimagined. Premium local & modern curated goods.',
      amharicTitle: 'WELCOME TO GEBEYA',
      tag: 'NEW ARRIVALS',
      gradient: [Color(0xFF0F766E), Color(0xFF0D9488), Color(0xFF115E59)],
      icon: Icons.storefront_rounded,
    ),
    HeroBannerItem(
      title: 'Ethiopian Specialty Coffee',
      subtitle: 'Direct from Yirgacheffe & Sidama highlands. Freshly roasted.',
      amharicTitle: 'የሀበሻ ስፔሻሊቲ ቡና',
      tag: 'UP TO 20% OFF',
      gradient: [Color(0xFF78350F), Color(0xFF92400E), Color(0xFFB45309)],
      icon: Icons.coffee_rounded,
    ),
    HeroBannerItem(
      title: 'Cyber & Modern Tech',
      subtitle: 'Next-gen ANC audio, mechanical keyboards, and wearables.',
      amharicTitle: 'ዘመናዊ የቴክኖሎጂ እቃዎች',
      tag: 'TECH FLASH SALE',
      gradient: [Color(0xFF1E1B4B), Color(0xFF312E81), Color(0xFF4338CA)],
      icon: Icons.headphones_rounded,
    ),
  ];

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
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: banner.gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: banner.gradient.first.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Subtle background decorative icon
                    Positioned(
                      right: -15,
                      bottom: -20,
                      child: Icon(
                        banner.icon,
                        size: 140,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
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
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(20),
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
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                banner.subtitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 12,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                banner.amharicTitle,
                                style: TextStyle(
                                  color: AppColors.accentLight,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 14,
                                color: AppColors.accentLight,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
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
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isCurrent ? 22 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isCurrent
                    ? AppColors.primary
                    : AppColors.lightTextMuted.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}
