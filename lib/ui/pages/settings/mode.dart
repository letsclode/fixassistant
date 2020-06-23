import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:myassistantv2/core/global/variables.dart';
import 'package:myassistantv2/ui/pages/home/home.dart';
import 'package:myassistantv2/ui/widgets/incomeExpense.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';

class Mode extends StatefulWidget {
  @override
  _ModeState createState() => _ModeState();
}

Future saveLanguage() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('language', locale);
}

Future saveMode(context) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('mode', ThemeProvider.themeOf(context).id);
}

enum Language { english, french }

class _ModeState extends State<Mode> {
  bool showLanguageSet = false;
  List language = ['en', 'fr'];
  Language _character = locale == "en" ? Language.english : Language.french;
  void _onSwitchChanged(bool value) {
    ThemeProvider.controllerOf(context).nextTheme();
    saveMode(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: scrW,
          height: scrH,
          padding: EdgeInsets.all(20),
          child: Center(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                          },
                          child: Container(
                            width: scrW / 7,
                            height: scrH / 23,
                            child: Center(
                                child: Text(
                              jsonResult[0]['language'][locale]['p7.14'],
                              style: TextStyle(
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.bold,
                                  fontSize: scrW / 25),
                            )),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color:
                                    ThemeProvider.themeOf(context).id == 'dark'
                                        ? Color.fromRGBO(37, 52, 65, 1)
                                        : Colors.grey[100],
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          ThemeProvider.themeOf(context).id ==
                                                  'dark'
                                              ? Colors.white12
                                              : Colors.white,
                                      blurRadius: 2,
                                      offset: Offset(-5, -5)),
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5,
                                      offset: Offset(5, 5))
                                ]),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: scrH / 15,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: ThemeProvider.themeOf(context).id ==
                                          'dark'
                                      ? Colors.white10
                                      : Colors.grey[200],
                                  width: 1))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            jsonResult[0]['language'][locale]['p11.5'],
                            style: TextStyle(
                                color: Color.fromRGBO(109, 117, 135, 1),
                                fontSize: 20),
                          ),
                          Switch(
                            value: ThemeProvider.themeOf(context).id == 'dark'
                                ? true
                                : false,
                            onChanged: _onSwitchChanged,
                            activeColor: Colors.tealAccent,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => IncomeExpense()));
                      },
                      child: Container(
                        height: scrH / 15,
                        width: scrW,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: ThemeProvider.themeOf(context).id ==
                                            'dark'
                                        ? Colors.white10
                                        : Colors.grey[200],
                                    width: 1))),
                        child: Row(
                          children: [
                            Text(
                              jsonResult[0]['language'][locale]['p11.10'],
                              style: TextStyle(
                                  color: Color.fromRGBO(109, 117, 135, 1),
                                  fontSize: 20),
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
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showLanguageSet = true;
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        height: scrH / 15,
                        width: scrW,
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text(
                              jsonResult[0]['language'][locale]['p11.8'],
                              style: TextStyle(
                                  color: Color.fromRGBO(109, 117, 135, 1),
                                  fontSize: 20),
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
                !showLanguageSet
                    ? Container()
                    : Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                showLanguageSet = false;
                              });
                            },
                            child: Container(
                              height: scrH,
                              color: Colors.transparent,
                            ),
                          ),
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: scrH / 3,
                                  padding: EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                    color: ThemeProvider.themeOf(context).id ==
                                            'dark'
                                        ? Color.fromRGBO(37, 52, 65, 1)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(
                                            3, 6), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(jsonResult[0]['language'][locale]['p1.10'], style: TextStyle(fontWeight: FontWeight.bold),),
                                        ListTile(
                                          contentPadding: EdgeInsets.all(0),
                                          title: GestureDetector(child: Text('English')),
                                          leading: Radio(
                                            value: Language.english,
                                            groupValue: _character,
                                            onChanged: (Language value) {
                                              setState(() {
                                                _character = value;
                                                locale = 'en';
                                                saveLanguage();
                                              });
                                            },
                                          ),
                                        ),
                                        ListTile(
                                          contentPadding: EdgeInsets.all(0),
                                          title: const Text('French'),
                                          leading: Radio(
                                            value: Language.french,
                                            groupValue: _character,
                                            onChanged: (Language value) {
                                              setState(() {
                                                _character = value;
                                                locale = 'fr';
                                                saveLanguage();
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
