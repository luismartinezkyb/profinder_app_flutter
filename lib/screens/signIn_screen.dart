import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profinder_app_flutter/firebase/email_authentication.dart';

import 'package:profinder_app_flutter/screens/authentication_screen.dart';
import 'package:provider/provider.dart';

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
  var loading = false;
  final formKey = GlobalKey<FormState>();

  bool checkVisibility = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EmailAuthentication _emailAuth = EmailAuthentication();

  @override
  Widget build(BuildContext context) {
    final kwidth = MediaQuery.of(context).size.width;
    final kheight = MediaQuery.of(context).size.height;
    ThemeProvider tema = Provider.of<ThemeProvider>(context);
    var kPrimaryColor = Theme.of(context).primaryColorDark;
    var kPrimaryLightColor = Theme.of(context).primaryColorLight;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
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
                    textStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                                    print('the visibility is $checkVisibility');
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 20)),
                    onPressed: () async {
                      final isValidForm = formKey.currentState!.validate();
                      //print('valid form value: $isValidForm');
                      if (isValidForm) {
                        print('email: ' + _controllertxtEmail.text);
                        print('password: ' + _controllertxtPassword.text);
                        var ban = await _emailAuth.signInWithEmailAndPassword(
                            email: _controllertxtEmail.text,
                            password: _controllertxtPassword.text);
                        if (ban == true) {
                          if (_auth.currentUser!.emailVerified) {
                            Navigator.pushNamed(context, '/dashboard');
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
                              msg: 'Invalid Credentials. Please try again.');
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
                AuthenticationButtons()
              ],
            ),
            Positioned(top: 65, right: 20, child: ColorWidgetRow(tema)),
          ],
        ),
      ),
    );
  }
}
