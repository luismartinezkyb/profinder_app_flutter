import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:profinder_app_flutter/screens/design/switch_mode.dart';
import 'package:provider/provider.dart';

import '../../provider/theme_provider.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeProvider tema = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Inbox'),
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
