import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'features/splash/splash_flow.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFFF5F0E8),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const RajKollectionsApp());
}

class RajKollectionsApp extends StatelessWidget {
  const RajKollectionsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raj Kollections',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplashFlow(),
    );
  }
}
