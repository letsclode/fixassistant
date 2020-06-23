import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:myassistantv2/core/global/variables.dart';
import 'package:myassistantv2/ui/pages/home/home.dart';
import 'package:myassistantv2/ui/pages/methods/pref.dart';
import 'package:myassistantv2/ui/pages/newuser/newUserPage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:theme_provider/theme_provider.dart';

class Authentication {
  
  static Future registerNew(email, password, context) async {
    final respo = await http
        .post("http://myassistant.ohm-conception.com/api/register", body: {
      "name": 'null',
      "email": email,
      "password": password,
    });
    if (respo.statusCode == 200) {
      _createCurrency();
      json.encode(respo.body);
      login(email, password, context);
      Fluttertoast.showToast(msg: "Register Success");
    } else {
      print("fail");
      login(email, password,context);
    }
  }

 static Future login(email, password,context) async {
    final response = await http.post(
      "http://myassistant.ohm-conception.com/api/login",
      body: {
        "email": email,
        "password": password,
      },
    );

    if (response.statusCode == 200) {
      savePref(email, password);
      var data = json.decode(response.body);
      token = data['success']['token'];
      budget = data['success']['details']['budgets'];
      budgetDetails = data['success']['details'];
      payment = data['success']['details']['payment_methods'];
      pass = password;
      uemail = email;
      uname = data['success']['details']['name'];
      id = data['success']['details']['id'].toString();
      allIncomeExpense = data['success']['details']['incomeexpense_categories'];

      if (budget.length == 0) {
        print('presave');
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: ThemeConsumer(child: NewUserPage()),
                type: PageTransitionType.leftToRightWithFade));
      } else {
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: ThemeConsumer(child: Home()),
                type: PageTransitionType.leftToRightWithFade));
      }
    } else {
      Fluttertoast.showToast(msg: "No Account Found");
    }
  }

 static  _createCurrency() async {
    var names = ['usd', 'euro'];
    for (var name in names) {
      final respo = await http
          .post("http://myassistant.ohm-conception.com/api/currency", body: {
        "name": name,
      }, headers: {
        HttpHeaders.authorizationHeader: "Bearer " + token,
        "Accept": "application/json"
      });
    }
  }
}
