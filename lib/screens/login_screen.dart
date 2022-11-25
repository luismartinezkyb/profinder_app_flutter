import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profinder_app_flutter/constants.dart';

import 'design/background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final kwidth = MediaQuery.of(context).size.width;
    final kheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Background(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome to',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                  )),
              Image.asset(
                'assets/icons/flutter_icono_sinletras.png',
                width: kwidth * .6,
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
                height: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(kwidth * .8, 20),
                      primary: kPrimaryColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 20)),
                  onPressed: () {},
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
                height: 10,
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: kwidth / 8, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      height: 1,
                      width: kwidth * .22,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Or Login with',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.black54)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 1,
                      width: kwidth * .22,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: kwidth * .2),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        print('facebook');
                      },
                      icon: Image.asset('assets/icons/facebook_logo.png'),
                    ),
                    IconButton(
                      onPressed: () {
                        print('github');
                      },
                      icon: Image.asset('assets/icons/github_logo.png'),
                    ),
                    IconButton(
                      onPressed: () {
                        print('google');
                      },
                      icon: Image.asset('assets/icons/google_logo.png'),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
