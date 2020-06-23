import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myassistantv2/core/global/variables.dart';
import 'package:myassistantv2/ui/pages/methods/add.dart';
import 'package:theme_provider/theme_provider.dart';

class ListOfCategory extends StatefulWidget {
  final categorySelected;
  ListOfCategory(this.categorySelected);
  @override
  _ListOfCategoryState createState() => _ListOfCategoryState();
}

class _ListOfCategoryState extends State<ListOfCategory> {
  var selectedCatValue;
  var presentList = tempExpense;
  var selectedList;

  @override
  void initState() {
    setState(() {
      if (widget.categorySelected == 2) {
        selectedList = tempExpense;
      } else {
        selectedList = tempIncome;
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
                                color:
                                    ThemeProvider.themeOf(context).id == 'dark'
                                        ? Color.fromRGBO(37, 52, 65, 1)
                                        : Colors.grey[100],
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          ThemeProvider.themeOf(context).id ==
                                                  'dark'
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
                                for (var category in selectedList)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        defaultCategory.add(category);
                                      });

                                      addEI(
                                          category['name'],
                                          category['icon'],
                                          selectedBudget['id'],
                                          category['amount'],
                                          widget.categorySelected);

                                      Fluttertoast.showToast(
                                          msg: "Successfully Added");
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      width: 73,
                                      height: 73,
                                      child: Center(
                                        child: Column(
                                          children: <Widget>[
                                            Image.asset(
                                              category['icon'],
                                              width: 25,
                                              color: Colors.grey,
                                            ),
                                            Text(
                                              category['name'],
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                // GestureDetector(
                                //   onTap: () {
                                //     showAddCustomizeCat(widget.categorySelected);
                                //   },
                                //   child: Container(
                                //     margin: EdgeInsets.symmetric(horizontal: 10),
                                //     width: 73,
                                //     height: 73,
                                //     child: Column(
                                //       children: <Widget>[
                                //         Icon(
                                //           Icons.add_circle_outline,
                                //           size: 35,
                                //           color:
                                //               ThemeProvider.themeOf(context).id ==
                                //                       'dark'
                                //                   ? Colors.white
                                //                   : Colors.grey,
                                //         ),
                                //         SizedBox(
                                //           height: 5,
                                //         ),
                                //         Text(
                                //           "Add",
                                //           style: TextStyle(
                                //               fontSize: scrW / 42,
                                //               fontWeight: FontWeight.bold),
                                //         )
                                //       ],
                                //     ),
                                //   ),
                                // ),
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
