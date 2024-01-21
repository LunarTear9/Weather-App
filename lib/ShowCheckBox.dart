import 'package:flutter/material.dart';
import 'package:weather/SecondScreen.dart';
import 'main.dart';
import "package:flutter_animate/flutter_animate.dart";

bool isVisible = true;

class CheckWindow extends StatefulWidget {
  @override
  CheckWindowState createState() => CheckWindowState();
}

class CheckWindowState extends State<CheckWindow> {
  Widget build(BuildContext context) {
    return Text("");
  }

  Future<void> showPopup2(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          backgroundColor: colors2,
          title: Text('                 Show:'),
          content: Column(children: [
            Row(children: [
              Text('  Temperature:   '),
              Switch(
                  value: isVisible,
                  onChanged: (bool value) {
                    setState(() {
                      isVisible = value;
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
                '       Close',
                style: TextStyle(color: nightflag),
              ),
            ),
          ],
        ).animate().slideX(
            curve: Curves.bounceOut, duration: Duration(milliseconds: 500));
      },
    );
  }
}
