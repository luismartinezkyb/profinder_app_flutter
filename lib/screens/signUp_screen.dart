import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import 'authentication_screen.dart';

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
  TextEditingController _controllertxtUserType = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool checkVisibility = true;
  int _dropdownValue = 2;

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
                            color: kPrimaryColor,
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
                            color: kPrimaryColor,
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
                            color: kPrimaryColor,
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
                            color: kPrimaryColor,
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
                                  ? Icon(Icons.visibility, color: kPrimaryColor)
                                  : Icon(Icons.visibility_off,
                                      color: kPrimaryColor)),
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
                            color: kPrimaryColor,
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
                          Icon(
                            Icons.security,
                            color: kPrimaryColor,
                          ),
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
                              icon: Icon(Icons.arrow_drop_down,
                                  color: kPrimaryColor),
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
                                print(value);
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
                            print(
                                'redirigeme al login with the notification con verificacion de correo');
                          } else {
                            Fluttertoast.showToast(
                                msg: 'There is some wrong information');
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
              ],
            ),
            Positioned(
              top: 40,
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
          ],
        ),
      ),
    );
  }
}
