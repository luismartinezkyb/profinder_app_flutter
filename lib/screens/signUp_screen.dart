import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profinder_app_flutter/provider/theme_provider.dart';
import 'package:provider/provider.dart';

import '../firebase/email_authentication.dart';
import '../settings/style_settings.dart';
import 'design/switch_mode.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _controllertxtName = TextEditingController();
  TextEditingController _controllertxtUsername = TextEditingController();
  TextEditingController _controllertxtEmail = TextEditingController();
  TextEditingController _controllertxtPassword = TextEditingController();

  TextEditingController _controllertxtNumber = TextEditingController();

  EmailAuthentication? _emailAuth;
  final formKey = GlobalKey<FormState>();

  bool checkVisibility = true;
  int _dropdownValue = 2;

  @override
  void initState() {
    super.initState();
    _emailAuth = EmailAuthentication();
  }

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
            ListView(
              children: [
                Container(
                  height: 50,
                ),
                Column(
                  children: [
                    Text(
                      'REGISTER USER',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Welcome to Profinder!',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                //FORMULARIO
                Form(
                  //autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: formKey,
                  child: Column(children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: kwidth * .8,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          color: kPrimaryLightColor,
                          borderRadius: BorderRadius.circular(29)),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        controller: _controllertxtName,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.person,
                          ),
                          hintText: "Full Name *",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: kwidth * .8,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          color: kPrimaryLightColor,
                          borderRadius: BorderRadius.circular(29)),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 4) {
                            return 'Please enter min 4 characters to validate the username';
                          } else if (value.contains(' ')) {
                            return 'Username cannot contains spaces';
                          }
                          return null;
                        },
                        controller: _controllertxtUsername,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.group,
                          ),
                          hintText: "Username *",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: kwidth * .8,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          color: kPrimaryLightColor,
                          borderRadius: BorderRadius.circular(29)),
                      child: TextFormField(
                        validator: (value) {
                          final emailRegExp =
                              RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                          final result = emailRegExp.hasMatch(value!);
                          //print('THE RESULT IS ${!result}');
                          if (value == null || value.isEmpty || !result) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        controller: _controllertxtEmail,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.email,
                          ),
                          hintText: "Email *",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: kwidth * .8,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          color: kPrimaryLightColor,
                          borderRadius: BorderRadius.circular(29)),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 6) {
                            return 'Please enter min 6 characters';
                          }
                          return null;
                        },
                        obscureText: checkVisibility,
                        controller: _controllertxtPassword,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.lock,
                          ),
                          hintText: "Password *",
                          border: InputBorder.none,
                          suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  //print('the visibility is $checkVisibility');
                                  checkVisibility = !checkVisibility;
                                });
                              },
                              child: checkVisibility
                                  ? Icon(Icons.visibility)
                                  : Icon(
                                      Icons.visibility_off,
                                    )),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: kwidth * .8,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          color: kPrimaryLightColor,
                          borderRadius: BorderRadius.circular(29)),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _controllertxtNumber,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.phone,
                          ),
                          hintText: "Phone Number",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: kwidth * .8,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          color: kPrimaryLightColor,
                          borderRadius: BorderRadius.circular(29)),
                      child: Row(
                        children: [
                          Icon(Icons.security),
                          SizedBox(
                            width: 15,
                          ),
                          SizedBox(
                            width: 230,
                            child: DropdownButton(
                              dropdownColor: kPrimaryLightColor,
                              isExpanded: true,

                              //alignment: Alignment.center,
                              value: _dropdownValue,
                              hint: Text('Choose a Role'),
                              icon: Icon(
                                Icons.arrow_drop_down,
                              ),
                              items: [
                                DropdownMenuItem(
                                  child: Text('Teacher'),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                  child: Text('Student'),
                                  value: 2,
                                )
                              ],
                              onChanged: (int? value) {
                                setState(() => {_dropdownValue = value!});

                                //value = _dropdownValue;
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),
                ),
                Column(
                  children: [
                    Text(
                      'Fields marked with "*" are required ',
                      style: GoogleFonts.poppins(
                          textStyle:
                              TextStyle(fontSize: 10, color: Colors.red)),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20)),
                        onPressed: () {
                          final isValidForm = formKey.currentState!.validate();
                          //print('valid form value: $isValidForm');
                          if (isValidForm) {
                            _emailAuth!
                                .createUserWithEmailAndPassword(
                              name: _controllertxtName.text,
                              username: _controllertxtUsername.text,
                              email: _controllertxtEmail.text,
                              password: _controllertxtPassword.text,
                              number: _controllertxtNumber.text,
                              role: _dropdownValue,
                            )
                                .then((value) {
                              print('valor del email auth $value');
                              if (value) {
                                Fluttertoast.showToast(
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.green,
                                    msg:
                                        "We've send you an email, please verify your email account to log in");
                                Navigator.pushNamed(context, '/signin');
                              } else {
                                Fluttertoast.showToast(
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    msg:
                                        'an error occurred while trying to sign up, verify the console');
                              }
                            });
                          } else {
                            Fluttertoast.showToast(
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                msg:
                                    'The information is not valid. Please try again!');
                          }
                        },
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an Account? ",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: kPrimaryColor),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/signin');
                      },
                      child: Text('Log In',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                          )),
                    )
                  ],
                ),
                Container(
                  height: 30,
                )
              ],
            ),
            Positioned(
              top: 50,
              left: 10,
              child: IconButton(
                iconSize: 40,
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                },
              ),
            ),
            Positioned(top: 55, right: 20, child: ColorWidgetRow(tema)),
          ],
        ),
      ),
    );
  }
}
