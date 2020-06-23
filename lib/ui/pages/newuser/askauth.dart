import 'package:flutter/material.dart';
import 'package:myassistantv2/core/global/variables.dart';
import 'package:theme_provider/theme_provider.dart';

class AskAuthBio extends StatefulWidget {
  @override
  _AskAuthBioState createState() => _AskAuthBioState();
}

class _AskAuthBioState extends State<AskAuthBio> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.fingerprint,
            size: 100,
            color: ThemeProvider.themeOf(context).id == 'dark'
                ? Colors.tealAccent
                : Colors.black,
          ),
          Text(
            jsonResult[0]['language'][locale]['p3.2'],
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            jsonResult[0]['language'][locale]['p3.3'],
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
