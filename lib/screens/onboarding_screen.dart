import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;
  int _page = 0;

  static const List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      brand: 'Eats.',
      title: 'Discover local\nhidden gems.',
      accentLine: 1,
      description:
          'Explore a curated selection of the finest restaurants and street eats in your neighborhood.',
      imageUrl:
          'https://www.figma.com/api/mcp/asset/fb77541f-43d7-4503-8dad-f773fa014d50',
      imageHeight: 486,
      imageRadius: 0,
      imageFit: BoxFit.cover,
      footer: '',
    ),
    _OnboardingPageData(
      brand: 'RapidBite',
      title: 'Fast Delivery',
      description:
          "Experience the joy of fresh food arriving at your doorstep while it's still piping hot and full of flavor.",
      imageUrl:
          'https://www.figma.com/api/mcp/asset/0e2d1319-a80c-4c98-a086-581629cee47b',
      imageHeight: 466,
      imageRadius: 40,
      imageFit: BoxFit.cover,
      badgeText: 'ETA: 15 Mins',
      footer: 'Powered by RapidBite logistics',
    ),
    _OnboardingPageData(
      brand: '',
      title: 'Easy Payment',
      description:
          'Enjoy seamless checkout with KHQR, local, and international cards. Secure, fast, and completely hassle-free.',
      imageUrl:
          'https://www.figma.com/api/mcp/asset/4b8fb447-5726-4792-a865-00fd3466b5ed',
      imageHeight: 280,
      imageRadius: 40,
      imageFit: BoxFit.cover,
      badgeText: 'Payment Successful',
      secondaryBadgeText: 'Visa / Master',
      footer: '',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_page == _pages.length - 1) {
      Navigator.of(context).pushReplacementNamed('/login');
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _skip() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F6),
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) => setState(() => _page = index),
              itemBuilder: (context, index) {
                return _OnboardingPage(
                  data: _pages[index],
                  index: index,
                  page: _page,
                  pageCount: _pages.length,
                  onNext: _goNext,
                  onBack: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                    );
                  },
                );
              },
            ),
            Positioned(
              left: 20,
              right: 20,
              top: 14,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _pages[_page].brand,
                    style: TextStyle(
                      color: _page == 0
                          ? Colors.white
                          : const Color(0xFFAB3500),
                      fontSize: _page == 0 ? 24 : 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextButton(
                    onPressed: _skip,
                    style: TextButton.styleFrom(
                      foregroundColor: _page == 0
                          ? Colors.white
                          : const Color(0xFF594139),
                    ),
                    child: const Text(
                      'Skip',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingPageData data;
  final int index;
  final int page;
  final int pageCount;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _OnboardingPage({
    required this.data,
    required this.index,
    required this.page,
    required this.pageCount,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final isFirst = index == 0;
    final isLast = index == pageCount - 1;

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight:
              MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.vertical,
        ),
        child: Column(
          children: [
            SizedBox(
              height: isFirst ? 486 : 530,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: isFirst ? 0 : 20,
                    right: isFirst ? 0 : 20,
                    top: isFirst ? 0 : 64,
                    height: data.imageHeight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(data.imageRadius),
                      child: Image.network(
                        data.imageUrl,
                        fit: data.imageFit,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(color: const Color(0xFFECE4DE));
                        },
                      ),
                    ),
                  ),
                  if (isFirst)
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.0, 0.74, 1.0],
                            colors: [
                              Colors.black.withValues(alpha: 0.25),
                              Colors.transparent,
                              const Color(0xFFFFF8F6),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (data.badgeText != null)
                    Positioned(
                      left: isLast ? 80 : 44,
                      right: isLast ? 80 : null,
                      bottom: isLast ? 126 : 24,
                      child: _GlassBadge(
                        icon: isLast ? Icons.check_circle : Icons.timer,
                        text: data.badgeText!,
                      ),
                    ),
                  if (data.secondaryBadgeText != null)
                    Positioned(
                      left: 12,
                      bottom: 132,
                      child: _GlassBadge(
                        icon: Icons.credit_card,
                        text: data.secondaryBadgeText!,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, isFirst ? 24 : 24, 20, 40),
              child: Column(
                children: [
                  _Dots(page: page, count: pageCount),
                  const SizedBox(height: 24),
                  _OnboardingTitle(data: data),
                  const SizedBox(height: 16),
                  Text(
                    data.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF594139),
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: isFirst ? 64 : 40),
                  SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B35),
                        elevation: 8,
                        shadowColor: const Color(0x4DFF6B35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isLast ? 'Get Started' : 'Next',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  if (isLast) ...[
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: onBack,
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Color(0xFF594139),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                  if (data.footer.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      data.footer,
                      style: const TextStyle(
                        color: Color(0xFF8D7168),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingTitle extends StatelessWidget {
  final _OnboardingPageData data;

  const _OnboardingTitle({required this.data});

  @override
  Widget build(BuildContext context) {
    final lines = data.title.split('\n');
    return Column(
      children: [
        for (var i = 0; i < lines.length; i++)
          Text(
            lines[i],
            textAlign: TextAlign.center,
            style: TextStyle(
              color: i == data.accentLine
                  ? const Color(0xFFFF6B35)
                  : const Color(0xFF261814),
              fontSize: 32,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
      ],
    );
  }
}

class _Dots extends StatelessWidget {
  final int page;
  final int count;

  const _Dots({required this.page, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final active = index == page;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: active ? 32 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFFF6B35) : const Color(0xFFE1BFB5),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}

class _GlassBadge extends StatelessWidget {
  final IconData icon;
  final String text;

  const _GlassBadge({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFAB3500), size: 16),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF261814),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPageData {
  final String brand;
  final String title;
  final int? accentLine;
  final String description;
  final String imageUrl;
  final double imageHeight;
  final double imageRadius;
  final BoxFit imageFit;
  final String? badgeText;
  final String? secondaryBadgeText;
  final String footer;

  const _OnboardingPageData({
    required this.brand,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.imageHeight,
    required this.imageRadius,
    required this.imageFit,
    required this.footer,
    this.accentLine,
    this.badgeText,
    this.secondaryBadgeText,
  });
}
