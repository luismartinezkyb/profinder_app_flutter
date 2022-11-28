import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:profinder_app_flutter/provider/google_provider.dart';
import 'package:profinder_app_flutter/provider/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../firebase/google_authentication.dart';
import '../../provider/loading_provider.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  String loggedWith = '';
  String email = '';
  String nameUser = '';

  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;
  bool _checking = true;

  final userFirebase = FirebaseAuth.instance.currentUser!;
  //final GoogleAuthentication _googleAuth = GoogleAuthentication();

  @override
  void initState() {
    _checkIfLogged();
    super.initState();
  }

  _checkIfLogged() async {
    final accessToken = await FacebookAuth.instance.accessToken;
    if (accessToken != null) {
      final userData = await FacebookAuth.instance.getUserData();
      _accessToken = accessToken;
      setState(() {
        _userData = userData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //loggedWith = FirebaseAuth.instance.currentUser!.providerData[0].providerId;
    ThemeProvider tema = Provider.of<ThemeProvider>(context);
    LoadingProvider watch = Provider.of<LoadingProvider>(context);

    void logOut() {
      switch (loggedWith) {
        case 'facebook.com':
          print('Cerrando sesión de facebook');
          FacebookAuth.instance.logOut();
          FirebaseAuth.instance.signOut();
          break;
        case 'password':
          print('Cerrando sesión con email y password');
          FirebaseAuth.instance.signOut();
          break;
        case 'google.com':
          print('Cerrando sesión de google');
          //FirebaseAuth.instance.signOut();
          final provider =
              Provider.of<GoogleSignInProvider>(context, listen: false);
          provider.logout();
          break;
        // case 'github.com':
        //   print('Cerrando sesión de github');
        //   FirebaseAuth.instance.signOut();
        //   break;
        default:
          FirebaseAuth.instance.signOut();
          break;
      }

      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }

    print('USUARIO FIREBASE: ${userFirebase}');
    // print(
    //     'logged with: ${FirebaseAuth.instance.currentUser!.providerData[0].providerId}');
    loggedWith = userFirebase.providerData[0].providerId;
    var checkimage = '';
    var userPhoto = '';

    switch (loggedWith) {
      case 'facebook.com':
        _userData != null
            ? userPhoto = _userData!['picture']['data']['url']
            : print('THERE is nothing');
        print('Es con Facebook el user');
        checkimage = 'assets/facebook_logo.png';
        //print(FacebookAuth.instance.accessToken.token);

        break;
      case 'password':
        checkimage = 'assets/email_logo.png';
        print('Es con Email y password el user');
        break;
      case 'google.com':
        userPhoto = userFirebase.photoURL!;
        checkimage = 'assets/google_logo.png';
        print('Es con Google el user');
        break;
      case 'github.com':
        userPhoto = userFirebase.photoURL!;
        checkimage = 'assets/github_logo.png';
        print('Es con Github el user');
        break;
      default:
        checkimage = 'assets/pokebola2.png';

        break;
    }
    nameUser = userFirebase.displayName != null
        ? userFirebase.displayName!
        : 'errorname';

    email = userFirebase.email!;

    return Scaffold(
      appBar: AppBar(
        title: Text('DashBoard'),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: Center(
          child: Column(
        children: [
          CircleAvatar(
              backgroundImage: NetworkImage(userPhoto.length != 0
                  ? '$userPhoto'
                  : 'http://www.gravatar.com/avatar/?d=mp')),
          Text('$nameUser'),
          Text('$email'),
          ElevatedButton(
            child: Text('LogOut'),
            onPressed: () {
              watch.setIfLoading(false);
              logOut();
            },
          ),
        ],
      )),
    );
  }
}
