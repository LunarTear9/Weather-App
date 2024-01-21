// ignore: file_names
// ignore_for_file: prefer_const_constructors, deprecated_member_use, sort_child_properties_last

import 'package:weather/ShowCheckBox.dart';
import 'package:weather/ShowStats.dart';
import 'package:weather/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

TimeOfDay selectedTime = TimeOfDay.now();
int sex = 0;
String changeTime = "Change Time";
String selectTime = "Select a time";
String okay = "ok";
String cancel = "cancel";
bool ContainerVisible = true;
bool ContainerVisible2 = true;
bool ContainerVisible3 = true;

class SecondScreen extends StatefulWidget {
  @override
  SecondScreenState createState() => SecondScreenState();
}

int hourindex = 1;

class SecondScreenState extends State<SecondScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    okay = okay0;
    cancel = cancel0;
    changeTime = changeTime0;
    selectTime = selectTime0;
  }

  void changeMode() {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          timePickerTheme: _timePickerTheme,
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.orange),
              overlayColor:
                  MaterialStateColor.resolveWith((states) => Colors.deepOrange),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                color: nightflag,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back)),
            actions: [
              IconButton(
                  color: nightflag,
                  onPressed: () {
                    StatsWindowState().showPopup2(context);
                  },
                  icon: Icon(Icons.assessment)),
              IconButton(
                  color: nightflag,
                  onPressed: () {
                    showPopup3(context);
                  },
                  icon: Icon(Icons.remove_red_eye))
            ],
            backgroundColor: colors2,
            title: Text(
              '$currentDay',
              style: TextStyle(color: nightflag),
            ),
          ),
          body: Center(
            child: Container(
              child: Column(
                children: [
                  Center(
                    child: Visibility(
                      visible:
                          isVisible, // Set this to the condition based on your logic
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            child: Column(
                              children: [
                                SizedBox(height: 10, width: 30),
                                Icon(
                                  CupertinoIcons.thermometer,
                                  color: nightflag,
                                  size: 60,
                                ),
                                Text(
                                  "${SecondTempMatrix[dayflag][hourindex]}°C",
                                  style: TextStyle(color: nightflag),
                                  textScaleFactor: 2,
                                )
                              ],
                            ),
                            color: colors,
                            height: 120,
                            width: 100,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible:
                        isVisible2, // Set this to the condition based on your logic
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          child: Column(
                            children: [
                              SizedBox(height: 10, width: 30),
                              Icon(
                                Icons.water,
                                size: 60,
                                color: nightflag,
                              ),
                              Text(
                                "${SecondHumMatrix[dayflag][hourindex]}%",
                                style: TextStyle(color: nightflag),
                                textScaleFactor: 2,
                              )
                            ],
                          ),
                          color: colors,
                          height: 120,
                          width: 100,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible:
                        isVisible3, // Set this to the condition based on your logic
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          child: Column(
                            children: [
                              SizedBox(height: 10, width: 30),
                              Icon(
                                CupertinoIcons.cloud_rain,
                                size: 60,
                                color: nightflag,
                              ),
                              Text(
                                "${SecondPrecMatrix[dayflag][hourindex]}%",
                                style: TextStyle(color: nightflag),
                                textScaleFactor: 2,
                              )
                            ],
                          ),
                          color: colors,
                          height: 120,
                          width: 100,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      _showTimePicker(context);
                    },
                    child: Text(
                        "${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}",
                        style: TextStyle(color: nightflag),
                        textScaleFactor: 2),
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(colors)),
                  )
                ],
              ),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/background.png"),
                      fit: BoxFit.cover)),
            ),
          ),
        ));
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
      helpText: '$selectTime', // Change help text
      confirmText: '$okay', // Change confirm button text
      cancelText: '$cancel', // Change cancel button text
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            primaryColor: nightflag, // Change primary color
            colorScheme: ColorScheme.fromSeed(
                seedColor: colors, surface: colors2, secondary: nightflag),
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: Colors.green), // Change text color
              titleMedium: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
              ), // Change subtitle color
            ),
            buttonTheme: ButtonThemeData(
              highlightColor: nightflag,
              buttonColor: Colors.white,
              textTheme: ButtonTextTheme.primary, // Change button text color
            ),
          ),
          child: child!,
        );
      },
    );

    if (timeOfDay != null) {
      setState(() {
        selectedTime = timeOfDay;
        hourindex = timeOfDay.hour;
      });
    }
  }

  void changeContainerVisible() {
    setState(() {
      ContainerVisible = isVisible;
    });
  }

  void changeContainerVisible2() {
    setState(() {
      ContainerVisible = isVisible2;
    });
  }

  void changeContainerVisible3() {
    setState(() {
      ContainerVisible = isVisible3;
    });
  }

  bool isVisible = true;
  bool isVisible2 = true;
  bool isVisible3 = true;

  Future<void> showPopup3(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              backgroundColor: colors2,
              title: Text(
                '$Show:',
                style: TextStyle(color: nightflag),
              ),
              content: Column(children: [
                Row(children: [
                  Text(
                    '  $Temperature:   ',
                    style: TextStyle(color: nightflag),
                  ),
                  Switch(
                      activeColor: nightflag,
                      value: isVisible,
                      onChanged: (value) {
                        setState(() {
                          isVisible = value;
                          changeContainerVisible();
                        });
                      })
                ]),
                Row(children: [
                  Text(
                    '  $Humidity:         ',
                    style: TextStyle(color: nightflag),
                  ),
                  Switch(
                      activeColor: nightflag,
                      value: isVisible2,
                      onChanged: (value) {
                        setState(() {
                          isVisible2 = value;
                          changeContainerVisible2();
                        });
                      })
                ]),
                Row(children: [
                  Text(
                    '  $Precipitation:     ',
                    style: TextStyle(fontSize: 15, color: nightflag),
                  ),
                  Switch(
                      activeColor: nightflag,
                      value: isVisible3,
                      onChanged: (value) {
                        setState(() {
                          isVisible3 = value;
                          changeContainerVisible3();
                        });
                      })
                ])
              ]),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the pop-up
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(color: nightflag),
                  ),
                ),
              ],
            ).animate().slideX(
                curve: Curves.bounceOut, duration: Duration(milliseconds: 500));
          },
        );
      },
    );
  }
}

void openSecondScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SecondScreen()),
  );
}

final _timePickerTheme = TimePickerThemeData(
  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
  hourMinuteShape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    side: BorderSide(color: Colors.orange, width: 4),
  ),
  dayPeriodBorderSide: const BorderSide(color: Colors.orange, width: 4),
  dayPeriodColor: const Color.fromARGB(255, 255, 255, 255),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    side: BorderSide(color: Colors.orange, width: 4),
  ),
  dayPeriodTextColor: Colors.white,
  dayPeriodShape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    side: BorderSide(color: Colors.orange, width: 4),
  ),
  hourMinuteColor: MaterialStateColor.resolveWith((states) =>
      states.contains(MaterialState.selected)
          ? Colors.orange
          : const Color.fromARGB(255, 255, 255, 255)),
  hourMinuteTextColor: MaterialStateColor.resolveWith((states) =>
      states.contains(MaterialState.selected) ? Colors.white : Colors.orange),
  dialHandColor: const Color.fromARGB(255, 255, 255, 255),
  dialBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
  hourMinuteTextStyle:
      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  dayPeriodTextStyle:
      const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
  helpTextStyle: const TextStyle(
      fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
  inputDecorationTheme: const InputDecorationTheme(
    border: InputBorder.none,
    contentPadding: EdgeInsets.all(0),
  ),
  dialTextColor: MaterialStateColor.resolveWith((states) =>
      states.contains(MaterialState.selected) ? Colors.orange : Colors.white),
  entryModeIconColor: Colors.orange,
);
