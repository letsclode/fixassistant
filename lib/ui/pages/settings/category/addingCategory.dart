
import 'package:flutter/material.dart';
import 'package:myassistantv2/core/global/variables.dart';
import 'package:theme_provider/theme_provider.dart';
class AddingCategory extends StatefulWidget {
  @override
  _AddingCategoryState createState() => _AddingCategoryState();
}

class _AddingCategoryState extends State<AddingCategory> {
  var selectedCategory = 2;
  var selectedCatValue;
  var listCategory = ["Expense", "Income"];

  var presentList; 

  @override
  void initState() {
    setState(() {
      presentList = selectedCategory == 2 ? expenseList : incomeList;
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
          child: Scaffold(
        body: SafeArea(
          child: Container(
            width: scrW,
            height: scrH,
            padding: EdgeInsets.all(20),
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: scrW / 4,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              icon: Icon(
                                Icons.expand_more,
                              ),
                              style: TextStyle(
                                  color: ThemeProvider.themeOf(context).id == 'dark'
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: scrW / 25),
                              isExpanded: true,
                              value: selectedCategory == 2? "Expense" : "Income",
                              hint: Text(""),
                              items: listCategory.map((String per) {
                                return DropdownMenuItem<String>(
                                  child: Text(per),
                                  value: per,
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val == 2) {
                                  setState(() {
                                    selectedCategory = val;
                                    presentList = tempExpense;
                                  
                                  });
                                } else {
                                  setState(() {
                                    selectedCategory = val;
                                    presentList = tempIncome;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        Expanded(child: Container()),
                        GestureDetector(
                          onTap: () {
                           
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: scrW / 7,
                            height: scrH / 23,
                            child: Center(
                                child: Text(
                              jsonResult[0]['language'][locale]['p7.14'],
                              style: TextStyle(
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.bold,
                                  fontSize: scrW / 25),
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
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                        child: Container(
                      child: ListView(
                        children: <Widget>[
                          Center(
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              children: <Widget>[
                                for (var x = 0; x < incomeList.length; x++)
                                 GestureDetector(
                                    onTap: () {
                                     setState(() {
                                       if(selectedCategory == 2){}
                                        addRecStat = true;
                                        selectedCatValue = presentList[x];
                                     });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      width: 73,
                                      height: 73,
                                      child: Column(
                                        children: <Widget>[
                                          Image.asset(
                                            presentList[x]['icon'],
                                            width: 30,
                                            color:
                                                ThemeProvider.themeOf(context).id ==
                                                        'dark'
                                                    ? Colors.white
                                                    : Colors.grey[800],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            presentList[x]['name'],
                                            style: TextStyle(
                                                fontSize: scrW / 42,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                GestureDetector(
                                  onTap: () {
                                    
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 10),
                                    width: 73,
                                    height: 73,
                                    child: Column(
                                      children: <Widget>[
                                        Icon(
                                          Icons.add_circle_outline,
                                          size: 35,
                                          color: ThemeProvider.themeOf(context).id ==
                                                  'dark'
                                              ? Colors.white
                                              : Colors.grey,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "dae",
                                          style: TextStyle(
                                              fontSize: scrW / 42,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
