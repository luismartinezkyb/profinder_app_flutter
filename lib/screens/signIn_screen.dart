import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profinder_app_flutter/constants.dart';
import 'package:profinder_app_flutter/screens/authentication_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _controllertxtEmail = TextEditingController();
  TextEditingController _controllertxtPassword = TextEditingController();

  bool checkVisibility = true;

  @override
  Widget build(BuildContext context) {
    final kwidth = MediaQuery.of(context).size.width;
    final kheight = MediaQuery.of(context).size.height;
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
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  width: kwidth * .8,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                      color: kPrimaryLightColor,
                      borderRadius: BorderRadius.circular(29)),
                  child: TextField(
                    controller: _controllertxtEmail,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.person,
                        color: kPrimaryColor,
                      ),
                      hintText: "Enter Your Email",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  width: kwidth * .8,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                      color: kPrimaryLightColor,
                      borderRadius: BorderRadius.circular(29)),
                  child: TextField(
                    obscureText: checkVisibility,
                    controller: _controllertxtPassword,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.lock,
                        color: kPrimaryColor,
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
                              ? Icon(Icons.visibility, color: kPrimaryColor)
                              : Icon(Icons.visibility_off,
                                  color: kPrimaryColor)),
                    ),
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
                    onPressed: () {
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
            )
          ],
        ),
      ),
    );
  }
}
