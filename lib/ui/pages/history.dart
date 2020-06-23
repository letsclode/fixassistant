import 'package:flutter/material.dart';
import 'package:myassistantv2/core/global/variables.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  DateTime _initDate = DateTime.now();
  DateTime _selectedValue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "History",
                      style: TextStyle(
                          color: ThemeProvider.themeOf(context).id == 'dark'
                              ? Colors.tealAccent
                              : secColor,
                          fontSize: scrW / 18,
                          fontWeight: FontWeight.bold),
                    ),
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
                                  color: ThemeProvider.themeOf(context).id ==
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
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today),
                        SizedBox(width: 10,),
                        Text("MARCH 2020"),
                      ],
                    ),
                    Text("-451.05 \$")
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: scrW,
                  height: scrH / 8,
                  child: DatePicker(
                    _initDate,
                    
                    width: 60,
                    height: 80,
                    initialSelectedDate: _initDate,
                    selectionColor: ThemeProvider.themeOf(context).id == 'dark'
                        ? Colors.black45
                        : Colors.black12,
                    selectedTextColor:
                        ThemeProvider.themeOf(context).id == 'dark'
                            ? Colors.white
                            : Colors.black,
                    onDateChange: (date) {
                      setState(() {
                        _selectedValue = date;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                Text(
                  "FUTURE",
                  style: TextStyle(color: Colors.grey, fontSize: scrW / 35),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "-1473.86\$",
                  style: TextStyle(
                      color: ThemeProvider.themeOf(context).id == 'dark'
                          ? Colors.white
                          : Colors.black,
                      fontSize: scrW / 20),
                ),

                SizedBox(
                  height: 10,
                ),

                //history

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "APR 2020",
                        style: TextStyle(color: Colors.grey, fontSize: scrW / 30),
                      ),
                      Text(
                        "-1473.86\$",
                        style: TextStyle(
                            color: ThemeProvider.themeOf(context).id == 'dark'
                                ? Colors.white
                                : Colors.black,
                            fontSize: scrW / 20),
                      ),
                    ],
                  ),
                ),
                 SizedBox(
                  height: 30,
                ),

                Text(
                  "HISTORY",
                  style: TextStyle(color: Colors.grey, fontSize: scrW / 35),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "-1473.86\$",
                  style: TextStyle(
                      color: ThemeProvider.themeOf(context).id == 'dark'
                          ? Colors.white
                          : Colors.black,
                      fontSize: scrW / 20),
                ),
 SizedBox(
                  height: 10,
                ),

                //history
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "APR 2020",
                        style: TextStyle(color: Colors.grey, fontSize: scrW / 30),
                      ),
                      Text(
                        "-1473.86\$",
                        style: TextStyle(
                            color: ThemeProvider.themeOf(context).id == 'dark'
                                ? Colors.white
                                : Colors.black,
                            fontSize: scrW / 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
