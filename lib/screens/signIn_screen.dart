import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profinder_app_flutter/firebase/email_authentication.dart';

import 'package:profinder_app_flutter/screens/authentication_screen.dart';
import 'package:provider/provider.dart';

import '../firebase/github_authentication.dart';
import '../firebase/google_authentication.dart';
import '../provider/theme_provider.dart';
import '../settings/style_settings.dart';
import 'design/switch_mode.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _controllertxtEmail = TextEditingController();
  TextEditingController _controllertxtPassword = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool checkVisibility = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EmailAuthentication _emailAuth = EmailAuthentication();

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
          'level': '9.3',
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
    ThemeProvider tema = Provider.of<ThemeProvider>(context);
    var kPrimaryColor = Theme.of(context).primaryColorDark;
    var kPrimaryLightColor = Theme.of(context).primaryColorLight;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              width: double.infinity,
              height: kheight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Image.asset(
                      'assets/images/main_top.png',
                      width: kwidth * .35,
                      color: kPrimaryLightColor,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/images/login_bottom.png',
                      width: kwidth * .4,
                      color: kPrimaryLightColor,
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 20,
                    child: IconButton(
                      iconSize: 50,
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/login', (route) => false);
                      },
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 40,
                      ),
                      Text(
                        'LOGIN',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Form(
                        //autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: formKey,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              width: kwidth * .8,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              decoration: BoxDecoration(
                                  color: kPrimaryLightColor,
                                  borderRadius: BorderRadius.circular(29)),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                                controller: _controllertxtEmail,
                                decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.person,
                                  ),
                                  hintText: "Enter Your Email",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              width: kwidth * .8,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              decoration: BoxDecoration(
                                  color: kPrimaryLightColor,
                                  borderRadius: BorderRadius.circular(29)),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a valid password';
                                  }
                                  return null;
                                },
                                obscureText: checkVisibility,
                                controller: _controllertxtPassword,
                                decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.lock,
                                  ),
                                  hintText: "Enter Your Password",
                                  border: InputBorder.none,
                                  suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          print(
                                              'the visibility is $checkVisibility');
                                          checkVisibility = !checkVisibility;
                                        });
                                      },
                                      child: checkVisibility
                                          ? Icon(
                                              Icons.visibility,
                                            )
                                          : Icon(
                                              Icons.visibility_off,
                                            )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(29),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(kwidth * .8, 20),
                              primary: kPrimaryColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 20)),
                          onPressed: () async {
                            final isValidForm =
                                formKey.currentState!.validate();
                            //print('valid form value: $isValidForm');
                            if (isValidForm) {
                              print('email: ' + _controllertxtEmail.text);
                              print('password: ' + _controllertxtPassword.text);
                              var ban =
                                  await _emailAuth.signInWithEmailAndPassword(
                                      email: _controllertxtEmail.text,
                                      password: _controllertxtPassword.text);
                              if (ban == true) {
                                if (_auth.currentUser!.emailVerified) {
                                  Navigator.pushNamed(
                                      context, '/onboardingPage');
                                } else
                                  Fluttertoast.showToast(
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.red,
                                      msg:
                                          'Please verify your email account to login.');
                              } else {
                                Fluttertoast.showToast(
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    msg:
                                        'Invalid Credentials. Please try again.');
                              }
                            } else {
                              Fluttertoast.showToast(
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red,
                                  msg:
                                      'The information is not valid. Please try again!');
                            }
                            print(
                                'redirigeme al dashboard con verificacion de correo');
                          },
                          child: Text(
                            'Sign In',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an Account? ",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(color: kPrimaryColor),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: Text('Sign Up',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold),
                                )),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 50,
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
                              icon:
                                  Image.asset('assets/icons/facebook_logo.png'),
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
                                var googleLogin =
                                    await _googleAuth.googleLogin();

                                if (googleLogin == true) {
                                  Navigator.pushNamed(
                                      context, '/onboardingPage');
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
                  Positioned(top: 65, right: 20, child: ColorWidgetRow(tema)),
                ],
              ),
            ),
    );
  }
}
