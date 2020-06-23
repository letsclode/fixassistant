import 'package:flutter/material.dart';
import 'package:myassistantv2/core/global/variables.dart';
import 'package:myassistantv2/ui/pages/recurrents/expense_recurrent.dart';
import 'package:myassistantv2/ui/pages/recurrents/income_recurrent.dart';
import 'package:theme_provider/theme_provider.dart';

class Recurrent extends StatefulWidget {
  @override
  _RecurrentState createState() => _RecurrentState();
}

class _RecurrentState extends State<Recurrent> {
  PageController controllerPage = PageController();
  int currentIndex = 1;

  @override
  void dispose() {
    showExpense = false;
    showIncome = false;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
              child: Container(
                  child: PageView(
            controller: controllerPage,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index + 1;
                    showExpense = false;
    showIncome = false;
              });
            },
            children: <Widget>[
              IncomeRecurrent(),
              ExpenseRecurrent(),
            ],
          ))),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 40,
            ),
            width: scrW / 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                for (var x = 0; x < 2; x++)
                  AnimatedContainer(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: currentIndex == x + 1
                            ? ThemeProvider.themeOf(context).id == 'dark'
                                ? Colors.tealAccent
                                : Color.fromRGBO(0, 128, 225, 1)
                            : Colors.black26,
                      ),
                      width: 15,
                      height: 15,
                      duration: Duration(milliseconds: 500))
              ],
            ),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
