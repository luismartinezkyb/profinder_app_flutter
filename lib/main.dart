import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:profinder_app_flutter/constants.dart';
import 'package:profinder_app_flutter/provider/classes_provider.dart';
import 'package:profinder_app_flutter/provider/google_provider.dart';
import 'package:profinder_app_flutter/provider/index_screen_provider.dart';
import 'package:profinder_app_flutter/provider/loading_provider.dart';
import 'package:profinder_app_flutter/provider/suscriptions_provider.dart';
import 'package:profinder_app_flutter/provider/theme_provider.dart';
import 'package:profinder_app_flutter/screens/login_screen.dart';

import 'package:profinder_app_flutter/screens/onboarding_screen.dart';
import 'package:profinder_app_flutter/screens/signIn_screen.dart';
import 'package:profinder_app_flutter/screens/signUp_screen.dart';
import 'package:profinder_app_flutter/screens/splash_screen.dart';
import 'package:profinder_app_flutter/screens/student/dashboard_screen.dart';
import 'package:profinder_app_flutter/screens/student/edit_profile_screen.dart';
import 'package:profinder_app_flutter/screens/student/messages_student_screen.dart';
import 'package:profinder_app_flutter/screens/student/profile_student_screen.dart';
import 'package:profinder_app_flutter/screens/student/search_student_screen.dart';
import 'package:profinder_app_flutter/screens/student/settings_student_screen.dart';
import 'package:profinder_app_flutter/screens/student/show_class_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  final int? counter = prefs.getInt('numTema');
  final int variable = counter != null ? counter : 1;

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? tokenMessage = await messaging.getToken();
  print('token from cloud_firestore: $tokenMessage');
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      // final docUser =
      //     FirebaseFirestore.instance.collection('notifications').doc();
      // final json = {
      //   'idNotification': docUser.id,
      //   'data': message.data,
      //   // 'from': message.from,
      //   // 'notification': message.notification,
      //   // 'ttl': message.ttl,
      //   // 'content': message.contentAvailable,
      //   // 'time': message.sentTime,
      //   // 'type': message.messageType,
      //   // 'category': message.category,
      // };
      // await docUser.set(json);
      print('Message also contained a notification: ${message.notification}');
    }
  });

  return runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (BuildContext context) =>
                  ThemeProvider(selectedTheme: variable)),
          ChangeNotifierProvider(
              create: (BuildContext context) =>
                  LoadingProvider(loading: false)),
          ChangeNotifierProvider(
              create: (BuildContext context) => ChangingIndexScreen(index: 2)),
          ChangeNotifierProvider(
              create: (BuildContext context) => GoogleSignInProvider()),
          ChangeNotifierProvider(
              create: (BuildContext context) => ClassProvider()),
          ChangeNotifierProvider(
              create: (BuildContext context) => SuscriptionsProvider())
        ],
        builder: (context, _) {
          return MyApp();
        }),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeProvider tema = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profinder App',
      theme: tema.getthemeData(),
      home: const SplashScreen(),
      routes: {
        '/login': (BuildContext context) => LoginScreen(),
        '/signin': (BuildContext context) => SignInScreen(),
        '/signup': (BuildContext context) => SignUpScreen(),
        '/dashboard': (BuildContext context) => DashBoardScreen(),
        '/onboardingPage': (BuildContext context) => OnboardingScreen(),
        '/messagesPage': (BuildContext context) => MessagesScreen(),
        '/searchPage': (BuildContext context) => SearchStudentScreen(),
        '/settingsPage': (BuildContext context) => SettingsStudentScreen(),
        '/profilePage': (BuildContext context) => ProfileStudentScreen(),
        '/editProfilePage': (BuildContext context) => EditProfileScreen(),
        '/showClassInfo': (BuildContext context) => ShowClassInfoScreen(),
      },
    );
  }
}
