// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'TimeChanger.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:flutter_animate/flutter_animate.dart';
import 'NotificationsPlugin.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:ui' as ui;
import 'package:url_launcher/url_launcher.dart';
import 'SecondScreen.dart';
import 'package:window_manager/window_manager.dart';
//import 'package:zlib/zlib.dart';
import 'dart:io';
import 'package:window_size/window_size.dart';

void main() {
  //FilePath();
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    setWindowMaxSize(const Size(612, 980));
    setWindowMinSize(const Size(612, 980));
  }
  tzdata.initializeTimeZones();

  runApp(MyApp());
}

String letter = 'A';
dynamic nightflag = Colors.white;
int y = 0;
String z = 'assets/sky1.png';
int Okay = 200;
dynamic colors = Color.fromRGBO(190, 32, 0, 0.675);
dynamic colors2 = Color.fromRGBO(114, 17, 0, 1);
int tempflag = 0;
int dayflag = 0;
int dayindex = 0;
bool DayChange = false;
dynamic transparent = Color.fromRGBO(255, 0, 0, 0.0);
String first = 'Monday';
String second = 'Tuesday';
String third = 'Wednesday';
int LanguageIndex = 1;
String SettingsLang = 'Settings';
String NotifyMes = 'Choose Language';
double AVGPrec = 0;
double AVGTemp = 0;
double AVGHum = 0;
String realAVGPrec = '';
String realAVGTemp = '';
String realAVGHum = '';
String Stats = 'Stats';
String AverageTemp = 'Average Temperature';
String AveragePrec = 'Average Precipitation';
String AverageHum = 'Average Humidity';
int play_Index = 0;
dynamic player = AudioPlayer();
int Timer2 = 0;
int Timer3 = 0;
int ClockIndx = 0;
double x = 3;
int nx = 16;
double slider = 0;
String currentDay = "Monday";
dynamic SecondTempMatrix = MyHomePageState().TempMatrix;
dynamic SecondPrecMatrix = MyHomePageState().PrecMatrix;
dynamic SecondHumMatrix = MyHomePageState().HumiMatrix;
final Uri _url = Uri.parse('https://github.com/LunarTear9');
String city = "Tokyo";
String changeTime0 = "Change Time";
String selectTime0 = "Select a time";
String okay0 = "Confirm";
String cancel0 = "Cancel";
String Precipitation = "Precipitation";
String Humidity = "Humidity";
String Temperature = "Temperature";
String Show = "Show";
String showStatus = "";

void ClockIndex() async {
  ClockIndx = ClockIndx + 1;
  MyHomePageState obj = MyHomePageState();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: false,
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MatrixElement {
  final int value;

  MatrixElement(this.value);
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();

  void PopUpHelper() {
    MyHomePageState().showPopup2(MyHomePageState().context);
  }
}

class MyHomePageState extends State<MyHomePage> {
  late List<String> hourlyTime;
  late List<double> hourlyTemperature;
  late List<int> precipitationperhour;
  late List<int> totalhumidity;
  bool loading = true;
  late TextEditingController controller;
  String text = "";

  void changeView() {
    setState(() {
      if (dayindex != -1) {
        dayflag = dayindex;
        x = 0;
        y = 0;
      }

      if (x > 18 || x < 7) {
        z = 'assets/sky1.png';
        colors = Color.fromRGBO(0, 116, 145, 0.675);
        colors2 = Color.fromRGBO(0, 146, 179, 1);
        nightflag = Colors.white;
      } else {
        z = 'assets/sky2.png';
        colors = Color.fromRGBO(64, 128, 255, 0.575);
        colors2 = Color.fromRGBO(64, 128, 255, 1);
        nightflag = Colors.black;
      }

      if (Timer == 1) {
        Timer = 0;
      } else if (Timer == 0) {
        Timer = 1;
      }

      if (y == 0) {
        if (x < 23) {
          x = x + 1;
        } else if (x == 23) {
          x = 0;
        }
      } else if (y == 1) {
        x = x - 1;
        if (x == -1) {
          x = 23;
        }
        y = 0;
      }

      DayChange = false;

      dayindex = -1;
    });
  }

  void IndicatorAnimation() {
    setState(() {
      if (Timer2 == 1) {
        Timer2 = 0;
      } else if (Timer2 == 0) {
        Timer2 = 1;
      }
    });
  }

  void buttonresumeAnimation() {
    setState(() {
      if (Timer3 == 1) {
        Timer3 = 0;
      } else if (Timer3 == 0) {
        Timer3 = 1;
      }
    });
  }

  void ChangeLanguage() {
    setState(() {
      if (LanguageIndex == 1) {
        first = 'Monday';
        second = 'Tuesday';
        third = 'Wednesday';
        SettingsLang = 'Settings';
        NotifyMes = 'Choose a language';
        AverageHum = 'Average Humidity';
        AveragePrec = 'Average Precipitation';
        AverageTemp = 'Average Temperature';
        Stats = 'Stats';
        city = "Tokyo";
        changeTime0 = "Change Time";
        selectTime0 = "Select a Time";
        okay0 = "Confirm";
        cancel0 = "Cancel";
        Precipitation = "Precipitation";
        Temperature = "Temperature";
        Humidity = "Humidity";
        Show = "Show";
      } else if (LanguageIndex == 0) {
        first = '月曜日';
        second = '火曜日';
        third = '水曜日';
        SettingsLang = '設定言語';
        NotifyMes = '言語を選択';
        AverageHum = '平均湿度';
        AveragePrec = '平均降水量';
        AverageTemp = '平均気温';
        Stats = '統計';
        city = "東京";
        changeTime0 = "時間を変更する";
        selectTime0 = "時間を選択してください ";
        okay0 = "確認する";
        cancel0 = "キャンセル";
        Precipitation = "降水量";
        Temperature = "温度";
        Humidity = "湿度";
        Show = "表示";
      }
    });
  }

  int Timer = 0;

  List<List<double>> TempMatrix =
      List.generate(7, (index) => List<double>.filled(24, 0));
  List<List<int>> PrecMatrix =
      List.generate(7, (index) => List<int>.filled(24, 0));
  List<List<int>> HumiMatrix =
      List.generate(7, (index) => List<int>.filled(24, 0));

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    fetchData();
  }

  Future<void> fetchData() async {
    loading = true;
    try {
      LanguageIndex = 1;
      ChangeLanguage();
      final response = await http.get(Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=35.6895&longitude=139.6917&hourly=temperature_2m,relative_humidity_2m,precipitation_probability'));

      if (response.statusCode == Okay) {
        // Parse JSON response
        final Map<String, dynamic> data = json.decode(response.body);

        // Extract values
        final List<String> timeList = List<String>.from(data['hourly']['time']);
        final List<double> temperatureList =
            List<double>.from(data['hourly']['temperature_2m']);
        final List<int> precipitationList =
            List<int>.from(data['hourly']['precipitation_probability']);
        final List<int> humidityList =
            List<int>.from(data['hourly']['relative_humidity_2m']);

        // Save values to variables
        setState(() {
          for (int i = 0; i <= 2; i++) {
            for (int j = 0; j <= 23; j++) {
              PrecMatrix[i][j] = precipitationList[tempflag];
              TempMatrix[i][j] = temperatureList[tempflag];
              HumiMatrix[i][j] = humidityList[tempflag];
              tempflag = tempflag + 1;
              changeView();
            }
          }

          void _saveMatrixData() async {
            final matrixBox = await Hive.openBox('matrixBox');

            for (int i = 0; i < PrecMatrix.length; i++) {
              final row = PrecMatrix[i];
              for (int j = 0; j < row.length; j++) {
                final element = MatrixElement(row[j]);
                matrixBox.add(element);
              }
            }
          }

          _saveMatrixData();
          timeList.clear();
          precipitationList.clear();
          humidityList.clear();
          hourlyTemperature.clear();
          precipitationperhour.clear();
          totalhumidity.clear();
          controller.dispose();
        });

        // Print specific data from the lists
        print('Third hour time: ${hourlyTime[x.toInt()]}');
        print('Fourth hour temperature: ${hourlyTemperature[x.toInt()]}');
      } else {
        // Handle errors
        print('Failed to load data. Status code: ${response.statusCode}');
      }

      setState(() {
        loading = false; // Set loading to false when data fetching is complete
      });
    } catch (error) {
      // Handle errors
      print('Error: $error');
      setState(() {
        loading = false; // Set loading to false even if there's an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.menu, // You can use a different icon if you want
              color: Colors.white, // Customize the color of the icon
            ),
            onPressed: () {
              Scaffold.of(context)
                  .openDrawer(); // Open the Drawer when the button is pressed
            },
          ),
          backgroundColor: colors2,
          title: LiveTimeWidget(),
          flexibleSpace: Icon(Icons.cloud),
          actions: [
            Text(
              "$showStatus",
              style: TextStyle(fontSize: 26, color: nightflag),
            ),
            IconButton(
                color: nightflag,
                onPressed: () {
                  _showAlertDialog(context);
                },
                icon: Icon(Icons.login)),
            IconButton(
              color: nightflag,
              icon: Icon(Icons.settings),
              style: ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(Size(0.01, 0.01)),
                  backgroundColor: MaterialStatePropertyAll(colors)),
              onPressed: () {
                // Call the function to show the pop-up
                _showPopup(context);
              },
            )
          ],
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/background.png"),
                    fit: BoxFit.cover)),
            child: Center(
                child: Column(children: [
              Padding(
                  padding: EdgeInsets.all(20),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: ElevatedButton(
                        onPressed: () {
                          dayflag = 0;
                          SecondTempMatrix = TempMatrix;

                          SecondPrecMatrix = PrecMatrix;
                          SecondHumMatrix = HumiMatrix;
                          currentDay = first;
                          returnPrec();
                          returnHum();
                          returnTemp();
                          okay = okay0;
                          cancel = cancel0;
                          changeTime = changeTime0;
                          selectTime = selectTime0;
                          openSecondScreen(context);
                        },
                        child:
                            Text("$first", style: TextStyle(color: nightflag)),
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(colors),
                            fixedSize: MaterialStatePropertyAll(Size(200, 40))),
                      ))),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: ElevatedButton(
                        onPressed: () {
                          dayflag = 1;
                          SecondTempMatrix = TempMatrix;

                          SecondPrecMatrix = PrecMatrix;
                          SecondHumMatrix = HumiMatrix;
                          currentDay = second;
                          returnPrec();
                          returnHum();
                          returnTemp();
                          okay = okay0;
                          cancel = cancel0;
                          changeTime = changeTime0;
                          selectTime = selectTime0;
                          openSecondScreen(context);
                        },
                        child: Text(
                          "$second",
                          style: TextStyle(color: nightflag),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(colors),
                            fixedSize: MaterialStatePropertyAll(Size(200, 40))),
                      ))),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: ElevatedButton(
                        onPressed: () {
                          dayflag = 2;
                          SecondTempMatrix = TempMatrix;
                          SecondPrecMatrix = PrecMatrix;
                          SecondHumMatrix = HumiMatrix;

                          currentDay = third;
                          returnPrec();
                          returnHum();
                          returnTemp();
                          okay = okay0;
                          cancel = cancel0;
                          changeTime = changeTime0;
                          selectTime = selectTime0;

                          openSecondScreen(context);
                        },
                        child: Text(
                          "$third",
                          style: TextStyle(color: nightflag),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(colors),
                            fixedSize: MaterialStatePropertyAll(Size(200, 40))),
                      )))
            ]))));
  }

  void _readAndPrintMatrixData() async {
    final matrixBox =
        await Hive.openBox('matrixBox'); // Make sure to open the correct box

    if (matrixBox.isNotEmpty) {
      // Assuming you have some data stored in the box
      final element = matrixBox.getAt(0) as MatrixElement;
      print('Value from Hive Box: ${element.value}');
    } else {
      print('Hive Box is empty or not initialized.');
    }
  }

  Future<void> _showPopup(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          backgroundColor: colors2,
          title: Text(
            '$SettingsLang',
            style: TextStyle(color: nightflag),
          ),
          content: Text(
            '$NotifyMes',
            style: TextStyle(color: nightflag),
          ),
          actions: [
            TextButton(
              onPressed: () {
                LanguageIndex = 1;
                ChangeLanguage();
                Navigator.of(context).pop(); // Close the pop-up
              },
              child: Text(
                'English',
                style: TextStyle(color: nightflag),
              ),
            ),
            TextButton(
              onPressed: () {
                LanguageIndex = 0;
                ChangeLanguage();
                Navigator.of(context).pop(); // Close the pop-up
              },
              child: Text(
                '日本語',
                style: TextStyle(color: nightflag),
              ),
            ),
          ],
        ).animate().scale(
            curve: Curves.bounceOut, duration: Duration(milliseconds: 500));
      },
    );
  }

  Future<void> showPopup2(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          backgroundColor: colors2,
          title: Text('                      $Stats'),
          content: Text(
            '$AveragePrec : $realAVGPrec%                                                                        $AverageTemp : $realAVGTemp°C                                                                  $AverageHum : $realAVGHum%                                               ',
            style: TextStyle(color: nightflag),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the pop-up
                showNotification();
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

  void returnPrec() {
    for (int i = 0; i <= 23; i++) {
      AVGPrec = AVGPrec + PrecMatrix[dayflag][i];
    }
    realAVGPrec = (AVGPrec / 24).toStringAsFixed(2);

    AVGPrec = 0;
  }

  void returnHum() {
    for (int i = 0; i <= 23; i++) {
      AVGHum = AVGHum + HumiMatrix[dayflag][i];
    }
    realAVGHum = (AVGHum / 24).toStringAsFixed(2);

    AVGHum = 0;
  }

  void returnTemp() {
    for (int i = 0; i <= 23; i++) {
      AVGTemp = AVGTemp + TempMatrix[dayflag][i];
    }

    realAVGTemp = (AVGTemp / 24).toStringAsFixed(2);
    AVGTemp = 0;
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  void onSliderValueChanged(double value) {
    setState(() {
      x = value;
      changeView();
      slider = value;
    });
    // Perform any other actions based on the new slider value
    // You can add your custom logic here
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colors2,
          title: Text(
            'Sign In',
            style: TextStyle(color: nightflag),
          ),
          content: Column(
            children: [
              TextField(
                  controller: controller,
                  onSubmitted: (String value) {
                    setState(() async {
                      text = controller.text;
                      final response = await http.post(
                          Uri.https(
                              "weather-app-d14d8-default-rtdb.asia-southeast1.firebasedatabase.app",
                              "Names.json"),
                          headers: {"Content-Type": "application/json"},
                          body: json.encode({"email": text}));
                      changeStatus();
                      // print((response.body));
                      // print(response.statusCode);
                      // Navigator.of(context).pop();
                    });
                  })
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the alert dialog
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: TextStyle(color: nightflag),
              ),
            ),
          ],
        );
      },
    );
  }

  void changeStatus() {
    setState(() {
      showStatus = "Logged in as $text";
    });
  }
}
