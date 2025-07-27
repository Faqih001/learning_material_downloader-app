import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'utils/theme.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/upload_screen.dart';
// import 'screens/chatbot_screen.dart';
import 'screens/chat_page.dart';
import 'screens/map_screen.dart';

import 'package:uni_links/uni_links.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(const LearningDownloaderApp());
}

class LearningDownloaderApp extends StatefulWidget {
  const LearningDownloaderApp({super.key});

  @override
  State<LearningDownloaderApp> createState() => _LearningDownloaderAppState();
}

class _LearningDownloaderAppState extends State<LearningDownloaderApp> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _sub = uriLinkStream.listen((Uri? uri) async {
      if (uri != null &&
          uri.scheme == 'learningmaterialdownloader' &&
          uri.host == 'login-callback') {
        // Complete Supabase sign-in from deep link
        await Supabase.instance.client.auth.getSessionFromUrl(uri.toString());
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learning Downloader',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const HomeScreen(),
        '/search': (context) => const SearchScreen(),
        '/upload': (context) => const UploadScreen(),
        // '/chatbot': (context) => const ChatbotScreen(),
        '/map': (context) => const MapScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/chat': (context) => const ChatPage(),
      },
    );
  }
}
