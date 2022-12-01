import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profinder_app_flutter/models/class_model.dart';
import 'package:profinder_app_flutter/models/profesor_model.dart';
import 'package:profinder_app_flutter/models/user_model.dart';
import 'package:profinder_app_flutter/provider/classes_provider.dart';
import 'package:profinder_app_flutter/settings/style_settings.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../../provider/theme_provider.dart';
import '../design/switch_mode.dart';

class SearchStudentScreen extends StatefulWidget {
  const SearchStudentScreen({Key? key}) : super(key: key);

  @override
  State<SearchStudentScreen> createState() => _SearchStudentScreenState();
}

class _SearchStudentScreenState extends State<SearchStudentScreen> {
  TextEditingController _controllerSearch = TextEditingController();

  String queryname = '';
  // List searchResult = [];
  // String prueba = '';

  // void searchFromFirebase(String query) async {
  //   //final professorTitle = element.name.toLowerCase();
  //   final input = query.toLowerCase();

  //   final result = await FirebaseFirestore.instance
  //       .collection('classes')
  //       .where('tags', arrayContains: query)
  //       .get();
  //   setState(() {
  //     searchResult = result.docs.map((e) => e.data()).toList();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    ThemeProvider tema = Provider.of<ThemeProvider>(context);
    ClassProvider query = Provider.of<ClassProvider>(context);
    var kPrimaryColor = Theme.of(context).primaryColorDark;
    var kPrimaryLightColor = Theme.of(context).primaryColorLight;
    var kTextColor = Theme.of(context).primaryColorDark;
    var kwidth = MediaQuery.of(context).size.width;
    var kheight = MediaQuery.of(context).size.height;
    Stream<List<ClassModel>> readUsers() {
      // if (query == 'none') {
      return FirebaseFirestore.instance.collection('classes').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => ClassModel.fromJson(doc.data()))
              .toList());
      // // } else {
      //   final input = query!.toLowerCase();

      //   final result = FirebaseFirestore.instance
      //       .collection('classes')
      //       .where('tags', arrayContains: query)
      //       .get();

      //   searchResult = result.docs.map((e) => e.data()).toList();
      // // }
      // return FirebaseFirestore.instance.collection('classes').snapshots().map(
      //     (snapshot) => snapshot.docs
      //         .map((doc) => ClassModel.fromJson(doc.data()))
      //         .toList());
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Search a Class',
          style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 20)),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        actions: [
          ColorWidgetRow(tema),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Column(children: [
        Container(
          //decoration: BoxDecoration(border: Border()),
          margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: TextField(
            controller: _controllerSearch,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).primaryColorDark,
              ),
              hintText: "Search for a subject or class",
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: kPrimaryColor),
                  borderRadius: BorderRadius.circular(20)),
            ),
            onChanged: (value) {
              setState(() {
                queryname = value;
              });
              query.setSearch(value);
              //searchFromFirebase(value);
            },
          ),
        ),
        Expanded(
          child: StreamBuilder<List<ClassModel>>(
            stream: readUsers(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              } else if (snapshot.hasData) {
                final classes = snapshot.data!;
                //print('$classes');
                //print(classes.map(val =>).toList());

                return ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    itemCount: classes.length,
                    itemBuilder: (context, index) {
                      final clase = classes[index];

                      return queryname.length == 0
                          ? Container(
                              height: 250,
                              child: AspectRatio(
                                aspectRatio: 1.80,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: kPrimaryLightColor,
                                    borderRadius:
                                        BorderRadius.circular(kwidth * .1),
                                  ),
                                  child: Row(children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 30),
                                        child: Column(
                                          children: [
                                            Spacer(),
                                            Text(
                                              '${clase.name}',
                                              style: GoogleFonts.poppins(
                                                  textStyle:
                                                      TextStyle(fontSize: 20)),
                                            ),

                                            //DESCRIPTION
                                            Text(
                                              '${clase.description}',
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: kTextColor
                                                        .withOpacity(0.5)),
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.timer),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  '${clase.duration} min.',
                                                  style: GoogleFonts.poppins(
                                                      textStyle: TextStyle()),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.calendar_month),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  formatDate(
                                                      DateTime.parse(
                                                          '${clase.date}'),
                                                      [yyyy, '/', mm, '/', dd]),
                                                  style: GoogleFonts.poppins(
                                                      textStyle: TextStyle()),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            clase.tags!.length == 2
                                                ? Row(
                                                    children: [
                                                      Icon(Icons.numbers),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5,
                                                                vertical: 3),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: kPrimaryColor,
                                                        ),
                                                        child: Text(
                                                          '${clase.tags![0]}',
                                                          style: TextStyle(
                                                              color:
                                                                  kPrimaryLightColor),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5,
                                                                vertical: 3),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: kPrimaryColor,
                                                        ),
                                                        child: Text(
                                                          '${clase.tags![1]}',
                                                          style: TextStyle(
                                                              color:
                                                                  kPrimaryLightColor),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    children: [
                                                      Icon(Icons.numbers),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5,
                                                                vertical: 3),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: kPrimaryColor,
                                                        ),
                                                        child: Text(
                                                          '${clase.tags![0]}',
                                                          style: TextStyle(
                                                              color:
                                                                  kPrimaryLightColor),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),

                                    //USER PROFILE
                                    AspectRatio(
                                      aspectRatio: .50,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                print('go to user profile');
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(75),
                                                child: CachedNetworkImage(
                                                    imageUrl:
                                                        '${clase.picture_tutor}',
                                                    width: 75,
                                                    height: 75,
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Icon(
                                              Icons.star_rounded,
                                            ),
                                            Text('${clase.level}'),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: kPrimaryColor,
                                                minimumSize: Size(90, 40),
                                              ),
                                              onPressed: () {
                                                print('view details');
                                              },
                                              child: Text(
                                                'Info',
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ]),
                                ),
                              ),
                            )
                          : (clase.tags!.contains(queryname.toLowerCase()) ||
                                  clase.name!
                                      .toLowerCase()
                                      .contains(queryname.toLowerCase()))
                              ? Container(
                                  height: 250,
                                  child: AspectRatio(
                                    aspectRatio: 1.80,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: kPrimaryLightColor,
                                        borderRadius:
                                            BorderRadius.circular(kwidth * .1),
                                      ),
                                      child: Row(children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 30),
                                            child: Column(
                                              children: [
                                                Spacer(),
                                                Text(
                                                  '${clase.name}',
                                                  style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          fontSize: 20)),
                                                ),

                                                //DESCRIPTION
                                                Text(
                                                  '${clase.description}',
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        color: kTextColor
                                                            .withOpacity(0.5)),
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(Icons.timer),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      '${clase.duration} min.',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              textStyle:
                                                                  TextStyle()),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(Icons.calendar_month),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      formatDate(
                                                          DateTime.parse(
                                                              '${clase.date}'),
                                                          [
                                                            yyyy,
                                                            '/',
                                                            mm,
                                                            '/',
                                                            dd
                                                          ]),
                                                      style:
                                                          GoogleFonts.poppins(
                                                              textStyle:
                                                                  TextStyle()),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                clase.tags!.length == 2
                                                    ? Row(
                                                        children: [
                                                          Icon(Icons.numbers),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        5,
                                                                    vertical:
                                                                        3),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              color:
                                                                  kPrimaryColor,
                                                            ),
                                                            child: Text(
                                                              '${clase.tags![0]}',
                                                              style: TextStyle(
                                                                  color:
                                                                      kPrimaryLightColor),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 4,
                                                          ),
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        5,
                                                                    vertical:
                                                                        3),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              color:
                                                                  kPrimaryColor,
                                                            ),
                                                            child: Text(
                                                              '${clase.tags![1]}',
                                                              style: TextStyle(
                                                                  color:
                                                                      kPrimaryLightColor),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Row(
                                                        children: [
                                                          Icon(Icons.numbers),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        5,
                                                                    vertical:
                                                                        3),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              color:
                                                                  kPrimaryColor,
                                                            ),
                                                            child: Text(
                                                              '${clase.tags![0]}',
                                                              style: TextStyle(
                                                                  color:
                                                                      kPrimaryLightColor),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),

                                        //USER PROFILE
                                        AspectRatio(
                                          aspectRatio: .50,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    print('go to user profile');
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            75),
                                                    child: CachedNetworkImage(
                                                        imageUrl:
                                                            '${clase.picture_tutor}',
                                                        width: 75,
                                                        height: 75,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Icon(
                                                  Icons.star_rounded,
                                                ),
                                                Text('${clase.level}'),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: kPrimaryColor,
                                                    minimumSize: Size(90, 40),
                                                  ),
                                                  onPressed: () {
                                                    print('view details');
                                                  },
                                                  child: Text(
                                                    'Info',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ]),
                                    ),
                                  ),
                                )
                              : Container();
                    });
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ]),
    );
  }

//CREATING A LIST OF THE CLASSES
  void searchClass(String query) {
    final suggestions = allProfessors.where((element) {
      final professorTitle = element.name.toLowerCase();
      final input = query.toLowerCase();

      return professorTitle.contains(input);
    }).toList();

    // setState(() {
    //   profes = suggestions;
    // });
  }
}
