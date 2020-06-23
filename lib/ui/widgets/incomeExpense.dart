
import 'package:flutter/material.dart';
import 'package:myassistantv2/core/global/variables.dart';
import 'package:myassistantv2/ui/pages/settings/category/listofCategory.dart';
import 'package:theme_provider/theme_provider.dart';


class IncomeExpense extends StatefulWidget {
  @override
  _IncomeExpenseState createState() => _IncomeExpenseState();
}

class _IncomeExpenseState extends State<IncomeExpense> {
  var selectedCategory = 2;
  var selectedCatValue;
  var listCategory = ["Expense", "Income"];
  var defaultIncome = [];
  var defaultExpense = [];
  List tempCategory = [];

  passData(){
   setState(() {
      for(var category in allIncomeExpense){
      if(category['amount'] == 0){
        if(category['type'] == 2){
          defaultExpense.add(category);
        }else{
          defaultIncome.add(category);
        }
      }
    }
   });
  }

  Stream categoryAdded() async*{
    setState(() {
      tempCategory = defaultCategory;
    });
    yield tempCategory;
  }

  @override
  void initState() {
    passData();
   setState(() {
      if(selectedCategory == 2){
      defaultCategory= defaultExpense;
    }else{
      defaultCategory = defaultIncome;
    }
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
                              value: selectedCategory == 2? listCategory[0] : listCategory[1],
                              hint: Text(""),
                              items: listCategory.map((String per) {
                                return DropdownMenuItem<String>(
                                  child: Text(per),
                                  value: per,
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val == "Expense") {
                                  setState(() {
                                    selectedCategory = 2;
                                    defaultCategory = defaultExpense;
                                  });
                                } else {
                                  setState(() {
                                    selectedCategory = 1;
                                     defaultCategory = defaultIncome;
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
                          width: scrW,
                          height: scrH,
                      child: ListView(
                        children: <Widget>[
                          Wrap(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.start,
                              children: <Widget>[
                                for (var category in defaultCategory)
                                StreamBuilder<Object>(
                                  stream: categoryAdded(),
                                  builder: (context, snapshot) {
                                    return Container(
                                      padding: EdgeInsets.all(10),
                                        width: 73,
                                        height: 73,
                                        child: Center(
                                          child: Column(
                                            children: <Widget>[
                                              Image.asset(category['icon'], width: 25,color: Colors.grey,),
                                              Text(category['name'], 
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                
                                              ),)
                                            ],
                                          ),
                                        ),
                                    );
                                  }
                                ),

                                GestureDetector(
                                  onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ListOfCategory(selectedCategory)));
                                  },
                                                                child: Container(
                                    padding: EdgeInsets.all(10),
                                      width: 73,
                                      height: 73,
                                      child: Center(
                                        child: Column(
                                          children: <Widget>[
                                            Icon(Icons.add_circle_outline, size: 25,color: Colors.grey,),
                                            Text('Add', 
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                            ),)
                                          ],
                                        ),
                                      ),
                                  ),
                                )
                              ],
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
