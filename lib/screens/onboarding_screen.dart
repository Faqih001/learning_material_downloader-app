import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      icon: Icons.menu_book,
      title: 'Access Learning Materials',
      description:
          'Browse and download a variety of educational resources for your studies.',
    ),
    _OnboardingPage(
      icon: Icons.location_on,
      title: 'Find Nearby Libraries',
      description:
          'Locate libraries near you and explore their collections easily.',
    ),
    _OnboardingPage(
      icon: Icons.smart_toy,
      title: 'AI Study Assistant',
      description:
          'Get help from an AI assistant to boost your learning experience.',
    ),
  ];

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/auth');
    }
  }

  void _onSkip() {
    Navigator.pushReplacementNamed(context, '/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;
          return SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWide ? 600 : double.infinity,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 48 : 24,
                    vertical: isWide ? 32 : 0,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _controller,
                          itemCount: _pages.length,
                          onPageChanged:
                              (index) => setState(() => _currentPage = index),
                          itemBuilder: (context, index) => _pages[index],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: isWide ? 32 : 24,
                        ),
                        child: SmoothPageIndicator(
                          controller: _controller,
                          count: _pages.length,
                          effect: const WormEffect(
                            dotColor: Colors.grey,
                            activeDotColor: Color(0xFF2563EB),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isWide ? 32 : 24,
                          vertical: isWide ? 16 : 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: TextButton(
                                onPressed: _onSkip,
                                style: TextButton.styleFrom(
                                  textStyle: TextStyle(
                                    fontSize: isWide ? 18 : 16,
                                  ),
                                ),
                                child: const Text('Skip'),
                              ),
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: ElevatedButton(
                                onPressed: _onNext,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2563EB),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isWide ? 32 : 20,
                                    vertical: isWide ? 18 : 12,
                                  ),
                                  textStyle: TextStyle(
                                    fontSize: isWide ? 18 : 16,
                                  ),
                                ),
                                child: Text(
                                  _currentPage == _pages.length - 1
                                      ? 'Get Started'
                                      : 'Next',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 48 : 32,
        vertical: isWide ? 64 : 48,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: isWide ? 140 : 100, color: const Color(0xFF2563EB)),
          SizedBox(height: isWide ? 48 : 32),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: isWide ? 30 : null,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isWide ? 24 : 16),
          Text(
            description,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontSize: isWide ? 20 : null),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
