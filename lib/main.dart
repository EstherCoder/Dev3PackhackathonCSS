import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Transparent status bar so the dark bg bleeds through
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppTheme.bgBase,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  await Supabase.initialize(
    url: 'https://vkhowglgaxnagqbmvuah.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZraG93Z2xnYXhuYWdxYm12dWFoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgyMjgyOTgsImV4cCI6MjA5MzgwNDI5OH0.TXXL93c8rBk8oOT9q_hAx44SSKvsrusCnb-Kgf_FWFs',
  );

  runApp(const CampusShieldApp());
}

class CampusShieldApp extends StatelessWidget {
  const CampusShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Shield',
      theme: AppTheme.theme,
      home: const LoginScreen(),
    );
  }
}