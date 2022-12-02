import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profinder_app_flutter/screens/design/background.dart';
import 'package:provider/provider.dart';

import '../../firebase/google_authentication.dart';
import '../../models/user_model.dart';
import '../../provider/index_screen_provider.dart';
import '../../provider/theme_provider.dart';
import '../design/switch_mode.dart';

class HomeStudentScreen extends StatefulWidget {
  const HomeStudentScreen({Key? key}) : super(key: key);

  @override
  State<HomeStudentScreen> createState() => _HomeStudentScreenState();
}

class _HomeStudentScreenState extends State<HomeStudentScreen> {
  String loggedWith = '';
  String email = '';
  String nameUser = '';
  String? imageString = '';
  late String imageUsuario = "";
  //BOTTOM BAR

  //final navigationKey = GlobalKey<CurvedNavigationBarState>();

  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;
  bool _checking = true;

  final userFirebase = FirebaseAuth.instance.currentUser!;
  final GoogleAuthentication _googleAuth = GoogleAuthentication();

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

  final colorizeTextStyle = TextStyle(
    fontSize: 50.0,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    //loggedWith = FirebaseAuth.instance.currentUser!.providerData[0].providerId;
    ThemeProvider tema = Provider.of<ThemeProvider>(context);
    ChangingIndexScreen indexScreen = Provider.of<ChangingIndexScreen>(context);
    var kPrimaryColor = Theme.of(context).primaryColorDark;
    var kPrimaryLightColor = Theme.of(context).primaryColorLight;
    var kTextColor = Theme.of(context).primaryColorDark;
    var kwidth = MediaQuery.of(context).size.width;
    var kheight = MediaQuery.of(context).size.height;
    final colorizeColors = [
      Theme.of(context).primaryColorDark,
      Colors.purpleAccent,
      Theme.of(context).backgroundColor,
      Colors.greenAccent,
      Theme.of(context).primaryColorDark,
    ];
    final items = [
      Icon(Icons.search, size: 30),
      Icon(Icons.person, size: 30),
      Icon(Icons.home, size: 30),
      Icon(Icons.message, size: 30),
      Icon(Icons.settings, size: 30),
    ];

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
          _googleAuth.logout();
          FirebaseAuth.instance.signOut();
          break;
        case 'github.com':
          print('Cerrando sesión de github');
          FirebaseAuth.instance.signOut();
          break;
        default:
          FirebaseAuth.instance.signOut();
          break;
      }

      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }

    //print('USUARIO FIREBASE: ${userFirebase}');
    // print(
    //     'logged with: ${FirebaseAuth.instance.currentUser!.providerData[0].providerId}');
    loggedWith = userFirebase.providerData[0].providerId;
    var checkimage = '';
    var userPhoto = '';
    Future<UserModel?> readUser() async {
      final docUser = FirebaseFirestore.instance
          .collection('users')
          .doc(userFirebase.email);
      final snapshot = await docUser.get();
      if (snapshot.exists) {
        return UserModel.fromJson(snapshot.data()!);
      }
    }

    final futuro = FutureBuilder<UserModel?>(
      future: readUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //print('Checamos que es lo que tiene ${snapshot.data!.image}');

          imageUsuario = snapshot.data!.image != ''
              ? snapshot.data!.image
              : imageString!.length != 0
                  ? imageString!
                  : 'http://www.gravatar.com/avatar/?d=mp';

          return GestureDetector(
            onTap: null,
            child: CachedNetworkImage(
              imageUrl: imageUsuario,
              fit: BoxFit.cover,
              width: 150,
              height: 150,
            ),
            // child: Image.file(
            //   File(imageUsuario),
            //   fit: BoxFit.cover,
            //   width: 200,
            //   height: 200,
            // ),
          );
        }
        if (snapshot.hasError) {
          return Ink.image(
            image: NetworkImage('http://www.gravatar.com/avatar/?d=mp'),
            fit: BoxFit.cover,
            width: 200,
            height: 200,
            child: InkWell(onTap: null),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

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
        //print(userFirebase);
        userPhoto = '';
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
        automaticallyImplyLeading: false,
        title: Text('Bienvenido ${nameUser}'),
        backgroundColor: Theme.of(context).backgroundColor,
        actions: [
          ColorWidgetRow(tema),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Container(
        height: kheight,
        width: kwidth,
        child: Stack(
          children: [
            Positioned(
              child: Container(
                color: kPrimaryLightColor,
                height: 200,
                width: kwidth,
                child: Text(''),
              ),
            ),
            Positioned(
              left: kwidth / 5,
              top: kheight / 27,
              child: AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText(
                    'Profinder',
                    speed: Duration(milliseconds: 400),
                    textStyle:
                        GoogleFonts.poppins(textStyle: colorizeTextStyle),
                    colors: colorizeColors,
                  ),
                  ColorizeAnimatedText(
                    'Profinder',
                    speed: Duration(milliseconds: 400),
                    textStyle:
                        GoogleFonts.poppins(textStyle: colorizeTextStyle),
                    colors: colorizeColors,
                  ),
                  ColorizeAnimatedText(
                    'Profinder',
                    speed: Duration(milliseconds: 400),
                    textStyle:
                        GoogleFonts.poppins(textStyle: colorizeTextStyle),
                    colors: colorizeColors,
                  ),
                ],
                isRepeatingAnimation: true,
                onTap: () {},
              ),
            ),
            Positioned(
              left: kwidth / 3.2,
              top: kheight / 7,
              child: buildNewCircle(
                  kPrimaryColor,
                  ClipOval(
                      child:
                          Material(color: Colors.transparent, child: futuro))),
            ),
            Positioned(
              top: kheight / 2.8,
              child: Container(
                width: kwidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    callContainer('Look up for a class', kPrimaryLightColor,
                        () {
                      indexScreen.setIndex(0);
                    }, Icons.search),
                    callContainer('Conversations', kPrimaryLightColor, () {
                      indexScreen.setIndex(3);
                    }, Icons.telegram),
                  ],
                ),
              ),
            ),
            Positioned(
              top: kheight / 1.7,
              child: Container(
                width: kwidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    callContainer('Edit user data', kPrimaryLightColor, () {
                      indexScreen.setIndex(1);
                    }, Icons.person),
                    callContainer('Settings', kPrimaryLightColor, () {
                      indexScreen.setIndex(4);
                    }, Icons.settings),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget callContainer(
      String title, Color ligthColor, VoidCallback onClicked, IconData icono) {
    return GestureDetector(
      onTap: () {
        onClicked();
      },
      child: Container(
        padding: EdgeInsets.all(20),
        height: 170,
        width: 160,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: ligthColor),
        child: Column(children: [
          buildNewCircle(
              Theme.of(context).primaryColorDark.withOpacity(.7),
              Icon(
                icono,
                size: 60,
                color: ligthColor,
              )),
          SizedBox(
            height: 10,
          ),
          Text('$title',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(textStyle: TextStyle()))
        ]),
      ),
    );
  }

  Widget buildNewCircle(Color color, Widget boy) => buildCircle(
        color: color,
        all: 2,
        child: buildCircle(
          color: color,
          all: 1,
          child: boy,
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
