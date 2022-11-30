import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profinder_app_flutter/models/profesor_model.dart';
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
  List<ProfesorModel> profes = allProfessors;

  @override
  Widget build(BuildContext context) {
    ThemeProvider tema = Provider.of<ThemeProvider>(context);
    var kPrimaryColor = Theme.of(context).primaryColorDark;
    var kPrimaryLightColor = Theme.of(context).primaryColorLight;
    var kTextColor = Theme.of(context).primaryColorDark;
    var kwidth = MediaQuery.of(context).size.width;
    var kheight = MediaQuery.of(context).size.height;

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
              searchClass(value);
            },
          ),
        ),
        Expanded(
          child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: profes.length,
              itemBuilder: (context, index) {
                final profe = profes[index];
                return Container(
                  height: 250,
                  child: AspectRatio(
                    aspectRatio: 1.80,
                    child: Container(
                      decoration: BoxDecoration(
                        color: kPrimaryLightColor,
                        borderRadius: BorderRadius.circular(kwidth * .1),
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
                                  'Understanding Javascript',
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(fontSize: 20)),
                                ),

                                //DESCRIPTION
                                Text(
                                  'A great class for improve your knowledge.',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: kTextColor.withOpacity(0.5)),
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
                                      '120 min.',
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
                                      '29/08/22',
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
                                    Icon(Icons.numbers),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '120 min.',
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle()),
                                    )
                                  ],
                                ),
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
                            padding: EdgeInsets.symmetric(vertical: 10.0),
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
                                    borderRadius: BorderRadius.circular(75),
                                    child: CachedNetworkImage(
                                        imageUrl:
                                            'https://randomuser.me/api/portraits/men/76.jpg',
                                        width: 75,
                                        height: 75,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Icon(
                                  Icons.star,
                                ),
                                Text('${profe.calification}'),
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
                );
                // return Container(
                //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       ListTile(
                //         leading: ClipRRect(
                //           borderRadius: BorderRadius.circular(20),
                //           child: Image.network(
                //             profe.image,
                //             fit: BoxFit.cover,
                //             width: 50,
                //             height: 50,
                //           ),
                //         ),
                //         title: Text(
                //           '${profe.name}',
                //           style: GoogleFonts.poppins(
                //               textStyle:
                //                   TextStyle(fontWeight: FontWeight.bold)),
                //         ),
                //         trailing: Column(
                //           children: [
                //             Icon(
                //               Icons.star,
                //               color: Colors.yellow,
                //             ),
                //             Text('${profe.calification}')
                //           ],
                //         ),
                //       ),
                //       SizedBox(
                //         height: 10,
                //       ),
                //       Text('Subject: ${profe.topic}',
                //           style: GoogleFonts.poppins()),
                //       SizedBox(
                //         height: 10,
                //       ),
                //       Text('Email: ${profe.email}',
                //           style: GoogleFonts.poppins()),
                //       SizedBox(
                //         height: 10,
                //       ),
                //       ReadMoreText(
                //         'Info: ${profe.description}',
                //         colorClickableText: Colors.pink,
                //         style: TextStyle(fontStyle: FontStyle.italic),
                //         lessStyle: TextStyle(
                //             fontSize: 14,
                //             fontWeight: FontWeight.bold,
                //             color: Colors.green),
                //         trimLines: 2,
                //         trimMode: TrimMode.Line,
                //         trimCollapsedText: 'Read more',
                //         trimExpandedText: 'Show less',
                //         moreStyle: TextStyle(
                //             fontSize: 14,
                //             fontWeight: FontWeight.bold,
                //             color: Colors.green),
                //       ),
                //     ],
                //   ),
                // );
              }),
        ),
      ]),
    );
  }

  void searchClass(String query) {
    final suggestions = allProfessors.where((element) {
      final professorTitle = element.name.toLowerCase();
      final input = query.toLowerCase();

      return professorTitle.contains(input);
    }).toList();

    setState(() {
      profes = suggestions;
    });
  }
}
//CREATING A CLASSES OBJECT
// Stream<List<Class>> readUsers() {
//   FirebaseFirestore.instance.collection('classes')
//   .snapshots()
//   .map((snapshot) => snapshot.docs.map((e) => e.data()).toList());
// }
