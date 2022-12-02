import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../api/firebase_api.dart';
import '../../provider/theme_provider.dart';
import '../design/switch_mode.dart';
import 'package:path/path.dart' as path;

class SettingsStudentScreen extends StatefulWidget {
  const SettingsStudentScreen({Key? key}) : super(key: key);

  @override
  State<SettingsStudentScreen> createState() => _SettingsStudentScreenState();
}

class _SettingsStudentScreenState extends State<SettingsStudentScreen> {
  File? _image;
  UploadTask? uploadTask;
  String? imagePath = '';

  @override
  Widget build(BuildContext context) {
    ThemeProvider tema = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).backgroundColor,
        leading: null,
        actions: [
          ColorWidgetRow(tema),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // _image != null
            //     ? Image.file(
            //         _image!,
            //         fit: BoxFit.cover,
            //         width: 200,
            //         height: 200,
            //       )
            //     : Image.network(
            //         imagePath!.length == 0
            //             ? 'http://www.gravatar.com/avatar/?d=mp'
            //             : imagePath!,
            //         fit: BoxFit.cover,
            //         width: 200,
            //         height: 200,
            //       ),
            // ElevatedButton(
            //   onPressed: () {
            //     selectImage(ImageSource.gallery);
            //     //Navigator.pushNamed(context, '/onboardingPage');
            //   },
            //   child: Text('select file gallery'),
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     selectImage(ImageSource.camera);
            //     //Navigator.pushNamed(context, '/onboardingPage');
            //   },
            //   child: Text('select file camera'),
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     uploadFile();
            //     //Navigator.pushNamed(context, '/onboardingPage');
            //   },
            //   child: Text('Upload the image'),
            // ),
          ],
        ),
      ),
    );
  }

  Future selectImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;

    final imageTemporary = File(image.path);
    setState(() {
      this._image = imageTemporary;
    });
    print('EL PATH DE LA IMAGEN TEMPRAL ES: ${imageTemporary.path}');
    print('new basename ${path.basename(imageTemporary.path)}');
    //await uploadFile();
  }

  Future uploadFile() async {
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

    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('URL DATA $urlDownload');

    setState(() {
      imagePath = urlDownload;
    });
  }
}
