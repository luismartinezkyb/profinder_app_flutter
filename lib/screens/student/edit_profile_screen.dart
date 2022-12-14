import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import '../../api/firebase_api.dart';
import '../../models/user_model.dart';
import '../../provider/theme_provider.dart';
import '../design/switch_mode.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var _initialTextName = '';
  var _initialTextDescription = '';
  var _initialTextPhoneNumber = '';
  // TextEditingController _controllertxtName = TextEditingController(text: '');
  // TextEditingController _controllertxtDescription = TextEditingController();
  // TextEditingController _controllertxtPhoneNumber = TextEditingController();

  void _updateTextName(val) {
    setState(() {
      _initialTextName = val;
    });
  }

  void _updateTextDescription(val) {
    setState(() {
      _initialTextDescription = val;
    });
  }

  void _updateTextPhoneNumber(val) {
    setState(() {
      _initialTextPhoneNumber = val;
    });
  }

  final formKey = GlobalKey<FormState>();
  File? _image;
  UploadTask? uploadTask;
  String? imageString = '';
  final userFirebase = FirebaseAuth.instance.currentUser!;
  String loggedWith = '';
  var lastPhoto = '';

  //File? _image;
  // Future<File> _fileFromImageUrl() async {
  //   final response = await http.get(Uri.parse('https://example.com/xyz.jpg'));

  //   final documentDirectory = await getApplicationDocumentsDirectory();

  //   final file = File(join(documentDirectory.path, 'imagetest.png'));

  //   file.writeAsBytesSync(response.bodyBytes);

  //   return file;
  // }

  Future selectImage(ImageSource source, String urlFinal) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;

    final imageTemporary = File(image.path);
    setState(() {
      this._image = imageTemporary;
      //lastPhoto = path.basename(_image!.path);
    });
    // print('EL PATH DE LA IMAGEN TEMPRAL ES: ${imageTemporary.path}');
    // print('new basename ${path.basename(imageTemporary.path)}');

    uploadFile(urlFinal);
    //deleteFile(lastpic);
  }

  Future uploadFile(String urlfinal) async {
    if (_image == null) return;

    final fileName = path.basename(_image!.path);
    final destination = 'images/$fileName';

    uploadTask = FirebaseApi.uploadFile(destination, _image!);
    if (uploadTask == null) {
      Fluttertoast.showToast(
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          msg: 'Failed to upload image, ERROR');
      return;
    }

    final snapshot = await uploadTask!.whenComplete(() {
      Fluttertoast.showToast(
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          msg: 'Picture upload successfully');
    });

    final urlDownload = await snapshot.ref.getDownloadURL();
    //print('URL DATA $urlDownload');

    //UPDATE URL PICTURE FIRESTORE
    final docUser =
        FirebaseFirestore.instance.collection('users').doc(userFirebase.email);
    docUser.update({'picture': urlDownload});

    final referencia = FirebaseStorage.instance.refFromURL(urlfinal);
    referencia.delete();

    ///END UPDATE URL PICTURE FIRESTORE
    setState(() {
      imageString = urlDownload;
    });
  }

  Future deleteFile(String filename) async {
    final destination = 'images/$filename';
    print('this is the path to the last photo:$destination');
    // final ref = FirebaseStorage.instance.ref(destination);
    //   return ref.putFile(file);
  }

  @override
  void initState() {
    super.initState();
  }

  late SimpleDialog _sb;

  void dialogMethod(String urlnew) {
    _sb = SimpleDialog(
      title: Text(
        'Elige una nueva Foto',
        style: GoogleFonts.poppins(
            textStyle: TextStyle(color: Theme.of(context).primaryColor)),
      ),
      children: [
        SimpleDialogOption(
          child: ListTile(
            title: Text(
              'Elegir una imagen',
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Theme.of(context).primaryColor)),
            ),
            trailing: Icon(
              Icons.folder,
              color: Theme.of(context).primaryColor,
            ),
          ),
          onPressed: () {
            selectImage(ImageSource.gallery, urlnew);

            Navigator.pop(context);
          },
        ),
        SimpleDialogOption(
          child: ListTile(
            title: Text(
              'Tomar Foto',
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Theme.of(context).primaryColor)),
            ),
            trailing: Icon(
              Icons.camera_alt,
              color: Theme.of(context).primaryColor,
            ),
          ),
          onPressed: () {
            selectImage(ImageSource.camera, urlnew);
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return _sb;
        });
  }

  late String imageUsuario = "";
  late String nombreUsuario = "";
  late String correoUsuario = "";
  late String telefonoUsuario = "";
  late String descripcionUsuario = "";
  late int role;
  late String levelUsuario = "";

  bool verifyTheme = false;
  @override
  Widget build(BuildContext context) {
    ThemeProvider tema = Provider.of<ThemeProvider>(context);
    var kPrimaryColor = Theme.of(context).primaryColorDark;
    var kPrimaryLightColor = Theme.of(context).primaryColorLight;
    var kTextColor = Theme.of(context).primaryColorDark;
    var kwidth = MediaQuery.of(context).size.width;
    var kheight = MediaQuery.of(context).size.height;
    loggedWith = userFirebase.providerData[0].providerId;
    var checkimage = '';

    switch (loggedWith) {
      case 'facebook.com':
        print('Es con Facebook el user');
        checkimage = 'assets/icons/facebook_logo.png';

        break;
      case 'password':
        checkimage = 'assets/icons/email_color_icon.png';
        print('Es con Email y password el user');
        break;
      case 'google.com':
        checkimage = 'assets/icons/google_logo.png';
        print('Es con Google el user');
        break;
      case 'github.com':
        checkimage = 'assets/icons/github_logo.png';
        print('Es con Github el user');
        break;
      default:
        checkimage = 'assets/icono/logo_itcelaya.png';

        break;
    }

    //final urlAsset = 'assets/ProfilePicture.png';
    //PARA GUARDAR LA PRIMERA IMAGEN
    // photo pic = photo(0, urlAsset);
    // _database!.save(pic);
    // UserModel newUser = UserModel(0, 'Luis Martinez', 'luismartinez@gmail.com',
    //     '4612091668', 'https://github.com/luismartinezkyb');
    // _database2!.save(newUser);

    Future<UserModel?> readUser() async {
      final docUser = FirebaseFirestore.instance
          .collection('users')
          .doc(userFirebase.email);
      final snapshot = await docUser.get();
      if (snapshot.exists) {
        return UserModel.fromJson(snapshot.data()!);
      }
    }

//FUTURO 2 lee la informacion del usuario y regresa toda la info
    final futuro2 = FutureBuilder<UserModel?>(
      future: readUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          nombreUsuario = snapshot.data!.name;
          correoUsuario = snapshot.data!.email;
          telefonoUsuario = snapshot.data!.number;

          role = snapshot.data!.role;
          descripcionUsuario = snapshot.data!.description;
          snapshot.data!.level == null
              ? levelUsuario = "0"
              : levelUsuario = snapshot.data!.level;

          return Form(
            //autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formKey,

            child: Column(
              children: [
                SizedBox(height: 24),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Full Name',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      userFirebase.providerData[0].providerId == 'password'
                          ? Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              width: kwidth * .8,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(color: kPrimaryLightColor),
                                  borderRadius: BorderRadius.circular(29)),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                initialValue: snapshot.data!.name,
                                onChanged: (value) {
                                  // print(value);
                                  _updateTextName(value);
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            )
                          : Text(nombreUsuario,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(color: Colors.grey))),
                    ],
                  ),
                ),

                SizedBox(height: 38),
                buildInfo('Email', correoUsuario),
                SizedBox(height: 38),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Description',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        width: kwidth * .8,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: kPrimaryLightColor),
                            borderRadius: BorderRadius.circular(29)),
                        child: TextFormField(
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            if (value.length > 70) {
                              return 'The description must have less than 70 characters, you have ${value.length} characters}';
                            }
                            return null;
                          },
                          initialValue: snapshot.data!.description,
                          onChanged: (value) {
                            _updateTextDescription(value);
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 38),
                //buildInfo('User type', role == 1 ? 'Professor' : 'Student'),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Phone Number',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        width: kwidth * .8,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: kPrimaryLightColor),
                            borderRadius: BorderRadius.circular(29)),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            } else if (value.length != 10) {
                              return 'The phone number must have 10 characters long';
                            }
                            return null;
                          },
                          initialValue: snapshot.data!.number,
                          onChanged: (value) {
                            _updateTextPhoneNumber(value);
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(height: 30),
                buildInfoRow('User type', role == 1 ? 'Professor' : 'Student',
                    'Level', levelUsuario),
                SizedBox(height: 48),
              ],
            ),
          );
        }
        if (snapshot.hasError) {
          nombreUsuario = "empty";
          correoUsuario = "empty";
          telefonoUsuario = "empty";

          role = 0;
          descripcionUsuario = "empty";
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
//RETURNS THE PHOTO
    final futuro = FutureBuilder<UserModel?>(
      future: readUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //print('Checamos que es lo que tiene ${snapshot.data!.image}');

          imageUsuario = snapshot.data!.image != ''
              ? snapshot.data!.image
              : imageString!.length != 0
                  ? imageString!
                  : 'http://www.gravatar.com/avatar/?d=mp';

          return GestureDetector(
            child: CachedNetworkImage(
              imageUrl: imageUsuario,
              fit: BoxFit.cover,
              width: 150,
              height: 150,
            ),
            // child: Image.file(
            //   File(imageUsuario),
            //   fit: BoxFit.cover,
            //   width: 200,
            //   height: 200,
            // ),
          );
        }
        if (snapshot.hasError) {
          return Ink.image(
            image: NetworkImage('http://www.gravatar.com/avatar/?d=mp'),
            fit: BoxFit.cover,
            width: 200,
            height: 200,
            child: InkWell(
              onTap: () async {
                dialogMethod(imageUsuario);
              },
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/dashboard', (route) => false);
          },
        ),
        title: Text(
          'Edit User Profile',
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
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: 10,
          ),
          ProfileWidget(
            imagePath: ClipOval(
              child: Material(color: Colors.transparent, child: futuro),
            ),
            onClicked: () async {
              userFirebase.providerData[0].providerId == 'password'
                  ? dialogMethod(imageUsuario)
                  : Fluttertoast.showToast(
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      msg:
                          'You cannot edit your profile picture while you are logged in with ${userFirebase.providerData[0].providerId}');
              ;
            },
          ),
          futuro2,
          //button edit profile
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(29),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(kwidth * .8, 20),
                    primary: Colors.green,
                    padding:
                        EdgeInsets.symmetric(horizontal: 40, vertical: 20)),
                onPressed: () async {
                  final isValidForm = formKey.currentState!.validate();
                  //print('valid form value: $isValidForm');

                  if (isValidForm) {
                    var finalNumber;
                    var finalName;
                    var finalDescription;

                    finalName = _initialTextName.length == 0
                        ? nombreUsuario
                        : _initialTextName;
                    finalDescription = _initialTextDescription.length == 0
                        ? descripcionUsuario
                        : _initialTextDescription;
                    finalNumber = _initialTextPhoneNumber.length == 0
                        ? telefonoUsuario
                        : _initialTextPhoneNumber;

                    // print(
                    //     'final vars: $finalNumber, $finalName, $finalDescription');
                    final docUser = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userFirebase.email);
                    docUser.update({
                      'description': finalDescription,
                      'number': finalNumber,
                      'name': finalName,
                    }).then((value) {
                      Fluttertoast.showToast(
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.green,
                          msg: 'User info Updated successfully!');
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/dashboard', (route) => false);
                    });
                  } else {
                    Fluttertoast.showToast(
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        msg: 'The information is not valid. Please try again!');
                  }
                },
                child: Text(
                  'Save info',
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
            height: 40,
          )
        ],
      ),
    );
  }
//tengo que activar el boton para saber por que tengo mal la bd

  Widget buildName(String user, String email) => Column(
        children: [
          Text(
            user,
            style: GoogleFonts.poppins(
                textStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
          ),
          SizedBox(height: 10),
          Text(
            email,
            style:
                GoogleFonts.poppins(textStyle: TextStyle(color: Colors.grey)),
          ),
        ],
      );

  Widget buildInfo(String title, String subtitle) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '$title',
              style: GoogleFonts.poppins(
                  textStyle:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 10,
            ),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(color: Colors.grey))),
          ],
        ),
      );
  Widget buildInfoRow(
          String title, String subtitle, String title1, String subtitle2) =>
      Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$title',
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(subtitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.grey))),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$title1',
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(subtitle2,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.grey))),
                ],
              ),
            ),
          ],
        ),
      );
}

//armamos el widget del perfil completo
class ProfileWidget extends StatelessWidget {
  final Widget imagePath;
  final VoidCallback onClicked;

  const ProfileWidget(
      {Key? key, required this.imagePath, required this.onClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).backgroundColor;
    return Center(
      child: Stack(
        children: [
          imagePath,
          Positioned(
            bottom: 0,
            right: 4,
            child:
                GestureDetector(onTap: onClicked, child: buildEditIcon(color)),
          ),
        ],
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 10,
          child: Icon(
            color: Colors.white,
            Icons.camera_alt,
            size: 20,
          ),
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
//UPDATE USER INFO

