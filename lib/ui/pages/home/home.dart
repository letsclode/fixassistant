import 'package:flutter/material.dart';
import 'package:myassistantv2/core/global/variables.dart';
import 'package:myassistantv2/ui/pages/home/budgetList.dart';
import 'package:myassistantv2/ui/pages/home/budgetStatus.dart';
import 'package:myassistantv2/ui/pages/methods/add.dart';
import 'package:myassistantv2/ui/pages/recurrents/recurrent.dart';
import 'package:myassistantv2/ui/pages/settings/settings.dart';
import 'package:theme_provider/theme_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _pages = [BudgetList(), Recurrent(), BudgetStatus(), Settings()];
  
  @override
  void initState() {
   if (budget.length != 0) {
      setState(() {
        allIncomeExpense = budget[activeBudget]['incomeexpense_categories'];
        selectedBudget = budget[activeBudget];
        selectedDate = selectedBudget['created_at'].toString().split(" ")[0];
      });
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
          body: SafeArea(
              child: Container(
            padding: EdgeInsets.all(10),
            width: scrW,
            height: scrH - 100,
            child: _pages[homeIndex],
          )),
          bottomSheet: BottomNavigationBar(
            
              currentIndex: homeIndex,
              onTap: (int index) {
                setState(() {
                  if (index != 0 && budget.length == 0) {
                    if(index == 3){
                      homeIndex = index;
                    }else{

                    noBudget(context);
                    }
                  } else {
                    homeIndex = index;
                  }
                });
              },
              items: [
                BottomNavigationBarItem(
                    icon: Image.asset('assets/image/budget.png',
                        width: 25, color: Colors.grey),
                    activeIcon: Image.asset(
                      'assets/image/budget.png',
                      width: 25,
                      color: Colors.blue,
                    ),
                    title: Text(r'')),
                BottomNavigationBarItem(
                    icon: Image.asset('assets/image/recurrent.png',
                        width: 30, color: Colors.grey),
                    activeIcon: Image.asset(
                      'assets/image/recurrent.png',
                      width: 30,
                      color: Colors.blue,
                    ),
                    title: Text('')),
                BottomNavigationBarItem(
                    icon: Image.asset('assets/image/wallet.png',
                        color: Colors.grey),
                    activeIcon: Image.asset(
                      'assets/image/wallet.png',
                      color: Colors.blue,
                    ),
                    title: Text('')),
                BottomNavigationBarItem(
                    icon: Image.asset('assets/image/ic-media-mixer.png',
                        color: Colors.grey),
                    activeIcon: Image.asset(
                      'assets/image/ic-media-mixer.png',
                      color: Colors.blue,
                    ),
                    title: Text(''))
              ])),
    );
  }
}
