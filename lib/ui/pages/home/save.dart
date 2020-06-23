// GestureDetector(
//                     onTap: () {
//                       showAddIncome(2);
//                     },
//                     child: Container(
//                       child: DottedBorder(
//                           dashPattern: [10],
//                           color: Colors.grey,
//                           strokeWidth: 1,
//                           child: Container(
//                             width: scrW / 2.5,
//                             height: scrH / 15,
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: <Widget>[
//                                   Icon(
//                                     Icons.add_circle_outline,
//                                     color: Colors.grey,
//                                     size: 30,
//                                   ),
//                                   SizedBox(width: 3),
//                                   Text(
//                                     jsonResult[0]['language'][locale]['p6.1'],
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                         color: Colors.grey[400],
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: scrW / 25),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           )),
//                     ),
//                   )

// void showAddIncome(category) {
//     showGeneralDialog(
//         barrierColor: Colors.white.withOpacity(0.5),
//         transitionBuilder: (context, a1, a2, widget) {
//           return Align(
//             alignment: Alignment.bottomCenter,
//             child: Transform.scale(
//               scale: a1.value,
//               child: Opacity(
//                 opacity: a1.value,
//                 child: AlertDialog(
//                     backgroundColor: Colors.transparent,
//                     contentPadding: EdgeInsets.all(0),
//                     content: BackdropFilter(
//                       filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
//                       child: Container(
//                         height: scrH / 2.7,
//                         padding: EdgeInsets.all(20),
//                         decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12)),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: <Widget>[
//                             Expanded(
//                                 child: Container(
//                                     child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: <Widget>[
//                                 Text(
//                                   category == 1
//                                       ? jsonResult[0]['language'][locale]
//                                               ['p5.6'] +
//                                           " " +
//                                           jsonResult[0]['language'][locale]
//                                               ['p4.6']
//                                       : jsonResult[0]['language'][locale]
//                                               ['p6.1'] +
//                                           " " +
//                                           jsonResult[0]['language'][locale]
//                                               ['p4.6'],
//                                   style: TextStyle(
//                                       color: Colors.black54,
//                                       fontSize: scrW / 15),
//                                 ),
//                                 SizedBox(
//                                   height: 20,
//                                 ),
//                                 Row(
//                                   children: <Widget>[
//                                     Container(
//                                       width: scrW / 2.2,
//                                       height: 60,
//                                       padding: EdgeInsets.all(8),
//                                       decoration: BoxDecoration(
//                                           border: Border.all(
//                                             width: 1,
//                                             color: Colors.grey,
//                                           ),
//                                           borderRadius:
//                                               BorderRadius.circular(10)),
//                                       child: TextField(
//                                         controller: category == 1
//                                             ? incomeName
//                                             : expenseName,
//                                         decoration: InputDecoration.collapsed(
//                                             hintText: jsonResult[0]['language']
//                                                 [locale]['p4.8'],
//                                             hintStyle: TextStyle(
//                                                 color: Colors.grey[300])),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 15,
//                                     ),
//                                     Expanded(
//                                         child: AnimatedContainer(
//                                       padding:
//                                           EdgeInsets.symmetric(horizontal: 2),
//                                       decoration: BoxDecoration(
//                                           color: ThemeProvider.themeOf(context)
//                                                       .id ==
//                                                   'dark'
//                                               ? Color.fromRGBO(37, 52, 65, 1)
//                                               : Color.fromRGBO(
//                                                   241, 243, 246, 1),
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                           boxShadow: [
//                                             BoxShadow(
//                                                 color: ThemeProvider.themeOf(
//                                                                 context)
//                                                             .id ==
//                                                         'dark'
//                                                     ? Colors.white12
//                                                     : Colors.white,
//                                                 blurRadius: 3,
//                                                 offset: Offset(-7, -7)),
//                                             BoxShadow(
//                                                 color: Colors.black12,
//                                                 blurRadius: 10,
//                                                 offset: Offset(8, 8))
//                                           ]),
//                                       duration: Duration(milliseconds: 500),
//                                       width: scrW / 1.6,
//                                       height: 60,
//                                       child: DropdownButtonHideUnderline(
//                                         child: DropdownButton(
//                                           icon: Icon(Icons.arrow_drop_down),
//                                           style: TextStyle(
//                                               color:
//                                                   ThemeProvider.themeOf(context)
//                                                               .id ==
//                                                           'dark'
//                                                       ? Colors.white
//                                                       : Colors.black,
//                                               fontSize: 17),
//                                           isExpanded: true,
//                                           value: category == 1
//                                               ? iconUrl
//                                               : iconUrl2,
//                                           onChanged: (newCurr) {
//                                             setState(() {
//                                               if (category == 1) {
//                                                 iconUrl = newCurr.toString();
//                                               } else {
//                                                 iconUrl2 = newCurr.toString();
//                                               }
//                                             });
//                                           },
//                                           items: category == 1
//                                               ? tempIncome.map((dynamic bank) {
//                                                   return DropdownMenuItem<
//                                                       dynamic>(
//                                                     child: Container(
//                                                         padding:
//                                                             EdgeInsets.all(4),
//                                                         width: 50,
//                                                         height: 50,
//                                                         child: Image.asset(
//                                                           bank['icon'],
//                                                           color: Colors.grey,
//                                                           width: 10,
//                                                           height: 10,
//                                                         )),
//                                                     value: bank['icon'],
//                                                   );
//                                                 }).toList()
//                                               : tempExpense.map((dynamic bank) {
//                                                   return DropdownMenuItem<
//                                                       dynamic>(
//                                                     child: Container(
//                                                         padding:
//                                                             EdgeInsets.all(4),
//                                                         width: 50,
//                                                         height: 50,
//                                                         child: Image.asset(
//                                                           bank['icon'],
//                                                           color: Colors.grey,
//                                                           width: 10,
//                                                           height: 10,
//                                                         )),
//                                                     value: bank['icon'],
//                                                   );
//                                                 }).toList(),
//                                         ),
//                                       ),
//                                     ))
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 20,
//                                 ),
//                               ],
//                             ))),
//                             GestureDetector(
//                               onTap: () {
//                                 //tap
//                                 setState(() {
//                                   if (category == 1) {
//                                     addIncome(incomeName.text,iconUrl);
//                                     _addEI(
//                                         incomeName.text,
//                                         iconUrl,
//                                         selectedBudget['id'].toString(),
//                                         "0.00",
//                                         1,
//                                         typeOf,
//                                         recurrent);
//                                     totalIncome += double.parse(incomeVal.text);

//                                     Navigator.pop(context);
//                                   } else {
//                                     addExpense(expenseName.text,iconUrl2);
//                                     _addEI(
//                                         expenseName.text,
//                                         iconUrl2,
//                                         selectedBudget['id'].toString(),
//                                         "0.00",
//                                         2,
//                                         typeOf,
//                                         recurrent);
//                                     totalExpense +=
//                                         double.parse(expenseVal.text);

//                                     Navigator.pop(context);
//                                   }
//                                 });
//                               },
//                               child: Container(
//                                   width: scrW,
//                                   padding: EdgeInsets.symmetric(horizontal: 20),
//                                   height: 60,
//                                   decoration: BoxDecoration(
//                                       color: ThemeProvider.themeOf(context)
//                                                   .id ==
//                                               'dark'
//                                           ? Color.fromRGBO(37, 52, 65, 1)
//                                           : Color.fromRGBO(241, 243, 246, 1),
//                                       borderRadius: BorderRadius.circular(10),
//                                       boxShadow: [
//                                         BoxShadow(
//                                             color:
//                                                 ThemeProvider.themeOf(context)
//                                                             .id ==
//                                                         'dark'
//                                                     ? Colors.white12
//                                                     : Colors.white,
//                                             blurRadius: 7,
//                                             offset: Offset(-8, -8)),
//                                         BoxShadow(
//                                             color: Colors.black12,
//                                             blurRadius: 10,
//                                             offset: Offset(8, 8))
//                                       ]),
//                                   child: Center(
//                                       child: Text(
//                                     jsonResult[0]['language'][locale]['p4.9'],
//                                     style: TextStyle(
//                                         color:
//                                             ThemeProvider.themeOf(context).id ==
//                                                     'dark'
//                                                 ? Colors.tealAccent
//                                                 : Colors.black),
//                                   ))),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )),
//               ),
//             ),
//           );
//         },
//         transitionDuration: Duration(milliseconds: 200),
//         barrierDismissible: true,
//         barrierLabel: '',
//         context: context,
//         pageBuilder: (context, a1, a2) {});
//   }


//Recurrent drag
 // Column(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: <Widget>[
                              //     GestureDetector(
                              //       onTap: () {
                              //         setState(() {});
                              //       },
                              //       child: Container(
                              //         margin: EdgeInsets.only(top: 10, left: 5),
                              //         child: DottedBorder(
                              //             dashPattern: [10],
                              //             color: Colors.grey,
                              //             strokeWidth: 1,
                              //             child: Container(
                              //               width: scrW / 3.8,
                              //               height: scrH / 9,
                              //               child: Center(
                              //                 child: Row(
                              //                   mainAxisAlignment:
                              //                       MainAxisAlignment.center,
                              //                   children: <Widget>[
                              //                     Icon(
                              //                       Icons.add_circle_outline,
                              //                       color: Colors.grey,
                              //                       size: 30,
                              //                     ),
                              //                     SizedBox(width: 3),
                              //                     Text(
                              //                       jsonResult[0]['language']
                              //                           [locale]['p5.6'],
                              //                       overflow:
                              //                           TextOverflow.ellipsis,
                              //                       style: TextStyle(
                              //                           color: Colors.grey[400],
                              //                           fontWeight:
                              //                               FontWeight.bold,
                              //                           fontSize: scrW / 25),
                              //                     )
                              //                   ],
                              //                 ),
                              //               ),
                              //             )),
                              //       ),
                              //     )
                              //   ],
                              // ),

                               // Expanded(
                          //   child: Container(
                          //     child: ListView(
                          //       children: <Widget>[
                          //         for (var x = 0;
                          //             x < allIncomeExpense.length;
                          //             x++)
                          //           allIncomeExpense[x]['type'] == 2
                          //               ? LongPressDraggable(
                          //                   onDraggableCanceled: (x, y) {
                          //                     print("Drag Cancelled");
                          //                     setState(() {
                          //                       showBin = false;
                          //                     });
                          //                   },
                          //                   onDragStarted: () {
                          //                     setState(() {
                          //                       showBin = true;
                          //                     });
                          //                   },
                          //                   childWhenDragging: Container(),
                          //                   feedback: Container(
                          //                     margin: EdgeInsets.symmetric(
                          //                         vertical: 5, horizontal: 5),
                          //                     padding: EdgeInsets.all(10),
                          //                     width: scrW / 2.4 + 30,
                          //                     height: scrH / 12 + 30,
                          //                     child: Scaffold(
                          //                       backgroundColor:
                          //                           Colors.transparent,
                          //                       body: Container(
                          //                         decoration: BoxDecoration(
                          //                             borderRadius:
                          //                                 BorderRadius.circular(
                          //                                     10),
                          //                             border: Border.all(
                          //                                 color: ThemeProvider.themeOf(
                          //                                                 context)
                          //                                             .id ==
                          //                                         'dark'
                          //                                     ? Colors.grey
                          //                                     : Colors.grey,
                          //                                 width: 1)),
                          //                         margin: EdgeInsets.symmetric(
                          //                             vertical: 5,
                          //                             horizontal: 5),
                          //                         padding: EdgeInsets.all(10),
                          //                         width: scrW / 2.4,
                          //                         height: scrH / 12,
                          //                         child: Column(
                          //                           crossAxisAlignment:
                          //                               CrossAxisAlignment
                          //                                   .start,
                          //                           mainAxisAlignment:
                          //                               MainAxisAlignment
                          //                                   .spaceBetween,
                          //                           children: <Widget>[
                          //                             Row(
                          //                               mainAxisAlignment:
                          //                                   MainAxisAlignment
                          //                                       .spaceBetween,
                          //                               children: <Widget>[
                          //                                 Image.asset(
                          //                                     allIncomeExpense[
                          //                                         x]['icon'],
                          //                                     width: scrW / 20),
                          //                                 Text(
                          //                                   allIncomeExpense[x][
                          //                                               'amount']
                          //                                           .toStringAsFixed(
                          //                                               2) +
                          //                                       (selectedBudget["currency"]
                          //                                                   [
                          //                                                   'name'] ==
                          //                                               "usd"
                          //                                           ? currencyList[
                          //                                               0][0]
                          //                                           : currencyList[
                          //                                               1][0]),
                          //                                   style: TextStyle(
                          //                                       fontSize:
                          //                                           scrW / 25),
                          //                                 )
                          //                               ],
                          //                             ),
                          //                             Text(
                          //                               allIncomeExpense[x]
                          //                                   ['name'],
                          //                               style: TextStyle(
                          //                                   fontSize:
                          //                                       scrW / 25),
                          //                             )
                          //                           ],
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ),
                          //                   data: (x.toString() +
                          //                       " " +
                          //                       allIncomeExpense[x]['id']
                          //                           .toString()),
                          //                   child: GestureDetector(
                          //                     onTap: () {
                          //                       setState(() {
                          //                         index = x;
                          //                         addStat = true;
                          //                       });
                          //                     },
                          //                     child: Container(
                          //                       decoration: BoxDecoration(
                          //                           borderRadius:
                          //                               BorderRadius.circular(
                          //                                   10),
                          //                           border: Border.all(
                          //                               color: ThemeProvider.themeOf(
                          //                                               context)
                          //                                           .id ==
                          //                                       'dark'
                          //                                   ? Colors.grey
                          //                                   : Colors.grey[400],
                          //                               width: 1)),
                          //                       margin: EdgeInsets.symmetric(
                          //                           vertical: 5, horizontal: 5),
                          //                       padding: EdgeInsets.all(10),
                          //                       width: scrW / 2.4,
                          //                       height: scrH / 12,
                          //                       child: Column(
                          //                         crossAxisAlignment:
                          //                             CrossAxisAlignment.start,
                          //                         mainAxisAlignment:
                          //                             MainAxisAlignment
                          //                                 .spaceBetween,
                          //                         children: <Widget>[
                          //                           Row(
                          //                             mainAxisAlignment:
                          //                                 MainAxisAlignment
                          //                                     .spaceBetween,
                          //                             children: <Widget>[
                          //                               Image.asset(
                          //                                 allIncomeExpense[x]
                          //                                     ['icon'],
                          //                                 width: scrW / 20,
                          //                               ),
                          //                               Text(
                          //                                 allIncomeExpense[x]
                          //                                             ['amount']
                          //                                         .toStringAsFixed(
                          //                                             2) +
                          //                                     (selectedBudget["currency"]
                          //                                                 [
                          //                                                 'name'] ==
                          //                                             "usd"
                          //                                         ? currencyList[
                          //                                             0][0]
                          //                                         : currencyList[
                          //                                             1][0]),
                          //                                 style: TextStyle(
                          //                                     fontSize:
                          //                                         scrW / 25),
                          //                               )
                          //                             ],
                          //                           ),
                          //                           Row(
                          //                             mainAxisAlignment:
                          //                                 MainAxisAlignment
                          //                                     .spaceBetween,
                          //                             children: <Widget>[
                          //                               Text(
                          //                                 allIncomeExpense[x]
                          //                                     ['name'],
                          //                                 style: TextStyle(
                          //                                     fontSize:
                          //                                         scrW / 25),
                          //                               ),
                          //                               Container(
                          //                                 width: 13,
                          //                                 height: 13,
                          //                                 decoration: BoxDecoration(
                          //                                     color: Colors.red,
                          //                                     borderRadius:
                          //                                         BorderRadius
                          //                                             .circular(
                          //                                                 100)),
                          //                               ),
                          //                             ],
                          //                           )
                          //                         ],
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 )
                          //               : Container(),
                          //       ],
                          //     ),
                          //   ),
                          // ),