import 'dart:ui';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myassistantv2/core/global/variables.dart';
import 'package:theme_provider/theme_provider.dart';
class AskBank extends StatefulWidget {
  AskBank({Key key}) : super(key: key);
  @override
  _AskBankState createState() => _AskBankState();
}

class _AskBankState extends State<AskBank> {
  TextEditingController paymentMethodName = new TextEditingController();
  bool successfulDrop;
  bool showBin = false;
  int removeIndex = 0;
  String iconUrl = 'assets/image/bank.png';

  _addPaymentMethod(){ 
      setState(() {
         bankInfo.add({
         "name": paymentMethodName.text.toUpperCase()[0] + paymentMethodName.text.substring(1),
         "icon": iconUrl
       });
      });

      print(bankInfo.length);
      Fluttertoast.showToast(msg: jsonResult[0]['language'][locale]['p12.4']);
      Navigator.pop(context);
  }

  void showEdit(index) {
    showGeneralDialog(
        barrierColor: Colors.white.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: AlertDialog(
                    backgroundColor: Colors.transparent,
                    contentPadding: EdgeInsets.all(0),
                    content: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                      child: Container(
                        height: scrH / 2.6,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                                child: Container(
                                    child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  jsonResult[0]['language'][locale]['p5.5'],
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: scrW / 15),
                                ),
                                Text(
                                  jsonResult[0]['language'][locale]['p4.7'],
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: scrW / 2,
                                      height: scrH / 14,
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1,
                                            color: Colors.grey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: TextField(
                                        controller: paymentMethodName,
                                        decoration: InputDecoration.collapsed(
                                            hintText: bankInfo[index]
                                                ['name'],
                                            hintStyle: TextStyle(
                                                color: Colors.grey[300])),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                        child: AnimatedContainer(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2),
                                      decoration: BoxDecoration(
                                          color: ThemeProvider.themeOf(context)
                                                      .id ==
                                                  'dark'
                                              ? Color.fromRGBO(37, 52, 65, 1)
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
                                                blurRadius: 3,
                                                offset: Offset(-7, -7)),
                                            BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 10,
                                                offset: Offset(8, 8))
                                          ]),
                                      duration: Duration(milliseconds: 500),
                                      width: scrW / 1.6,
                                      height: 60,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          icon: Icon(Icons.arrow_drop_down),
                                          style: TextStyle(
                                              color:
                                                  ThemeProvider.themeOf(context)
                                                              .id ==
                                                          'dark'
                                                      ? Colors.white
                                                      : Colors.black,
                                              fontSize: 17),
                                          isExpanded: true,
                                          value: bankInfo[index]['icon'],
                                          onChanged: (newCurr) {
                                            setState(() {
                                              iconUrl = newCurr.toString();
                                            });
                                          },
                                          items: tempbankInfo.map((dynamic bank) {
                                            return DropdownMenuItem<dynamic>(
                                              child: Container(
                                                  padding: EdgeInsets.all(4),
                                                  width: 50,
                                                  height: 50,
                                                  child: Image.asset(
                                                    bank['icon'],
                                                    color: Colors.grey,
                                                    width: 10,
                                                    height: 10,
                                                  )),
                                              value: bank['icon'],
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ))
                                  ],
                                ),
                               
                              ],
                            ))),
                            GestureDetector(
                              onTap: () {
                                if (paymentMethodName.text.isEmpty) {
                                  paymentMethodName.text =
                                      bankInfo[index]['name'];
                                }
                             
                                if (iconUrl == "assets/image/bank.png") {
                                  iconUrl = bankInfo[index]['icon'];
                                }
                                //tap
                                bankInfo.removeAt(index);
                                _addPaymentMethod();
                                paymentMethodName.clear();
                 
                              },
                              child: Container(
                                  width: scrW,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: ThemeProvider.themeOf(context)
                                                  .id ==
                                              'dark'
                                          ? Color.fromRGBO(37, 52, 65, 1)
                                          : Color.fromRGBO(241, 243, 246, 1),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                ThemeProvider.themeOf(context)
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
                                    jsonResult[0]['language'][locale]['p4.9'],
                                    style: TextStyle(
                                        color:
                                            ThemeProvider.themeOf(context).id ==
                                                    'dark'
                                                ? Colors.tealAccent
                                                : Colors.black),
                                  ))),
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, a1, a2) {});
  }

  void showAddPayment() {
    showGeneralDialog(
        barrierColor: Colors.white.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: AlertDialog(
                    backgroundColor: Colors.transparent,
                    contentPadding: EdgeInsets.all(0),
                    content: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                      child: Container(
                        height: scrH / 3.2,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                                child: Container(
                                    child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  jsonResult[0]['language'][locale]['p4.6'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: scrW / 15),
                                ),


                                //remove 4.7

                                SizedBox(height: 20,),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: scrW / 2,
                                      height: scrH / 14,
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1,
                                            color: Colors.grey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: TextField(
                                        controller: paymentMethodName,
                                        decoration: InputDecoration.collapsed(
                                            hintText: jsonResult[0]['language'][locale]['p4.8'],
                                            hintStyle: TextStyle(
                                                color: Colors.grey[300])),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                        child: AnimatedContainer(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2),
                                      decoration: BoxDecoration(
                                          color: ThemeProvider.themeOf(context)
                                                      .id ==
                                                  'dark'
                                              ? Color.fromRGBO(37, 52, 65, 1)
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
                                                blurRadius: 3,
                                                offset: Offset(-7, -7)),
                                            BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 10,
                                                offset: Offset(8, 8))
                                          ]),
                                      duration: Duration(milliseconds: 500),
                                      width: scrW / 1.6,
                                      height: 60,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          icon: Icon(Icons.arrow_drop_down),
                                          style: TextStyle(
                                              color:
                                                  ThemeProvider.themeOf(context)
                                                              .id ==
                                                          'dark'
                                                      ? Colors.white
                                                      : Colors.black,
                                              fontSize: 17),
                                          isExpanded: true,
                                          value: iconUrl,
                                          onChanged: (newCurr) {
                                      
                                            setState(() {
                                              iconUrl = newCurr.toString();
                                            });
                                          },
                                          items: tempbankInfo.map((dynamic bank) {
                                            return DropdownMenuItem<dynamic>(
                                              child: Container(
                                                padding: EdgeInsets.all(4),
                                                width: 50,
                                                height: 50,
                                                child: Image.asset(bank['icon'],color: Colors.grey,
                                                width: 10,
                                                height: 10,)),
                                              value: bank['icon'],
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ))
                                  ],
                                ),
                              ],
                            ))),
                            GestureDetector(
                              onTap: () {
                                //tap
                                _addPaymentMethod();
                                paymentMethodName.clear();
                              },
                              child: Container(
                                  width: scrW,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: ThemeProvider.themeOf(context)
                                                  .id ==
                                              'dark'
                                          ? Color.fromRGBO(37, 52, 65, 1)
                                          : Color.fromRGBO(241, 243, 246, 1),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                ThemeProvider.themeOf(context)
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
                                    jsonResult[0]['language'][locale]['p4.9'],
                                    style: TextStyle(
                                        color:
                                            ThemeProvider.themeOf(context).id ==
                                                    'dark'
                                                ? Colors.tealAccent
                                                : Colors.black),
                                  ))),
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, a1, a2) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child:
             Stack(
               children: <Widget>[
                 Container(
                width: scrW,
                height: scrH,
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          shrinkWrap: true,
                          children: <Widget>[
                            for (var x = 0; x < bankInfo.length; x++)
                              Draggable(
                                  onDraggableCanceled: (x, y) {
                                    print("Drag Cancelled");
                                    setState(() {
                                      showBin = false;
                                    });
                                  },
                                  onDragStarted: () {
                                    setState(() {
                                      showBin = true;
                                    });
                                  },
                                  childWhenDragging: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey)),
                                  ),
                                  feedback: Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(10, 10),
                                              blurRadius: 10)
                                        ],
                                        color: Colors.black26,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey)),
                                    child: Scaffold(
                                      body: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Image.asset(
                                                bankInfo[x]['icon'],
                                                width: scrW/13,
                                                color: Colors.grey,),
                                            Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(bankInfo[x]['name']),
                                          GestureDetector(
                                              onTap: () {
                                                //show editor
                                                //delete then add

                                                print('edit');
                                                // showEdit(x);
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                color: ThemeProvider.themeOf(
                                                                context)
                                                            .id ==
                                                        'dark'
                                                    ? Colors.tealAccent
                                                    : secColor,
                                              ))
                                        ],
                                      ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  data: x.toString(),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Image.asset(bankInfo[x]['icon'],
                                        width: scrW/13,
                                        color: Colors.grey,),
                                        Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(bankInfo[x]['name']),
                                          GestureDetector(
                                              onTap: () {
                                                print('edit');
                                                showEdit(x);
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                color: ThemeProvider.themeOf(
                                                                context)
                                                            .id ==
                                                        'dark'
                                                    ? Colors.tealAccent
                                                    : secColor,
                                              ))
                                        ],
                                      ),
                                      ],
                                    ),
                                  ),
                                ),
                           
                            GestureDetector(
                              onTap: () {
                                showAddPayment();
                              },
                              child: DottedBorder(
                                  dashPattern: [10],
                                  color: Colors.grey,
                                  strokeWidth: 1,
                                  child: Container(
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.add_circle_outline,
                                            color: Colors.grey,
                                            size: 30,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            jsonResult[0]['language'][locale]['p4.5'],
                                            style: TextStyle(
                                                color: Colors.grey[400],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
                ),
                showBin
              ? BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(bottom: 20),
                    margin: EdgeInsets.only(bottom:20),
                    width: scrW,
                    height: scrH,
                    color: Colors.grey.shade200.withOpacity(0.5),
                    child: DragTarget<String>(
                      builder: (BuildContext context, List<String> incoming,
                          List rejected) {
                        if (showBin == true) {
                          return Container(
                            width: scrW / 3,
                            height: scrH / 10,
                            child: Icon(
                              Icons.delete,
                              size: 40,
                              color: Colors.red,
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                      onWillAccept: (data) {
                        print('accept');
                        return int.parse(data) > -1;
                      },
                      onAccept: (data) {
                        var wichList = data.substring(data.length - 1);
                        var value = data.substring(0, data.length - 1);
                        setState(() {
                          successfulDrop = true;
                          showBin = false;
                          print(value);
                          print(wichList);
                         bankInfo.removeAt(int.parse(data));
                        });
                      },
                      onLeave: (data) {
                        print('leaving');
                      },
                    ),
                  ),
                )
              : Container()
               ],
             ),
                ),
        
        );
  }
}


