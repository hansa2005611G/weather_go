import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/home/view/home_screen.dart';
import 'features/settings/viewmodel/settings_provider.dart';

Future<void> main() async {
  // REQUIRED for SharedPreferences & async services
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather Go',

      // LIGHT THEME
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,

        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,

        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFF5F5F5),
          border: OutlineInputBorder(),
        ),
      ),

      // DARK THEME
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,

        scaffoldBackgroundColor: Colors.black,
        cardColor: Color(0xFF1E1E1E),

        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF2A2A2A),
          border: OutlineInputBorder(),
        ),

        chipTheme: const ChipThemeData(
          backgroundColor: Color(0xFF2A2A2A),
          selectedColor: Colors.blue,
          labelStyle: TextStyle(color: Colors.white),
          brightness: Brightness.dark,
        ),
      ),

      // THEME MODE FROM SETTINGS (PERSISTED)
      themeMode:
          settings.darkMode ? ThemeMode.dark : ThemeMode.light,

      home: const HomeScreen(),
    );
  }
}
