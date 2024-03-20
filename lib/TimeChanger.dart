import 'dart:async';


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newweatherapp/main.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:intl/intl.dart';

void main() {
  tzdata.initializeTimeZones();
}
int j = 0;
String first = 'Monday';
String second = 'Tuesday';
String third = 'Wednesday';
String fourth = 'Thursday';
String fifth = 'Friday';
String sixth = 'Saturday';
String seventh = 'Sunday';
String currentDay = "Monday";
String Dayplusone = "Tuesday";
String Dayplustwo = "Wednesday";
String Dayplusthree = "Thursday";
String Dayplusfour = "Friday";
String Dayplusfive = "Saturday";
String Dayplussix = "Sunday";
String StartingDay = first;
class LiveTimeWidget extends StatefulWidget {
  @override
  final String month;
  LiveTimeWidget({super.key,required this.month});
  LiveTimeWidgetState createState() => LiveTimeWidgetState();
}

class LiveTimeWidgetState extends State<LiveTimeWidget> {
  late Timer _timer;
  late String _currentTime;
  
  late String _currentDay;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    final location = tz.getLocation('Asia/Tokyo');
    final now = tz.TZDateTime.now(location);
    _currentTime = DateFormat('HH:mm').format(now);
    if (month != '三月') {

      month = DateFormat('MMMM').format(now);
    }



    
    _currentDay = DateFormat('d').format(now);
    setState(() {});
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getDayOfWeek(DateTime.now().weekday, j);
    String dayOfWeek = StartingDay;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
        
          
           
            
               Text(
                _currentTime ?? '',
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
            
          
        Row(mainAxisSize:MainAxisSize.min,children: [
        
        Text(
          '$dayOfWeek  $month',
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
        
        Text(
          ' $_currentDay',
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),])
      ],
    );
  }

  
  void getDayOfWeek(int day,int j) {
    day = day + j;
   
   switch (day) {
      case 1:
        StartingDay = first; 
        Dayplusone = second; 
        Dayplustwo = third; 
        Dayplusthree = fourth;
        Dayplusfour = fifth;
        Dayplusfive = sixth;
        Dayplussix = seventh;
        break;
      case 2:
        StartingDay = second; 
        Dayplusone =third; 
        Dayplustwo = fourth; 
        Dayplusthree = fifth;
        Dayplusfour = sixth;
        Dayplusfive = seventh;
        Dayplussix = first;
        break;
      case 3:
        StartingDay = third; 
        Dayplusone = fourth; 
        Dayplustwo = fifth; 
        Dayplusthree = sixth;
        Dayplusfour = seventh;
        Dayplusfive = first;
        Dayplussix = second;
        break;
      case 4:
        StartingDay = fourth; 
        Dayplusone = fifth; 
        Dayplustwo = sixth; 
        Dayplusthree = seventh;
        Dayplusfour = first;
        Dayplusfive = second;
        Dayplussix = third;
        break;
      case 5:
        StartingDay = fifth; 
        Dayplusone = sixth; 
        Dayplustwo = seventh; 
        Dayplusthree = first;
        Dayplusfour = second;
        Dayplusfive = third;
        Dayplussix = fourth;
        break;
      case 6:
        StartingDay = sixth; 
        Dayplusone = seventh; 
        Dayplustwo = first; 
        Dayplusthree = second;
        Dayplusfour = third;
        Dayplusfive = fourth;
        Dayplussix = fifth;
        break;
      case 7:
        StartingDay = seventh;
        Dayplusone = first; 
        Dayplustwo = second; 
        Dayplusthree = third;
        Dayplusfour = fourth;
        Dayplusfive = fifth;
        Dayplussix = sixth;
        break;
      default:
        StartingDay = first;
        Dayplusone = second; 
        Dayplustwo = third; 
        Dayplusthree = fourth;
        Dayplusfour = fifth;
        Dayplusfive = sixth;
        Dayplussix = seventh;
        
        break;
    }
  }}