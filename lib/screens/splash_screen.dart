import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:profinder_app_flutter/screens/login_screen.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: LoginScreen(),
      duration: 3500,
      imageSize: 450,
      imageSrc: "assets/icons/flutter_icono_transparente.png",
      textType: TextType.ScaleAnimatedText,
      textStyle: const TextStyle(
        fontSize: 30.0,
      ),
      backgroundColor: Colors.white,
    );
    //Theme.of(context).backgroundColor
  }
}
