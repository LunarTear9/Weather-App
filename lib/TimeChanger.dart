import 'dart:async';

import 'package:weather/ClockWidget.dart';
import 'package:weather/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

void main() {
  tzdata.initializeTimeZones();
}

class LiveTimeWidget extends StatefulWidget {
  @override
  _LiveTimeWidgetState createState() => _LiveTimeWidgetState();
}

class _LiveTimeWidgetState extends State<LiveTimeWidget> {
  late Timer _timer;
  late String _currentTime;
  int counter = 0;
  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTime();
      ClockIndex();
    });
  }

  void _updateTime() {
    final location = tz.getLocation('Asia/Tokyo');
    final now = tz.TZDateTime.now(location);
    _currentTime = DateFormat('             HH:mm:ss').format(now);
    setState(() {});
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _currentTime,
      style: TextStyle(fontSize: 24),
    );
  }
}
