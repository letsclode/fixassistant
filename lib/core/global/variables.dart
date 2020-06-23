import 'package:flutter/material.dart';

bool pinActive = false;
bool addIncomeExpense = false;
bool fingerActive = false;
bool fbActive = false;
bool googleActive = false;
bool backButton = false;
bool visited = false;
int homeIndex = 0;
Map selectedBudget = {};
int activeBudget = 0;
String pin = '';
bool darkMode = false;
int lastVisited = 0;
String token;
List budget = [];
List payment = [];
var budgetEdit;
String appmode;
String pass = '';
String uemail = '';
List currency;
List eiCat = [];
String beiCat = '';
String uname;
String id;
List savedPin;
double scrW = 0.0;
double scrH = 0.0;
Color secColor = Color.fromRGBO(0, 128, 225, 1);
String locale = "en";
List jsonResult = [];
List allIncomeExpense = [];
List incomeList = [];
List expenseList = [];
List listIncomeExpense = incomeList + expenseList;
double todayBudget = 0.00;
double weekBudget = 0.00;
List recType = ["Off", "Weekly", "Monthly"];
List recType2 = ["De", "Hebdomadaire", "Mensuel"];
double perDay = 0.00;
double perWeek = 0.00;
double initialBudget = 0.00;
double totalIncome = 0.00;
double totalExpense = 0.00;
double totalrecIncome = 0.00;
double totalrecExpense = 0.00;
bool loadManage = true;
bool loadStat = true;
String selectedDate = DateTime.now().toString().split(" ")[0];
var year = DateTime.now().year;
var month = DateTime.now().month;
var numDays;
bool addStat = false;
bool addRecStat = false;
Map budgetDetails = {};
List recIncome = [];
List recExpense = [];
double presentBudgetInitial = 0.00;
double todayExpense = 0.00;
double weekExpense = 0.00;
double todayIncome = 0.00;
double lastDayExpense = 0.00;
double lastDayIncome = 0.00;
double weekIncome = 0.00;
double originalPerDay = 0.00;
var nextDay = DateTime.now().add(Duration(days: 1)).day;
double newDay = 0.00;
double newWeek = 0.00;
List availableIcons = [];
List availableIcons2 = [];
String selected = "";
List activeList = [];
List defaultCategory = [];
var toBeEdited;
bool isEditState = false;
bool fingerPrintAvailability = false;
List budgetChildIncomeExpense;
bool addedEI = false;
bool showIncome = false;
bool showExpense = false;
var activeCategory = -1;
var activePaid = -1;
bool keyBoardOn = false;
bool globalDisable = false;
bool fActive;
bool pActive;

List staticincomeCat = [
  {
    "icon": "assets/image/cash.png",
    "name": jsonResult[0]['language'][locale]['p4.3'],
    "amount": "0.00"
  },
  {
    "icon": "assets/image/Moneypng.png",
    "name": jsonResult[0]['language'][locale]['p5.1'],
    "amount": "0.00"
  },
  {
    "icon": "assets/image/unity.png",
    "name": jsonResult[0]['language'][locale]['p5.2'],
    "amount": "0.00"
  }
];

List tempIncome = [
  {"icon": "assets/image/others.png", "name": "Others", "amount": "0.00"},
  {
    "icon": "assets/image/cash.png",
    "name": jsonResult[0]['language'][locale]['p4.3'],
    "amount": "0.00"
  },
  {
    "icon": "assets/image/Moneypng.png",
    "name": jsonResult[0]['language'][locale]['p5.1'],
    "amount": "0.00"
  },
  {
    "icon": "assets/image/unity.png",
    "name": jsonResult[0]['language'][locale]['p5.2'],
    "amount": "0.00"
  },
  {"icon": "assets/image/award.png", "name": "Award", "amount": "0.00"},
  {"icon": "assets/image/product.png", "name": "Grants", "amount": "0.00"},
  {"icon": "assets/image/sale.png", "name": "Sale", "amount": "0.00"},
  {"icon": "assets/image/rent.png", "name": "Rental", "amount": "0.00"},
  {"icon": "assets/image/forex.png", "name": "Refunds", "amount": "0.00"},
  {"icon": "assets/image/coupon.png", "name": "Coupon", "amount": "0.00"},
  {"icon": "assets/image/lottery.png", "name": "Lottery", "amount": "0.00"},
  {"icon": "assets/image/graphic.png", "name": "Dividents", "amount": "0.00"},
  {"icon": "assets/image/invest.png", "name": "Investment", "amount": "0.00"},
];

List staticexpenseCat = [
  {
    "icon": "assets/image/realstate.png",
    "name": jsonResult[0]['language'][locale]['p4.11'],
    "amount": "0.00"
  },
  {
    "icon": "assets/image/shopping.png",
    "name": jsonResult[0]['language'][locale]['p4.12'],
    "amount": "0.00"
  },
  {
    "icon": "assets/image/resto.png",
    "name": jsonResult[0]['language'][locale]['p6.3'],
    "amount": "0.00"
  },
];
List tempExpense = [
  {"icon": "assets/image/others.png", "name": "Other", "amount": "0.00"},
  {
    "icon": "assets/image/realstate.png",
    "name": jsonResult[0]['language'][locale]['p4.11'],
    "amount": "0.00"
  },
  {
    "icon": "assets/image/shopping.png",
    "name": jsonResult[0]['language'][locale]['p4.12'],
    "amount": "0.00"
  },
  {
    "icon": "assets/image/resto.png",
    "name": jsonResult[0]['language'][locale]['p6.3'],
    "amount": "0.00"
  },
  {"icon": "assets/image/home-run.png", "name": "Home", "amount": "0.00"},
  {"icon": "assets/image/car.png", "name": "Car", "amount": "0.00"},
  {
    "icon": "assets/image/virtual-reality.png",
    "name": "Entertainment",
    "amount": "0.00"
  },
  {"icon": "assets/image/shop.png", "name": "Shopping", "amount": "0.00"},
  {"icon": "assets/image/tax.png", "name": "Tax", "amount": "0.00"},
  {"icon": "assets/image/phone.png", "name": "Telephone", "amount": "0.00"},
  {"icon": "assets/image/smoke.png", "name": "Cigarette", "amount": "0.00"},
  {"icon": "assets/image/health.png", "name": "Health", "amount": "0.00"},
  {"icon": "assets/image/boy.png", "name": "Baby", "amount": "0.00"},
  {"icon": "assets/image/pets.png", "name": "Pet", "amount": "0.00"},

  {"icon": "assets/image/soap.png", "name": "Beauty", "amount": "0.00"},
  //
  {"icon": "assets/image/brain.png", "name": "Electronic", "amount": "0.00"},
  {"icon": "assets/image/burger.png", "name": "Hamburger", "amount": "0.00"},
  {"icon": "assets/image/wine.png", "name": "Wine", "amount": "0.00"},
  {
    "icon": "assets/image/vegetable.png",
    "name": "Vegetables",
    "amount": "0.00"
  },
  {"icon": "assets/image/snack.png", "name": "Snacks", "amount": "0.00"},
  {"icon": "assets/image/gift.png", "name": "Gift", "amount": "0.00"},
  {"icon": "assets/image/book.png", "name": "Book", "amount": "0.00"},
  {"icon": "assets/image/plane.png", "name": "Travel", "amount": "0.00"},
  {
    "icon": "assets/image/mortarboard.png",
    "name": "Education",
    "amount": "0.00"
  },
  {"icon": "assets/image/fruit.png", "name": "Fruit", "amount": "0.00"},
  {"icon": "assets/image/paper-clip.png", "name": "Office", "amount": "0.00"},
];

Map pageTitles = {
  "en": [
    jsonResult[0]['language']["en"]['p8.1'],
    jsonResult[0]['language']["en"]['p11.6'],
    jsonResult[0]['language']["en"]['p9.3'],
    jsonResult[0]['language']["en"]['p10.4'],
  ],
  "fr": [
    jsonResult[0]['language']["fr"]['p8.1'],
    jsonResult[0]['language']["fr"]['p11.6'],
    jsonResult[0]['language']["fr"]['p9.3'],
    jsonResult[0]['language']["fr"]['p10.4'],
  ]
};

List currencyList = [
  "\$(USD)",
  "€(EUR)",
];

Map period = {
  "en": [
    jsonResult[0]['language']["en"]['p7.2'],
    jsonResult[0]['language']["en"]['p7.3'],
    jsonResult[0]['language']["en"]['p7.4'],
    jsonResult[0]['language']["en"]['p7.5'],
    jsonResult[0]['language']["en"]['p7.6']
  ],
  "fr": [
    jsonResult[0]['language']["fr"]['p7.2'],
    jsonResult[0]['language']["fr"]['p7.3'],
    jsonResult[0]['language']["fr"]['p7.4'],
    jsonResult[0]['language']["fr"]['p7.5'],
    jsonResult[0]['language']["fr"]['p7.6']
  ]
};

List<String> tempPeriod1 = [
  "Monthly",
  "Weekly",
  "One-off",
  "Trimester",
  "Semester",
];

List<String> tempPeriod2 = [
  "Mensuel",
  "Hebdomadaire",
  "Sans récurrence",
  "Trimestriel",
  "Semestriel",
];

List<String> purpose = [
  jsonResult[0]['language'][locale]['p7.10'],
  jsonResult[0]['language'][locale]['p7.11']
];

List<String> tempPurpose2 = [
  "Le reporter sur la période suivante",
  "Rien, je verrais ce que je fais du solde"
];

List<String> tempPurpose1 = [
  "Save it for the next period",
  "Nothing, start a new period"
];

List bankInfo = [
  {"name": "PNB Bank", "icon": "assets/image/bank.png"},
  {"name": "Paypal", "icon": "assets/image/paypal.png"},
  {"name": "Cash", "icon": "assets/image/cash2.png"},
];

List tempbankInfo = [
  {"name": "PNB BANK", "icon": "assets/image/bank.png"},
  {"name": "PAYPAL", "icon": "assets/image/paypal.png"},
  {"name": "CASH", "icon": "assets/image/cash2.png"},
];

List icons = [
  {
    "icon": "assets/images/bank.png",
    "icon_url":
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHHKGtFkEN0IFc0iFxrl3vnFi4ABYmevgKeHulMM16asD_4_t1"
  },
  {
    "icon": "assets/images/paypal.png",
    "icon_url":
        "data:image/png;base64,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"
  },
  {
    "icon": "assets/images/cash.png",
    "icon_url":
        "data:image/png;base64,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"
  }
];

List allWeekExpireDate = [
  DateTime.parse(selectedBudget['created_at']).add(
      Duration(days: 8 - DateTime.parse(selectedBudget['created_at']).weekday)),
  for (var x = 7; x <= 7 * 13; x += 7)
    DateTime.parse(selectedBudget['created_at'])
        .add(Duration(
            days: 8 - DateTime.parse(selectedBudget['created_at']).weekday))
        .add(Duration(days: x)),
];
List allStartWeekDate = [
  DateTime.parse(selectedBudget['created_at']),
  DateTime.parse(selectedBudget['created_at']).add(
      Duration(days: 8 - DateTime.parse(selectedBudget['created_at']).weekday)),
  for (var x = 7; x <= 7 * 12; x += 7)
    DateTime.parse(selectedBudget['created_at'])
        .add(Duration(
            days: 8 - DateTime.parse(selectedBudget['created_at']).weekday))
        .add(Duration(days: x)),
];

List allExpectedDays = [
  for (var x = 1; x <= 30; x++)
    DateTime.parse(selectedBudget['created_at']).add(Duration(days: x)),
];

