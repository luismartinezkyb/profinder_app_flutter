import 'package:flutter/material.dart';
import 'package:profinder_app_flutter/constants.dart';
import 'package:profinder_app_flutter/screens/login_screen.dart';
import 'package:profinder_app_flutter/screens/signIn_screen.dart';
import 'package:profinder_app_flutter/screens/signUp_screen.dart';
import 'package:profinder_app_flutter/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profinder App',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (BuildContext context) => LoginScreen(),
        '/signin': (BuildContext context) => SignInScreen(),
        '/signup': (BuildContext context) => SignUpScreen()
      },
    );
  }
}
