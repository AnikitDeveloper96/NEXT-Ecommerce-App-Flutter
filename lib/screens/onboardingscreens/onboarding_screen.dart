import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;
  bool _showTitle = true;

  final List<String> _imagesAssets = [
    'assets/images/categoryofproducts.jpg',
    'assets/images/perfect_onboarding_screen.jpg',
    'assets/images/style.jpg',
  ];
  final List<String> imagesNetwork = [
    "https://images.unsplash.com/photo-1591085686350-798c0f9faa7f?q=80&w=1931&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://images.unsplash.com/photo-1483985988355-763728e1935b?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://images.unsplash.com/photo-1534452203293-494d7ddbf7e0?q=80&w=2072&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  ];

  final List<String> titles = [
    "Discover Your Style",
    "Effortless Shopping",
    "Shop with Confidence",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < imagesNetwork.length - 1) {
        _pageController.animateToPage(
          _currentPage + 1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      } else {
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _getStarted() {
    Navigator.pushReplacementNamed(context, '/welcomescreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: PageView.builder(
              physics:
                  const NeverScrollableScrollPhysics(), // Prevent manual swiping
              controller: _pageController,
              itemCount: imagesNetwork.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _showTitle = !_showTitle;
                    });
                  },
                  child: AnimatedScale(
                    scale: 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: Stack(
                      children: [
                        SizedBox.expand(
                          child: Image.network(
                            imagesNetwork[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.3),
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 60,
            child: Text(
              "Next",
              style: TextStyle(
                fontSize: 54,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(blurRadius: 4, color: Colors.black.withOpacity(0.5)),
                ],
              ),
            ),
          ),
          if (_showTitle)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              bottom: 280,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _showTitle ? 1.0 : 0.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Text(
                    titles[_currentPage],
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 180,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: AnimatedSmoothIndicator(
                activeIndex: _currentPage,
                count: imagesNetwork.length,
                effect: WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.white,
                  dotColor: Colors.grey.withOpacity(0.6),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: TextButton(
              onPressed: _getStarted,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: const Center(
                  child: Text(
                    'Get Started',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
