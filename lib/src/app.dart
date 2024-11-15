import 'package:flutter/material.dart';
import 'package:house_prediction/src/screen/home/home_screen.dart';
import 'package:house_prediction/src/screen/splash/splash_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),

      home: SplashScreen(),
    );
  }
}
