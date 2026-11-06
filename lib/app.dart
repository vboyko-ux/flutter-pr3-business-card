import 'package:flutter/material.dart';

import 'screens/card_screen.dart';

/// Кореневий віджет. Режим теми зберігається у State, тому
/// Hot Reload його не скидає, а Hot Restart повертає до початкового.
class BusinessCardApp extends StatefulWidget {
  const BusinessCardApp({super.key});

  @override
  State<BusinessCardApp> createState() => _BusinessCardAppState();
}

class _BusinessCardAppState extends State<BusinessCardApp> {
  ThemeMode _themeMode = ThemeMode.light;

  bool get _isDark => _themeMode == ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode = _isDark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  static const Color _seed = Colors.indigo;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Візитівка розробника',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _seed),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: CardScreen(isDark: _isDark, onToggleTheme: _toggleTheme),
    );
  }
}
