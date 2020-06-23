import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myassistantv2/core/global/variables.dart';
import 'package:myassistantv2/ui/pages/home/home.dart';
import 'package:myassistantv2/ui/pages/methods/pref.dart';
import 'package:myassistantv2/ui/pages/newuser/addBudget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:http/http.dart' as http;

class BudgetList extends StatefulWidget {
  @override
  _BudgetListState createState() => _BudgetListState();
}

bool expireDay(firstDay, dateType) {
  DateTime fday = DateTime.parse(firstDay);
  DateTime expireday;
  if (dateType == 0) {
    expireday = fday.add(Duration(days: 30));
    print(expireday);
    return DateTime.now().isAfter(expireday) ||
        DateTime.now().toString().split(" ")[0] ==
            expireday.toString().split(" ")[0];
  } else if (dateType == 1) {
    expireday = fday.add(Duration(days: 7));
    return DateTime.now().isAfter(expireday) ||
        DateTime.now().toString().split(" ")[0] ==
            expireday.toString().split(" ")[0];
  } else if (dateType == 2) {
    expireday = fday.add(Duration(days: 1));
    return DateTime.now().isAfter(expireday) ||
        DateTime.now().toString().split(" ")[0] ==
            expireday.toString().split(" ")[0];
  } else if (dateType == 3) {
    expireday = fday.add(Duration(days: 90));
    return DateTime.now().isAfter(expireday) ||
        DateTime.now().toString().split(" ")[0] ==
            expireday.toString().split(" ")[0];
  } else {
    expireday = fday.add(Duration(days: (30 * 6)));
    return DateTime.now().isAfter(expireday) ||
        DateTime.now().toString().split(" ")[0] ==
            expireday.toString().split(" ")[0];
  }
}

void recurrentAlgo() {}
class _BudgetListState extends State<BudgetList> {
  var count = 0;
  Future _login() async {
    final response = await http.post(
      "http://myassistant.ohm-conception.com/api/login",
      body: {
        "email": uemail,
        "password": pass,
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (mounted) {
        setState(() {
          token = data['success']['token'];
          budget = data['success']['details']['budgets'];
          budgetDetails = data['success']['details'];
          payment = data['success']['details']['payment_methods'];
          uname = data['success']['details']['name'];
          id = data['success']['details']['id'].toString();
          allIncomeExpense =
              data['success']['details']['incomeexpense_categories'];
          currency = data['success']['details']['currencies'];
        });
      }
    } else {
      Fluttertoast.showToast(msg: "No Account Found");
    }
  }

  void showConfirmDelete(budgetID) {
    showGeneralDialog(
        barrierColor: Colors.white.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return ThemeConsumer(
            child: Align(
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
                          height: scrH / 4,
                          padding: EdgeInsets.all(30),
                          decoration: BoxDecoration(
                              color: ThemeProvider.themeOf(context).id == "dark"
                                  ? Color.fromRGBO(37, 52, 65, 1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                jsonResult[0]['language'][locale]['p1.11'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: scrW / 20),
                              ),
                              Text(
                                jsonResult[0]['language'][locale]['p1.13'],
                                textAlign: TextAlign.center,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      jsonResult[0]['language'][locale]['p1.14'],
                                      style: TextStyle(
                                          color: ThemeProvider.themeOf(context)
                                                      .id ==
                                                  'dark'
                                              ? Colors.tealAccent
                                              : secColor),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 25,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      deleteChild(budgetID);
                                      print("delete");
                                    },
                                    child: Text(
                                      "OK",
                                      style: TextStyle(
                                          color: ThemeProvider.themeOf(context)
                                                      .id ==
                                                  'dark'
                                              ? Colors.tealAccent
                                              : secColor),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )),
                ),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, a1, a2) {
          return null;
        });
  }

  _editBudget(editBudgets, isSaved) async {
    final respo = await http.put(
        "http://myassistant.ohm-conception.com/api/budget/${editBudgets["id"]}",
        body: {
          "name": editBudgets["name"],
          "initial_budget": isSaved ? editBudgets['initial_budget'].toString() : "0.00",
          "first_day_period": DateTime.now().toString(),
          "period_type": editBudgets['period_type'].toString(),
          "purpose": editBudgets['purpose'].toString(),
          "currency_id": editBudgets['currency_id'].toString(),
        },
        headers: {
          HttpHeaders.authorizationHeader: "Bearer " + token,
          "Accept": "application/json"
        });

    if (respo.statusCode == 200 || respo.statusCode == 201) {
      Fluttertoast.showToast(msg: "Successfully updated");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      print("fail");
    }
  }

  bool exType(expiredType) {
    if (expiredType == jsonResult[0]['language'][locale]['p7.10']) {
      return true;
    } else {
      return false;
    }
  }

  bool extype = false;

  void showUpdate(balance, expiredType, expireBudget) {
    showGeneralDialog(
        barrierColor: Colors.white.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return ThemeConsumer(
            child: Align(
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
                          height: scrH / 4,
                          padding: EdgeInsets.all(30),
                          decoration: BoxDecoration(
                              color: ThemeProvider.themeOf(context).id == "dark"
                                  ? Color.fromRGBO(37, 52, 65, 1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    "Balance",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: scrW / 30,
                                        color: Colors.grey),
                                  ),
                                  Text(
                                    "$balance" + (locale == "en" ? "\$" : "€"),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: scrW / 20),
                                  ),
                                ],
                              ),
                              Text(
                                exType(expiredType)
                                    ? jsonResult[0]['language'][locale]['p7.10']
                                    : jsonResult[0]['language'][locale]
                                        ['p7.11'],
                                textAlign: TextAlign.center,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  // GestureDetector(
                                  //     onTap: () {
                                  //       setState(() {
                                  //         if (exType(expiredType)) {
                                  //           expiredType =
                                  //               "Discard remaining balance for the next period";

                                  //         } else {
                                  //           expiredType = locale == "en"
                                  //               ? "Save it for the next period"
                                  //               : "Le reporter sur la période suivante";

                                  //         }
                                  //         Navigator.pop(context);
                                  //           showUpdate(balance, expiredType, budget);
                                  //       });
                                  //     },
                                  //     child: Icon(
                                  //       Icons.swap_horiz,
                                  //       size: 30,
                                  //       color:
                                  //           ThemeProvider.themeOf(context).id ==
                                  //                   "dark"
                                  //               ? Colors.tealAccent
                                  //               : secColor,
                                  //     )),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      jsonResult[0]['language'][locale]['p1.14'],
                                      style: TextStyle(
                                          color: ThemeProvider.themeOf(context)
                                                      .id ==
                                                  'dark'
                                              ? Colors.tealAccent
                                              : secColor),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 25,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _editBudget(
                                          expireBudget, exType(expiredType));
                                      print("update");
                                    },
                                    child: Text(
                                      jsonResult[0]['language'][locale]['p1.15'],
                                      style: TextStyle(
                                          color: ThemeProvider.themeOf(context)
                                                      .id ==
                                                  'dark'
                                              ? Colors.tealAccent
                                              : secColor),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )),
                ),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, a1, a2) {
          return null;
        });
  }

  deleteChild(budgetID) {
    if (budgetChildIncomeExpense.length != 0) {
      for (var x in budgetChildIncomeExpense) {
        if (x['budget_id'].toString() == budgetID.toString()) {
          deleteCat(x['id'], budgetID);
        }
      }
    } else {
      deleteBudget(budgetID);
    }
  }

  deleteCat(index, budgetID) async {
    final res = await http.delete(
        "http://myassistant.ohm-conception.com/api/income_expense/$index",
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer " + token
        });
    if (res.statusCode == 200) {
      json.encode(res.body);
      print('deleted at' + index.toString());
    }

    if (count == budgetChildIncomeExpense.length - 1) {
      deleteBudget(budgetID);
    }
    count += 1;
  }

  Future deleteBudget(index) async {
    final res = await http.delete(
        'http://myassistant.ohm-conception.com/api/budget/${index.toString()}',
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer " + token
        });
    if (res.statusCode == 200 || res.statusCode == 201) {
      json.encode(res.body);
      Fluttertoast.showToast(msg: "Deleted successfully");
      _login();
    } else {
      Fluttertoast.showToast(msg: "REQUEST TIME OUT ${res.statusCode}");
    }
    Navigator.pop(context);
  }

  Future saveInitVal() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble(
        "initialVal", double.parse(selectedBudget['initial_budget']));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: scrW,
              padding: EdgeInsets.all(10),
              child: Text(
                pageTitles[locale][0],
                style: TextStyle(
                    color: ThemeProvider.themeOf(context).id == 'dark'
                        ? Colors.tealAccent
                        : secColor,
                    fontSize: scrW / 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Container(
                  child: ListView.builder(
                      itemCount: budget.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (expireDay(budget[index]["first_day_period"],
                                  budget[index]['period_type'])) {
                                print("EXPIRED");
                              } else {
                                activeBudget = index;
                                selectedBudget = budget[index];
                                selectedDate = selectedBudget['created_at']
                                    .toString()
                                    .split(" ")[0];
                                saveActive();
                                homeIndex = 2;
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()));
                              }
                            });
                          },
                          child: expireDay(budget[index]["first_day_period"],
                                  budget[index]['period_type'])
                              ?
                              //expire
                              Stack(
                                  children: <Widget>[
                                    Container(
                                      height: scrH / 4.3,
                                      padding:
                                          EdgeInsets.only(left: 20, bottom: 20),
                                      margin: EdgeInsets.only(
                                          bottom: 10,
                                          left: 10,
                                          right: 10,
                                          top: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color:
                                                  ThemeProvider.themeOf(context)
                                                              .id ==
                                                          'dark'
                                                      ? Colors.white12
                                                      : Colors.grey[400],
                                              width: 1)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                  child: Row(
                                                children: <Widget>[
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        budgetEdit =
                                                            budget[index];
                                                      });
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ThemeConsumer(
                                                                      child: AddBudget(
                                                                          false,
                                                                          true))));
                                                    },
                                                    child: Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color: ThemeProvider.themeOf(
                                                                              context)
                                                                          .id ==
                                                                      "dark"
                                                                  ? Colors
                                                                      .tealAccent
                                                                  : secColor)),
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: ThemeProvider.themeOf(
                                                                        context)
                                                                    .id ==
                                                                "dark"
                                                            ? Colors.tealAccent
                                                            : secColor,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    budget[index]['name'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: scrW / 15),
                                                  ),
                                                ],
                                              )),
                                              IconButton(
                                                  icon: Icon(Icons.close),
                                                  onPressed: () {
                                                    setState(() {
                                                      budgetChildIncomeExpense =
                                                          budget[index][
                                                              'incomeexpense_categories'];
                                                    });
                                                    showConfirmDelete(
                                                        budget[index]['id']);
                                                  }),
                                            ],
                                          ),
                                          SizedBox(height: 12),
                                          Container(
                                            padding: EdgeInsets.only(right: 20),
                                            child: FittedBox(
                                              child: Text(
                                                  double.parse(budget[index][
                                                              'initial_budget'])
                                                          .toStringAsFixed(2) +
                                                      (budget[index]["currency"]
                                                                  ['name'] ==
                                                              "usd"
                                                          ? currencyList[0][0]
                                                          : currencyList[1][0]),
                                                  style: TextStyle(
                                                      color: secColor,
                                                      fontSize: scrW / 10)),
                                            ),
                                          ),
                                          Expanded(child: Container()),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(DateTime.parse(budget[index]
                                                          ['first_day_period'])
                                                      .month
                                                      .toString() +
                                                  "-" +
                                                  DateTime.parse(budget[index]
                                                          ['first_day_period'])
                                                      .day
                                                      .toString() +
                                                  "-" +
                                                  DateTime.parse(budget[index]
                                                          ['first_day_period'])
                                                      .year
                                                      .toString()),
                                              Expanded(child: Container()),
                                              GestureDetector(
                                                onTap: () {
                                                  showUpdate(
                                                      budget[index]
                                                          ["initial_budget"],
                                                      budget[index]["purpose"],
                                                      budget[index]);
                                                  print("updatethis");
                                                },
                                                child: Text(
                                                  "Update",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      color:
                                                          ThemeProvider.themeOf(
                                                                          context)
                                                                      .id ==
                                                                  'dark'
                                                              ? Colors
                                                                  .tealAccent
                                                              : secColor),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                period[locale][budget[index]
                                                    ['period_type']],
                                              ),
                                              SizedBox(
                                                width: 20,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                        top: 10,
                                        left: 10,
                                        child: Image.asset(
                                          "assets/image/expired.png",
                                          width: 50,
                                        )),
                                  ],
                                )
                              : activeBudget == index
                                  ? Container(
                                      height: scrH / 4.3,
                                      width: scrW,
                                      padding:
                                          EdgeInsets.only(left: 20, bottom: 20),
                                      margin: EdgeInsets.only(
                                          bottom: 10,
                                          left: 10,
                                          right: 10,
                                          top: 10),
                                      decoration: BoxDecoration(
                                          color: ThemeProvider.themeOf(context)
                                                      .id ==
                                                  'dark'
                                              ? Color.fromRGBO(37, 52, 65, 1)
                                              : Colors.grey[100],
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
                                                blurRadius: 5,
                                                offset: Offset(-7, -7)),
                                            BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 10,
                                                offset: Offset(8, 8))
                                          ]),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                  child: Row(
                                                children: <Widget>[
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        budgetEdit =
                                                            budget[index];
                                                      });
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ThemeConsumer(
                                                                      child: AddBudget(
                                                                          false,
                                                                          true))));
                                                    },
                                                    child: Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color: ThemeProvider.themeOf(
                                                                              context)
                                                                          .id ==
                                                                      "dark"
                                                                  ? Colors
                                                                      .tealAccent
                                                                  : secColor)),
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: ThemeProvider.themeOf(
                                                                        context)
                                                                    .id ==
                                                                "dark"
                                                            ? Colors.tealAccent
                                                            : secColor,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    budget[index]['name'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: scrW / 15),
                                                  ),
                                                ],
                                              )),
                                              IconButton(
                                                  icon: Icon(Icons.close),
                                                  onPressed: () {
                                                    setState(() {
                                                      budgetChildIncomeExpense =
                                                          budget[index][
                                                              'incomeexpense_categories'];
                                                    });
                                                    showConfirmDelete(
                                                        budget[index]['id']);
                                                  }),
                                            ],
                                          ),
                                          SizedBox(height: 12),
                                          Container(
                                            padding: EdgeInsets.only(right: 20),
                                            child: FittedBox(
                                              child: Text(
                                                  double.parse(budget[index][
                                                              'initial_budget'])
                                                          .toStringAsFixed(2) +
                                                      (budget[index]["currency"]
                                                                  ['name'] ==
                                                              "usd"
                                                          ? currencyList[0][0]
                                                          : currencyList[1][0]),
                                                  style: TextStyle(
                                                      color: secColor,
                                                      fontSize: scrW / 10)),
                                            ),
                                          ),
                                          Expanded(child: Container()),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(DateTime.parse(budget[index]
                                                          ['first_day_period'])
                                                      .month
                                                      .toString() +
                                                  "-" +
                                                  DateTime.parse(budget[index]
                                                          ['first_day_period'])
                                                      .day
                                                      .toString() +
                                                  "-" +
                                                  DateTime.parse(budget[index]
                                                          ['first_day_period'])
                                                      .year
                                                      .toString()),
                                              Expanded(child: Container()),
                                              Text(
                                                period[locale][budget[index]
                                                    ['period_type']],
                                              ),
                                              SizedBox(
                                                width: 20,
                                              )
                                            ],
                                          )
                                        ],
                                      ))
                                  : Container(
                                      padding:
                                          EdgeInsets.only(left: 20, bottom: 20),
                                      margin: EdgeInsets.only(
                                          bottom: 10,
                                          left: 10,
                                          right: 10,
                                          top: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color:
                                                  ThemeProvider.themeOf(context)
                                                              .id ==
                                                          'dark'
                                                      ? Colors.white12
                                                      : Colors.grey[400],
                                              width: 1)),
                                      height: scrH / 4.3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                  child: Row(
                                                children: <Widget>[
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        budgetEdit =
                                                            budget[index];
                                                      });
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ThemeConsumer(
                                                                      child: AddBudget(
                                                                          false,
                                                                          true))));
                                                    },
                                                    child: Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color: ThemeProvider.themeOf(
                                                                              context)
                                                                          .id ==
                                                                      "dark"
                                                                  ? Colors
                                                                      .tealAccent
                                                                  : secColor)),
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: ThemeProvider.themeOf(
                                                                        context)
                                                                    .id ==
                                                                "dark"
                                                            ? Colors.tealAccent
                                                            : secColor,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    budget[index]['name'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: scrW / 15),
                                                  ),
                                                ],
                                              )),
                                              IconButton(
                                                  icon: Icon(Icons.close),
                                                  onPressed: () {
                                                    setState(() {
                                                      budgetChildIncomeExpense =
                                                          budget[index][
                                                              'incomeexpense_categories'];
                                                    });
                                                    showConfirmDelete(
                                                        budget[index]['id']);
                                                  }),
                                            ],
                                          ),
                                          SizedBox(height: 12),
                                          Container(
                                            padding: EdgeInsets.only(right: 20),
                                            child: FittedBox(
                                              child: Text(
                                                  double.parse(budget[index][
                                                              'initial_budget'])
                                                          .toStringAsFixed(2) +
                                                      (budget[index]["currency"]
                                                                  ['name'] ==
                                                              "usd"
                                                          ? currencyList[0][0]
                                                          : currencyList[1][0]),
                                                  style: TextStyle(
                                                      color: secColor,
                                                      fontSize: scrW / 10)),
                                            ),
                                          ),
                                          Expanded(child: Container()),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(DateTime.parse(budget[index]
                                                          ['first_day_period'])
                                                      .month
                                                      .toString() +
                                                  "-" +
                                                  DateTime.parse(budget[index]
                                                          ['first_day_period'])
                                                      .day
                                                      .toString() +
                                                  "-" +
                                                  DateTime.parse(budget[index]
                                                          ['first_day_period'])
                                                      .year
                                                      .toString()),
                                              Expanded(child: Container()),
                                              Text(
                                                period[locale][budget[index]
                                                    ['period_type']],
                                              ),
                                              SizedBox(
                                                width: 20,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                        );
                      })),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ThemeConsumer(child: AddBudget(false, false))));
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                child: DottedBorder(
                  dashPattern: [10],
                  color: Colors.grey,
                  strokeWidth: 1,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.add_circle_outline,
                            color: Colors.grey,
                            size: 30,
                          ),
                          SizedBox(width: 10),
                          Text(
                            jsonResult[0]['language'][locale]['p8.2']
                                .toString(),
                            style: TextStyle(
                                color: Colors.grey[400],
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
