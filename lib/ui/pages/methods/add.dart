import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:myassistantv2/core/global/variables.dart';
import 'package:theme_provider/theme_provider.dart';

Future editBudget(double updateValue) async {
  final response = await http.put(
      "http://myassistant.ohm-conception.com/api/budget/${selectedBudget['id']}",
      body: {
        "name": selectedBudget['name'].toString(),
        "initial_budget": updateValue.toString(),
        "purpose": selectedBudget['purpose'].toString(),
        "currency_id": selectedBudget['currency_id'].toString(),
        "first_day_period": selectedBudget['first_day_period'].toString(),
        "period_type": selectedBudget["period_type"].toString(),
        "today_budget": todayBudget.toString(),
        "week_budget": weekBudget.toString()
      },
      headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer " + token,
        "Content-Type": "application/x-www-form-urlencoded"
      });
  if (response.statusCode == 200) {
    print("edited");
  } else {
    print("fail");
  }
}

editEI(index, name, icon, amount, type, startingDate) async {
  final res = await http.put(
      "http://myassistant.ohm-conception.com/api/income_expense/$index",
      body: {
        "name": name.toString(),
        "icon": icon.toString(),
        "amount": amount.toString(),
        "type": type.toString(),
        "starting_date": startingDate.toString(),
      },
      headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer " + token,
        "Content-Type": "application/x-www-form-urlencoded"
      });
  if (res.statusCode == 200) {
    Fluttertoast.showToast(msg: jsonResult[0]['language'][locale]['p12.4']);
  } else {
    print("fail to edit");
  }
}

totalIncomeExpense() {
  for (var category in allIncomeExpense) {
    if (category['type'] == 1) {
      totalIncome += category['amount'];
    } else {
      totalExpense += category['amount'];
    }
  }
}

addEI(eiName, eiIcon, budgetId, price, eiDiff) async {
  final response = await http
      .post("http://myassistant.ohm-conception.com/api/income_expense", body: {
    "name": eiName..toString(),
    "icon": eiIcon.toString(),
    "budget_id": budgetId.toString(),
    "amount": price.toString(),
    "type": eiDiff.toString(),
  }, headers: {
    "Accept": "application/json",
    HttpHeaders.authorizationHeader: "Bearer " + token,
    "Content-Type": "application/x-www-form-urlencoded"
  });
}



noBudget(context) {
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
                      height: scrH / 5,
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                jsonResult[0]['language'][locale]['p1.11'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: scrW / 20),
                              ),
                            ],
                          ),
                          Center(
                            child: Text(
                              jsonResult[0]['language'][locale]['p1.12'],
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              SizedBox(
                                width: 25,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "OK",
                                  style: TextStyle(
                                      color:
                                          ThemeProvider.themeOf(context).id ==
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
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, a1, a2) {});
}
