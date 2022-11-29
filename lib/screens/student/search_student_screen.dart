import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profinder_app_flutter/models/profesor_model.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search a Professor',
          style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 20)),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        leading: null,
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
                hintText: "Search for a professor",
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                    borderRadius: BorderRadius.circular(20))),
          ),
        ),
        Expanded(
          child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
              padding: EdgeInsets.all(10),
              itemCount: profes.length,
              itemBuilder: (context, index) {
                final profe = profes[index];
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            profe.image,
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        title: Text(
                          '${profe.name}',
                          style: GoogleFonts.poppins(
                              textStyle:
                                  TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        trailing: Column(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                            Text('${profe.calification}')
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Subject: ${profe.topic}',
                          style: GoogleFonts.poppins()),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Email: ${profe.email}',
                          style: GoogleFonts.poppins()),
                      SizedBox(
                        height: 10,
                      ),
                      ReadMoreText(
                        'Info: ${profe.description}',
                        colorClickableText: Colors.pink,
                        style: TextStyle(fontStyle: FontStyle.italic),
                        lessStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                        trimLines: 2,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Read more',
                        trimExpandedText: 'Show less',
                        moreStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    ],
                  ),
                );
              }),
        )
      ]),
    );
  }

  void searchClass() {}
}
