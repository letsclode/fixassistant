import 'dart:async';
import 'dart:io';
import 'dart:ui';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:myassistantv2/core/global/variables.dart';
import 'package:theme_provider/theme_provider.dart';

class AddingRecCat extends StatefulWidget {
  final catType;
  final catValue;
  AddingRecCat(this.catType,this.catValue);
  @override
  _AddingRecCatState createState() => _AddingRecCatState();
}

class _AddingRecCatState extends State<AddingRecCat> {
  bool moreDetails = false;
  bool detail = false;
  String defType = "Daily";
  String iconUrl = "recurrent";
  String defVal = "0.00";
  String defName = "title";
  bool isRecurrent = false;
  bool withDetails = false;
  double initialSize = scrH / 3;
  String recurrent = "";

  var _date = jsonResult[0]['language'][locale]['p7.7'];
  TextEditingController ieVal = TextEditingController();
  TextEditingController ieName = TextEditingController();


  void passData() {
    List temp1 = [];
    List temp2 = [];

    setState(() {
      totalrecIncome = 0.00;
      totalrecExpense = 0.00;

      for (var x in allIncomeExpense) {
        if (x['type'] == 1) {
          if (x['is_recurrent'] == 1) {
            totalrecIncome += double.parse(x['amount'].toString());
            temp1.add(x);
          }
        } else {
          if (x['is_recurrent'] == 1) {
            totalrecExpense += double.parse(x['amount'].toString());
            temp2.add(x);
          }
        }
      }
      recIncome = temp1;
      recExpense = temp2;
    });
    calculateBudget();
  }

  _addEI(eiName, eiIcon, budgetId, price, eiDiff) async {
    final res = await http.post(
        "http://myassistant.ohm-conception.com/api/income_expense",
        body: {
          "name": eiName.toUpperCase()[0] + eiName.toString().substring(1),
          "icon": eiIcon,
          "budget_id": budgetId.toString(),
          "amount": price.toString(),
          "type": eiDiff.toString(),
          "is_recurrent": recurrent.toString(),
          "type_of": defType.toString(),
          "starting_date": _date.toString()
        },
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer " + token,
          "Content-Type": "application/x-www-form-urlencoded"
        });
    if (res.statusCode == 200 || res.statusCode == 201) {
      Fluttertoast.showToast(msg: jsonResult[0]['language'][locale]['p12.4']);
    } else {
      print(res.statusCode);
    }
    setState(() {
      addRecStat = false;
      isEditState = false;
    });

    ieVal.clear();
    ieName.clear();
  }

  void calculateBudget() {
    setState(() {
      print(totalExpense);
      presentBudgetInitial = initialBudget - totalExpense;
      perDay = (initialBudget - todayExpense) / 30;
      originalPerDay = initialBudget / 30;
      print(todayExpense);
      perWeek = originalPerDay * 7;
      addStat = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
        child: AnimatedContainer(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 10, offset: Offset(0, 0))
              ]),
          duration: Duration(milliseconds: 500),
          padding: EdgeInsets.all(10),
          width: scrW / 1.5,
          height: initialSize,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        print("close");
                        setState(() {
                          addRecStat = false;
                          isEditState = false;
                        });
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.red,
                      ))
                ],
              ),
              Expanded(
                  child: Container(
                      child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: scrW,
                    height: scrH / 14,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: ieVal,
                      decoration: InputDecoration.collapsed(
                          hintText: defVal,
                          hintStyle: TextStyle(color: Colors.grey[300])),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                          value: withDetails,
                          onChanged: (val) {
                            setState(() {
                              setState(() {
                                if (withDetails) {
                                  withDetails = val;
                                  Timer(Duration(milliseconds: 700), () {
                                    initialSize -= 100;
                                  });
                                } else {
                                  initialSize += 100;
                                  Timer(Duration(milliseconds: 700), () {
                                    withDetails = val;
                                  });
                                }
                              });
                            });
                          }),
                      Text(
                        "More Details",
                        style: TextStyle(fontSize: scrW / 25),
                      )
                    ],
                  ),
                  withDetails
                      ? Column(
                          children: <Widget>[
                            Container(
                              width: scrW,
                              height: scrH / 14,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextField(
                                controller: ieName,
                                decoration: InputDecoration.collapsed(
                                    hintText: defName,
                                    hintStyle:
                                        TextStyle(color: Colors.grey[300])),
                              ),
                            ),
                      
                            SizedBox(
                              height: 15,
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //     DatePicker.showDatePicker(context,
                            //         minTime:
                            //             DateTime.parse(selectedBudget['created_at']),
                            //         locale: locale == "en"
                            //             ? LocaleType.en
                            //             : LocaleType.fr,
                            //         showTitleActions: true,
                            //         theme: DatePickerTheme(
                            //             headerColor: Colors.white,
                            //             backgroundColor:
                            //                 ThemeProvider.themeOf(context).id ==
                            //                         'dark'
                            //                     ? Color.fromRGBO(37, 52, 65, 1)
                            //                     : Colors.white,
                            //             itemStyle: TextStyle(
                            //                 color:
                            //                     ThemeProvider.themeOf(context).id ==
                            //                             'dark'
                            //                         ? Colors.white
                            //                         : Colors.black,
                            //                 fontWeight: FontWeight.bold,
                            //                 fontSize: 18),
                            //             doneStyle: TextStyle(color: Colors.black)),
                            //         onChanged: (date) {}, onConfirm: (date) {
                            //       setState(() {
                            //         _date = (date.year.toString() +
                            //             "-" +
                            //             date.month.toString() +
                            //             "-" +
                            //             date.day.toString());
                            //       });
                            //     });
                            //   },
                            //   child: Container(
                            //       width: scrW / 2.7,
                            //       height: 60,
                            //       padding: EdgeInsets.only(right: 10),
                            //       decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.circular(10),
                            //           border:
                            //               Border.all(width: 1, color: Colors.grey)),
                            //       child: Row(
                            //         mainAxisAlignment: MainAxisAlignment.center,
                            //         children: <Widget>[
                            //           Icon(
                            //             Icons.calendar_today,
                            //             color: ThemeProvider.themeOf(context).id ==
                            //                     'dark'
                            //                 ? Colors.black
                            //                 : Colors.black,
                            //           ),
                            //           SizedBox(
                            //             width: 10,
                            //           ),
                            //           Text(
                            //             _date.toString(),
                            //             style: TextStyle(
                            //                 color: Colors.grey, fontSize: scrW / 30),
                            //           ),
                            //         ],
                            //       )),
                            // ),

                            //comments

                            //pic
                            //Recieve_on
                          ],
                        )
                      : Container(),
                  Row(
                    children: <Widget>[
                      Checkbox(
                          value: isRecurrent,
                          onChanged: (val) {
                            setState(() {
                              if (isRecurrent) {
                                isRecurrent = val;
                                recurrent = "";
                                Timer(Duration(milliseconds: 700), () {
                                  initialSize -= 70;
                                });
                              } else {
                                initialSize += 70;
                                recurrent = "1";
                                Timer(Duration(milliseconds: 700), () {
                                  isRecurrent = val;
                                });
                              }
                            });
                          }),
                      Text(
                        "Recurrent",
                        style: TextStyle(fontSize: scrW / 25),
                      )
                    ],
                  ),
                  // isRecurrent == true
                  //     ? Row(
                  //         children: <Widget>[
                  //           GestureDetector(
                  //             onTap: () {
                  //               DatePicker.showDatePicker(context,
                  //                   minTime: DateTime.parse(
                  //                       selectedBudget['created_at']),
                  //                   locale: locale == "en"
                  //                       ? LocaleType.en
                  //                       : LocaleType.fr,
                  //                   showTitleActions: true,
                  //                   // theme: DatePickerTheme(
                  //                   //     headerColor: Colors.white,
                  //                   //     backgroundColor:
                  //                   //         ThemeProvider.themeOf(context).id ==
                  //                   //                 'dark'
                  //                   //             ? Color.fromRGBO(37, 52, 65, 1)
                  //                   //             : Colors.white,
                  //                   //     itemStyle: TextStyle(
                  //                   //         color:
                  //                   //             ThemeProvider.themeOf(context)
                  //                   //                         .id ==
                  //                   //                     'dark'
                  //                   //                 ? Colors.white
                  //                   //                 : Colors.black,
                  //                   //         fontWeight: FontWeight.bold,
                  //                   //         fontSize: 18),
                  //                   //     doneStyle:
                  //                   //         TextStyle(color: Colors.black)),
                  //                   onChanged: (date) {}, onConfirm: (date) {
                  //                 setState(() {
                  //                   _date = (date.year.toString() +
                  //                       "-" +
                  //                       date.month.toString() +
                  //                       "-" +
                  //                       date.day.toString());
                  //                 });
                  //               });
                  //             },
                  //             child: Container(
                  //                 width: scrW / 2.7,
                  //                 height: 60,
                  //                 padding: EdgeInsets.only(right: 10),
                  //                 decoration: BoxDecoration(
                  //                     borderRadius: BorderRadius.circular(10),
                  //                     border: Border.all(
                  //                         width: 1, color: Colors.grey)),
                  //                 child: Row(
                  //                   mainAxisAlignment: MainAxisAlignment.center,
                  //                   children: <Widget>[
                  //                     Icon(
                  //                       Icons.calendar_today,
                  //                       color:
                  //                           ThemeProvider.themeOf(context).id ==
                  //                                   'dark'
                  //                               ? Colors.black
                  //                               : Colors.black,
                  //                     ),
                  //                     SizedBox(
                  //                       width: 10,
                  //                     ),
                  //                     Text(
                  //                       _date.toString(),
                  //                       style: TextStyle(
                  //                           color: Colors.grey,
                  //                           fontSize: scrW / 30),
                  //                     ),
                  //                   ],
                  //                 )),
                  //           ),
                  //           SizedBox(
                  //             width: 10,
                  //           ),
                  //           Expanded(
                  //             child: AnimatedContainer(
                  //               padding: EdgeInsets.symmetric(horizontal: 2),
                  //               decoration: BoxDecoration(
                  //                   color: ThemeProvider.themeOf(context).id ==
                  //                           'dark'
                  //                       ? Color.fromRGBO(37, 52, 65, 1)
                  //                       : Color.fromRGBO(241, 243, 246, 1),
                  //                   borderRadius: BorderRadius.circular(10),
                  //                   boxShadow: [
                  //                     BoxShadow(
                  //                         color: ThemeProvider.themeOf(context)
                  //                                     .id ==
                  //                                 'dark'
                  //                             ? Colors.white12
                  //                             : Colors.white,
                  //                         blurRadius: 3,
                  //                         offset: Offset(-7, -7)),
                  //                     BoxShadow(
                  //                         color: Colors.black12,
                  //                         blurRadius: 10,
                  //                         offset: Offset(8, 8))
                  //                   ]),
                  //               duration: Duration(milliseconds: 100),
                  //               height: 60,
                  //               child: DropdownButtonHideUnderline(
                  //                 child: DropdownButton(
                  //                   icon: Icon(Icons.arrow_drop_down),
                  //                   style: TextStyle(
                  //                       color:
                  //                           ThemeProvider.themeOf(context).id ==
                  //                                   'dark'
                  //                               ? Colors.white
                  //                               : Colors.black,
                  //                       fontSize: 17),
                  //                   isExpanded: true,
                  //                   value: defType,
                  //                   onChanged: (newCurr) {
                  //                     setState(() {
                  //                       defType = newCurr.toString();
                  //                     });
                  //                   },
                  //                   items: recType.map((dynamic text) {
                  //                     return DropdownMenuItem<dynamic>(
                  //                       child: Container(
                  //                           padding: EdgeInsets.all(10),
                  //                           width: scrW,
                  //                           height: 50,
                  //                           child: Center(
                  //                               child: Text(
                  //                             text,
                  //                             style: TextStyle(
                  //                                 fontSize: scrW / 30),
                  //                           ))),
                  //                       value: text,
                  //                     );
                  //                   }).toList(),
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       )
                  //     : Container(),
                ],
              ))),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  if(_date == jsonResult[0]['language'][locale]['p7.7']){
                    setState(() {
                      _date = DateTime.now();
                    });
                  }

                  var type;
                  if(widget.catType == 2){
                    setState(() {
                      type = 2;
                    });
                  }else{
                    type = 1;
                  }

                  _addEI(widget.catValue['name'], widget.catValue['icon'], selectedBudget['id'], ieVal.text, type);
                },
                child: Container(
                    width: scrW,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    height: 60,
                    decoration: BoxDecoration(
                        color: ThemeProvider.themeOf(context).id == 'dark'
                            ? Color.fromRGBO(37, 52, 65, 1)
                            : Color.fromRGBO(241, 243, 246, 1),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: ThemeProvider.themeOf(context).id == 'dark'
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
                          color: ThemeProvider.themeOf(context).id == 'dark'
                              ? Colors.tealAccent
                              : Colors.black),
                    ))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
