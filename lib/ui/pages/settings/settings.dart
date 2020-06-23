import 'package:flutter/material.dart';
import 'package:myassistantv2/core/global/variables.dart';
import 'package:myassistantv2/ui/pages/settings/account.dart';
import 'package:myassistantv2/ui/pages/settings/mode.dart';
import 'package:myassistantv2/ui/pages/settings/security.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  securityCheck() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      pActive = prefs.getBool("pinActive");
      fActive = prefs.getBool("fingerActive");
      if (pActive != null) {
        pinActive = pActive;
        print("active pin");
      }

      if (fActive != null) {
        fingerActive = fActive;
        print("active finger");
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: scrW,
      height: scrH,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: scrW,
            padding: EdgeInsets.all(10),
            // color: Colors.red,
            child: Text(
              pageTitles[locale][3],
              style: TextStyle(
                  color: ThemeProvider.themeOf(context).id == 'dark'
                      ? Colors.tealAccent
                      : secColor,
                  fontSize: scrW / 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ThemeConsumer(child: Account())));
            },
            child: Container(
              width: scrW,
              height: scrH / 20,
              margin: EdgeInsets.all(0),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: ThemeProvider.themeOf(context).id == 'dark'
                              ? Colors.white10
                              : Colors.grey[200],
                          width: 1))),
              child: Row(
                children: <Widget>[
                  Image.asset(
                    'assets/image/ic-actions-user.png',
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    jsonResult[0]['language'][locale]['p10.1'],
                    style: TextStyle(

                        //  fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  Expanded(child: Container()),
                  Icon(
                    Icons.arrow_right,
                    color: Colors.black45,
                    size: 30,
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 15,),
          GestureDetector(
            onTap: () {
              securityCheck();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ThemeConsumer(child: Security())));
            },
            child: Container(
              width: scrW,
              height: scrH / 20,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: ThemeProvider.themeOf(context).id == 'dark'
                              ? Colors.white10
                              : Colors.grey[200],
                          width: 1))),
              child: Row(
                children: <Widget>[
                  Image.asset(
                    'assets/image/security.png',
                     color: Colors.grey,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    jsonResult[0]['language'][locale]['p10.2'],
                    style: TextStyle(

                        //  fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  Expanded(child: Container()),
                  Icon(
                    Icons.arrow_right,
                    color: Colors.black45,
                    size: 30,
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 15,),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ThemeConsumer(child: Mode())));
            },
            child: Container(
              color: Colors.transparent,
              width: scrW,
              height: scrH / 20,
              child: Row(
                children: <Widget>[
                  Image.asset(
                    'assets/image/app.png',
                     color: Colors.grey,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    jsonResult[0]['language'][locale]['p10.3'],
                    style: TextStyle(

                        //  fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  Expanded(child: Container()),
                  Icon(
                    Icons.arrow_right,
                    color: Colors.black45,
                    size: 30,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
