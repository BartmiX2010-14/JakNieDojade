import 'package:flutter/material.dart';
import 'dart:ui';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onFinished;
  const OnboardingScreen({Key? key, required this.onFinished}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.auto_awesome_rounded,
      'color': Color(0xFF6366F1),
      'title': 'Inteligencja Emocjonalna',
      'desc': 'AI, które rozumie Twoją sytuację. Generujemy wymówki, które brzmią naturalnie i wiarygodnie.',
    },
    {
      'icon': Icons.bolt_rounded,
      'color': Color(0xFF8B5CF6),
      'title': 'Błyskawiczne Akcje',
      'desc': 'Stoisz w korku? Jednym tapnięciem poinformuj wszystkich w Twoim unikalnym stylu.',
    },
    {
      'icon': Icons.security_rounded,
      'color': Color(0xFF06B6D4),
      'title': 'Darmowe AI na zawsze',
      'desc': 'Korzystaj z potęgi Gemini AI bez żadnych opłat. Twoja prywatność i Twój klucz są u nas bezpieczne.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF020617),
                  (_pages[_currentPage]['color'] as Color).withOpacity(0.2),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _pages.length,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemBuilder: (context, index) {
                      final page = _pages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 48.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(40),
                              decoration: BoxDecoration(
                                color: (page['color'] as Color).withOpacity(0.1),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(color: (page['color'] as Color).withOpacity(0.2), blurRadius: 40, spreadRadius: 10),
                                ],
                              ),
                              child: Icon(page['icon'] as IconData, size: 80, color: page['color'] as Color),
                            ),
                            const SizedBox(height: 60),
                            Text(
                              page['title'] as String,
                              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              page['desc'] as String,
                              style: TextStyle(fontSize: 17, color: Colors.white.withOpacity(0.6), height: 1.6),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: List.generate(
                          _pages.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 10),
                            width: _currentPage == i ? 30 : 10,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _currentPage == i ? (_pages[i]['color'] as Color) : Colors.white12,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_currentPage < _pages.length - 1) {
                            _controller.nextPage(duration: const Duration(milliseconds: 600), curve: Curves.easeOutQuart);
                          } else {
                            widget.onFinished();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _pages[_currentPage]['color'] as Color,
                          minimumSize: const Size(120, 56),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: Text(
                          _currentPage < _pages.length - 1 ? 'Dalej' : 'Gotowe',
                          style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
