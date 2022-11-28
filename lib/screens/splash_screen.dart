import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:profinder_app_flutter/screens/login_screen.dart';
import 'package:profinder_app_flutter/screens/student/dashboard_screen.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Widget newNavigate() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Something went wrong!'),
          );
        }
        if (snapshot.hasData) {
          print('user logged with: ${snapshot.data}');
          //FirebaseAuth.instance.currentUser!.providerData[0].providerId;

          if (snapshot.data!.providerData[0].providerId == 'password') {
            if (snapshot.data!.emailVerified) {
              return DashBoardScreen();
            } else {
              //FirebaseAuth.instance.signOut();
              return LoginScreen();
            }
          } else {
            return DashBoardScreen();
          }
        } else {
          print('user not logged');
          return LoginScreen();
        }
      },
    );

    // if (verifyUser) {
    //   return DashBoardScreen2();
    // } else {
    //   return LoginScreen();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: newNavigate(),
      duration: 3500,
      imageSize: 450,
      imageSrc: "assets/icons/flutter_icono_transparente.png",
      textType: TextType.ScaleAnimatedText,
      textStyle: const TextStyle(
        fontSize: 30.0,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
    //Theme.of(context).backgroundColor
  }
}
