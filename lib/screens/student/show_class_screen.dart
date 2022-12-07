import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profinder_app_flutter/screens/design/switch_mode.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../provider/suscriptions_provider.dart';
import '../../provider/theme_provider.dart';

class ShowClassInfoScreen extends StatefulWidget {
  const ShowClassInfoScreen({Key? key}) : super(key: key);

  @override
  State<ShowClassInfoScreen> createState() => _ShowClassInfoScreenState();
}

class _ShowClassInfoScreenState extends State<ShowClassInfoScreen> {
  var tutorEmail;
  late bool checkSuscription;
  var items;
  late String imageUsuario = "";
  @override
  Widget build(BuildContext context) {
    ThemeProvider tema = Provider.of<ThemeProvider>(context);
    SuscriptionsProvider suscribed = Provider.of<SuscriptionsProvider>(context);
    var kPrimaryColor = Theme.of(context).primaryColorDark;
    var kPrimaryLightColor = Theme.of(context).primaryColorLight;
    var kTextColor = Theme.of(context).primaryColorDark;
    var kwidth = MediaQuery.of(context).size.width;
    var kheight = MediaQuery.of(context).size.height;
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    tutorEmail = arguments['tutorReference'].substring(6);

    Future<UserModel?> readUser() async {
      print('usuario a buscar es el ${tutorEmail.trim()}');
      final docUser =
          FirebaseFirestore.instance.collection('users').doc(tutorEmail);
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
              : 'http://www.gravatar.com/avatar/?d=mp';

          return CachedNetworkImage(
            imageUrl: imageUsuario,
            fit: BoxFit.cover,
            width: 130,
            height: 130,
          );
        }
        if (snapshot.hasError) {
          return Ink.image(
            image: NetworkImage('http://www.gravatar.com/avatar/?d=mp'),
            fit: BoxFit.cover,
            width: 150,
            height: 150,
            child: InkWell(onTap: null),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/dashboard', (route) => false);
          },
        ),
        title: Text(
          'Class Details',
          style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 20)),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        actions: [ColorWidgetRow(tema), SizedBox(width: 20)],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.amber,
            height: kheight / 2.06,
            width: kwidth,
            child: Stack(
              children: [
                Positioned(
                  child: Container(
                    color: kPrimaryLightColor,
                    height: 260,
                    width: kwidth,
                  ),
                ),
                Positioned(
                  left: 20,
                  top: kheight * .01,
                  width: kwidth,
                  child: Text(
                    arguments['className'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    )),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: kheight * .15,
                  width: kwidth / 1.8,
                  child: Text(
                    arguments['classDescription'],
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                      color: Theme.of(context).primaryColorDark.withOpacity(.5),
                      fontSize: 20.0,
                    )),
                  ),
                ),
                Positioned(
                  top: kheight * .16,
                  right: 17,
                  child: Image.asset(
                    'assets/icons/flutter_students1.png',
                    width: 150,
                  ),
                ),
                Positioned(
                  top: kheight * .324,
                  child: Container(
                    height: 100,
                    width: kwidth,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Date',
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.calendar_month),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      formatDate(
                                          DateTime.parse(
                                              "${arguments['classDate']}"),
                                          [yyyy, '/', mm, '/', dd]),
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle()),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Modalidad',
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.school),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('${arguments['classModality']}',
                                        style: GoogleFonts.poppins()),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Duration',
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.timer),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('${arguments['classDuration']}',
                                        style: GoogleFonts.poppins()),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: kheight * .40,
                  left: kwidth * .46,
                  child: Text(
                    'TAGS',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Positioned(
                  top: kheight * .43,
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: kwidth,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: arguments['classTags'].length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              arguments['classTags'][index].toUpperCase(),
                              style: GoogleFonts.poppins(),
                            ),
                          );
                        }),
                  ),
                ),
                Positioned(
                  top: kheight / 2.16,
                  child: Container(
                    width: kwidth,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                    ),
                  ),
                )
              ],
            ),
          ),
          FutureBuilder<UserModel?>(
            future: readUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //print('Checamos que es lo que tiene ${snapshot.data!.image}');

                imageUsuario = snapshot.data!.image != ''
                    ? snapshot.data!.image
                    : 'http://www.gravatar.com/avatar/?d=mp';

                return Container(
                  height: kheight / 2.6,
                  width: kwidth,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Tutor Info',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold))),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipOval(
                                  child: Material(
                                      color: Colors.transparent,
                                      child: futuro)),
                              SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('${snapshot.data!.name}',
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold))),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('${snapshot.data!.email}',
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                          fontSize: 15,
                                        ))),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    RatingBarIndicator(
                                      rating: double.parse(
                                              '${snapshot.data!.level}') /
                                          2,
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star_rounded,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 25.0,
                                      direction: Axis.horizontal,
                                    ),
                                    Text('${snapshot.data!.level}',
                                        style: GoogleFonts.poppins()),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: Column(
                          children: [
                            Text('Description',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold))),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${snapshot.data!.description}',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(fontSize: 15),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(29),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(kwidth * .8, 20),
                                primary: kPrimaryColor,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 20)),
                            onPressed: () {
                              Fluttertoast.showToast(
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.green,
                                  msg: "This method is'nt available yet");
                            },
                            child: Text(
                              'Send Message',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
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
          ),
        ],
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
