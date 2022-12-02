import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profinder_app_flutter/provider/loading_provider.dart';

import 'package:profinder_app_flutter/screens/authentication_screen.dart';
import 'package:provider/provider.dart';

import '../firebase/github_authentication.dart';
import '../firebase/google_authentication.dart';
import '../provider/theme_provider.dart';
import 'design/background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  GithubAuthentication file = GithubAuthentication();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _logInWithFacebook() async {
    setState(() {
      loading = true;
    });
    try {
      final facebookLoginResult = await FacebookAuth.instance.login();
      print(facebookLoginResult.status);
      if (facebookLoginResult.status == LoginStatus.success) {
        final facebookAuthCredential = FacebookAuthProvider.credential(
            facebookLoginResult.accessToken!.token);
        await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);

        final userData = await FacebookAuth.instance.getUserData();

        final docUser = FirebaseFirestore.instance
            .collection('users')
            .doc(userData['email']);
        final json = {
          'name': userData['name'],
          'username': userData['name'],
          'email': userData['email'],
          'number': '',
          'role': 2,
          'picture': userData['picture']['data']['url'],
          'description': '',
          'level': '9.2',
        };
        await docUser.set(json);
        //asdasdasdasd
        Fluttertoast.showToast(
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.blue,
            msg: "Now you're logged in with Facebook");
        mounted
            ? Navigator.pushNamed(context, '/onboardingPage')
            : print('mounted');
      } else {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);

        Fluttertoast.showToast(
            gravity: ToastGravity.BOTTOM,
            msg: 'the action did not complete successfully');
      }
    } on FirebaseAuthException catch (e) {
      var title = '';
      print('ERROR EN: $e');
      Fluttertoast.showToast(
          gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red, msg: '$e');
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  final GoogleAuthentication _googleAuth = GoogleAuthentication();
  @override
  Widget build(BuildContext context) {
    final kwidth = MediaQuery.of(context).size.width;
    final kheight = MediaQuery.of(context).size.height;
    LoadingProvider watch = Provider.of<LoadingProvider>(context);
    var kPrimaryColor = Theme.of(context).primaryColorDark;
    var kPrimaryLightColor = Theme.of(context).primaryColorLight;
    //print('ESTA CARGANDO??? ${watch.getIfLoading()}');
    ThemeProvider tema = Provider.of<ThemeProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Background(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 60,
                    ),
                    Text('Welcome to',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        )),
                    Image.asset(
                      tema.getImage1Theme(),
                      width: kwidth * .6,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'The best place to learn between students',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(29),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(kwidth * .8, 20),
                            primary: kPrimaryColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20)),
                        onPressed: () {
                          Navigator.pushNamed(context, '/signin');
                        },
                        child: Text(
                          'Log In',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(29),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(kwidth * .8, 20),
                            primary: kPrimaryLightColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20)),
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: kwidth / 8, vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            height: 1,
                            width: kwidth * .24,
                            color: kPrimaryLightColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Or Login with',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(color: kPrimaryColor)),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 1,
                            width: kwidth * .22,
                            color: kPrimaryLightColor,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    // AQUI IRAN LOS BUTTONS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 90,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: .4),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: IconButton(
                            onPressed: () {
                              _logInWithFacebook();
                            },
                            icon: Image.asset('assets/icons/facebook_logo.png'),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          height: 50,
                          width: 90,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: .4),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: IconButton(
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });
                              var googleLogin = await _googleAuth.googleLogin();

                              if (googleLogin == true) {
                                Navigator.pushNamed(context, '/onboardingPage');
                              } else {
                                print('Credenciales invalidas');
                                setState(() {
                                  loading = false;
                                });
                              }
                            },
                            icon: Image.asset('assets/icons/google_logo.png'),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          height: 50,
                          width: 90,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: .4),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: IconButton(
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });
                              var githubLogin = await file.getSomething();

                              if (githubLogin) {
                                mounted
                                    ? Navigator.pushNamed(
                                        context, '/onboardingPage')
                                    : print('mounted');
                              } else {
                                setState(() {
                                  loading = false;
                                });
                              }
                              //await file.fetchFiles();
                            },
                            icon: Image.asset('assets/icons/github_logo.png'),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
