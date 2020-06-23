import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myassistantv2/core/global/variables.dart';
import 'package:myassistantv2/ui/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:http/http.dart' as http;
class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool fb = false;
  bool google = false;
  var fbEmail = "";
  var googleEmail ="";
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FacebookLogin _facebookLogin = new FacebookLogin();
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future registerNew(email, password) async {
    setState(() {
      if (fb) {
        fbActive = true;
      } else if (google) {
        googleActive = true;
      }
    });
    final respo = await http
        .post("http://myassistant.ohm-conception.com/api/register", body: {
      "name": 'null',
      "email": email,
      "password": password,
    });
    if (respo.statusCode == 200) {
      print("register");
      Fluttertoast.showToast(msg: "Register Success");
    } else {
      print("fail");
    }
  }

  getGoogleFb() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      var google = prefs.getBool('googleIn');
      var fb = prefs.getBool('fbIn');
      if (fb != null) {
        fbActive = fb;
      }

      if (google != null) {
        googleActive = google;
      }
    });
  }

  Future<String> removeData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
    return "SUCCESS!";
  }

  @override
  void initState() {
    getGoogleFb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: scrW,
          height: scrH,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
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
                      color: ThemeProvider.themeOf(context).id == 'dark'
                          ? Color.fromRGBO(37, 52, 65, 1)
                          : Colors.grey[100],
                      boxShadow: [
                        BoxShadow(
                            color: ThemeProvider.themeOf(context).id == 'dark'
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
              SizedBox(
                height: 20,
              ),
              fbActive
                  ? GestureDetector(
                      onTap: () {
                        setState(() {});
                      },
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            'assets/image/fb.png',
                            width: 25,
                            height: 25,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Facebook",
                            style: TextStyle(
                                color: Color.fromRGBO(109, 117, 135, 1),
                                fontSize: scrW / 20),
                          ),
                          Expanded(child: Container()),
                          Text(uemail),
                          SizedBox(
                            width: 10,
                          ),
                          // Container(
                          //   margin: EdgeInsets.only(right: 10),
                          //   child: Center(
                          //       child: Icon(
                          //     Icons.delete,
                          //     color: Colors.red,
                          //   )),
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(10),
                          //       color:
                          //           ThemeProvider.themeOf(context).id == 'dark'
                          //               ? Color.fromRGBO(37, 52, 65, 1)
                          //               : Colors.grey[100],
                          //       boxShadow: [
                          //         BoxShadow(
                          //             color:
                          //                 ThemeProvider.themeOf(context).id ==
                          //                         'dark'
                          //                     ? Colors.white12
                          //                     : Colors.white,
                          //             blurRadius: 5,
                          //             offset: Offset(-7, -7)),
                          //         BoxShadow(
                          //             color: Colors.black12,
                          //             blurRadius: 10,
                          //             offset: Offset(8, 8))
                          //       ]),
                          //   width: 40,
                          //   height: 40,
                          // ),
                        ],
                      ),
                    )
                  : DottedBorder(
                  dashPattern: [10],
                  color: Colors.grey,
                  strokeWidth: 1,
                  child: GestureDetector(
                    onTap: (){
                    
                    },
                                      child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Center(
                        child: Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/image/fb.png',
                              width: 25,
                              height: 25,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Facebook",
                              style: TextStyle(
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.bold,
                                  fontSize: scrW / 20),
                            ),
                            Expanded(child: Container()),
                            // Icon(
                            //   Icons.add_circle_outline,
                            //   color: Colors.grey,
                            // ),
                            // SizedBox(width: 10),
                            // Text(
                            //   jsonResult[0]['language'][locale]['p5.4'],
                            //   style: TextStyle(
                            //       color: Colors.grey,
                            //       fontWeight: FontWeight.bold),
                            // )
                          ],
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              googleActive
                  ? GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            'assets/image/google.png',
                            width: 25,
                            height: 25,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Google",
                            style: TextStyle(
                                color: Color.fromRGBO(109, 117, 135, 1),
                                fontSize: scrW / 20),
                          ),
                          Expanded(child: Container()),
                          Text(uemail),
                          SizedBox(
                            width: 10,
                          ),
                          // Container(
                          //   padding: EdgeInsets.only(right: 10),
                          //   child: Center(
                          //       child: Icon(
                          //     Icons.delete,
                          //     color: Colors.red,
                          //   )),
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(10),
                          //       color:
                          //           ThemeProvider.themeOf(context).id == 'dark'
                          //               ? Color.fromRGBO(37, 52, 65, 1)
                          //               : Colors.grey[100],
                          //       boxShadow: [
                          //         BoxShadow(
                          //             color:
                          //                 ThemeProvider.themeOf(context).id ==
                          //                         'dark'
                          //                     ? Colors.white12
                          //                     : Colors.white,
                          //             blurRadius: 5,
                          //             offset: Offset(-7, -7)),
                          //         BoxShadow(
                          //             color: Colors.black12,
                          //             blurRadius: 10,
                          //             offset: Offset(8, 8))
                          //       ]),
                          //   margin: EdgeInsets.symmetric(vertical: 20),
                          //   width: 40,
                          //   height: 40,
                          // ),
                        ],
                      ),
                    )
                  : DottedBorder(
                  dashPattern: [10],
                  color: Colors.grey,
                  strokeWidth: 1,
                  child: GestureDetector(
                    onTap: (){
                    
                    },
                                      child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Center(
                        child: Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/image/google.png',
                              width: 25,
                              height: 25,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Google",
                              style: TextStyle(
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.bold,
                                  fontSize: scrW / 20),
                            ),
                            Expanded(child: Container()),
                            // Icon(
                            //   Icons.add_circle_outline,
                            //   color: Colors.grey,
                            // ),
                            // SizedBox(width: 10),
                            // Text(
                            //   jsonResult[0]['language'][locale]['p5.4'],
                            //   style: TextStyle(
                            //       color: Colors.grey,
                            //       fontWeight: FontWeight.bold),
                            // )
                          ],
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  removeData();
                  setState(() {
                    homeIndex = 0;
                    pin = '';
                  });
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.grey,
                      size: scrW / 15,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      jsonResult[0]['language'][locale]['p10.5'],
                      style: TextStyle(
                          color: Color.fromRGBO(109, 117, 135, 1),
                          fontSize: scrW / 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
