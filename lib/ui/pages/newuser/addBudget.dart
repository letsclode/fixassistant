import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myassistantv2/core/global/variables.dart';
import 'package:myassistantv2/ui/pages/home/home.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:http/http.dart' as http;

class AddBudget extends StatefulWidget {
  bool newUser = true;
  bool editUser = false;
  AddBudget(this.newUser, this.editUser);
  @override
  _AddBudgetState createState() => _AddBudgetState();
}

class _AddBudgetState extends State<AddBudget> {
  bool successfulDrop;
  bool _load = false;
  bool showBin = false;
  String hintTitle = jsonResult[0]['language'][locale]['p4.8'];
  int intColor = 0;
  List hintColor = [Colors.grey[400], Colors.red];
  String hintValue = "0.00";
  int perId = 0;
  String currId;
  String _selectedPeriod = tempPeriod1[0];
  String _selectedPeriod2 = tempPeriod2[0];
  String selectedOption = tempPurpose1[0];
  String selectedOption2 = tempPurpose2[0];
  String selectedCurrId = "\$(USD)";
  var _date = DateTime.now().toString();
  TextEditingController budgetName = TextEditingController();
  TextEditingController initialBudget = TextEditingController();

  getCurrency(currId) {
    for (var x in currency) {
      if (x['id'].toString() == currId) {
        selectedCurrId = x['name'] == "usd" ? "\$(USD)" : "€(EUR)";
      }
    }
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
        },
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer " + token,
          "Content-Type": "application/x-www-form-urlencoded"
        });
  }

  _getToday() {
    if (perId == 0) {
      setState(() {
        newDay = double.parse(initialBudget.text) / 30;
      });
    } else if (perId == 1) {
      setState(() {
        newDay = double.parse(initialBudget.text) / 7;
      });
    } else {
      setState(() {
        newDay = 0.00;
      });
    }
  }

  _getWeek() {
    setState(() {
      newWeek = newDay * (8 - DateTime.parse(_date).weekday.toDouble());
    });
  }

  _createBudget() async {
    _getToday();
    _getWeek();

    final respo = await http
        .post("http://myassistant.ohm-conception.com/api/budget", body: {
      "name": budgetName.text.toUpperCase()[0] + budgetName.text.substring(1),
      "initial_budget": initialBudget.text.toString(),
      "first_day_period": _date.toString(),
      "period_type": perId.toString(),
      "purpose": selectedOption.toString(),
      "currency_id": selectedCurrId == "\$(USD)" ? 1.toString() : 2.toString(),
      "today_budget": newDay.toString(),
      "week_budget": newWeek.toString(),
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer " + token,
      "Accept": "application/json"
    });

    if (respo.statusCode == 200 || respo.statusCode == 201) {
      Fluttertoast.showToast(msg: jsonResult[0]['language'][locale]['p12.4']);
      _login(widget.newUser);
    }
  }

  _editBudget(id) async {
    final respo = await http
        .put("http://myassistant.ohm-conception.com/api/budget/$id", body: {
      "name": budgetName.text.toUpperCase()[0] + budgetName.text.substring(1),
      "initial_budget": initialBudget.text,
      "first_day_period": _date,
      "period_type": perId.toString(),
      "purpose": selectedOption,
      "currency_id": currId,
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer " + token,
      "Accept": "application/json"
    });

    if (respo.statusCode == 200 || respo.statusCode == 201) {
      Fluttertoast.showToast(msg: "Successfully edited");
      _login(widget.newUser);
    } else {
      print("fail");
    }
  }

  Future _login(bool create) async {
    final response = await http.post(
      "http://myassistant.ohm-conception.com/api/login",
      body: {
        "email": uemail,
        "password": pass,
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
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

      if (widget.editUser == false) {
        add().whenComplete(() => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home())));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    } else {
      Fluttertoast.showToast(msg: "No Account Found");
    }
  }

  Future add() async {
    for (var x in staticincomeCat) {
      _addEI(x['name'], x['icon'], budget[budget.length - 1]['id'], x['amount'],
          1);
    }

    for (var x in staticexpenseCat) {
      _addEI(x['name'], x['icon'], budget[budget.length - 1]['id'], x['amount'],
          2);
    }
  }

  @override
  void initState() {
    if (widget.editUser) {
      setState(() {
        budgetName.text = budgetEdit['name'];
        initialBudget.text = budgetEdit['initial_budget'];
        _selectedPeriod = tempPeriod1[budgetEdit['period_type']];
        _selectedPeriod2 = tempPeriod2[budgetEdit['period_type']];
        selectedOption =
            tempPurpose1[budgetEdit['purpose'] == tempPurpose1[0] ? 0 : 1];
        selectedOption2 =
            tempPurpose2[budgetEdit['purpose'] == tempPurpose1[0] ? 0 : 1];
        _date = budgetEdit['first_day_period'];
        perId = budgetEdit['period_type'];
        currId = budgetEdit['currency_id'].toString();
        getCurrency(currId);
      });
    } else {
      getCurrency(selectedCurrId);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      child: Scaffold(
        appBar: widget.newUser
            ? null
            : AppBar(
                automaticallyImplyLeading: false,
                actions: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      width: scrW / 5,
                      height: scrH / 40,
                      child: Center(
                          child: Text(
                        jsonResult[0]['language'][locale]['p7.14'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: scrW / 25),
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
                                blurRadius: 2,
                                offset: Offset(-5, -5)),
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(5, 5))
                          ]),
                    ),
                  ),
                ],
                elevation: 0,
                title: Row(
                  children: <Widget>[
                    Text(
                      jsonResult[0]['language'][locale]['p8.2'],
                      style: TextStyle(
                          color: ThemeProvider.themeOf(context).id == 'dark'
                              ? Colors.tealAccent
                              : secColor),
                    )
                  ],
                ),
              ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    width: scrW,
                    height: scrH,
                    child: Column(
                      children: <Widget>[
                        widget.newUser
                            ? Column(
                                children: <Widget>[
                                  Text(
                                    jsonResult[0]['language'][locale]['p7.1'],
                                    style: TextStyle(
                                        color:
                                            ThemeProvider.themeOf(context).id ==
                                                    'dark'
                                                ? Colors.tealAccent
                                                : secColor,
                                        fontSize: scrW / 10),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    jsonResult[0]['language'][locale]['p7.13'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: ThemeProvider.themeOf(context).id == 'dark'
                                ? Color.fromRGBO(32, 48, 59, 1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: ThemeProvider.themeOf(context).id ==
                                          'dark'
                                      ? Colors.grey[900]
                                      : Colors.grey[300],
                                  blurRadius: 1,
                                  offset: Offset(-3, -3)),
                            ],
                          ),
                          child: TextField(
                            controller: budgetName,
                            decoration: InputDecoration(
                                hintText: hintTitle,
                                hintStyle: TextStyle(
                                    color: intColor == 0
                                        ? Colors.grey[400]
                                        : Colors.red,
                                    fontWeight: FontWeight.bold),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width: scrW / 2,
                              decoration: BoxDecoration(
                                color:
                                    ThemeProvider.themeOf(context).id == 'dark'
                                        ? Color.fromRGBO(32, 48, 59, 1)
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          ThemeProvider.themeOf(context).id ==
                                                  'dark'
                                              ? Colors.grey[900]
                                              : Colors.grey[300],
                                      blurRadius: 1,
                                      offset: Offset(-3, -3)),
                                ],
                              ),
                              child: TextField(
                                controller: initialBudget,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: hintValue,
                                    hintStyle: TextStyle(
                                        color: intColor == 0
                                            ? Colors.grey[400]
                                            : Colors.red,
                                        fontWeight: FontWeight.bold),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none)),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            //currency
                            Expanded(
                              child: AnimatedContainer(
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
                                            blurRadius: 3,
                                            offset: Offset(-7, -7)),
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 10,
                                            offset: Offset(8, 8))
                                      ]),
                                  duration: Duration(milliseconds: 500),
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  height: 60,
                                  child: Center(
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        icon: Icon(
                                          Icons.expand_more,
                                        ),
                                        style: TextStyle(
                                            color:
                                                ThemeProvider.themeOf(context)
                                                            .id ==
                                                        'dark'
                                                    ? Colors.white
                                                    : Colors.black,
                                            fontSize: scrW / 25),
                                        isExpanded: true,
                                        value: selectedCurrId,
                                        hint: Text(""),
                                        items: currencyList.map((var per) {
                                          return DropdownMenuItem<String>(
                                            child: Text(per),
                                            value: per,
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          setState(() {
                                            selectedCurrId = val;
                                            currId = selectedCurrId;
                                            if (widget.editUser) {
                                              currId = val == "\$(USD)"
                                                  ? currency[0]['id'].toString()
                                                  : currency[1]["id"]
                                                      .toString();
                                            }
                                          });
                                          print(currId);
                                        },
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                DatePicker.showDatePicker(
                                  context,
                                  minTime: DateTime(DateTime.now().year,
                                      (DateTime.now().month) - 1, 01),
                                  maxTime:
                                      DateTime(DateTime.now().year, 12, 30),
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
                                          color: ThemeProvider.themeOf(context)
                                                      .id ==
                                                  'dark'
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                      doneStyle:
                                          TextStyle(color: Colors.black)),
                                  onChanged: (date) {
                                    print(date);
                                  },
                                  onConfirm: (date) {
                                    setState(() {
                                      _date = date.toString();
                                    });
                                  },
                                );
                              },
                              child: Container(
                                  width: scrW / 2,
                                  height: 60,
                                  padding: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 1, color: Colors.grey)),
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
                                        _date.toString().split(" ")[0],
                                        style: TextStyle(fontSize: scrW / 25),
                                      ),
                                    ],
                                  )),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: AnimatedContainer(
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
                                            blurRadius: 3,
                                            offset: Offset(-7, -7)),
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 10,
                                            offset: Offset(8, 8))
                                      ]),
                                  duration: Duration(milliseconds: 500),
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  height: 60,
                                  child: Center(
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        icon: Icon(
                                          Icons.expand_more,
                                        ),
                                        style: TextStyle(
                                            color:
                                                ThemeProvider.themeOf(context)
                                                            .id ==
                                                        'dark'
                                                    ? Colors.white
                                                    : Colors.black,
                                            fontSize: scrW / 25),
                                        isExpanded: true,
                                        value: locale == "en"
                                            ? _selectedPeriod
                                            : _selectedPeriod2,
                                        hint: Text(""),
                                        items: locale == "en"
                                            ? tempPeriod1.map((String per) {
                                                return DropdownMenuItem<String>(
                                                  child: Text(per),
                                                  value: per,
                                                );
                                              }).toList()
                                            : tempPeriod2.map((String per) {
                                                return DropdownMenuItem<String>(
                                                  child: Text(per),
                                                  value: per,
                                                );
                                              }).toList(),
                                        onChanged: (val) {
                                          setState(() {
                                            if (val ==
                                                jsonResult[0]['language']
                                                    [locale]['p7.2']) {
                                              perId = 0;
                                            } else if (val ==
                                                jsonResult[0]['language']
                                                    [locale]['p7.3']) {
                                              perId = 1;
                                            } else if (val ==
                                                jsonResult[0]['language']
                                                    [locale]['p7.4']) {
                                              perId = 2;
                                            } else if (val ==
                                                jsonResult[0]['language']
                                                    [locale]['p7.5']) {
                                              perId = 3;
                                            } else {
                                              perId = 4;
                                            }
                                            locale == "en"
                                                ? _selectedPeriod =
                                                    tempPeriod1[perId]
                                                : _selectedPeriod2 =
                                                    tempPeriod2[perId];
                                          });
                                        },
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          jsonResult[0]['language'][locale]['p7.9'],
                          style: TextStyle(
                              color: Colors.grey[700], fontSize: scrW / 20),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            decoration: BoxDecoration(
                                color:
                                    ThemeProvider.themeOf(context).id == 'dark'
                                        ? Color.fromRGBO(37, 52, 65, 1)
                                        : Color.fromRGBO(241, 243, 246, 1),
                                borderRadius: BorderRadius.circular(10),
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
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            height: 60,
                            child: Center(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  icon: Icon(
                                    Icons.expand_more,
                                  ),
                                  style: TextStyle(
                                      color:
                                          ThemeProvider.themeOf(context).id ==
                                                  'dark'
                                              ? Colors.white
                                              : Colors.black,
                                      fontSize: 17),
                                  isExpanded: true,
                                  value: locale == "en"
                                      ? selectedOption
                                      : selectedOption2,
                                  hint: Text(jsonResult[0]['language'][locale]
                                      ['p7.2']),
                                  items: locale == "en"
                                      ? tempPurpose1.map((String purpose) {
                                          return DropdownMenuItem<String>(
                                            child: Text(purpose),
                                            value: purpose,
                                          );
                                        }).toList()
                                      : tempPurpose2.map((String purpose) {
                                          return DropdownMenuItem<String>(
                                            child: Text(purpose),
                                            value: purpose,
                                          );
                                        }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      if (val ==
                                          jsonResult[0]['language'][locale]
                                              ['p7.10']) {
                                        locale == "en"
                                            ? selectedOption = tempPurpose1[0]
                                            : selectedOption2 = tempPurpose2[0];
                                      } else {
                                        locale == "en"
                                            ? selectedOption = tempPurpose1[1]
                                            : selectedOption2 = tempPurpose2[1];
                                      }
                                    });
                                  },
                                ),
                              ),
                            )),
                        SizedBox(
                          height: scrH / 15,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _load = true;
                            });

                            if (widget.editUser) {
                              if (budgetName.text.isEmpty) {
                                setState(() {
                                  budgetName.text = hintTitle;
                                  _load = false;
                                });
                              }
                              _editBudget(budgetEdit['id']);
                              print("edit");
                              setState(() {
                                budgetName.text = hintTitle;
                                _load = false;
                              });
                            } else {
                              if (initialBudget.text.isEmpty) {
                                setState(() {
                                  initialBudget.text = "0.00";
                                  _load = false;
                                });
                              }
                              if (budgetName.text.isEmpty) {
                                setState(() {
                                  intColor = 1;
                                  _load = false;
                                });
                              } else {
                                _createBudget();
                              }
                            }
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: ThemeProvider.themeOf(context).id ==
                                          'dark'
                                      ? Color.fromRGBO(37, 52, 65, 1)
                                      : Color.fromRGBO(241, 243, 246, 1),
                                  borderRadius: BorderRadius.circular(10),
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
                              width: scrW / 1.6,
                              height: 60,
                              child: Center(
                                  child: Text(
                                jsonResult[0]['language'][locale]['p4.9'],
                                style: TextStyle(
                                    color: ThemeProvider.themeOf(context).id ==
                                            'dark'
                                        ? Colors.tealAccent
                                        : secColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: scrW / 20),
                              ))),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              _load == true
                  ? Container(
                      width: scrW,
                      height: scrH,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
