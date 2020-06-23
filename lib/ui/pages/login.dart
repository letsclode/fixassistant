import 'package:flutter/material.dart';
import 'package:myassistantv2/core/global/variables.dart';
import 'package:myassistantv2/core/services/authentication.dart';
import 'package:myassistantv2/core/services/social_login.dart';
import 'package:myassistantv2/ui/pages/register.dart';
import 'package:theme_provider/theme_provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool fbIn = false;
  bool googleIn = false;
  bool _loader = false;
  bool _obscureText = true;
  String testEmail = '';
  bool keyboard = false;
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      child: Scaffold(
        body: SafeArea(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: scrW,
              height: scrH,
              child: Stack(
                children: <Widget>[
                  ListView(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            height: scrH / 30,
                          ),
                          Text(
                            jsonResult[0]['language'][locale]['p1.1'],
                            style: TextStyle(
                              color: ThemeProvider.themeOf(context).id == 'dark'
                                  ? Colors.tealAccent
                                  : secColor,
                              fontSize: scrW / 15,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            jsonResult[0]['language'][locale]['p1.2'],
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: ThemeProvider.themeOf(context).id ==
                                          'dark'
                                      ? Color.fromRGBO(32, 48, 59, 1)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            ThemeProvider.themeOf(context).id ==
                                                    'dark'
                                                ? Colors.grey[900]
                                                : Colors.grey[300],
                                        blurRadius: 1,
                                        offset: Offset(-3, -3)),
                                  ],
                                ),
                                child: TextField(
                                  onTap: () {
                                    setState(() {
                                      keyboard = true;
                                    });
                                  },
                                  onSubmitted: (x) {
                                    setState(() {
                                      keyboard = false;
                                    });
                                  },
                                  controller: email,
                                  decoration: InputDecoration(
                                      hintText: jsonResult[0]['language']
                                          [locale]['p1.3'],
                                      hintStyle: TextStyle(
                                        color:
                                            ThemeProvider.themeOf(context).id ==
                                                    'dark'
                                                ? Colors.white12
                                                : Colors.grey[400],
                                        fontWeight: FontWeight.bold,
                                      ),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none)),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: ThemeProvider.themeOf(context).id ==
                                          'dark'
                                      ? Color.fromRGBO(32, 48, 59, 1)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            ThemeProvider.themeOf(context).id ==
                                                    'dark'
                                                ? Colors.grey[900]
                                                : Colors.grey[300],
                                        blurRadius: 1,
                                        offset: Offset(-3, -3)),
                                  ],
                                ),
                                child: TextField(
                                  onTap: () {
                                    setState(() {
                                      keyboard = true;
                                    });
                                  },
                                  onSubmitted: (x) {
                                    setState(() {
                                      keyboard = false;
                                    });
                                  },
                                  controller: password,
                                  obscureText: _obscureText,
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                          icon: _obscureText
                                              ? Icon(
                                                  Icons.visibility_off,
                                                  color: ThemeProvider.themeOf(
                                                                  context)
                                                              .id ==
                                                          'dark'
                                                      ? Colors.white12
                                                      : Colors.grey[400],
                                                )
                                              : Icon(
                                                  Icons.visibility,
                                                  color: ThemeProvider.themeOf(
                                                                  context)
                                                              .id ==
                                                          'dark'
                                                      ? Colors.white12
                                                      : Colors.grey,
                                                ),
                                          onPressed: () {
                                            setState(() {
                                              _obscureText = !_obscureText;
                                            });
                                          }),
                                      hintText: jsonResult[0]['language']
                                          [locale]['p1.4'],
                                      hintStyle: TextStyle(
                                          color: ThemeProvider.themeOf(context)
                                                      .id ==
                                                  'dark'
                                              ? Colors.white12
                                              : Colors.grey[400],
                                          fontWeight: FontWeight.bold),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: scrH / 30,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _loader = true;
                              });
                              
                              Authentication.login(email, password, context).whenComplete((){
                                setState(() {
                                  _loader = false;
                                });
                              });
                            },
                            child: Container(
                                width: scrW / 2.3,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: ThemeProvider.themeOf(context).id ==
                                            'dark'
                                        ? Color.fromRGBO(37, 52, 65, 1)
                                        : Color.fromRGBO(241, 243, 246, 1),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: ThemeProvider.themeOf(context)
                                                      .id ==
                                                  'dark'
                                              ? Colors.white12
                                              : Colors.white,
                                          blurRadius: 7,
                                          offset: Offset(-8, -8)),
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 10,
                                          offset: Offset(8, 8))
                                    ]),
                                child: Center(
                                    child: Text(
                                  jsonResult[0]['language'][locale]['p1.8'],
                                  style: TextStyle(
                                      color:
                                          ThemeProvider.themeOf(context).id ==
                                                  'dark'
                                              ? Colors.tealAccent
                                              : Colors.black),
                                ))),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          keyboard != false
                              ? Container()
                              : Column(
                                  children: <Widget>[
                                    Text(
                                      jsonResult[0]['language'][locale]['p1.5'],
                                      style: TextStyle(
                                          color: ThemeProvider.themeOf(context)
                                                      .id ==
                                                  'dark'
                                              ? Colors.white
                                              : Colors.black54),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            SocialLogin.facebookSignIn(context);
                                          },
                                          child: Container(
                                              width: scrW / 2.3,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                  color: ThemeProvider.themeOf(
                                                                  context)
                                                              .id ==
                                                          'dark'
                                                      ? Color.fromRGBO(
                                                          37, 52, 65, 1)
                                                      : Color.fromRGBO(
                                                          241, 243, 246, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: ThemeProvider.themeOf(
                                                                        context)
                                                                    .id ==
                                                                'dark'
                                                            ? Colors.white12
                                                            : Colors.white,
                                                        blurRadius: 7,
                                                        offset: Offset(-8, -8)),
                                                    BoxShadow(
                                                        color: Colors.black12,
                                                        blurRadius: 10,
                                                        offset: Offset(8, 8))
                                                  ]),
                                              child: Center(
                                                  child: Text(
                                                "Facebook",
                                                style: TextStyle(
                                                    color:
                                                        ThemeProvider.themeOf(
                                                                        context)
                                                                    .id ==
                                                                'dark'
                                                            ? Colors.tealAccent
                                                            : Colors.black),
                                              ))),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SocialLogin.googleLogIn(context);
                                          },
                                          child: Container(
                                              width: scrW / 2.3,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                  color: ThemeProvider.themeOf(
                                                                  context)
                                                              .id ==
                                                          'dark'
                                                      ? Color.fromRGBO(
                                                          37, 52, 65, 1)
                                                      : Color.fromRGBO(
                                                          241, 243, 246, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: ThemeProvider.themeOf(
                                                                        context)
                                                                    .id ==
                                                                'dark'
                                                            ? Colors.white12
                                                            : Colors.white,
                                                        blurRadius: 7,
                                                        offset: Offset(-8, -8)),
                                                    BoxShadow(
                                                        color: Colors.black12,
                                                        blurRadius: 10,
                                                        offset: Offset(8, 8))
                                                  ]),
                                              child: Center(
                                                  child: Text(
                                                "Google",
                                                style: TextStyle(
                                                    color:
                                                        ThemeProvider.themeOf(
                                                                        context)
                                                                    .id ==
                                                                'dark'
                                                            ? Colors.tealAccent
                                                            : Colors.black),
                                              ))),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          jsonResult[0]['language'][locale]
                                              ['p1.6'],
                                          style: TextStyle(
                                              color:
                                                  ThemeProvider.themeOf(context)
                                                              .id ==
                                                          'dark'
                                                      ? Colors.white
                                                      : Colors.black54),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ThemeConsumer(
                                                            child:
                                                                Register())));
                                          },
                                          child: Text(
                                            jsonResult[0]['language'][locale]
                                                ['p1.7'],
                                            style: TextStyle(
                                                color: ThemeProvider.themeOf(
                                                                context)
                                                            .id ==
                                                        'dark'
                                                    ? Colors.tealAccent
                                                    : secColor),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ],
                  ),
                  _loader
                      ? Container(
                          width: scrW,
                          height: scrH,
                          child: Center(
                            child: CircularProgressIndicator(
                              backgroundColor: secColor,
                            ),
                          ),
                        )
                      : Container(),
                ],
              )),
        ),
      ),
    );
  }
}
