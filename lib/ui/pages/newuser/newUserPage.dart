import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:myassistantv2/core/global/variables.dart';
import 'package:myassistantv2/ui/pages/methods/pref.dart';
import 'package:myassistantv2/ui/pages/newuser/addBudget.dart';
import 'package:myassistantv2/ui/pages/newuser/askExpense.dart';
import 'package:myassistantv2/ui/pages/newuser/askIncome.dart';
import 'package:myassistantv2/ui/pages/newuser/askauth.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:http/http.dart' as http;
import '../settings/setPin.dart';
import 'askbank.dart';

class NewUserPage extends StatefulWidget {
  @override
  _NewUserPageState createState() => _NewUserPageState();
}

class _NewUserPageState extends State<NewUserPage> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  bool bio = false;
  List _authPage = [
    AskAuthBio(),
    SetPin(),
  ];
  int currentAuth = 0;
  String button = "Register fingerprint";

  _addPaymentMethod(paymentName, iconUrl) async {
    final respo = await http.post(
        "http://myassistant.ohm-conception.com/api/payment_method",
        body: {
          "name": paymentName,
          "icon": iconUrl,
        },
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer " + token
        });
    if (respo.statusCode == 200) {
      Fluttertoast.showToast(msg: "payment added");
    }
  }

  Future<bool> _isBiometricAvailable() async {
    bool isAvailable = false;
    try {
      isAvailable = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return isAvailable;

    isAvailable
        ? print('Biometric is available!')
        : print('Biometric is unavailable.');

    return isAvailable;
  }

  Future getListOfBiometricTypes() async {
    List<BiometricType> listOfBiometrics;
    try {
      listOfBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    print(listOfBiometrics);
  }

  Future authenticateUser() async {
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

    if (isAuthenticated) {
      fingerAvailability();
      saveFinger();
      controllerPage.nextPage(
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    }
  }

  int currentIndex = 1;
  PageController controllerPage = PageController();
  List<String> _titles = [
    "",
    jsonResult[0]['language'][locale]['p4.1'],
    jsonResult[0]['language'][locale]['p5.3'],
    jsonResult[0]['language'][locale]['p6.2']
  ];
  List<dynamic> _buttonTitles = [
    jsonResult[0]['language'][locale]['p3.4'],
    jsonResult[0]['language'][locale]['p4.4'],
    jsonResult[0]['language'][locale]['p4.4'],
    jsonResult[0]['language'][locale]['p4.4']
  ];

  Future checkFinger() async {
    if (await _isBiometricAvailable()) {
      setState(() {
        currentAuth = 0;
      });
    } else {
      setState(() {
        currentAuth = 1;
      });
    }
  }

  @override
  void initState() {
    checkFinger();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: scrW,
            height: scrH,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    width: scrW,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "${jsonResult[0]['language'][locale]['p3.1']} $currentIndex/4",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _titles[currentIndex - 1],
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                          child: PageView(
                    controller: controllerPage,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index + 1;
                      });
                    },
                    children: <Widget>[
                      _authPage[currentAuth],
                      AskBank(),
                      AskIncome(),
                      AskExpense()
                    ],
                  ))),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40,
                    ),
                    width: scrW / 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        for (var x = 0; x < 4; x++)
                          AnimatedContainer(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: currentIndex == x + 1
                                    ? ThemeProvider.themeOf(context).id ==
                                            'dark'
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
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      if (currentIndex == 1) {
                        if (currentAuth == 0) {
                          // await getListOfBiometricTypes();

                          authenticateUser();
                        } else {
                          savePin();
                          setState(() {
                            pinActive = true;
                          });
                          controllerPage.nextPage(
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeIn);
                        }
                      } else if (currentIndex == 2) {
                        print(bankInfo.length);
                        for (var x in bankInfo) {
                          _addPaymentMethod(x['name'], x['icon']);
                        }

                        controllerPage.nextPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeIn);
                      } else if (currentIndex == 3) {
                        setState(() {
                          incomeList = staticincomeCat;
                        });

                        controllerPage.nextPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeIn);
                      } else if (currentIndex == 4) {
                        setState(() {
                          expenseList = staticexpenseCat;
                        });

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddBudget(true, false)));
                      } else {
                        controllerPage.nextPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeIn);
                      }
                    },
                    child: Container(
                        width: scrW / 2.3,
                        height: 60,
                        decoration: BoxDecoration(
                            color: ThemeProvider.themeOf(context).id == 'dark'
                                ? Color.fromRGBO(37, 52, 65, 1)
                                : Color.fromRGBO(241, 243, 246, 1),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: ThemeProvider.themeOf(context).id ==
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
                          _buttonTitles[currentIndex - 1],
                          style: TextStyle(
                              color: ThemeProvider.themeOf(context).id == 'dark'
                                  ? Colors.tealAccent
                                  : Colors.black),
                        ))),
                  ),
                  InkWell(
                    onTap: () {
                      if (currentIndex == 4) {
                        staticexpenseCat.clear();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddBudget(true, false)));
                      } else {
                        controllerPage.nextPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeIn);
                        if (currentIndex == 3) {
                          staticincomeCat.clear();
                        }
                        if (currentIndex == 2) {
                          bankInfo.clear();
                        }
                      }
                    },
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(
                          vertical: 30,
                        ),
                        width: scrW,
                        alignment: Alignment.center,
                        child: Text(
                          jsonResult[0]['language'][locale]['p3.5'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
