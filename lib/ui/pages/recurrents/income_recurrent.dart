import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myassistantv2/core/global/variables.dart';
import 'package:myassistantv2/ui/widgets/addEI.dart';
import 'package:theme_provider/theme_provider.dart';

class IncomeRecurrent extends StatefulWidget {
  @override
  _IncomeRecurrentState createState() => _IncomeRecurrentState();
}

class _IncomeRecurrentState extends State<IncomeRecurrent> {
  var activeCategory = -1;
  var activePaid = -1;
  bool showI;
  int index = 0;
  PageController controllerPage = PageController();
  int currentIndex = 1;
  bool successfulDrop;
  bool showBin = false;
  List wichList = [1, 2];
  int _index;
  TextEditingController moneyValue = TextEditingController();
  bool _addRecStat = false;
  String selectedCategory = jsonResult[0]['language'][locale]['p11.6'];
  List<String> listCategory = [
    jsonResult[0]['language'][locale]['p11.6'],
    jsonResult[0]['language'][locale]['p11.9']
  ];

  Stream updateIncome() async* {
    setState(() {
      showI = showIncome;
    });
    yield showI;
  }

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
    setState(() {
      visited = true;
      loadManage = false;
    });
  }

  addEdit(index, type) {
    if (type == 1) {
      setState(() {
        toBeEdited = recIncome[index];
        _index = index;
      });
    } else {
      setState(() {
        _index = index;
        toBeEdited = recExpense[index];
      });
    }

    setState(() {
      isEditState = true;
      addRecStat = true;
    });
  }

  _deleteIncome(index, val) async {
    final res = await http.delete(
        "http://myassistant.ohm-conception.com/api/income_expense/$index",
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer " + token
        });
    if (res.statusCode == 200) {
      allIncomeExpense.removeAt(val);
      json.encode(res.body);
      Fluttertoast.showToast(msg: jsonResult[0]['language'][locale]['p12.6']);
    }
    _login(uemail, pass);
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
        token = data['success']['token'];
        payment = data['success']['details']['payment_methods'];
        pass = password;
        uemail = email;
        uname = data['success']['details']['name'];
        id = data['success']['details']['id'].toString();
        allIncomeExpense = budget[activeBudget]['incomeexpense_categories'];
        currency = data['success']['details']['currencies'];
      });

      setState(() {
        visited = true;
        loadManage = false;
      });
    }
  }

  @override
  void initState() {
    passData();
    print(recIncome);
    _login(uemail, pass);
  }

  @override
  void dispose() {
    showExpense = false;
    controllerPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: scrW,
                    child: Row(
                      children: <Widget>[
                        Text(
                           "Income",
                          style: TextStyle(
                              color: ThemeProvider.themeOf(context).id == 'dark'
                                  ? Colors.tealAccent
                                  : secColor,
                              fontSize: scrW / 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                showIncome = true;
                                activePaid = -1;
                                activeCategory = -1;
                              });
                            },
                            child: Icon(Icons.add_circle_outline))
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: ListView(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                totalrecIncome.toStringAsFixed(2) +
                                    (selectedBudget["currency"]['name'] == "usd"
                                        ? currencyList[0][0]
                                        : currencyList[1][0]),
                                style: TextStyle(fontSize: scrW / 20),
                              ),
                              Text(
                                locale == "en"
                                    ? tempPeriod1[selectedBudget['period_type']]
                                    : tempPeriod2[
                                        selectedBudget['period_type']],
                                style: TextStyle(color: Colors.grey),
                              ),
                              for (var x = 0; x < allIncomeExpense.length; x++)
                                allIncomeExpense[x]["is_recurrent"] == 1 &&
                                        allIncomeExpense[x]["type"] == 1
                                    ? LongPressDraggable(
                                        onDraggableCanceled: (x, y) {
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
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: ThemeProvider.themeOf(
                                                                  context)
                                                              .id ==
                                                          'dark'
                                                      ? Colors.white12
                                                      : Colors.grey[400],
                                                  width: 1)),
                                          padding: EdgeInsets.all(10),
                                          margin: EdgeInsets.all(5),
                                          width: scrW,
                                          height: scrH / 15,
                                        ),
                                        feedback: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: ThemeProvider.themeOf(
                                                                  context)
                                                              .id ==
                                                          'dark'
                                                      ? Colors.grey[600]
                                                      : Colors.grey[400],
                                                  width: 1)),
                                          padding: EdgeInsets.all(10),
                                          margin: EdgeInsets.all(5),
                                          width: scrW,
                                          height: scrH / 15,
                                          child: Scaffold(
                                            body: Row(
                                              children: <Widget>[
                                                Container(
                                                  width: scrW / 5,
                                                  child: Text(
                                                    allIncomeExpense[x]['name'],
                                                    style: TextStyle(
                                                        fontSize: scrW / 25),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                  height: 15,
                                                  child: Container(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  allIncomeExpense[x]['type_of']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: scrW / 25),
                                                ),
                                                Expanded(child: Container()),
                                                Text(
                                                  allIncomeExpense[x]['amount']
                                                          .toStringAsFixed(2) +
                                                      (selectedBudget["currency"]
                                                                  ['name'] ==
                                                              "usd"
                                                          ? currencyList[0][0]
                                                          : currencyList[1][0]),
                                                  style: TextStyle(
                                                      fontSize: scrW / 25),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        data: (x.toString() +
                                            " " +
                                            allIncomeExpense[x]['id']
                                                .toString()),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: ThemeProvider.themeOf(
                                                                  context)
                                                              .id ==
                                                          'dark'
                                                      ? Colors.white24
                                                      : Colors.grey[400],
                                                  width: 1)),
                                          padding: EdgeInsets.all(10),
                                          margin: EdgeInsets.all(5),
                                          width: scrW,
                                          height: scrH / 15,
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                width: scrW / 5,
                                                child: Text(
                                                  allIncomeExpense[x]['name'],
                                                  style: TextStyle(
                                                      fontSize: scrW / 25),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
                                                width: 5,
                                                height: 15,
                                                child: Container(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                allIncomeExpense[x]['type_of']
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: scrW / 25),
                                              ),
                                              Expanded(child: Container()),
                                              Text(
                                                allIncomeExpense[x]['amount']
                                                        .toStringAsFixed(2) +
                                                    (selectedBudget["currency"]
                                                                ['name'] ==
                                                            "usd"
                                                        ? currencyList[0][0]
                                                        : currencyList[1][0]),
                                                style: TextStyle(
                                                    fontSize: scrW / 25),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  StreamBuilder<Object>(
                      stream: updateIncome(),
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return Container();
                        }
                        return snapshot.data ? AddEI(1) : Container();
                      }),
                ],
              ),
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
                          _deleteIncome(datas[1], int.parse(datas[0]));
                          setState(() {
                            successfulDrop = true;
                            showBin = false;
                          });
                        },
                        onLeave: (data) {
                          print('leaving');
                        },
                      ),
                    ),
                  )
                : Container(),
            loadManage == true
                ? Container(
                    width: scrW,
                    height: scrH,
                    decoration: BoxDecoration(
                        color: ThemeProvider.themeOf(context).id == 'dark'
                            ? Colors.white12
                            : Colors.white54,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
