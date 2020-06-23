import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myassistantv2/core/global/variables.dart';
import 'package:myassistantv2/ui/pages/home/enterFinger.dart';
import 'package:myassistantv2/ui/pages/home/enterPin.dart';
import 'package:myassistantv2/ui/pages/home/home.dart';
import 'package:myassistantv2/ui/pages/login.dart';
import 'package:myassistantv2/ui/pages/newuser/newUserPage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';

class GetLanguage {

  static Future initPlatformState(context) async {
    List languages;
    String currentLocale;
    try {
      languages = await Devicelocale.preferredLanguages;
      print(languages);
    } on PlatformException {
      print("Error obtaining preferred languages");
    }
    try {
      currentLocale = await Devicelocale.currentLocale;
      print(currentLocale);
    } on PlatformException {
      print("Error obtaining current locale");
    }

    locale = currentLocale;
    if (locale[0] == "f") {
      locale = "fr";
    } else {
      locale = "en";
    }
    getData(context);
  }

  static Future getData(context) async {
    String data =
        await DefaultAssetBundle.of(context).loadString("lang/language.json");
    jsonResult = json.decode(data);
    readData(context);
  }

  static Future readData(context) async {
    final prefs = await SharedPreferences.getInstance();
    var respass = prefs.getString('acc_pass');
    var resmail = prefs.getString('acc_mail');
    var lan = prefs.getString('language');
    print(lan);
    if (resmail != null) {
      if (lan != null) {
        locale = lan.toString();
      }
      _loginByPref(resmail, respass,context);
    } else {
      setLanguage(context);
    }
  }

  static Future setLanguage(context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('language', locale);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  static Future _loginByPref(email, password,context) async {
    final response = await http.post(
      "http://myassistant.ohm-conception.com/api/login",
      body: {
        "email": email,
        "password": password,
      },
    );

    if (response.statusCode == 200) {
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
      currency = data['success']['details']['currencies'];

      checkActive(context);
    } else {
      removeData(context);
    }
  }

  static Future removeData(context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  static checkActive(context) async {
    final prefs = await SharedPreferences.getInstance();
    var active = prefs.getInt('activeBudget');
    if (active != null) {
      activeBudget = prefs.getInt('activeBudget');
    }

    if (budget.length != 0) {
      selectedBudget = budget[activeBudget];

      getPinFinger(context);
    } else {
      Navigator.pushReplacement(
          context,
          PageTransition(
              child: ThemeConsumer(child: NewUserPage()),
              type: PageTransitionType.leftToRightWithFade));
    }
  }

  static getPinFinger(context) async {
    final prefs = await SharedPreferences.getInstance();
    pActive = prefs.getBool("pinActive");
    fActive = prefs.getBool("fingerActive");
    if (fActive == true) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => EnterFingerPrint()));
    } else if (pActive == true) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => EnterPin(true, false)));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    }
  }
}
