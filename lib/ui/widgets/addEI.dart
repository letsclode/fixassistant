import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myassistantv2/core/global/variables.dart';
import 'package:myassistantv2/ui/widgets/incomeExpense.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:http/http.dart' as http;

class AddEI extends StatefulWidget {
  final type;
  AddEI(this.type);
  @override
  _AddEIState createState() => _AddEIState();
}

class _AddEIState extends State<AddEI> {
  TextEditingController moneyValue = TextEditingController();
  TextEditingController catName = TextEditingController();
  var leftDays = 30 -
      DateTime.parse(selectedBudget['created_at'])
          .difference(DateTime.now())
          .inDays;
  var timeIncome;
  var _date = jsonResult[0]['language'][locale]['p7.7'];
  String defType = "Off";
  String recurrent = "";

  addEI(eiName, eiIcon, budgetId, price, eiDiff, recurrent, startingDate,defType) async {

    if (startingDate == jsonResult[0]['language'][locale]['p7.7'].toString()) {
      setState(() {
        startingDate = DateTime.now();
       
      });
    }
    if (defType.toString().toLowerCase() != "off") {
      recurrent = 1;
    }

    final res = await http.post(
        "http://myassistant.ohm-conception.com/api/income_expense",
        body: {
          "budget_id": budgetId.toString(),
          "name": eiName.toUpperCase()[0] + eiName.toString().substring(1),
          "icon": eiIcon.toString(),
          "amount": price.toString(),
          "type": eiDiff.toString(),
          "type_of": defType.toString(),
          "starting_date": startingDate.toString(),
          'is_recurrent': recurrent.toString()
        },
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer " + token,
          "Content-Type": "application/x-www-form-urlencoded"
        });
    if (res.statusCode == 200) {
      Fluttertoast.showToast(msg: jsonResult[0]['language'][locale]['p12.4']);
    } else {
      print("fail to add");
    }
    _login(uemail, pass);
  }

  incomeCalculate(value) {
    print("INCOME");
    setState(() {
      initialBudget += double.parse(value);
    });

    editBudget(initialBudget);
    setState(() {
      todayBudget = initialBudget / leftDays;
      weekBudget = todayBudget * (8 - DateTime.now().weekday.toDouble());
    });
  }

  expenseCalculate(value) {
    print("EXPENSE");
    setState(() {
      initialBudget -= double.parse(value);
      todayBudget -= double.parse(value);
      weekBudget -= double.parse(value);
    });
    editBudget(initialBudget);
  }

  editBudget(value) async {
    final respo = await http.put(
        "http://myassistant.ohm-conception.com/api/budget/${selectedBudget['id']}",
        body: {
          "name": selectedBudget['name'].toString(),
          "initial_budget": value.toString(),
          "first_day_period": selectedBudget['first_day_period'].toString(),
          "period_type": selectedBudget['period_type'].toString(),
          "purpose": selectedBudget['purpose'].toString(),
          "currency_id": selectedBudget['currency_id'].toString(),
          "today_budget": todayBudget.toString(),
          "week_budget": weekBudget.toString(),
        },
        headers: {
          HttpHeaders.authorizationHeader: "Bearer " + token,
          "Accept": "application/json"
        });

    if (respo.statusCode != 200) {
      print("fail");
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
        token = data['success']['token'];
        budget = data['success']['details']['budgets'];
        budgetDetails = data['success']['details'];
        allIncomeExpense = budget[activeBudget]['incomeexpense_categories'];
        initialBudget = double.parse(budget[activeBudget]['initial_budget']);
        currency = data['success']['details']['currencies'];
        selectedBudget = budget[activeBudget];
      });

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
    setState(() {
      showExpense = false;
      showIncome = false;
    });
  }

  @override
  void initState() {
    setState(() {
      incomeList = [];
      expenseList = [];
      for (var x in allIncomeExpense) {
        if (x['amount'] == 0) {
          if (x['type'] == 1) {
            incomeList.add(x);
          } else {
            expenseList.add(x);
          }
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    globalDisable = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            color: ThemeProvider.themeOf(context).id == 'dark'
                ? Color.fromRGBO(37, 52, 65, 1)
                : Colors.white,
            border: Border(top: BorderSide(color: Colors.grey[200]))),
        width: scrW - 20,
        height: scrH / 3,
        child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                // Opacity(
                //     opacity: 0.5,
                //     child: Text(widget.type == 1
                //         ? jsonResult[0]['language'][locale]['p5.6']
                //         : jsonResult[0]['language'][locale]['p11.9'])),
                TextField(
                  autofocus: true,
                  controller: moneyValue,
                  keyboardType: TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration.collapsed(
                      hintText: "0.00",
                      hintStyle:
                          TextStyle(color: Colors.grey, fontSize: scrW / 15)),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            print("click");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => IncomeExpense()));
                          },
                          child: Opacity(
                              opacity: 0.5,
                              child: Icon(Icons.add_circle_outline)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(jsonResult[0]['language'][locale]['p11.10'],
                            textAlign: TextAlign.start),
                      ],
                    )),

                Container(
                  width: scrW,
                  height: widget.type == 2
                      ? expenseList.length == 0 ? 10 : scrH / 10
                      : incomeList.length == 0 ? 10 : scrH / 10,
                  child: Center(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        for (var x
                            in widget.type == 2 ? expenseList : incomeList)
                          x['amount'] == 0
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      activeCategory = showExpense
                                          ? expenseList.indexOf(x)
                                          : incomeList.indexOf(x);
                                    });
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: activeCategory ==
                                                (showExpense
                                                    ? expenseList.indexOf(x)
                                                    : incomeList.indexOf(x))
                                            ? ThemeProvider.themeOf(context)
                                                        .id ==
                                                    'dark'
                                                ? Colors.grey[900]
                                                : Colors.grey[300]
                                            : Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    margin: EdgeInsets.all(4),
                                    padding: EdgeInsets.all(4),
                                    child: Column(
                                      children: <Widget>[
                                        Image.asset(
                                          x['icon'],
                                          height: 30,
                                          width: 30,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          x['name'],
                                          style: TextStyle(fontSize: 10),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Container()
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(jsonResult[0]['language'][locale]['p4.8']),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    onTap: () {},
                    controller: catName,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(jsonResult[0]['language'][locale]['p9.6']),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          DatePicker.showDatePicker(context,
                              minTime:
                                  DateTime.parse(selectedBudget['created_at']),
                              locale: locale == "en"
                                  ? LocaleType.en
                                  : LocaleType.fr,
                              showTitleActions: true,
                              theme: DatePickerTheme(
                                  headerColor: Colors.white,
                                  backgroundColor:
                                      ThemeProvider.themeOf(context).id ==
                                              'dark'
                                          ? Color.fromRGBO(37, 52, 65, 1)
                                          : Colors.white,
                                  itemStyle: TextStyle(
                                      color:
                                          ThemeProvider.themeOf(context).id ==
                                                  'dark'
                                              ? Colors.white
                                              : Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  doneStyle: TextStyle(color: Colors.black)),
                              onChanged: (date) {}, onConfirm: (date) {
                            setState(() {
                              _date = (date.year.toString() +
                                  "-" +
                                  date.month.toString() +
                                  "-" +
                                  date.day.toString());
                            });
                          });
                        },
                        child: Container(
                            width: scrW / 2.8,
                            height: 60,
                            padding: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  _date.toString(),
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: scrW / 30),
                                ),
                              ],
                            )),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: scrW / 2.8,
                        height: 60,
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            icon: Icon(Icons.arrow_drop_down),
                            style: TextStyle(color: Colors.grey, fontSize: 17),
                            isExpanded: true,
                            value: defType,
                            onChanged: (newCurr) {
                              setState(() {
                                defType = newCurr.toString();
                              });
                            },
                            items: recType.map((dynamic text) {
                              return DropdownMenuItem<dynamic>(
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    width: scrW,
                                    height: 50,
                                    child: Center(
                                        child: Text(
                                      text,
                                      style: TextStyle(fontSize: scrW / 30),
                                    ))),
                                value: text,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                // Padding(
                //   padding: const EdgeInsets.only(left: 10.0),
                //   child: Text(jsonResult[0]['language'][locale]['p10.1']),
                // ),
                Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Opacity(
                              opacity: 0.5,
                              child: Icon(Icons.add_circle_outline)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(jsonResult[0]['language'][locale]['p10.1'],
                            textAlign: TextAlign.start),
                      ],
                    )),
                Container(
                  width: scrW,
                  height: bankInfo.length == 0 ? 10 : scrH / 10,
                  child: Center(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        for (var x in bankInfo)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                activePaid = bankInfo.indexOf(x);
                              });
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: activePaid == bankInfo.indexOf(x)
                                      ? ThemeProvider.themeOf(context).id ==
                                              'dark'
                                          ? Colors.grey[900]
                                          : Colors.grey[300]
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10)),
                              margin: EdgeInsets.all(4),
                              padding: EdgeInsets.all(4),
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    x['icon'],
                                    height: 30,
                                    width: 30,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    x['name'],
                                    style: TextStyle(fontSize: 10),
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                )
              ],
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  var category = widget.type == 1 ? expenseList : incomeList;
                  var eiDiff = showExpense ? 2 : 1;
                  var name;
                  var icon;
                  setState(() {
                    if (activeCategory == -1) {
                      icon = tempExpense[0]['icon'];
                      name = tempExpense[0]['name'];
                    } else {
                      icon = category[activeCategory]['icon'];
                      if (catName.text.isEmpty) {
                        name = category[activeCategory]['name'];
                      } else {
                        name = catName.text;
                      }
                    }

                    if (moneyValue.text.isEmpty ||
                        double.parse(moneyValue.text) < 0) {
                      print("please input a value");
                    } else {
                      addEI(
                          name,
                          icon,
                          selectedBudget["id"].toString(),
                          moneyValue.text.toString(),
                          eiDiff,
                          recurrent,
                          _date,
                          defType);
                    }
                    if (eiDiff == 1) {
                      print("in");
                      incomeCalculate(moneyValue.text);
                    } else {
                      print("ex");
                      expenseCalculate(moneyValue.text);
                    }
                  });
                },
                child: Container(
                  width: scrW,
                  height: scrH / 10,
                  margin: EdgeInsets.only(right: 0, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: 60,
                        height: 60,
                        child: Center(
                            child: Icon(
                          Icons.check,
                          color: Colors.green,
                        )),
                        decoration: BoxDecoration(
                            color: ThemeProvider.themeOf(context).id == 'dark'
                                ? Color.fromRGBO(37, 52, 65, 1)
                                : Color.fromRGBO(241, 243, 246, 1),
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: [
                              BoxShadow(
                                  color: ThemeProvider.themeOf(context).id ==
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
                      )
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      setState(() {
                        showIncome = false;
                        showExpense = false;
                      });
                    },
                    child: Container(
                        width: 30,
                        height: 30,
                        color: Colors.red,
                        child: Icon(Icons.close)))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
