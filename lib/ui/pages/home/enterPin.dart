import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myassistantv2/core/global/variables.dart';
import 'package:myassistantv2/ui/pages/home/home.dart';
import 'package:myassistantv2/ui/pages/methods/pref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';

class EnterPin extends StatefulWidget {
  bool newUser = false;
  bool deActivate = false;
  EnterPin(this.newUser, this.deActivate);
  @override
  _EnterPinState createState() => _EnterPinState();
}

class _EnterPinState extends State<EnterPin> {
  String error = '';
  int _currentIndex = -1;

  Future getPin() async {
    var originalPin;
    final prefs = await SharedPreferences.getInstance();
    originalPin = prefs.getString('pin');

    if (pin == originalPin) {
      if (widget.deActivate) {
        setState(() {
          pin = "";
          clearPin();
        });
        Fluttertoast.showToast(msg: "PIN deactivated");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        setState(() {
          homeIndex = 0;
        });

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    } else {
      Fluttertoast.showToast(msg: "You entered wrong PIN");
      setState(() {
        pin = '';
        _currentIndex = -1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        if (!widget.deActivate) {
                          setState(() {
                            pinActive = false;
                            pin = "";
                          });
                        }
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
                            color: ThemeProvider.themeOf(context).id == 'dark'
                                ? Color.fromRGBO(37, 52, 65, 1)
                                : Colors.grey[100],
                            boxShadow: [
                              BoxShadow(
                                  color: ThemeProvider.themeOf(context).id ==
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
                Text(
                  widget.newUser
                      ? "Enter your PIN"
                      : widget.deActivate
                          ? "Enter your PIN to deactivate"
                          : "Set-up your PIN",
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                error == ''
                    ? Text(
                        error,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      )
                    : null,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                  width: scrW / 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      for (var x = 0; x < 4; x++)
                        AnimatedContainer(
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(100),
                              color: _currentIndex >= x
                                  ? ThemeProvider.themeOf(context).id == 'dark'
                                      ? Colors.tealAccent
                                      : Color.fromRGBO(0, 128, 225, 1)
                                  : Colors.black26,
                            ),
                            width: 15,
                            height: 15,
                            duration: Duration(milliseconds: 500))
                    ],
                  ),
                ),
                Container(
                  width: scrW,
                  height: scrH / 2.5,
                  child: Wrap(
                    spacing: 15,
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      for (var x = 1; x <= 9; x++)
                        GestureDetector(
                          onTap: () {
                            if (pin.length < 4) {
                              setState(() {
                                pin += x.toString();
                                _currentIndex++;
                              });

                              if (widget.newUser || widget.deActivate) {
                                if (pin.length == 4) {
                                  getPin();
                                }
                              }
                            }
                          },
                          child: Container(
                            child: Center(
                                child: Text(
                              "$x",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: scrW / 17),
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
                                      blurRadius: 1,
                                      offset: Offset(-6, -6)),
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8,
                                      offset: Offset(6, 6))
                                ]),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            width: scrW / 4,
                            height: scrH / 15,
                          ),
                        ),
                      GestureDetector(
                        onTap: () {
                          if (pin.length < 4) {
                            setState(() {
                              pin += '0';
                              _currentIndex++;
                            });
                            if (pin.length == 4) {
                              getPin();
                            }
                          }
                        },
                        child: Container(
                          child: Center(
                              child: Text(
                            "0",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: scrW / 17),
                          )),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ThemeProvider.themeOf(context).id == 'dark'
                                  ? Color.fromRGBO(37, 52, 65, 1)
                                  : Colors.grey[100],
                              boxShadow: [
                                BoxShadow(
                                    color: ThemeProvider.themeOf(context).id ==
                                            'dark'
                                        ? Colors.white12
                                        : Colors.white,
                                    blurRadius: 1,
                                    offset: Offset(-6, -6)),
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    offset: Offset(6, 6))
                              ]),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          width: scrW / 4,
                          height: scrH / 15,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (pin.length > 0) {
                              pin = pin.substring(0, pin.length - 1);
                              _currentIndex--;
                            }
                          });
                        },
                        child: Container(
                          child: Center(
                              child: Icon(
                            Icons.close,
                            color: Colors.grey,
                          )),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ThemeProvider.themeOf(context).id == 'dark'
                                  ? Color.fromRGBO(37, 52, 65, 1)
                                  : Colors.grey[100],
                              boxShadow: [
                                BoxShadow(
                                    color: ThemeProvider.themeOf(context).id ==
                                            'dark'
                                        ? Colors.white12
                                        : Colors.white,
                                    blurRadius: 1,
                                    offset: Offset(-6, -6)),
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    offset: Offset(6, 6))
                              ]),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          width: scrW / 1.9,
                          height: scrH / 15,
                        ),
                      ),
                    ],
                  ),
                ),
                widget.newUser
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          savePin();
                          setState(() {
                            pinActive = true;
                          });
                          Fluttertoast.showToast(msg: "PIN Activated");
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                        },
                        child: Container(
                            width: scrW / 2,
                            height: scrH / 15,
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
                                      blurRadius: 1,
                                      offset: Offset(-6, -6)),
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8,
                                      offset: Offset(6, 6))
                                ]),
                            child: Center(child: Text("Save"))),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
