import 'package:flutter/material.dart';
import 'package:myassistantv2/core/global/variables.dart';
import 'package:theme_provider/theme_provider.dart';

class SetPin extends StatefulWidget {
  @override
  _SetPinState createState() => _SetPinState();
}

class _SetPinState extends State<SetPin> {
  int _currentIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text(
            jsonResult[0]['language'][locale]['p11.3'],
            style: TextStyle(
                color: Colors.black45,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: scrH / 30,
          ),
          Text(
            jsonResult[0]['language'][locale]['p11.4'],
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
            height: scrH / 2.3,
            child: Wrap(
              spacing: 10,
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
                      }
                      print(pin);
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
                          color: ThemeProvider.themeOf(context).id == 'dark'
                              ? Color.fromRGBO(37, 52, 65, 1)
                              : Colors.grey[100],
                          boxShadow: [
                            BoxShadow(
                                color:
                                    ThemeProvider.themeOf(context).id == 'dark'
                                        ? Colors.white12
                                        : Colors.white,
                                blurRadius: 1,
                                offset: Offset(-6, -6)),
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(6, 6))
                          ]),
                      margin: EdgeInsets.symmetric(vertical: 7),
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
                              color: ThemeProvider.themeOf(context).id == 'dark'
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
                              color: ThemeProvider.themeOf(context).id == 'dark'
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
          )
        ],
      ),
    );
  }
}
