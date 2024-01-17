import 'package:weather/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

TimeOfDay selectedTime = TimeOfDay.now();
int sex = 0;

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreen createState() => _SecondScreen();
}

int hourindex = 1;

class _SecondScreen extends State<SecondScreen> {
  void ChangeData() {
    setState(() {
      if (hourindex < 23) {
        hourindex = hourindex + 1;
      } else if (hourindex == 23) {
        hourindex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.assessment))],
        backgroundColor: colors2,
        title: Text('$currentDay'),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Center(
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          child: Column(children: [
                            SizedBox(height: 10, width: 30),
                            Icon(
                              CupertinoIcons.thermometer,
                              size: 60,
                            ),
                            Text(
                              "${SecondTempMatrix[dayflag][hourindex]}°C",
                              textScaleFactor: 2,
                            )
                          ]),
                          color: colors,
                          height: 120,
                          width: 100,
                        ))),
              ),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        child: Column(children: [
                          SizedBox(height: 10, width: 30),
                          Icon(
                            Icons.water,
                            size: 60,
                          ),
                          Text(
                            "${SecondHumMatrix[dayflag][hourindex]}%",
                            textScaleFactor: 2,
                          )
                        ]),
                        color: colors,
                        height: 120,
                        width: 100,
                      ))),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        child: Column(children: [
                          SizedBox(height: 10, width: 30),
                          Icon(
                            CupertinoIcons.cloud_rain,
                            size: 60,
                          ),
                          Text(
                            "${SecondPrecMatrix[dayflag][hourindex]}%",
                            textScaleFactor: 2,
                          )
                        ]),
                        color: colors,
                        height: 120,
                        width: 100,
                      ))),
              Text(
                "${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}",
                style: TextStyle(color: Color.fromARGB(255, 232, 232, 232)),
                textScaleFactor: 2,
              ),
              ElevatedButton(
                onPressed: () async {
                  _showTimePicker(context);
                },
                child: Text("Change Time"),
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
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
      helpText: 'Select a time', // Change help text
      confirmText: 'OK', // Change confirm button text
      cancelText: 'Cancel', // Change cancel button text
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            primaryColor: colors, // Change primary color
            colorScheme: ColorScheme.fromSeed(
                seedColor: colors, surface: Color.fromARGB(255, 183, 187, 131)),
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: Colors.green), // Change text color
              titleMedium:
                  TextStyle(color: Colors.orange), // Change subtitle color
            ),
            buttonTheme: ButtonThemeData(
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
}

void openSecondScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SecondScreen()),
  );
  _SecondScreen().ChangeData();
}
