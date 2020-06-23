import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:myassistantv2/core/global/variables.dart';
import 'package:myassistantv2/ui/pages/home/home.dart';
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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

  Future<void> _getListOfBiometricTypes() async {
    List<BiometricType> listOfBiometrics;
    try {
      listOfBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    print(listOfBiometrics);
  }

  Future<void> _authenticateUser() async {
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
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: scrW,
      height: scrH,
      child: Center(child: Text("You need to authenticate in device")),
    );
  }
}