// 241,243,246)
// ThemeProvider.themeOf(context).id == 'dark'
// SizedBox(height: 20,),
//          Container(
//                       width: scrW / 1,
//                       height: scrH/6,
//                       child: AnimatedContainer(
//                           decoration: BoxDecoration(
//                               color: !dark
//                                   ? Color.fromRGBO(37, 52, 65, 1)
//                                   : Colors.grey[200],
//                               borderRadius: BorderRadius.circular(10),
//                               boxShadow: [
//                                 BoxShadow(
//                                     color:
//                                         !dark ? Colors.white12 : Colors.white,
//                                     blurRadius: 10,
//                                     offset: Offset(-7, -7)),
//                                 BoxShadow(
//                                     color: Colors.black12,
//                                     blurRadius: 10,
//                                     offset: Offset(8, 8))
//                               ]),
//                           duration: Duration(milliseconds: 500),
//                           width: scrW / 1.6,
//                           height: 60,
//                           child: Center(
//                               child: Text(
//                             "PERIOD",
//                             style: TextStyle(
//                                 color: dark ? Colors.black : Colors.tealAccent),
//                           )))),

// DottedBorder(
//                                 dashPattern: [10],
//                                 color: Colors.grey,
//                                 strokeWidth: 1,
//                                 child: Container(
//                                   child: Center(
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: <Widget>[
//                                         Icon(
//                                           Icons.add_circle_outline,
//                                           color: Colors.grey,
//                                           size: 30,
//                                         ),
//                                         SizedBox(width: 10),
//                                         Text(
//                                           "Income",
//                                           style: TextStyle(
//                                               color: Colors.grey[400],
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 20),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ))