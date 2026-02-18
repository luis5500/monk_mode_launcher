import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Barras de estado y navegación en negro para coherencia con el tema
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      systemNavigationBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(
    const ProviderScope(
      child: MonkModeLauncherApp(),
    ),
  );
}

/// Punto de entrada de la aplicación. MaterialApp con tema oscuro minimalista.
class MonkModeLauncherApp extends StatelessWidget {
  const MonkModeLauncherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monk Mode Launcher',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.dark(
          surface: Colors.black,
          onSurface: Colors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
