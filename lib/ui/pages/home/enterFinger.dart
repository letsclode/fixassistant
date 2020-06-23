import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:myassistantv2/core/global/variables.dart';
import 'package:myassistantv2/ui/pages/home/home.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:flutter/services.dart';
class EnterFingerPrint extends StatefulWidget {
  @override
  _EnterFingerPrintState createState() => _EnterFingerPrintState();
}

class _EnterFingerPrintState extends State<EnterFingerPrint> {
   final LocalAuthentication _localAuthentication = LocalAuthentication();
   
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
   await Future.delayed(Duration(
      seconds: 3
    ));
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
      
      print("pass");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));
    } else {
      print("fail");
      // setState(() {
      //   currentAuth = 1;
      // });
      //save unavailability
    }
  }

  @override
  void initState() {
   getListOfBiometricTypes();
   authenticateUser();
    super.initState();
  }

@override
void dispose(){
  super.dispose();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: SafeArea(
        child: Container(
          width: scrW,
          height: scrH,
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              
              Container(
                width: scrW,
                height: scrH - (scrH / 2.5),
               
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container()),
                    Container(
                      
                      constraints: BoxConstraints(
                        maxHeight: 300
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Icon(
                        Icons.fingerprint,
                        size: 100,
                        color: ThemeProvider.themeOf(context).id == 'dark' ? Colors.tealAccent: Colors.black,
                      ),
                      Text(
                        "The App is protected by fingerprint ID",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      
                        ],
                      ),
                    ),

                     Text(
                        "You can disable fingerprint security in settings",
                        style: TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    Expanded(
                      flex: 2,
                      child: Container(),
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