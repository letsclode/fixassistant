import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:myassistantv2/core/global/variables.dart';
import 'package:theme_provider/theme_provider.dart';

class AddingSubCat extends StatefulWidget {
  final category;
  final type;
  AddingSubCat(this.category,this.type);

  @override
  _AddingSubCatState createState() => _AddingSubCatState();
}

class _AddingSubCatState extends State<AddingSubCat> {
  bool moreDetails = false;
  bool detail = false;
  String _toDay = DateTime.now().toString().split(" ")[0];
  TextEditingController val = TextEditingController();
  TextEditingController name = TextEditingController();
  String defVal = "";

  void addMoreDetails(bool _onMoreDetails) {
    setState(() {
      moreDetails = !moreDetails;
    });
    if (moreDetails) {
      Timer(Duration(milliseconds: 700), () {
        setState(() {
          detail = true;
        });
      });
    }
  }

  deleteCat(index) async {
    final res = await http.delete(
        "http://myassistant.ohm-conception.com/api/income_expense/$index",
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer " + token
        });
    if (res.statusCode == 200) {
      json.encode(res.body);
      Fluttertoast.showToast(msg: jsonResult[0]['language'][locale]['p12.6']);
    }
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
        budget = data['success']['details']['budgets'];
        budgetDetails = data['success']['details'];
        allIncomeExpense = budget[activeBudget]['incomeexpense_categories'];
        initialBudget =
            double.parse(selectedBudget['initial_budget']) - totalExpense;
      });
      calculateIncomeExpense(selectedDate);
    }
  }

  void calculateIncomeExpense(toDay) {
    List temp1 = [];
    List temp2 = [];
    var _created_at;
    var index = DateTime.now()
        .difference(DateTime.parse(selectedBudget['created_at']))
        .inDays;
    var firstWeekExpire =
        8 - DateTime.parse(selectedBudget['created_at']).weekday;

    setState(() {
      totalIncome = 0.00;
      totalExpense = 0.00;
      todayExpense = 0.00;
      weekExpense = 0.00;
      lastDayExpense = 0.00;

      for (var x in allIncomeExpense) {
        _created_at = DateTime.parse(x['created_at']).toString().split(" ")[0];
        if (x['type'] == 1) {
          totalIncome += double.parse(x['amount'].toString());
          temp1.add(x);
          if (_toDay == allExpectedDays[index]) {
            if (_created_at != DateTime.now()) {
              lastDayExpense += double.parse(x['amount'].toString());
            }
          }
        } else {
          temp2.add(x);
          totalExpense += double.parse(x['amount'].toString());
          if (DateTime.now().toString().split(" ")[0] ==
              DateTime.parse(x['created_at']).toString().split(" ")[0]) {
            todayExpense += double.parse(x['amount'].toString());
          }
          if (DateTime.parse(x['created_at']).toString().split(" ")[0] ==
                  allWeekExpireDate[index] ||
              DateTime.parse(x['created_at']).toString().split(" ")[0] ==
                  allStartWeekDate[index] ||
              (DateTime.parse(x['created_at'])
                      .isAfter(allStartWeekDate[index]) &&
                  DateTime.parse(x['created_at'])
                      .isBefore(allWeekExpireDate[index]))) {
            print("object");
            weekExpense += double.parse(x['amount'].toString());
          }
        }
      }
      incomeList = temp1;
      expenseList = temp2;
    });
    setState(() {
      visited = true;
      loadStat = false;
    });
    calculateBudget();
  }

  void calculateBudget() {
    var leftDays = 30 -
        DateTime.parse(selectedBudget['created_at'])
            .difference(DateTime.now())
            .inDays;
    print(leftDays);

    setState(() {
      perDay = (initialBudget / (leftDays));
      perWeek = (perDay * (8 - DateTime.now().weekday)) - weekExpense;
      perDay = (initialBudget / (leftDays)) - todayExpense;
      addStat = false;
    });
  }

  _addEI(eiName, eiIcon, budgetId, price, eiDiff, id) async {
    final res = await http.post(
        "http://myassistant.ohm-conception.com/api/income_expense",
        body: {
          "name": eiName.toUpperCase()[0] + eiName.toString().substring(1),
          "icon": eiIcon,
          "budget_id": budgetId.toString(),
          "amount": price.toString(),
          "type": eiDiff.toString()
        },
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer " + token,
          "Content-Type": "application/x-www-form-urlencoded"
        });
    if (res.statusCode == 200 || res.statusCode == 201) {
      deleteCat(id);
      Fluttertoast.showToast(msg: jsonResult[0]['language'][locale]['p12.4']);
    } else {
      print('fail');
    }

    _login(uemail, pass);
  }


  @override
  void initState() {
    selectedDate = DateTime.now().toString().split(" ")[0];
    setState(() {
      defVal = widget.category['amount'].toStringAsFixed(2);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: scrW,
      height: scrH,
      color: Colors.transparent,
      child: Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
          child: Container(
            child: AnimatedContainer(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 0))
                  ]),
              duration: Duration(milliseconds: 500),
              padding: EdgeInsets.all(10),
              width: scrW / 1.5,
              height: scrH / 3.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            print("close");
                            setState(() {
                              addStat = false;
                            });
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                          ))
                    ],
                  ),
                  Text(
                    widget.category['name'] + " " + "Category (Edit)",
                    style:
                        TextStyle(color: Colors.black54, fontSize: scrW / 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 60,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            controller: val,
                            decoration: InputDecoration.collapsed(
                                hintText: defVal,
                                hintStyle: TextStyle(color: Colors.grey[300])),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Row(
                  //   children: <Widget>[
                  //     Checkbox(
                  //       value: moreDetails,
                  //       onChanged: addMoreDetails,
                  //       checkColor: Colors.green,
                  //     ),
                  //     Text(
                  //       "Add more details",
                  //       style: TextStyle(color: Colors.grey),
                  //     )
                  //   ],
                  // ),
                  // detail
                  //     ? Column(
                  //         children: <Widget>[
                  //           Container(
                  //             width: scrW,
                  //             height: 60,
                  //             padding: EdgeInsets.all(8),
                  //             decoration: BoxDecoration(
                  //                 border: Border.all(
                  //                   width: 1,
                  //                   color: Colors.grey,
                  //                 ),
                  //                 borderRadius: BorderRadius.circular(10)),
                  //             child: TextField(
                  //               controller: name,
                  //               decoration: InputDecoration.collapsed(
                  //                   hintText: "name",
                  //                   hintStyle: TextStyle(color: Colors.grey[300])),
                  //             ),
                  //           ),
                  //         ],
                  //       )
                  //     : Container(),
                  // Expanded(child: Container()),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (val.text.isNotEmpty) {
                          if (name.text.isEmpty) {
                            name.text = widget.category['name'];
                          }

                          if (widget.category['type'] == 2) {
                            totalExpense += double.parse(val.text);
                          } else {
                            totalIncome += double.parse(val.text);
                          }

                          _addEI(
                              widget.category['name'],
                              widget.category['icon'],
                              selectedBudget['id'],
                              val.text,
                              widget.category['type'],
                              widget.category['id']);
                        }
                      });
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
                          "Save",
                          style: TextStyle(
                              color: ThemeProvider.themeOf(context).id == 'dark'
                                  ? Colors.tealAccent
                                  : Colors.black),
                        ))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
