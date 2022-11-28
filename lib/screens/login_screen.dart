import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profinder_app_flutter/provider/loading_provider.dart';

import 'package:profinder_app_flutter/screens/authentication_screen.dart';
import 'package:provider/provider.dart';

import 'design/background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final kwidth = MediaQuery.of(context).size.width;
    final kheight = MediaQuery.of(context).size.height;
    LoadingProvider watch = Provider.of<LoadingProvider>(context);
    var kPrimaryColor = Theme.of(context).primaryColorDark;
    var kPrimaryLightColor = Theme.of(context).primaryColorLight;
    print('ESTA CARGANDO??? ${watch.getIfLoading()}');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: watch.getIfLoading()
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
                      'assets/icons/flutter_icono_sinletras.png',
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
                    AuthenticationButtons(),
                  ],
                ),
              ),
            ),
    );
  }
}
