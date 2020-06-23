import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myassistantv2/core/global/variables.dart';
import 'package:myassistantv2/ui/pages/methods/add.dart';
import 'package:myassistantv2/ui/widgets/addEI.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:http/http.dart' as http;

class BudgetStatus extends StatefulWidget {
  @override
  _BudgetStatusState createState() => _BudgetStatusState();
}

enum Category { expense, income }
class _BudgetStatusState extends State<BudgetStatus> {
  TextEditingController centerValue = TextEditingController();
  var leftDays = 30 -
      DateTime.parse(selectedBudget['created_at'])
          .difference(DateTime.now())
          .inDays;
  var selectedType;
  var timeIncome;
  bool showE = false;
  bool showI = false;
  bool hide = false;
  bool showBin = false;
  bool shortCut = false;
  var tempEI;
  var tembudgetValue;
  int index = 0;

  Stream updateAdd(type) async* {
    if (type == 2) {
      if (mounted) {
        setState(() {
          showE = showExpense;
        });
      }
      yield showE;
    } else {
      if (mounted) {
        setState(() {
          showI = showIncome;
        });
      }
      yield showI;
    }
  }

  recurrentCheck() {
    for (var x in allIncomeExpense) {
      if (x['is_recurrent'] != null) {
        var itsRecurrentWeek =
            DateTime.parse(x['starting_date']).add(Duration(days: 7));
        if (DateTime.now() == itsRecurrentWeek) {
          addEI(x['name'], x['icon'], x["budget_id"], x['amount'], x['type']);
          editEI(x['id'], x["name"], x['icon'], x['amount'], x['type'],
              itsRecurrentWeek);
        } else {
          print("nope");
        }
        var itRecurrentMonth =
            DateTime.parse(x['starting_date']).add(Duration(days: 30));
        if (DateTime.now() == itRecurrentMonth) {
          addEI(x['name'], x['icon'], x["budget_id"], x['amount'], x['type']);
          editEI(x['id'], x["name"], x['icon'], x['amount'], x['type'],
              itRecurrentMonth);
        } else {
          print("nope");
        }
      }
    }
  }

  incomeCalculate(value) {
    setState(() {
      todayBudget = value / leftDays;
      weekBudget = todayBudget * (8 - DateTime.now().weekday.toDouble());
    });
  }

  expenseCalculate() {
    setState(() {
      todayBudget += tempEI['amount'];
      weekBudget += tempEI['amount'];
    });
  }

  _deleteIncome(index, dataIndex) async {
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

    if (tempEI['type'] == 1) {
      incomeCalculate(selectedBudget['initial_budget']);
      editBudget(double.parse(selectedBudget['initial_budget'].toString()) -
          double.parse(tempEI["amount"].toString()));
    } else {
      expenseCalculate();
      editBudget(double.parse(selectedBudget['initial_budget'].toString()) +
          double.parse(tempEI["amount"].toString()));
    }

    _login(uemail, pass);
  }

  // addEI(eiName, eiIcon, budgetId, price, eiDiff, recurrent, startingDate,defType) async {
  //   if (startingDate == jsonResult[0]['language'][locale]['p7.7'].toString()) {
  //     setState(() {
  //       startingDate = DateTime.now();
  //     });
  //   }
  //   if (defType.toString().toLowerCase() != "off") {
  //     recurrent = 1;
  //   }

  //   final res = await http.post(
  //       "http://myassistant.ohm-conception.com/api/income_expense",
  //       body: {
  //         "budget_id": budgetId.toString(),
  //         "name": eiName.toUpperCase()[0] + eiName.toString().substring(1),
  //         "icon": eiIcon.toString(),
  //         "amount": price.toString(),
  //         "type": eiDiff.toString(),
  //         "type_of": defType.toString(),
  //         "starting_date": startingDate.toString(),
  //         'is_recurrent': recurrent.toString()
  //       },
  //       headers: {
  //         "Accept": "application/json",
  //         HttpHeaders.authorizationHeader: "Bearer " + token,
  //         "Content-Type": "application/x-www-form-urlencoded"
  //       });
  //   if (res.statusCode == 200) {
  //     Fluttertoast.showToast(msg: jsonResult[0]['language'][locale]['p12.4']);
  //   } else {
  //     print("fail to add");
  //   }
  //   _login(uemail, pass);
  // }
  iCalculate(value) {
    print("INCOME");
    setState(() {
      initialBudget += double.parse(value);
    });
    setState(() {
      todayBudget = initialBudget / leftDays;
      weekBudget = todayBudget * (8 - DateTime.now().weekday.toDouble());
    });
    editBudget(initialBudget);
  }

  eCalculate(value) {
    print("EXPENSE");
    setState(() {
      initialBudget -= double.parse(value);
      todayBudget -= double.parse(value);
      weekBudget -= double.parse(value);
    });
    editBudget(initialBudget);
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
      if (mounted) {
        setState(() {
          budget = data['success']['details']['budgets'];
          budgetDetails = data['success']['details'];
          allIncomeExpense = budget[activeBudget]['incomeexpense_categories'];
          initialBudget = double.parse(budget[activeBudget]['initial_budget']);
          currency = data['success']['details']['currencies'];
          selectedBudget = budget[activeBudget];
          if (budget[activeBudget]['today_budget'] != null) {
            todayBudget =
                double.parse(budget[activeBudget]['today_budget'].toString());
          } else {
            todayBudget = 0.00;
          }

          if (budget[activeBudget]['week_budget'] != null) {
            weekBudget =
                double.parse(budget[activeBudget]['week_budget'].toString());
          } else {
            weekBudget = 0.00;
          }
        });
        passAllNonZeroCategory();
      }
    }

    if (mounted) {
      setState(() {
        visited = true;
        loadStat = false;
      });
    }
  }

  checkIncomeAdded() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      timeIncome = prefs.getString("timeIncome");
    });
  }

  @override
  void initState() {
    if (mounted) {
      setState(() {
        _login(uemail, pass);
        recurrentCheck();
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    setState(() {
      loadStat = true;
      showExpense = false;
      showIncome = false;
    });

    super.dispose();
  }

  passAllNonZeroCategory() {
    if (mounted) {
      setState(() {
        activeList = [];
        totalExpense = 0;
        totalIncome = 0;
        for (var x in allIncomeExpense) {
          if (x['amount'] != 0) {
            activeList.add(x);
            if (x["type"] == 2) {
              totalExpense += x['amount'];
            }

            if (x["type"] == 1) {
              totalIncome += x['amount'];
            }
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        selectedBudget['name'],
                        style: TextStyle(
                            color: ThemeProvider.themeOf(context).id == 'dark'
                                ? Colors.tealAccent
                                : secColor,
                            fontSize: scrW / 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        period[locale][selectedBudget['period_type']],
                      ),
                    ],
                  )),
                  // GestureDetector(
                  //   onTap: () {
                  //     print("histo");
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) => History()));
                  //   },
                  //   child: Container(
                  //     width: 40,
                  //     height: 40,
                  //     child: Center(
                  //         child:
                  //             Image.asset("assets/image/history.png", width: 20)),
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(10),
                  //         color: ThemeProvider.themeOf(context).id == 'dark'
                  //             ? Color.fromRGBO(37, 52, 65, 1)
                  //             : Colors.grey[100],
                  //         boxShadow: [
                  //           BoxShadow(
                  //               color: ThemeProvider.themeOf(context).id == 'dark'
                  //                   ? Colors.white12
                  //                   : Colors.white,
                  //               blurRadius: 2,
                  //               offset: Offset(-5, -5)),
                  //           BoxShadow(
                  //               color: Colors.black12,
                  //               blurRadius: 5,
                  //               offset: Offset(5, 5))
                  //         ]),
                  //   ),
                  // ),
                ],
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      width: scrW,
                      height: scrH / 9,
                      child: FittedBox(
                        child: Center(
                            child: Text(
                          "${(initialBudget).toStringAsFixed(2)} " +
                              (selectedBudget["currency"]['name'] == "usd"
                                  ? currencyList[0][0]
                                  : currencyList[1][0]),
                          style: TextStyle(fontSize: 50),
                        )),
                      ),
                    ),
                    showExpense || showIncome
                        ? Container()
                        : selectedBudget['period_type'] != 2
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: scrW / 2.5,
                                    height: scrW / 6,
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: scrH / 20,
                                          child: FittedBox(
                                            child: Text(
                                              todayBudget.toStringAsFixed(2) +
                                                  " " +
                                                  (selectedBudget["currency"]
                                                              ['name'] ==
                                                          "usd"
                                                      ? currencyList[0][0]
                                                      : currencyList[1][0]),
                                              style: TextStyle(
                                                  fontSize: scrW / 13),
                                            ),
                                          ),
                                        ),
                                        Opacity(
                                          opacity: 0.6,
                                          child: Text(
                                            jsonResult[0]['language'][locale]
                                                    ['p9.1']
                                                .toString()
                                                .toUpperCase(),
                                            style: TextStyle(
                                                color: ThemeProvider.themeOf(
                                                                context)
                                                            .id ==
                                                        'dark'
                                                    ? Colors.tealAccent
                                                    : secColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: scrW / 35),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  selectedBudget['period_type'] != 1
                                      ? Expanded(
                                          child: Container(
                                          width: scrW,
                                          height: scrH / 15,
                                          child: VerticalDivider(
                                            color:
                                                ThemeProvider.themeOf(context)
                                                            .id ==
                                                        'dark'
                                                    ? Colors.white
                                                    : Colors.black,
                                            width: 2,
                                          ),
                                        ))
                                      : Container(),
                                  selectedBudget['period_type'] != 1
                                      ? Container(
                                          width: scrW / 2.5,
                                          height: scrW / 6,
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                height: scrH / 20,
                                                child: FittedBox(
                                                  child: Text(
                                                    weekBudget.toStringAsFixed(
                                                            2) +
                                                        " " +
                                                        (selectedBudget["currency"]
                                                                    ['name'] ==
                                                                "usd"
                                                            ? currencyList[0][0]
                                                            : currencyList[1]
                                                                [0]),
                                                    style: TextStyle(
                                                        fontSize: scrW / 13),
                                                  ),
                                                ),
                                              ),
                                              Opacity(
                                                opacity: 0.6,
                                                child: Text(
                                                  DateTime.now().weekday != 7
                                                      ? jsonResult[0]['language']
                                                                      [locale][
                                                                  'p13.${DateTime.now().weekday}']
                                                              .toString()
                                                              .toUpperCase() +
                                                          " - " +
                                                          jsonResult[0]['language']
                                                                      [locale]
                                                                  ['p13.7']
                                                              .toString()
                                                              .toUpperCase()
                                                      : jsonResult[0]
                                                                  ['language']
                                                              [locale]['p9.2']
                                                          .toString()
                                                          .toUpperCase()
                                                          .toString()
                                                          .toUpperCase(),
                                                  style: TextStyle(
                                                      color:
                                                          ThemeProvider.themeOf(
                                                                          context)
                                                                      .id ==
                                                                  'dark'
                                                              ? Colors
                                                                  .tealAccent
                                                              : secColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: scrW / 35),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container()
                                ],
                              )
                            : Container(),
                    SizedBox(height: 10),
                    showExpense || showIncome
                        ? Container()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    width: 13,
                                    height: 13,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                  ),
                                  SizedBox(width: 5),
                                  Text(jsonResult[0]['language'][locale]
                                          ['p5.6'] +
                                      " : " +
                                      totalIncome.toStringAsFixed(2) +
                                      (jsonResult[0]['language'][locale]
                                          ['p2.5'])),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: <Widget>[
                                  Container(
                                    width: 13,
                                    height: 13,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                  ),
                                  SizedBox(width: 5),
                                  Text(jsonResult[0]['language'][locale]
                                          ['p6.1'] +
                                      " : " +
                                      totalExpense.toStringAsFixed(2) +
                                      (jsonResult[0]['language'][locale]
                                          ['p2.5']))
                                ],
                              ),
                            ],
                          ),
                  ],
                ),
              ),
              showExpense || showIncome
                  ? Container()
                  : Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: ListView(
                                children: <Widget>[
                                  for (var x in activeList)
                                    LongPressDraggable(
                                      onDraggableCanceled: (x, y) {
                                        setState(() {
                                          tempEI = x;
                                          showBin = false;
                                        });
                                      },
                                      onDragStarted: () {
                                        setState(() {
                                          tempEI = x;
                                          showBin = true;
                                        });
                                      },
                                      childWhenDragging: Container(),
                                      feedback: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: ThemeProvider.themeOf(
                                                                context)
                                                            .id ==
                                                        'dark'
                                                    ? Colors.grey
                                                    : Colors.grey[400],
                                                width: 1)),
                                        margin: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 5),
                                        padding: EdgeInsets.all(10),
                                        width: scrW,
                                        height: scrH / 15,
                                        child: Scaffold(
                                          body: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Image.asset(
                                                    x['icon'],
                                                    width: scrW / 20,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    x['name'],
                                                    style: TextStyle(
                                                        fontSize: scrW / 25),
                                                  ),
                                                  Expanded(child: Container()),
                                                  Text(
                                                    x['amount'].toStringAsFixed(
                                                            2) +
                                                        (selectedBudget["currency"]
                                                                    ['name'] ==
                                                                "usd"
                                                            ? currencyList[0][0]
                                                            : currencyList[1]
                                                                [0]),
                                                    style: TextStyle(
                                                        fontSize: scrW / 25),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(
                                                        width: 13,
                                                        height: 13,
                                                        decoration: BoxDecoration(
                                                            color: x["type"] ==
                                                                    1
                                                                ? Colors.green
                                                                : Colors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100)),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      data: (x.toString() +
                                          " " +
                                          x['id'].toString()),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            index = x;
                                            // addStat = true;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: ThemeProvider.themeOf(
                                                                  context)
                                                              .id ==
                                                          'dark'
                                                      ? Colors.grey
                                                      : Colors.grey[400],
                                                  width: 1)),
                                          margin: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 5),
                                          padding: EdgeInsets.all(10),
                                          width: scrW / 2.4,
                                          height: scrH / 15,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Image.asset(
                                                    x['icon'],
                                                    width: scrW / 20,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    x['name'],
                                                    style: TextStyle(
                                                        fontSize: scrW / 25),
                                                  ),
                                                  Expanded(child: Container()),
                                                  Text(
                                                    x['amount'].toStringAsFixed(
                                                            2) +
                                                        (selectedBudget["currency"]
                                                                    ['name'] ==
                                                                "usd"
                                                            ? currencyList[0][0]
                                                            : currencyList[1]
                                                                [0]),
                                                    style: TextStyle(
                                                        fontSize: scrW / 25),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(
                                                        width: 13,
                                                        height: 13,
                                                        decoration: BoxDecoration(
                                                            color: x["type"] ==
                                                                    1
                                                                ? Colors.green
                                                                : Colors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100)),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              Container(
                margin: EdgeInsets.only(bottom: 10,top: 10),
                 color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                         if(centerValue.text != "" || centerValue.text.isNotEmpty){
                           addEI("Others", "assets/image/others.png", selectedBudget['id'], centerValue.text, 2);
                           eCalculate(centerValue.text);
                           _login(uemail, pass);
                            centerValue.text = "";
                         }else{
                          globalDisable = true;
                          showExpense = !showExpense;
                          selectedType = 2;
                          activePaid = -1;
                          activeCategory = -1; 
                         }
                        });
                      },
                      child: Container(
                          margin: EdgeInsets.only(left: 10),
                          width: 60,
                          height: 60,
                          child: Container(
                            width: 60,
                            height: 60,
                            child: Center(
                              child: Text(
                                "-",
                                style: TextStyle(
                                    color: Colors.green, fontSize: scrH / 25),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color:
                                    ThemeProvider.themeOf(context).id == 'dark'
                                        ? Color.fromRGBO(37, 52, 65, 1)
                                        : Color.fromRGBO(241, 243, 246, 1),
                                borderRadius: BorderRadius.circular(60),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          ThemeProvider.themeOf(context).id ==
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
                          )),
                    ),
                    GestureDetector(
                      onTap: (){
                        
                      },
                                          child: Container(
                        width: scrW / 2,
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: centerValue,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if(centerValue.text != "" || centerValue.text.isNotEmpty){
                            addEI("Others", "assets/image/others.png", selectedBudget['id'], centerValue.text, 1);
                            iCalculate(centerValue.text);
                           _login(uemail, pass);
                           centerValue.text = "";
                         }else{
                          globalDisable = true;
                          showIncome = !showIncome;
                          selectedType = 1;
                          activePaid = -1;
                          activeCategory = -1;
                         }
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                          margin: EdgeInsets.only(right: 10),
                          width: 60,
                          height: 60,
                          child: Container(
                            width: 60,
                            height: 60,
                            child: Center(
                                child: Icon(
                              Icons.add,
                              color: Colors.green,
                            )),
                            decoration: BoxDecoration(
                                color:
                                    ThemeProvider.themeOf(context).id == 'dark'
                                        ? Color.fromRGBO(37, 52, 65, 1)
                                        : Color.fromRGBO(241, 243, 246, 1),
                                borderRadius: BorderRadius.circular(60),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          ThemeProvider.themeOf(context).id ==
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
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
          showExpense || showIncome
              ? Positioned(
                  bottom: 0,
                  child: StreamBuilder(
                      stream: updateAdd(selectedType),
                      builder: (context, snapshot) {
                        return AddEI(selectedType);
                      }),
                )
              : Container(
                  height: 0,
                ),
          showBin
              ? BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(bottom: 20),
                    width: scrW,
                    height: scrH,
                    color: ThemeProvider.themeOf(context).id == 'dark'
                        ? Colors.grey.shade800.withOpacity(0.5)
                        : Colors.grey.shade200.withOpacity(0.5),
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
                        return true;
                      },
                      onAccept: (data) {
                        print(data);
                        var datas = data.toString().split(" ");

                        var index = data.indexOf('type') + 6;

                        _deleteIncome(datas[1], int.parse(data[index]));
                        setState(() {
                          showBin = false;
                        });
                      },
                      onLeave: (data) {
                        print('leaving');
                      },
                    ),
                  ),
                )
              : Container(
                  height: 0,
                ),
        ],
      ),
    );
  }
}
// showExpense || showIncome
//     ? Positioned(
//         bottom: 20,
//         child: StreamBuilder(
//             stream: updateAdd(selectedType),
//             builder: (context, snapshot) {
//               return AddEI(selectedType);
//             }),
//       )
//     : Container(
//         height: 0,
//       ),
// showBin
//     ? BackdropFilter(
//         filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//         child: Container(
//           alignment: Alignment.bottomCenter,
//           padding: EdgeInsets.only(bottom: 20),
//           width: scrW,
//           height: scrH,
//           color: ThemeProvider.themeOf(context).id == 'dark'
//               ? Colors.grey.shade800.withOpacity(0.5)
//               : Colors.grey.shade200.withOpacity(0.5),
//           child: DragTarget<String>(
//             builder: (BuildContext context, List<String> incoming,
//                 List rejected) {
//               if (showBin == true) {
//                 return Container(
//                   width: scrW / 3,
//                   height: scrH / 10,
//                   child: Icon(
//                     Icons.delete,
//                     size: 40,
//                     color: Colors.red,
//                   ),
//                 );
//               } else {
//                 return Container();
//               }
//             },
//             onWillAccept: (data) {
//               print('accept');
//               return true;
//             },
//             onAccept: (data) {
//               print(data);
//               var datas = data.toString().split(" ");

//               var index = data.indexOf('type') + 6;

//               _deleteIncome(datas[1], int.parse(data[index]));
//               setState(() {
//                 showBin = false;
//               });
//             },
//             onLeave: (data) {
//               print('leaving');
//             },
//           ),
//         ),
//       )
//     : Container(
//         height: 0,
//       ),
// loadStat == true
//     ? Container(
//         width: scrW,
//         height: scrH,
//         decoration:
//             BoxDecoration(borderRadius: BorderRadius.circular(10)),
//         child: Center(child: CircularProgressIndicator()),
//       )
//     : Container(
//         height: 0,
//       ),
// showExpense || showIncome
//     ? Container(
//         height: 0,
//       )
//     : Positioned(
//         bottom: 50,
//         right: 10,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: <Widget>[
//             AnimatedContainer(
//               duration: Duration(milliseconds: 300),
//               color: Colors.transparent,
//               width: hide ? 120 : 60,
//               height: hide ? 120 : 60,
//               child: Stack(
//                 children: <Widget>[
//                   Positioned(
//                     top: 40,
//                     left: 0,
//                     child: GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           globalDisable = true;
//                           showExpense = !showExpense;
//                           selectedType = 2;
//                           activePaid = -1;
//                           activeCategory = -1;
//                         });
//                       },
//                       child: AnimatedContainer(
//                         child: Center(
//                             child: Text(
//                           "E",
//                           style: TextStyle(color: Colors.white),
//                         )),
//                         duration: Duration(milliseconds: 300),
//                         width: hide ? 50 : 0,
//                         height: hide ? 50 : 0,
//                         decoration: BoxDecoration(
//                             color: Colors.red,
//                             border: Border.all(color: Colors.red),
//                             borderRadius: BorderRadius.circular(100)),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 0,
//                     left: 40,
//                     child: GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           globalDisable = true;
//                           showIncome = !showIncome;
//                           selectedType = 1;
//                           activePaid = -1;
//                           activeCategory = -1;
//                         });
//                       },
//                       child: AnimatedContainer(
//                         child: Center(
//                             child: Text(
//                           "I",
//                           style: TextStyle(color: Colors.white),
//                         )),
//                         duration: Duration(milliseconds: 300),
//                         width: hide ? 50 : 0,
//                         height: hide ? 50 : 0,
//                         decoration: BoxDecoration(
//                             color: Colors.green,
//                             border: Border.all(color: Colors.green),
//                             borderRadius: BorderRadius.circular(100)),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     right: 0,
//                     bottom: 0,
//                     child: GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           hide = !hide;
//                         });
//                       },
//                       child:
//                       Container(
//                           width: 60,
//                           height: 60,
//                           child: Container(
//                             width: 60,
//                             height: 60,
//                             child: Center(
//                                 child: Icon(
//                               Icons.add,
//                               color: Colors.green,
//                             )),
//                             decoration: BoxDecoration(
//                                 color: ThemeProvider.themeOf(context)
//                                             .id ==
//                                         'dark'
//                                     ? Color.fromRGBO(37, 52, 65, 1)
//                                     : Color.fromRGBO(241, 243, 246, 1),
//                                 borderRadius: BorderRadius.circular(60),
//                                 boxShadow: [
//                                   BoxShadow(
//                                       color:
//                                           ThemeProvider.themeOf(context)
//                                                       .id ==
//                                                   'dark'
//                                               ? Colors.white12
//                                               : Colors.white,
//                                       blurRadius: 3,
//                                       offset: Offset(-7, -7)),
//                                   BoxShadow(
//                                       color: Colors.black12,
//                                       blurRadius: 10,
//                                       offset: Offset(8, 8))
//                                 ]),
//                           )),
//                     ),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
