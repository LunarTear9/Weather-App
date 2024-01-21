import 'package:flutter/material.dart';
import 'main.dart';
import "package:flutter_animate/flutter_animate.dart";
import 'package:fl_chart/fl_chart.dart';

class StatsWindow extends StatefulWidget {
  @override
  StatsWindowState createState() => StatsWindowState();
}

class StatsWindowState extends State<StatsWindow> {
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
          title: Text(
            '                      $Stats',
            style: TextStyle(color: nightflag),
          ),
          content: Column(children: [
            Text(
              '$AveragePrec : $realAVGPrec%                                                                        $AverageTemp : $realAVGTemp°C                                                                  $AverageHum : $realAVGHum%                                               ',
              style: TextStyle(color: nightflag),
            ),
            //  PieChart(PieChartData(sections: [
            //    PieChartSectionData(value: AVGHum, color: Colors.blue),
            //   PieChartSectionData(value: AVGPrec, color: Colors.green),
            //   PieChartSectionData(value: AVGTemp, color: Colors.red)
            //  ]))
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
