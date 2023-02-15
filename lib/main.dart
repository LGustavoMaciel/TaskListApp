import 'package:flutter/material.dart';
import 'package:flutter_sqlite_example/app/routes/app_routes.dart';
import 'package:flutter_sqlite_example/app/ui/android_screens/home/screens/home_screen.dart';
import 'package:flutter_sqlite_example/app/ui/android_screens/login/login_screen.dart';
import 'package:flutter_sqlite_example/app/ui/android_screens/splash/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Tarefas',
      theme: ThemeData(
        primaryColor: Colors.orangeAccent,
        scaffoldBackgroundColor: Colors.orange[900],
      ),
      routes: {
        AppRoutes.INITIAL: (ctx) => SplashScreenPage(),
        AppRoutes.LOGIN: (ctx) => LoginScreen(),
        AppRoutes.HOME: (ctx) => HomeScreen(),
      },
      initialRoute: AppRoutes.INITIAL,
    );
  }
}
