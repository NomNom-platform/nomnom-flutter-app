import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Welcome to NomNom',
      'subtitle': 'Your personal guide to discovering the best local food, tailored just for you.',
      'image': AppConstants.mockFood1,
    },
    {
      'title': 'Eat Healthy, Effortlessly',
      'subtitle': 'We make healthy eating simple by finding the right meals that fit your lifestyle.',
      'image': AppConstants.mockFood2,
    },
    {
      'title': 'AI-Powered Recommendations',
      'subtitle': 'Our smart AI learns your taste and nutritional goals to suggest the perfect dish every time.',
      'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuC1BH87THuc4UQJnULbik757fro1zTkMNKJ2uX1KY-HbbYB-w6Iqe1T8s_9KipxbshRNEX8xhAc8MjL-V8pmgj_z4K1yYQ5HlAjEniDx7VfyYZZ7emDo4_QST4lZEaz-og32rBWpxWs6UVkOWGBjbqt-m7JobwcitmvkY4ttPm452YXSi_TDfRr9YzO4sc7JmeMeKPtAEj7jn3REoC1xA08es_q1ohRGXTyTl_EWN7efvrR-uuYiO2hwOk8tKP-FzQRabJRvOC_zs4p',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 256,
                          width: 256,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(48),
                            image: DecorationImage(
                              image: NetworkImage(_pages[index]['image']!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          _pages[index]['title']!,
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontSize: 28,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _pages[index]['subtitle']!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 16 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.push('/login');
                      },
                      child: const Text('Sign Up'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: theme.textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push('/login');
                        },
                        child: Text(
                          'Login',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
