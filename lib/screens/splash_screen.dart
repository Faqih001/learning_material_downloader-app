import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2563EB),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isWide ? 64 : 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.school,
                    size: isWide ? 160 : 100,
                    color: Colors.white,
                  ),
                  SizedBox(height: isWide ? 40 : 24),
                  Text(
                    'Learning Material Downloader',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isWide ? 38 : null,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isWide ? 28 : 16),
                  const CircularProgressIndicator(color: Colors.white),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
