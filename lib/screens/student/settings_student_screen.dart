import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../provider/theme_provider.dart';
import '../design/switch_mode.dart';

class SettingsStudentScreen extends StatefulWidget {
  const SettingsStudentScreen({Key? key}) : super(key: key);

  @override
  State<SettingsStudentScreen> createState() => _SettingsStudentScreenState();
}

class _SettingsStudentScreenState extends State<SettingsStudentScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeProvider tema = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Theme.of(context).backgroundColor,
        leading: null,
        actions: [
          ColorWidgetRow(tema),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}
