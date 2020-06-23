import 'package:flutter/material.dart';
import 'package:myassistantv2/core/global/variables.dart';
class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    scrW = MediaQuery.of(context).size.width;
    scrH = MediaQuery.of(context).size.height;
    return Container(
      color: Color.fromRGBO(0,128,225,1),
      width: scrW,
      height: scrH,
      child: Container(
        child: Image.asset('assets/image/myassistant-logo.png', scale: 3,))
    );
  }
}