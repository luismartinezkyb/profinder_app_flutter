import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:profinder_app_flutter/provider/google_provider.dart';
import 'package:profinder_app_flutter/provider/index_screen_provider.dart';
import 'package:profinder_app_flutter/provider/theme_provider.dart';
import 'package:profinder_app_flutter/screens/student/home_student_screen.dart';
import 'package:profinder_app_flutter/screens/student/messages_student_screen.dart';
import 'package:profinder_app_flutter/screens/student/profile_student_screen.dart';
import 'package:profinder_app_flutter/screens/student/search_student_screen.dart';
import 'package:profinder_app_flutter/screens/student/settings_student_screen.dart';
import 'package:profinder_app_flutter/settings/style_settings.dart';
import 'package:provider/provider.dart';

import '../../firebase/google_authentication.dart';
import '../../provider/loading_provider.dart';
import '../design/switch_mode.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  // String loggedWith = '';
  // String email = '';
  // String nameUser = '';
  //BOTTOM BAR
  int index = 2;
  final screens = [
    SearchStudentScreen(),
    ProfileStudentScreen(),
    HomeStudentScreen(),
    MessagesScreen(),
    SettingsStudentScreen()
  ];

  final navigationKey = GlobalKey<CurvedNavigationBarState>();

  // Map<String, dynamic>? _userData;
  // AccessToken? _accessToken;
  //bool _checking = true;

  // final userFirebase = FirebaseAuth.instance.currentUser!;
  // final GoogleAuthentication _googleAuth = GoogleAuthentication();

  @override
  void initState() {
    //_checkIfLogged();
    super.initState();
  }

  // _checkIfLogged() async {
  //   final accessToken = await FacebookAuth.instance.accessToken;
  //   if (accessToken != null) {
  //     final userData = await FacebookAuth.instance.getUserData();
  //     _accessToken = accessToken;
  //     setState(() {
  //       _userData = userData;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    //loggedWith = FirebaseAuth.instance.currentUser!.providerData[0].providerId;
    ThemeProvider tema = Provider.of<ThemeProvider>(context);
    ChangingIndexScreen indexScreen = Provider.of<ChangingIndexScreen>(context);
    var kPrimaryColor = Theme.of(context).primaryColorDark;
    var kPrimaryLightColor = Theme.of(context).primaryColorLight;
    final items = [
      Icon(Icons.search, size: 30),
      Icon(Icons.person, size: 30),
      Icon(Icons.home, size: 30),
      Icon(Icons.message, size: 30),
      Icon(Icons.settings, size: 30),
    ];

    return ClipRRect(
      child: Scaffold(
          bottomNavigationBar: CurvedNavigationBar(
            key: navigationKey,
            index: indexScreen.getIndex(),
            color: kPrimaryLightColor,
            backgroundColor: Colors.transparent,
            buttonBackgroundColor: kPrimaryLightColor,
            height: 60,
            items: items,
            onTap: (val) {
              indexScreen.setIndex(val);
              //print('$index');
            },
          ),
          body: screens[indexScreen.getIndex()]),
    );
  }
  //final navigationState = navigationKey.currentState!;
  //navigationState.setPage(0);
}
