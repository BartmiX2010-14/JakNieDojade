import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme/app_theme.dart';
import 'screens/main_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'providers/ai_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/auth_provider.dart' as app_auth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Błąd inicjalizacji Firebase: $e');
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AiProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => app_auth.AuthProvider()),
      ],
      child: const JakNieDojadeApp(),
    ),
  );
}

class JakNieDojadeApp extends StatelessWidget {
  const JakNieDojadeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dynamiczny motyw v6.0
    final profile = Provider.of<ProfileProvider>(context);
    
    ThemeMode mode;
    if (profile.themeMode == 'Ciemny') {
      mode = ThemeMode.dark;
    } else if (profile.themeMode == 'Jasny') {
      mode = ThemeMode.light;
    } else {
      mode = ThemeMode.system;
    }

    return MaterialApp(
      title: 'JakNieDojadę',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: mode,
      home: const AppNavigator(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppNavigator extends StatefulWidget {
  const AppNavigator({Key? key}) : super(key: key);

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

enum AppScreen { splash, onboarding, login, main }

class _AppNavigatorState extends State<AppNavigator> {
  AppScreen _currentScreen = AppScreen.splash;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<app_auth.AuthProvider>(context);

    if (auth.isLoggedIn && _currentScreen != AppScreen.splash) {
      return const MainScreen();
    }

    switch (_currentScreen) {
      case AppScreen.splash:
        return SplashScreen(onFinished: () async {
          final seen = await auth.hasSeenOnboarding();
          setState(() {
            _currentScreen = seen
                ? (auth.isLoggedIn ? AppScreen.main : AppScreen.login)
                : AppScreen.onboarding;
          });
        });
      case AppScreen.onboarding:
        return OnboardingScreen(onFinished: () async {
          await auth.markOnboardingSeen();
          setState(() {
            _currentScreen = auth.isLoggedIn ? AppScreen.main : AppScreen.login;
          });
        });
      case AppScreen.login:
        return const LoginScreen();
      case AppScreen.main:
        return const MainScreen();
    }
  }
}
