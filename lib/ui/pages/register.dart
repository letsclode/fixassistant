import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myassistantv2/core/global/variables.dart';
import 'package:myassistantv2/ui/pages/newuser/newUserPage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController c_pass = new TextEditingController();
  bool _obscureText = true;
  bool _obscureText2 = true;
  bool _keyboard = false;
  bool _loader = false;
  String errors = '';
  Color errorColor = Colors.red;
  var data;
  GlobalKey globe = GlobalKey();

  Future _createCurrency() async {
    var names = ['usd', 'euro'];
    for (var name in names) {
      final respo = await http
          .post("http://myassistant.ohm-conception.com/api/currency", body: {
        "name": name,
      }, headers: {
        HttpHeaders.authorizationHeader: "Bearer " + token,
        "Accept": "application/json"
      });
      print('currency created');
    }
  }

  Future _registerNew() async {
    final respo = await http
        .post("http://myassistant.ohm-conception.com/api/register", body: {
      "name": 'null',
      "email": email.text,
      "password": password.text,
    });
    if (respo.statusCode == 200) {
      var data = json.decode(respo.body);
      setState(() {
        token = token = data['success']['token'];
      });
      setState(() {
        errorColor = ThemeProvider.themeOf(context).id == 'dark'
            ? Colors.tealAccent
            : secColor;
        errors = jsonResult[0]['language'][locale]['p1.16'];
      });
      Timer(
          Duration(milliseconds: 500),
          () => _createCurrency().whenComplete(() {
                _login(email.text, password.text);
              }));
    } else {
      var data = json.decode(respo.body);
      setState(() {
        _loader = false;
      });
      Map error = data['error'];
      if (error != null) {
        var getError = error.values.toList();
        setState(() {
          errors = getError[0]
          
              .toString()
              .substring(1, getError[0].toString().length - 1);
          if(errors == "The email has already been taken."){
            if(locale == 'fr'){
              errors = "Courriel déjà pris";
            }
          }
          print(errors);
        });
      }
    }
  }

  savePref(email, pass) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('acc_mail', email);
    prefs.setString('acc_pass', pass);
  }

  Future _login(email, password) async {
    final response = await http.post(
      "http://myassistant.ohm-conception.com/api/login",
      body: {
        "email": email,
        "password": password,
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        token = data['success']['token'];
        budget = data['success']['details']['budgets'];
        payment = data['success']['details']['payment_methods'];
        pass = password;
        uemail = email;
        uname = data['success']['details']['name'];
        id = data['success']['details']['id'].toString();
        allIncomeExpense =
            data['success']['details']['incomeexpense_categories'];
        currency = data['success']['details']['currencies'];
      });

      if (budget.length == 0) {
        savePref(email, password);
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: ThemeConsumer(child: NewUserPage()),
                type: PageTransitionType.leftToRightWithFade));
      }
    }
    setState(() {
      _loader = false;
    });
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    c_pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globe,
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: scrW,
              height: scrH,
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: scrH / 30,
                      ),
                      Text(
                        jsonResult[0]['language'][locale]['p2.1'],
                        style: TextStyle(
                          color: ThemeProvider.themeOf(context).id == 'dark'
                              ? Colors.tealAccent
                              : secColor,
                          fontSize: scrW / 15,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        jsonResult[0]['language'][locale]['p2.2'],
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
                              color: ThemeProvider.themeOf(context).id == 'dark'
                                  ? Color.fromRGBO(32, 48, 59, 1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: ThemeProvider.themeOf(context).id ==
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
                                  _keyboard = true;
                                });
                              },
                              onSubmitted: (x) {
                                setState(() {
                                  _keyboard = false;
                                });
                              },
                              onChanged: (x) {
                                setState(() {
                                  errors = '';
                                });
                              },
                              controller: email,
                              decoration: InputDecoration(
                                  hintText: jsonResult[0]['language'][locale]
                                      ['p1.3'],
                                  hintStyle: TextStyle(
                                      color:
                                          ThemeProvider.themeOf(context).id ==
                                                  'dark'
                                              ? Colors.white12
                                              : Colors.grey[400],
                                      fontWeight: FontWeight.bold,
                                      fontSize: scrW / 27),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none)),
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            decoration: BoxDecoration(
                              color: ThemeProvider.themeOf(context).id == 'dark'
                                  ? Color.fromRGBO(32, 48, 59, 1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: ThemeProvider.themeOf(context).id ==
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
                                  _keyboard = true;
                                });
                              },
                              onSubmitted: (x) {
                                setState(() {
                                  _keyboard = false;
                                });
                              },
                              controller: password,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      icon: _obscureText
                                          ? Icon(
                                              Icons.visibility_off,
                                              color:
                                                  ThemeProvider.themeOf(context)
                                                              .id ==
                                                          'dark'
                                                      ? Colors.grey[700]
                                                      : Colors.grey[300],
                                            )
                                          : Icon(
                                              Icons.visibility,
                                              color: Colors.grey,
                                            ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      }),
                                  hintText: jsonResult[0]['language'][locale]
                                      ['p1.4'],
                                  hintStyle: TextStyle(
                                    color: ThemeProvider.themeOf(context).id ==
                                            'dark'
                                        ? Colors.white12
                                        : Colors.grey[400],
                                    fontWeight: FontWeight.bold,
                                    fontSize: scrW / 27,
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none)),
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            decoration: BoxDecoration(
                              color: ThemeProvider.themeOf(context).id == 'dark'
                                  ? Color.fromRGBO(32, 48, 59, 1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: ThemeProvider.themeOf(context).id ==
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
                                  _keyboard = true;
                                });
                              },
                              onSubmitted: (x) {
                                setState(() {
                                  _keyboard = false;
                                });
                              },
                              controller: c_pass,
                              obscureText: _obscureText2,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      icon: _obscureText2
                                          ? Icon(
                                              Icons.visibility_off,
                                              color:
                                                  ThemeProvider.themeOf(context)
                                                              .id ==
                                                          'dark'
                                                      ? Colors.grey[700]
                                                      : Colors.grey[300],
                                            )
                                          : Icon(
                                              Icons.visibility,
                                              color: Colors.grey,
                                            ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureText2 = !_obscureText2;
                                        });
                                      }),
                                  hintText: jsonResult[0]['language'][locale]
                                      ['p2.3'],
                                  hintStyle: TextStyle(
                                      color:
                                          ThemeProvider.themeOf(context).id ==
                                                  'dark'
                                              ? Colors.white12
                                              : Colors.grey[400],
                                      fontWeight: FontWeight.bold,
                                      fontSize: scrW / 27),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        errors,
                        style: TextStyle(color: errorColor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _loader = true;
                          });
                          if (email.text.length != 0 &&
                              password.text.length != 0 &&
                              c_pass.text.length != 0) {
                            if (password.text == c_pass.text) {
                              if (email.text.contains('@')) {
                                _registerNew();
                              } else {
                                setState(() {
                                  errors = jsonResult[0]['language'][locale]
                                      ['p12.1'];
                                  _loader = false;
                                });
                              }
                            } else {
                              setState(() {
                                errors =
                                    jsonResult[0]['language'][locale]['p12.2'];
                                _loader = false;
                              });
                            }
                          } else {
                            setState(() {
                              errors =
                                  jsonResult[0]['language'][locale]['p12.3'];
                              _loader = false;
                            });
                          }
                        },
                        child: Container(
                            width: scrW / 2.3,
                            height: 60,
                            decoration: BoxDecoration(
                                color:
                                    ThemeProvider.themeOf(context).id == 'dark'
                                        ? Color.fromRGBO(37, 52, 65, 1)
                                        : Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          ThemeProvider.themeOf(context).id ==
                                                  'dark'
                                              ? Colors.white12
                                              : Colors.white,
                                      blurRadius: 10,
                                      offset: Offset(-7, -7)),
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10,
                                      offset: Offset(8, 8))
                                ]),
                            child: Center(
                              child: Text(
                                jsonResult[0]['language'][locale]['p1.7'],
                                style: TextStyle(
                                    color: ThemeProvider.themeOf(context).id ==
                                            'dark'
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            )),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(jsonResult[0]['language'][locale]['p2.4'] + " "),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              jsonResult[0]['language'][locale]['p1.8'],
                              style: TextStyle(
                                color:
                                    ThemeProvider.themeOf(context).id == 'dark'
                                        ? Colors.tealAccent
                                        : secColor,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ],
              )),
          _loader == true
              ? Container(
                  width: scrW,
                  height: scrH,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container()
        ],
      )),
    );
  }
}
