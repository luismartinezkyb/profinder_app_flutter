import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    fontSize: 30.0,
    fontWeight: FontWeight.bold,
  );
  final colorizeTextStyle2 = TextStyle(
    fontSize: 25.0,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    String greeting() {
      var hour = DateTime.now().hour;
      if (hour < 12) {
        return 'Morning';
      }
      if (hour < 17) {
        return 'Afternoon';
      }
      return 'Evening';
    }

    print('Hi user, good${greeting()}');
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
      Fluttertoast.showToast(
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          msg: 'Session closed successfully');
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
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Text('Bienvenido ${nameUser}'),
      //   backgroundColor: Theme.of(context).backgroundColor,
      // ),
      body: Column(
        children: [
          Container(
            height: kheight / 2.43,
            width: kwidth,
            child: Stack(
              children: [
                Positioned(
                  child: Container(
                    color: kPrimaryLightColor,
                    height: 260,
                    width: kwidth,
                    child: Text(''),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: kheight * .07,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                        'Hi, ${nameUser}',
                        speed: Duration(milliseconds: 400),
                        textStyle:
                            GoogleFonts.poppins(textStyle: colorizeTextStyle),
                        colors: colorizeColors,
                      ),
                      ColorizeAnimatedText(
                        'Hi, ${nameUser}',
                        speed: Duration(milliseconds: 400),
                        textStyle:
                            GoogleFonts.poppins(textStyle: colorizeTextStyle),
                        colors: colorizeColors,
                      ),
                      ColorizeAnimatedText(
                        'Hi, ${nameUser}',
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
                  left: 40,
                  top: kheight * .13,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                        'Good ${greeting()}!',
                        speed: Duration(milliseconds: 400),
                        textStyle:
                            GoogleFonts.poppins(textStyle: colorizeTextStyle2),
                        colors: colorizeColors,
                      ),
                      ColorizeAnimatedText(
                        'Good ${greeting()}!',
                        speed: Duration(milliseconds: 400),
                        textStyle:
                            GoogleFonts.poppins(textStyle: colorizeTextStyle2),
                        colors: colorizeColors,
                      ),
                      ColorizeAnimatedText(
                        'Good ${greeting()}!',
                        speed: Duration(milliseconds: 400),
                        textStyle:
                            GoogleFonts.poppins(textStyle: colorizeTextStyle2),
                        colors: colorizeColors,
                      ),
                    ],
                    isRepeatingAnimation: true,
                    onTap: () {},
                  ),
                ),
                //USER FOTO
                Positioned(
                  left: 10,
                  top: kheight / 4.5,
                  child: buildNewCircle(
                      kPrimaryColor,
                      ClipOval(
                          child: Material(
                              color: Colors.transparent, child: futuro))),
                ),
                Positioned(
                  left: kwidth * .70,
                  top: kheight / 4,
                  child: ColorWidgetSwitch(tema),
                ),
                // child: Image.asset(
                //     tema.getImage3Theme(),
                //     width: 100,
                //     height: 100,
                //   ),
                //mover esto a un lugar mejor
              ],
            ),
          ),
          Expanded(
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: .8),
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              children: [
                callContainer(
                    'Find your class',
                    "In this section you'll be able to search for your favorite class or subject.",
                    kPrimaryLightColor, () {
                  indexScreen.setIndex(0);
                }, 'search_icon.png'),
                callContainer(
                    'User Profile',
                    "You can see and change some of your user information.",
                    kPrimaryLightColor, () {
                  indexScreen.setIndex(1);
                }, 'user_profile_icon.png'),
                callContainer(
                    'Messages',
                    "Come here to see all the conversations with your teachers",
                    kPrimaryLightColor, () {
                  indexScreen.setIndex(3);
                }, 'messages_icon.png'),
                callContainer(
                    'Settings',
                    "You're able to change the settings of your app here, let's do it.",
                    kPrimaryLightColor, () {
                  indexScreen.setIndex(4);
                }, 'settings_icon.png'),
                callContainer(
                    'Log Out',
                    "If you want to log out and close your session then touch me.",
                    kPrimaryLightColor, () {
                  logOut();
                }, 'logout_icon.png'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget callContainer(String title, String subtitle, Color ligthColor,
      VoidCallback onClicked, String icono) {
    return GestureDetector(
      onTap: () {
        onClicked();
      },
      child: Card(
        //A8A77A

        color: Theme.of(context).primaryColorDark.withOpacity(.7),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(
              height: 15,
            ),
            Image.asset(
              'assets/icons/$icono',
              width: 90,
            ),
            SizedBox(
              height: 15,
            ),
            //Positioned(bottom: 5, right: 5, child: Icon(icono)),
            Text(
              '$title',
              style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '$subtitle',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                  textStyle: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              )),
            ),
          ]),
        ),
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
