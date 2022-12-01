import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profinder_app_flutter/settings/style_settings.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../provider/theme_provider.dart';
import 'design/switch_mode.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int contador = 0;
  final controller = PageController();
  bool isLastPage = false;
  String nameUser = '';
  final userFirebase = FirebaseAuth.instance.currentUser!;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  final colorizeTextStyle = TextStyle(
    fontSize: 40.0,
    fontWeight: FontWeight.bold,
  );
  final colorizeTextStyle2 = TextStyle(
    fontSize: 35.0,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    ThemeProvider tema = Provider.of<ThemeProvider>(context);
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
    Widget buildPage({
      required String title,
      required String title1,
      required String urlImage,
      required List<AnimatedText> frases,
    }) {
      return Container(
        color: kPrimaryLightColor,
        child: Stack(
          alignment: Alignment.center,
          children: [
            //IMAGE OF THE TEACHER
            Positioned(
              top: kheight / 2.5,
              child: Image.asset(
                urlImage,
                width: MediaQuery.of(context).size.width / 1,
              ),
            ),
            //TEXT WELCOME
            Positioned(
              top: MediaQuery.of(context).size.width / 7,
              child: AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText(
                    title1,
                    speed: Duration(milliseconds: 400),
                    textStyle:
                        GoogleFonts.poppins(textStyle: colorizeTextStyle),
                    colors: colorizeColors,
                  ),
                  ColorizeAnimatedText(
                    title1,
                    speed: Duration(milliseconds: 400),
                    textStyle:
                        GoogleFonts.poppins(textStyle: colorizeTextStyle),
                    colors: colorizeColors,
                  ),
                  ColorizeAnimatedText(
                    title1,
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
            //TEXT NAME
            title.length != 0
                ? Positioned(
                    top: MediaQuery.of(context).size.width / 3,
                    child: AnimatedTextKit(
                      animatedTexts: [
                        ColorizeAnimatedText(
                          title,
                          speed: Duration(milliseconds: 400),
                          textStyle: GoogleFonts.poppins(
                              textStyle: colorizeTextStyle2),
                          colors: colorizeColors,
                        ),
                        ColorizeAnimatedText(
                          title,
                          speed: Duration(milliseconds: 400),
                          textStyle: GoogleFonts.poppins(
                              textStyle: colorizeTextStyle2),
                          colors: colorizeColors,
                        ),
                        ColorizeAnimatedText(
                          title,
                          speed: Duration(milliseconds: 400),
                          textStyle: GoogleFonts.poppins(
                              textStyle: colorizeTextStyle2),
                          colors: colorizeColors,
                        ),
                      ],
                      isRepeatingAnimation: true,
                      onTap: () {},
                    ),
                  )
                : Positioned(
                    top: MediaQuery.of(context).size.width / 3.8,
                    child: Image.asset(tema.getImage3Theme(),
                        width: 150, height: 150)),
            title.length != 0
                ? Positioned(
                    top: MediaQuery.of(context).size.height / 3.5,
                    child: Container(
                      alignment: Alignment.center,
                      width: kwidth,
                      height: MediaQuery.of(context).size.height / 10,
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 15,
                        top: MediaQuery.of(context).size.height / 70,
                        bottom: MediaQuery.of(context).size.height / 65,
                        right: MediaQuery.of(context).size.width / 15,
                      ),
                      child: DefaultTextStyle(
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: kTextColor,
                            fontSize: 20.0,
                          ),
                        ),
                        child: AnimatedTextKit(
                          totalRepeatCount: 1,
                          onFinished: () {
                            print('El contador es $contador');
                            if (contador != 2) {
                              controller.animateToPage(contador + 1,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeIn);
                              //controller.jumpToPage(contador + 1);
                            }
                          },
                          pause: Duration(milliseconds: 5000),
                          isRepeatingAnimation: true,
                          repeatForever: false,
                          animatedTexts: frases,
                          onTap: () {},
                        ),
                      ),
                    ),
                  )
                :
                //This is the container with the text
                Positioned(
                    top: MediaQuery.of(context).size.height / 3.5,
                    child: Container(
                      alignment: Alignment.center,
                      width: kwidth,
                      height: MediaQuery.of(context).size.height / 10,
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 15,
                        top: MediaQuery.of(context).size.height / 70,
                        bottom: MediaQuery.of(context).size.height / 65,
                        right: MediaQuery.of(context).size.width / 15,
                      ),
                      child: DefaultTextStyle(
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: kTextColor,
                            fontSize: 20.0,
                          ),
                        ),
                        child: AnimatedTextKit(
                          totalRepeatCount: 1,
                          onFinished: () {
                            print('El contador es $contador');
                            if (contador != 2) {
                              controller.animateToPage(contador + 1,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeIn);
                              //controller.jumpToPage(contador + 1);
                            }
                          },
                          pause: Duration(milliseconds: 5000),
                          isRepeatingAnimation: true,
                          repeatForever: false,
                          animatedTexts: frases,
                          onTap: () {},
                        ),
                      ),
                    ),
                  ),
            //SWITCH MODE
            Positioned(
              bottom: 20,
              right: 30,
              child: ColorWidgetRow(tema),
            )
          ],
        ),
      );
    }

    nameUser =
        userFirebase.displayName != null ? userFirebase.displayName! : ' ';
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (value) => {
            setState(() {
              isLastPage = value == 2;
              contador = value;
              // switch (contador) {
              //   case 0:
              //     tema.sethemeData(temaNoche());
              //     break;
              //   case 1:
              //     tema.sethemeData(temaDia());
              //     break;
              //   case 2:
              //     tema.sethemeData(temaAmarillo());
              //     break;
              //   case 3:
              //     tema.sethemeData(temaAzul());

              //     break;
              //   case 4:
              //     tema.sethemeData(temaNoche());

              //     break;
              // }
            })
          },
          children: [
            buildPage(
                title: '${nameUser}',
                title1: 'Welcome',
                urlImage: 'assets/icons/flutter_teacher1.png',
                frases: [
                  TypewriterAnimatedText('Welcome to our app!'),
                  //TypewriterAnimatedText('We are so proud of having you, ${nameUser}'),
                  TypewriterAnimatedText(
                      'We are really happy to having you here in profinder...'),
                  TypewriterAnimatedText(
                      'Now that you are here, we can learning something new...'),
                  TypewriterAnimatedText(
                      '${nameUser} Let me show you what Profinder is!'),
                ]),
            //PANTALLA 2
            buildPage(
                title: '',
                title1: 'Profinder',
                urlImage: 'assets/icons/flutter_students1.png',
                frases: [
                  TypewriterAnimatedText(
                      'Profinder is an Mobile App where you can learn more and more!'),
                  //TypewriterAnimatedText('We are so proud of having you, ${nameUser}'),
                  TypewriterAnimatedText(
                      'It helps students to learn specific topics or subjects...'),
                  TypewriterAnimatedText(
                      'This works because you can be a teacher and a student too!'),
                  TypewriterAnimatedText(
                      "If you know something about some topic, you can teach it!"),
                  // TypewriterAnimatedText('This works because you can be a teacher and the student too!'),
                  // TypewriterAnimatedText("Even if you are good at something, that can help other students!"),
                ]),
            buildPage(
                title: '',
                title1: 'Profinder',
                urlImage: 'assets/icons/flutter_students2.png',
                frases: [
                  TypewriterAnimatedText(
                      'Even if you are good at something, that can help other students!'),
                  //TypewriterAnimatedText('We are so proud of having you, ${nameUser}'),
                  TypewriterAnimatedText(
                      'You can create a class about something and wait if someone'),
                  TypewriterAnimatedText(
                      'Is interested to learn that topic or practice that skill...'),
                  TypewriterAnimatedText(
                      "And then both of you can meet to learn together as students!"),
                  TypewriterAnimatedText(
                      "Isn't it Amazing? you can learn from other students!"),
                  // TypewriterAnimatedText('This works because you can be a teacher and the student too!'),
                  // TypewriterAnimatedText("Even if you are good at something, that can help other students!"),
                ]),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                primary: Colors.red,
                minimumSize: Size.fromHeight(80),
              ),
              child: ListTile(
                title:
                    Text("Let's get Started!", style: TextStyle(fontSize: 24)),
                leading: Image.asset(tema.getImage3Theme()),
              ),
              onPressed: () async {
                Navigator.pushNamed(context, '/dashboard');
              },
            )
          : Container(
              color: Theme.of(context).backgroundColor,
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Text(
                      'SKIP',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: kTextColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                    onPressed: () {
                      controller.jumpToPage(4);
                    },
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: WormEffect(
                        spacing: 16,
                        dotColor: Colors.black26,
                        activeDotColor: kPrimaryLightColor,
                      ),
                      onDotClicked: (index) {
                        controller.animateToPage(index,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn);

                        setState(() {
                          contador = index;
                        });
                      },
                    ),
                  ),
                  TextButton(
                    child: Text(
                      'NEXT',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: kTextColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                    onPressed: () {
                      controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    },
                  )
                ],
              ),
            ),
    );
  }
}
