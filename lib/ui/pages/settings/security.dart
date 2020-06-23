import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:myassistantv2/core/global/variables.dart';
import 'package:myassistantv2/ui/pages/home/enterPin.dart';
import 'package:myassistantv2/ui/pages/methods/pref.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:flutter/services.dart';

class Security extends StatefulWidget {
  @override
  _SecurityState createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  Future authenticateUser(val) async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason:
            "Please authenticate to view your transaction overview",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;
    isAuthenticated
        ? print('User is authenticated!')
        : print('User is not authenticated.');

    if (!val) {
      if (isAuthenticated) {
        setState(() {
          fingerActive = false;
          clearFinger();
        });
      } else {
        setState(() {
          fingerActive = true;
        });
      }
    } else {
      if (isAuthenticated) {
        setState(() {
          fingerActive = true;
          saveFinger();
        });
      } else {
        setState(() {
          fingerActive = false;
        });
      }
    }
  }



  registerFinger(val) {
    var stringAct = val ? "Activate" : "Deactivate";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.fingerprint), Text("Touch ID to $stringAct")],
          ),

          // actions: <Widget>[
          //   new FlatButton(
          //     child: new Text("Close"),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          // ],
        );
      },
    );

  }

  void checkPinActive(bool value) {
    setState(() {
      pin="";
    });
    if (value) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => EnterPin(false, false)));
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => EnterPin(false, true)));
    }
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
              Row(
                children: <Widget>[
                  Icon(
                    Icons.fingerprint,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: scrW - 150,
                    child: Text(
                      jsonResult[0]['language'][locale]['p11.1'],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Color.fromRGBO(109, 117, 135, 1),
                          fontSize: scrW / 20),
                    ),
                  ),
                  Expanded(child: Container()),
                  Transform.scale(
                    scale: 1.2,
                    child: Switch(
                        value: fingerActive,
                        onChanged: (value) {
                          registerFinger(value);
                        }),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Image.asset(
                    'assets/image/security.png',
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    jsonResult[0]['language'][locale]['p11.3'],
                    style: TextStyle(
                        color: Color.fromRGBO(109, 117, 135, 1), fontSize: 20),
                  ),
                  Expanded(child: Container()),
                  Transform.scale(
                    scale: 1.2,
                    child: new Switch(
                      value: pinActive,
                      onChanged: (val) {
                        checkPinActive(val);
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
