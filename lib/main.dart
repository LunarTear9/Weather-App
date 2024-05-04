// ignore_for_file: non_constant_identifier_names

import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter/widgets.dart';
import 'package:newweatherapp/TimeChanger.dart';
import 'package:newweatherapp/container.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:universal_io/io.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:text_scroll/text_scroll.dart';

import 'package:timezone/data/latest.dart' as tzdata;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';


int ClockIndx = 0;
int tempflag = 0;
int humidity = 0;
double currentTemperatureNow = 0;
double apparenttemperature = 0;
int cloudcover = 0;
int currentHumidity = 0;
double windspeed = 0;
double currentwindspeed = 0;
double currentPrecipitationNow = 0;
int currentCloudNow = 0;
double currentApparentNow = 0;
int currentHumidityNow = 0;
int hourindex = 1;
int tempindexone = 0;
int tempindextwo = 0;
dynamic colorDay = const Color.fromARGB(133, 50, 127, 190);
dynamic colornight = const Color.fromARGB(174, 105, 105, 105);
int precindexone = 0;
int precindextwo = 0;
double realAVGPrec = 0;
double AVGprec = 0;
String Precipitation = 'Precipitation';
List<double> AVGPrec2 = List<double>.filled(7, 0);
List<double> AVGCloud2 = List<double>.filled(7, 0);
int long = 35;
int lat = 139;

final Uri _url = Uri.parse('https://github.com/LunarTear9/Weather-App');

int? currentSelected = 0;
int selectedIndex = 0;
String city = 'Tokyo';
String AveragePrec = 'Average Precipitation';
String country = 'Japan';
String month = 'March';
String today = 'Today';
String tomorrow = 'Tomorrow';
String hour = 'hr';
String Language = 'Language';
String English = 'English';
String Japanese = 'Japanese';
double AVGCloud = 0;
double realAVGCloud = 0;

List<_SalesData> data = [
  _SalesData('Jan', 35, 0),
  _SalesData('Feb', 28, 0),
  _SalesData('Mar', 34, 0),
  _SalesData('Apr', 32, 0),
  _SalesData('May', 40, 0),
  _SalesData('May', 40, 0),
  _SalesData('May', 40, 0)
];

void main() {
  runApp(const MaterialApp(
    home: MainHomeScreen(),
    debugShowCheckedModeBanner: false,
  ));
  debugPaintSizeEnabled = false;
  tzdata.initializeTimeZones();
  //checkLanguage();
}

void ClockIndex() async {
  ClockIndx = ClockIndx + 1;
  MainHomeScreenState obj = MainHomeScreenState();
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => MainHomeScreenState();
}

class MainHomeScreenState extends State<MainHomeScreen> {
  final PageController _pageController = PageController();
  late List<int> cloudTotal;
  late List<String> hourlyTime;
  late List<double> dewPoint;
  late List<double> hourlyTemperature;
  late List<int> precipitationperhour;
  late List<int> totalhumidity;
  int _selectedIndex = 0;
  bool loading = true;

  List<List<int>> CloudMatrix =
      List.generate(7, (index) => List<int>.filled(24, 0));
  List<List<double>> TempMatrix =
      List.generate(7, (index) => List<double>.filled(24, 0));
  List<List<double>> DewMatrix =
      List.generate(7, (index) => List<double>.filled(24, 0));
  List<List<int>> PrecMatrix =
      List.generate(7, (index) => List<int>.filled(24, 0));
  List<List<int>> HumiMatrix =
      List.generate(7, (index) => List<int>.filled(24, 0));
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      //LanguageIndex = 1;
      //ChangeLanguage();
      final response = await http.get(Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$long.6854&longitude=$lat.7531&current=temperature_2m,apparent_temperature,precipitation,cloud_cover,relative_humidity_2m,wind_speed_10m&hourly=temperature_2m,relative_humidity_2m,dew_point_2m,precipitation_probability,cloud_cover'));

      if (response.statusCode == 200) {
        // Parse JSON response
        final Map<String, dynamic> data = json.decode(response.body);

        // Extract values
        final List<int> cloudTotal =
            List<int>.from(data['hourly']['cloud_cover']);
        final apparenttemperature = data['current']['apparent_temperature'];
        final cloudcover = data['current']['cloud_cover'];
        final windSpeed = data['current']['wind_speed_10m'];
        final humidity = data['current']['relative_humidity_2m'];
        final currentPrecipitation = data['current']['precipitation'];
        final currentTemperature = data['current']['temperature_2m'];
        final List<double> dewPoint =
            List<double>.from(data['hourly']['dew_point_2m']);
        final List<String> timeList = List<String>.from(data['hourly']['time']);
        final List<double> temperatureList =
            List<double>.from(data['hourly']['temperature_2m']);
        final List<int> precipitationList =
            List<int>.from(data['hourly']['precipitation_probability']);
        final List<int> humidityList =
            List<int>.from(data['hourly']['relative_humidity_2m']);

        // Save values to variables

        for (int i = 0; i <= 6; i++) {
          for (int j = 0; j <= 23; j++) {
            currentPrecipitationNow = currentPrecipitation;
            currentTemperatureNow = currentTemperature;
            currentApparentNow = apparenttemperature;
            currentCloudNow = cloudcover;
            currentwindspeed = windSpeed;
            currentHumidityNow = humidity;
            DewMatrix[i][j] = dewPoint[tempflag];
            CloudMatrix[i][j] = cloudTotal[tempflag];
            PrecMatrix[i][j] = precipitationList[tempflag];
            TempMatrix[i][j] = temperatureList[tempflag];
            HumiMatrix[i][j] = humidityList[tempflag];

            tempflag = tempflag + 1;
          }
        }
        // for (int i = 0; i<=6;i++){
        // dayflag = i;
        returnPrec();
        returnCloud();
        // returnTemp();
        // }
        setState(() {
          loading =
              false; // Set loading to false when data fetching is complete
        });

        timeList.clear();
        precipitationList.clear();
        humidityList.clear();
        hourlyTemperature.clear();
        precipitationperhour.clear();
        totalhumidity.clear();

        // Print specific data from the lists
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
    }
  }

  @override
  Widget build(BuildContext context) {
    
    DateTime now = DateTime.now();
    String formattedHour = DateFormat('HH').format(now);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton.filledTonal(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(returnColorWidget())),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(29),
                                topRight: Radius.circular(29)),
                            child: Container(
                              
                              width: double.infinity,
                              height: 1200,
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                    Color.fromARGB(255, 27, 27, 27),
                                    Color.fromARGB(255, 31, 31, 31)
                                  ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight)),
            
                              child: Container(
                                  child: Column(children: [
                                    const Text('Extras',style: TextStyle(color: Colors.white,fontSize: 40),),
                                OutlinedButton(child: const Text('Live Webcam'),onPressed: (){
                                  Navigator.pop(context);
                                  showCustomDialog(context,'Live Webcam', 'Tokyo,Shinjuku', () { 
            
            
                                });},)
                              ])),
                            ));
                      });
                },
                icon: const Icon(Icons.add)),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      /*  bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: returnColorWidget(),
          index: _selectedIndex,
          items: [
            const CurvedNavigationBarItem(
              child: const Icon(Icons.home),
            ),
            const CurvedNavigationBarItem(child: Icon(Icons.settings))
          ],
          height: 26,
          color: returnColorWidget(),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            });
          },
        ),*/
        body: MediaQuery(data: MediaQuery.of(context),child:Container(
          
          child: Center(
            child: SizedBox(
              height: double.infinity,
              width: 450,
              child: PageView(
                
                scrollDirection: Axis.horizontal,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                controller: _pageController,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                      
                      height: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: returnImageWidget(), fit: BoxFit.fill),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 4,
                              height: 0,
                            ),
                            LiveTimeWidget(month: month),
                            const SizedBox(
                              width: 100,
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(children: [
                                returnStatusMainImage(0),
                                Text(
                                  '$country ,$city',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 32),
                                )
                              ]),
                            ),
                            Row(mainAxisSize: MainAxisSize.min, children: [
                              Column(children: [
                                const Icon(
                                  CupertinoIcons.thermometer,
                                  color: Colors.white,
                                  size: 56,
                                ),
                                Text(
                                  '${currentTemperatureNow}°C',
                                  style: const TextStyle(
                                      fontSize: 23, color: Colors.white),
                                )
                              ]),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 40.0, right: 40.0),
                                child: Column(children: [
                                  Container(
                                      height: 55,
                                      width: 55,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'lib/assets/heavy-rain3.png')))),
                                  Text(
                                    '${currentPrecipitationNow}%',
                                    style: const TextStyle(
                                        fontSize: 23, color: Colors.white),
                                  )
                                ]),
                              ),
                              Column(children: [
                                Container(
                                  height: 55,
                                  width: 50,
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              AssetImage('lib/assets/water2.png'))),
                                ),
                                Text(
                                  '${currentHumidityNow}%',
                                  style: const TextStyle(
                                      fontSize: 23, color: Colors.white),
                                )
                              ])
                            ]),
                            Visibility(
                                visible: loading,
                                child: const CircularProgressIndicator()),
                            // Add some spacing
              
                            const SizedBox(height: 20.0), // Add some spacing
                            ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: MyContainerOne(
                                    color: returnColorWidget(),
                                    height: 80,
                                    width: 420,
                                    child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 6, top: 6),
                                              child: WidgetBuilder(0, formattedHour)),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 18, top: 6),
                                              child: WidgetBuilder(1, formattedHour)),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 18, top: 6),
                                              child: WidgetBuilder(2, formattedHour)),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 18, top: 6),
                                              child: WidgetBuilder(3, formattedHour)),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 18, top: 6),
                                              child: WidgetBuilder(4, formattedHour)),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 18, top: 6),
                                              child: WidgetBuilder(5, formattedHour)),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 18, top: 6),
                                              child: WidgetBuilder(6, formattedHour)),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 18, top: 6),
                                              child: WidgetBuilder(7, formattedHour)),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 18, top: 6),
                                              child: WidgetBuilder(8, formattedHour)),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 18, top: 6),
                                              child: WidgetBuilder(9, formattedHour)),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 18, top: 6),
                                              child:
                                                  WidgetBuilder(10, formattedHour)),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 18, top: 6),
                                              child:
                                                  WidgetBuilder(11, formattedHour)),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 18, top: 6),
                                              child: WidgetBuilder(12, formattedHour))
                                        ]))),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Divider(
                                color: Color.fromARGB(255, 130, 215, 255),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                height: 500,
                                width: 400,
                                color: returnColorWidget(),
                                child: ListView(
                                  padding: const EdgeInsets.all(8),
                                  children: [
                                    Column(children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: Divider(
                                          color: returnColorWidget(),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          data = [
                                            returnStats(1, 0, 0, 0, 0),
                                            returnStats(2, 0, 1, 0, 1),
                                            returnStats(3, 0, 2, 0, 2),
                                            returnStats(4, 0, 3, 0, 3),
                                            returnStats(5, 0, 4, 0, 4),
                                            returnStats(6, 0, 5, 0, 5),
                                            returnStats(7, 0, 6, 0, 6),
                                            returnStats(8, 0, 7, 0, 7),
                                            returnStats(9, 0, 8, 0, 8),
                                            returnStats(10, 0, 9, 0, 9),
                                            returnStats(11, 0, 10, 0, 10),
                                            returnStats(12, 0, 11, 0, 11)
                                          ];
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(29),
                                                            topRight:
                                                                Radius.circular(29)),
                                                    child: Container(
                                                      height: 1200,
                                                      decoration: const BoxDecoration(
                                                          gradient: LinearGradient(
                                                              colors: [
                                                            Color.fromARGB(
                                                                255, 27, 27, 27),
                                                            Color.fromARGB(
                                                                255, 31, 31, 31)
                                                          ],
                                                              begin:
                                                                  Alignment.topLeft,
                                                              end: Alignment
                                                                  .bottomRight)),
                                                      child: Container(
                                                          child: SingleChildScrollView(child: Column(children: [
                                                            
                                                        SfCartesianChart(
                                                            onZoomStart:
                                                                (zoomingArgs) =>
                                                                    ZoomPanArgs(),
                                                            plotAreaBorderColor:
                                                                Colors.yellow,
                                                            plotAreaBackgroundColor:
                                                                Colors.grey[600],
                                                            primaryYAxis:
                                                                const CategoryAxis(
                                                              isVisible: false,
                                                            ),
                                                            primaryXAxis: const CategoryAxis(
                                                                labelStyle: TextStyle(
                                                                    color: Color.fromARGB(
                                                                        211, 255, 240, 240))),
                                                            title: ChartTitle(
                                                                text: '$StartingDay',
                                                                textStyle: const TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                            legend: const Legend(
                                                                isVisible: true,
                                                                textStyle: TextStyle(
                                                                    color:
                                                                        Colors.white,
                                                                    fontSize: 18)),
                                                            tooltipBehavior:
                                                                TooltipBehavior(enable: true, color: Colors.black),
                                                            series: <CartesianSeries<_SalesData, String>>[
                                                              LineSeries<_SalesData,
                                                                  String>(
                                                                color: Colors.blue,
                                                                dataSource: data,
                                                                xValueMapper:
                                                                    (_SalesData sales,
                                                                            _) =>
                                                                        sales.year,
                                                                yValueMapper:
                                                                    (_SalesData sales,
                                                                            _) =>
                                                                        sales.sales,
                                                                name:
                                                                    '$Precipitation',
                                                                dataLabelSettings:
                                                                    const DataLabelSettings(
                                                                        isVisible:
                                                                            true,
                                                                        color: Colors
                                                                            .black),
                                                              ),
                                                              
                                                            ]), SfCartesianChart(
                                                            onZoomStart:
                                                                (zoomingArgs) =>
                                                                    ZoomPanArgs(),
                                                            plotAreaBorderColor:
                                                                Colors.yellow,
                                                            plotAreaBackgroundColor:
                                                                Colors.grey[600],
                                                            primaryYAxis:
                                                                const CategoryAxis(
                                                              isVisible: false,
                                                            ),
                                                            primaryXAxis: const CategoryAxis(
                                                                labelStyle: TextStyle(
                                                                    color: Color.fromARGB(
                                                                        211, 255, 240, 240))),
                                                            title: ChartTitle(
                                                                
                                                                textStyle: const TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                            legend: const Legend(
                                                                isVisible: true,
                                                                textStyle: TextStyle(
                                                                    color:
                                                                        Colors.white,
                                                                    fontSize: 18)),
                                                            tooltipBehavior:
                                                                TooltipBehavior(enable: true, color: Colors.black),
                                                            series: <CartesianSeries<_SalesData, String>>[
                                                            
                                                              LineSeries<_SalesData,
                                                                  String>(
                                                                color: Colors.yellow,
                                                                dataSource: data,
                                                                xValueMapper:
                                                                    (_SalesData sales,
                                                                            _) =>
                                                                        sales.year,
                                                                yValueMapper: (_SalesData
                                                                            sales,
                                                                        _) =>
                                                                    sales.Temperature,
                                                                name: 'Temperature',
                                                                dataLabelSettings:
                                                                    const DataLabelSettings(
                                                                        isVisible:
                                                                            true,
                                                                        color: Colors
                                                                            .black),
                                                              )
                                                            ])
                                                      ])),)
                                                    ));
                                              });
                                        },
                                        child: ListTile(
                                          subtitle: Text('$currentTemperatureNow°C',
                                              style: const TextStyle(
                                                  color: Colors.white, fontSize: 16)),
                                          leading: returnStatusImage(0),
                                          title: Text('$today',
                                              style: const TextStyle(
                                                  color: Colors.white, fontSize: 16)),
                                          trailing: SingleChildScrollView(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            child: Row(
                                              mainAxisSize: MainAxisSize
                                                  .min, // Ensures the row only takes the minimum required space
                                              children: [
                                                // Add your widgets here
              
                                                Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        height: 35,
                                                        width: 35,
                                                        decoration: const BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    'lib/assets/heavy-rain.png'))),
                                                      ),
                                                      Text(
                                                        '${AVGPrec2[0].toInt()}%',
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                      )
                                                    ]),
              
                                                // Add spacing between widgets
                                                Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 16, right: 16),
                                                    child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            height: 35,
                                                            width: 35,
                                                            decoration: const BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        'lib/assets/clouddisplay.png'))),
                                                          ),
                                                          Text(
                                                              '${AVGCloud2[0].toInt()}%',
                                                              style: const TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 12))
                                                        ])),
                                                Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        height: 35,
                                                        width: 35,
                                                        decoration: const BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    'lib/assets/water2.png'))),
                                                      ),
                                                      Text('$currentHumidityNow%',
                                                          style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 12))
                                                    ]),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: Divider(
                                          color: returnColorWidget(),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          data = [
                                            returnStats(1, 0, 0, 0, 0),
                                            returnStats(2, 1, 1, 1, 1),
                                            returnStats(3, 1, 2, 1, 2),
                                            returnStats(4, 1, 3, 1, 3),
                                            returnStats(5, 1, 4, 1, 4),
                                            returnStats(6, 1, 5, 1, 5),
                                            returnStats(7, 1, 6, 1, 6),
                                            returnStats(8, 1, 7, 1, 7),
                                            returnStats(9, 1, 8, 1, 8),
                                            returnStats(10, 1, 9, 1, 9),
                                            returnStats(11, 1, 10, 1, 10),
                                            returnStats(12, 1, 11, 1, 11)
                                          ];
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(29),
                                                            topRight:
                                                                Radius.circular(29)),
                                                    child: Container(
                                                      height: 1200,
                                                      decoration: const BoxDecoration(
                                                          gradient: LinearGradient(
                                                              colors: [
                                                            Color.fromARGB(
                                                                255, 27, 27, 27),
                                                            Color.fromARGB(
                                                                255, 31, 31, 31)
                                                          ],
                                                              begin:
                                                                  Alignment.topLeft,
                                                              end: Alignment
                                                                  .bottomRight)),
                                                      child: Container(
                                                          child: SingleChildScrollView(
                                                            child: Column(children: [
                                                                                                               SfCartesianChart(
                                                            onZoomStart:
                                                                (zoomingArgs) =>
                                                                    ZoomPanArgs(),
                                                            plotAreaBorderColor:
                                                                Colors.yellow,
                                                            plotAreaBackgroundColor:
                                                                Colors.grey[600],
                                                            primaryYAxis:
                                                                const CategoryAxis(
                                                              isVisible: false,
                                                            ),
                                                            primaryXAxis: const CategoryAxis(
                                                                labelStyle: TextStyle(
                                                                    color: Color.fromARGB(
                                                                        211, 255, 240, 240))),
                                                            title: ChartTitle(
                                                                text: '$Dayplusone',
                                                                textStyle: const TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                            legend: const Legend(
                                                                isVisible: true,
                                                                textStyle: TextStyle(
                                                                    color:
                                                                        Colors.white,
                                                                    fontSize: 18)),
                                                            tooltipBehavior:
                                                                TooltipBehavior(enable: true, color: Colors.black),
                                                            series: <CartesianSeries<_SalesData, String>>[
                                                              LineSeries<_SalesData,
                                                                  String>(
                                                                color: Colors.blue,
                                                                dataSource: data,
                                                                xValueMapper:
                                                                    (_SalesData sales,
                                                                            _) =>
                                                                        sales.year,
                                                                yValueMapper:
                                                                    (_SalesData sales,
                                                                            _) =>
                                                                        sales.sales,
                                                                name:
                                                                    '$Precipitation',
                                                                dataLabelSettings:
                                                                    const DataLabelSettings(
                                                                        isVisible:
                                                                            true,
                                                                        color: Colors
                                                                            .black),
                                                              ),
                                                              
                                                            ]), SfCartesianChart(
                                                            onZoomStart:
                                                                (zoomingArgs) =>
                                                                    ZoomPanArgs(),
                                                            plotAreaBorderColor:
                                                                Colors.yellow,
                                                            plotAreaBackgroundColor:
                                                                Colors.grey[600],
                                                            primaryYAxis:
                                                                const CategoryAxis(
                                                              isVisible: false,
                                                            ),
                                                            primaryXAxis: const CategoryAxis(
                                                                labelStyle: TextStyle(
                                                                    color: Color.fromARGB(
                                                                        211, 255, 240, 240))),
                                                            title: ChartTitle(
                                                                
                                                                textStyle: const TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                            legend: const Legend(
                                                                isVisible: true,
                                                                textStyle: TextStyle(
                                                                    color:
                                                                        Colors.white,
                                                                    fontSize: 18)),
                                                            tooltipBehavior:
                                                                TooltipBehavior(enable: true, color: Colors.black),
                                                            series: <CartesianSeries<_SalesData, String>>[
                                                            
                                                              LineSeries<_SalesData,
                                                                  String>(
                                                                color: Colors.yellow,
                                                                dataSource: data,
                                                                xValueMapper:
                                                                    (_SalesData sales,
                                                                            _) =>
                                                                        sales.year,
                                                                yValueMapper: (_SalesData
                                                                            sales,
                                                                        _) =>
                                                                    sales.Temperature,
                                                                name: 'Temperature',
                                                                dataLabelSettings:
                                                                    const DataLabelSettings(
                                                                        isVisible:
                                                                            true,
                                                                        color: Colors
                                                                            .black),
                                                              )
                                                            ])
                                                                                                            ]),
                                                          )),
                                                    ));
                                              });
                                        },
                                        child: ListTile(
                                          subtitle: Text('${TempMatrix[1][0]}°C',
                                              style: const TextStyle(
                                                  color: Colors.white, fontSize: 16)),
                                          leading: returnStatusImage(1),
                                          title: Text('$tomorrow',
                                              style: const TextStyle(
                                                  color: Colors.white, fontSize: 16)),
                                          trailing: SingleChildScrollView(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            child: Row(
                                              mainAxisSize: MainAxisSize
                                                  .min, // Ensures the row only takes the minimum required space
                                              children: [
                                                // Add your widgets here
              
                                                Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        height: 35,
                                                        width: 35,
                                                        decoration: const BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    'lib/assets/heavy-rain.png'))),
                                                      ),
                                                      Text(
                                                        '${AVGPrec2[1].toInt()}%',
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                      )
                                                    ]),
              
                                                // Add spacing between widgets
                                                Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 16, right: 16),
                                                    child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            height: 35,
                                                            width: 35,
                                                            decoration: const BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        'lib/assets/clouddisplay.png'))),
                                                          ),
                                                          Text(
                                                              '${AVGPrec2[1].toInt()}%',
                                                              style: const TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 12))
                                                        ])),
                                                Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        height: 35,
                                                        width: 35,
                                                        decoration: const BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    'lib/assets/water2.png'))),
                                                      ),
                                                      Text('${HumiMatrix[1][0]}%',
                                                          style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 12))
                                                    ]),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: Divider(
                                          color: returnColorWidget(),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          data = [
                                            returnStats(1, 0, 0, 0, 0),
                                            returnStats(2, 2, 1, 2, 1),
                                            returnStats(3, 2, 2, 2, 2),
                                            returnStats(4, 2, 3, 2, 3),
                                            returnStats(5, 2, 4, 2, 4),
                                            returnStats(6, 2, 5, 2, 5),
                                            returnStats(7, 2, 6, 2, 6),
                                            returnStats(8, 2, 7, 2, 7),
                                            returnStats(9, 2, 8, 2, 8),
                                            returnStats(10, 2, 9, 2, 9),
                                            returnStats(11, 2, 10, 2, 10),
                                            returnStats(12, 2, 11, 2, 11)
                                          ];
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(29),
                                                            topRight:
                                                                Radius.circular(29)),
                                                    child: Container(
                                                      height: 1200,
                                                      decoration: const BoxDecoration(
                                                          gradient: LinearGradient(
                                                              colors: [
                                                            Color.fromARGB(
                                                                255, 27, 27, 27),
                                                            Color.fromARGB(
                                                                255, 31, 31, 31)
                                                          ],
                                                              begin:
                                                                  Alignment.topLeft,
                                                              end: Alignment
                                                                  .bottomRight)),
                                                      child: Container(
                                                          child: SingleChildScrollView(
                                                            child: Column(children: [
                                                                                                               SfCartesianChart(
                                                            onZoomStart:
                                                                (zoomingArgs) =>
                                                                    ZoomPanArgs(),
                                                            plotAreaBorderColor:
                                                                Colors.yellow,
                                                            plotAreaBackgroundColor:
                                                                Colors.grey[600],
                                                            primaryYAxis:
                                                                const CategoryAxis(
                                                              isVisible: false,
                                                            ),
                                                            primaryXAxis: const CategoryAxis(
                                                                labelStyle: TextStyle(
                                                                    color: Color.fromARGB(
                                                                        211, 255, 240, 240))),
                                                            title: ChartTitle(
                                                                text: '$Dayplustwo',
                                                                textStyle: const TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                            legend: const Legend(
                                                                isVisible: true,
                                                                textStyle: TextStyle(
                                                                    color:
                                                                        Colors.white,
                                                                    fontSize: 18)),
                                                            tooltipBehavior:
                                                                TooltipBehavior(enable: true, color: Colors.black),
                                                            series: <CartesianSeries<_SalesData, String>>[
                                                              LineSeries<_SalesData,
                                                                  String>(
                                                                color: Colors.blue,
                                                                dataSource: data,
                                                                xValueMapper:
                                                                    (_SalesData sales,
                                                                            _) =>
                                                                        sales.year,
                                                                yValueMapper:
                                                                    (_SalesData sales,
                                                                            _) =>
                                                                        sales.sales,
                                                                name:
                                                                    '$Precipitation',
                                                                dataLabelSettings:
                                                                    const DataLabelSettings(
                                                                        isVisible:
                                                                            true,
                                                                        color: Colors
                                                                            .black),
                                                              ),
                                                              
                                                            ]), SfCartesianChart(
                                                            onZoomStart:
                                                                (zoomingArgs) =>
                                                                    ZoomPanArgs(),
                                                            plotAreaBorderColor:
                                                                Colors.yellow,
                                                            plotAreaBackgroundColor:
                                                                Colors.grey[600],
                                                            primaryYAxis:
                                                                const CategoryAxis(
                                                              isVisible: false,
                                                            ),
                                                            primaryXAxis: const CategoryAxis(
                                                                labelStyle: TextStyle(
                                                                    color: Color.fromARGB(
                                                                        211, 255, 240, 240))),
                                                            title: ChartTitle(
                                                                
                                                                textStyle: const TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                            legend: const Legend(
                                                                isVisible: true,
                                                                textStyle: TextStyle(
                                                                    color:
                                                                        Colors.white,
                                                                    fontSize: 18)),
                                                            tooltipBehavior:
                                                                TooltipBehavior(enable: true, color: Colors.black),
                                                            series: <CartesianSeries<_SalesData, String>>[
                                                            
                                                              LineSeries<_SalesData,
                                                                  String>(
                                                                color: Colors.yellow,
                                                                dataSource: data,
                                                                xValueMapper:
                                                                    (_SalesData sales,
                                                                            _) =>
                                                                        sales.year,
                                                                yValueMapper: (_SalesData
                                                                            sales,
                                                                        _) =>
                                                                    sales.Temperature,
                                                                name: 'Temperature',
                                                                dataLabelSettings:
                                                                    const DataLabelSettings(
                                                                        isVisible:
                                                                            true,
                                                                        color: Colors
                                                                            .black),
                                                              )
                                                            ])
                                                                                                            ]),
                                                          )),
                                                    ));
                                              });
                                        },
                                        child: ListTile(
                                          subtitle: Text('${TempMatrix[2][0]}°C',
                                              style: const TextStyle(
                                                  color: Colors.white, fontSize: 16)),
                                          leading: returnStatusImage(2),
                                          title: Text('${Dayplustwo.substring(0, 3)}',
                                              style: const TextStyle(
                                                  color: Colors.white, fontSize: 16)),
                                          trailing: SingleChildScrollView(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            child: Row(
                                              mainAxisSize: MainAxisSize
                                                  .min, // Ensures the row only takes the minimum required space
                                              children: [
                                                // Add your widgets here
              
                                                Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        height: 40,
                                                        width: 40,
                                                        decoration: const BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    'lib/assets/heavy-rain.png'))),
                                                      ),
                                                      Text(
                                                        '${AVGPrec2[2].toInt()}%',
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                      )
                                                    ]),
              
                                                // Add spacing between widgets
                                                Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 16, right: 16),
                                                    child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            height: 35,
                                                            width: 35,
                                                            decoration: const BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        'lib/assets/clouddisplay.png'))),
                                                          ),
                                                          Text(
                                                              '${AVGCloud2[2].toInt()}%',
                                                              style: const TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 12))
                                                        ])),
                                                Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        height: 35,
                                                        width: 35,
                                                        decoration: const BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    'lib/assets/water2.png'))),
                                                      ),
                                                      Text('${HumiMatrix[2][0]}%',
                                                          style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 12))
                                                    ]),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: Divider(
                                          color: returnColorWidget(),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          data = [
                                            returnStats(1, 0, 0, 0, 0),
                                            returnStats(2, 3, 1, 3, 1),
                                            returnStats(3, 3, 2, 3, 2),
                                            returnStats(4, 3, 3, 3, 3),
                                            returnStats(5, 3, 4, 3, 4),
                                            returnStats(6, 3, 5, 3, 5),
                                            returnStats(7, 3, 6, 3, 6),
                                            returnStats(8, 3, 7, 3, 7),
                                            returnStats(9, 3, 8, 3, 8),
                                            returnStats(10, 3, 9, 3, 9),
                                            returnStats(11, 3, 10, 3, 10),
                                            returnStats(12, 3, 11, 3, 11)
                                          ];
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(29),
                                                            topRight:
                                                                Radius.circular(29)),
                                                    child: Container(
                                                      height: 1200,
                                                      decoration: const BoxDecoration(
                                                          gradient: LinearGradient(
                                                              colors: [
                                                            Color.fromARGB(
                                                                255, 27, 27, 27),
                                                            Color.fromARGB(
                                                                255, 31, 31, 31)
                                                          ],
                                                              begin:
                                                                  Alignment.topLeft,
                                                              end: Alignment
                                                                  .bottomRight)),
                                                      child: Container(
                                                          child: SingleChildScrollView(
                                                            child: Column(children: [
                                                                                                               SfCartesianChart(
                                                            onZoomStart:
                                                                (zoomingArgs) =>
                                                                    ZoomPanArgs(),
                                                            plotAreaBorderColor:
                                                                Colors.yellow,
                                                            plotAreaBackgroundColor:
                                                                Colors.grey[600],
                                                            primaryYAxis:
                                                                const CategoryAxis(
                                                              isVisible: false,
                                                            ),
                                                            primaryXAxis: const CategoryAxis(
                                                                labelStyle: TextStyle(
                                                                    color: Color.fromARGB(
                                                                        211, 255, 240, 240))),
                                                            title: ChartTitle(
                                                                text: '$Dayplusthree',
                                                                textStyle: const TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                            legend: const Legend(
                                                                isVisible: true,
                                                                textStyle: TextStyle(
                                                                    color:
                                                                        Colors.white,
                                                                    fontSize: 18)),
                                                            tooltipBehavior:
                                                                TooltipBehavior(enable: true, color: Colors.black),
                                                            series: <CartesianSeries<_SalesData, String>>[
                                                              LineSeries<_SalesData,
                                                                  String>(
                                                                color: Colors.blue,
                                                                dataSource: data,
                                                                xValueMapper:
                                                                    (_SalesData sales,
                                                                            _) =>
                                                                        sales.year,
                                                                yValueMapper:
                                                                    (_SalesData sales,
                                                                            _) =>
                                                                        sales.sales,
                                                                name:
                                                                    '$Precipitation',
                                                                dataLabelSettings:
                                                                    const DataLabelSettings(
                                                                        isVisible:
                                                                            true,
                                                                        color: Colors
                                                                            .black),
                                                              ),
                                                              
                                                            ]), SfCartesianChart(
                                                            onZoomStart:
                                                                (zoomingArgs) =>
                                                                    ZoomPanArgs(),
                                                            plotAreaBorderColor:
                                                                Colors.yellow,
                                                            plotAreaBackgroundColor:
                                                                Colors.grey[600],
                                                            primaryYAxis:
                                                                const CategoryAxis(
                                                              isVisible: false,
                                                            ),
                                                            primaryXAxis: const CategoryAxis(
                                                                labelStyle: TextStyle(
                                                                    color: Color.fromARGB(
                                                                        211, 255, 240, 240))),
                                                            title: ChartTitle(
                                                               
                                                                textStyle: const TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                            legend: const Legend(
                                                                isVisible: true,
                                                                textStyle: TextStyle(
                                                                    color:
                                                                        Colors.white,
                                                                    fontSize: 18)),
                                                            tooltipBehavior:
                                                                TooltipBehavior(enable: true, color: Colors.black),
                                                            series: <CartesianSeries<_SalesData, String>>[
                                                            
                                                              LineSeries<_SalesData,
                                                                  String>(
                                                                color: Colors.yellow,
                                                                dataSource: data,
                                                                xValueMapper:
                                                                    (_SalesData sales,
                                                                            _) =>
                                                                        sales.year,
                                                                yValueMapper: (_SalesData
                                                                            sales,
                                                                        _) =>
                                                                    sales.Temperature,
                                                                name: 'Temperature',
                                                                dataLabelSettings:
                                                                    const DataLabelSettings(
                                                                        isVisible:
                                                                            true,
                                                                        color: Colors
                                                                            .black),
                                                              )
                                                            ])
                                                                                                            ]),
                                                          )),
                                                    ));
                                              });
                                        },
                                        child: ListTile(
                                          subtitle: Text('${TempMatrix[3][0]}°C',
                                              style: const TextStyle(
                                                  color: Colors.white, fontSize: 16)),
                                          leading: returnStatusImage(3),
                                          title: Text(
                                              '${Dayplusthree.substring(0, 3)}',
                                              style: const TextStyle(
                                                  color: Colors.white, fontSize: 16)),
                                          trailing: SingleChildScrollView(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            child: Row(
                                              mainAxisSize: MainAxisSize
                                                  .min, // Ensures the row only takes the minimum required space
                                              children: [
                                                // Add your widgets here
              
                                                Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        height: 40,
                                                        width: 40,
                                                        decoration: const BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    'lib/assets/heavy-rain.png'))),
                                                      ),
                                                      Text(
                                                        '${AVGPrec2[3].toInt()}%',
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                      )
                                                    ]),
              
                                                // Add spacing between widgets
                                                Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 16, right: 16),
                                                    child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            height: 35,
                                                            width: 35,
                                                            decoration: const BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        'lib/assets/clouddisplay.png'))),
                                                          ),
                                                          Text(
                                                              '${AVGCloud2[3].toInt()}%',
                                                              style: const TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 12))
                                                        ])),
                                                Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        height: 35,
                                                        width: 35,
                                                        decoration: const BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    'lib/assets/water2.png'))),
                                                      ),
                                                      Text('${HumiMatrix[3][0]}%',
                                                          style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 12))
                                                    ]),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: Divider(
                                          color: returnColorWidget(),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          data = [
                                            returnStats(1, 0, 0, 0, 0),
                                            returnStats(2, 4, 1, 4, 1),
                                            returnStats(3, 4, 2, 4, 2),
                                            returnStats(4, 4, 3, 4, 3),
                                            returnStats(5, 4, 4, 4, 4),
                                            returnStats(6, 4, 5, 4, 5),
                                            returnStats(7, 4, 6, 4, 6),
                                            returnStats(8, 4, 7, 4, 7),
                                            returnStats(9, 4, 8, 4, 8),
                                            returnStats(10, 4, 9, 4, 9),
                                            returnStats(11, 4, 10, 4, 10),
                                            returnStats(12, 4, 11, 4, 11)
                                          ];
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(29),
                                                            topRight:
                                                                Radius.circular(29)),
                                                    child: Container(
                                                      height: 1200,
                                                      decoration: const BoxDecoration(
                                                          gradient: LinearGradient(
                                                              colors: [
                                                            Color.fromARGB(
                                                                255, 27, 27, 27),
                                                            Color.fromARGB(
                                                                255, 31, 31, 31)
                                                          ],
                                                              begin:
                                                                  Alignment.topLeft,
                                                              end: Alignment
                                                                  .bottomRight)),
                                                      child: Container(
                                                          child: SingleChildScrollView(
                                                            child: Column(children: [
                                                                                                               SfCartesianChart(
                                                            onZoomStart:
                                                                (zoomingArgs) =>
                                                                    ZoomPanArgs(),
                                                            plotAreaBorderColor:
                                                                Colors.yellow,
                                                            plotAreaBackgroundColor:
                                                                Colors.grey[600],
                                                            primaryYAxis:
                                                                const CategoryAxis(
                                                              isVisible: false,
                                                            ),
                                                            primaryXAxis: const CategoryAxis(
                                                                labelStyle: TextStyle(
                                                                    color: Color.fromARGB(
                                                                        211, 255, 240, 240))),
                                                            title: ChartTitle(
                                                                text: '$Dayplusfour',
                                                                textStyle: const TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                            legend: const Legend(
                                                                isVisible: true,
                                                                textStyle: TextStyle(
                                                                    color:
                                                                        Colors.white,
                                                                    fontSize: 18)),
                                                            tooltipBehavior:
                                                                TooltipBehavior(enable: true, color: Colors.black),
                                                            series: <CartesianSeries<_SalesData, String>>[
                                                              LineSeries<_SalesData,
                                                                  String>(
                                                                color: Colors.blue,
                                                                dataSource: data,
                                                                xValueMapper:
                                                                    (_SalesData sales,
                                                                            _) =>
                                                                        sales.year,
                                                                yValueMapper:
                                                                    (_SalesData sales,
                                                                            _) =>
                                                                        sales.sales,
                                                                name:
                                                                    '$Precipitation',
                                                                dataLabelSettings:
                                                                    const DataLabelSettings(
                                                                        isVisible:
                                                                            true,
                                                                        color: Colors
                                                                            .black),
                                                              ),
                                                              
                                                            ]), SfCartesianChart(
                                                            onZoomStart:
                                                                (zoomingArgs) =>
                                                                    ZoomPanArgs(),
                                                            plotAreaBorderColor:
                                                                Colors.yellow,
                                                            plotAreaBackgroundColor:
                                                                Colors.grey[600],
                                                            primaryYAxis:
                                                                const CategoryAxis(
                                                              isVisible: false,
                                                            ),
                                                            primaryXAxis: const CategoryAxis(
                                                                labelStyle: TextStyle(
                                                                    color: Color.fromARGB(
                                                                        211, 255, 240, 240))),
                                                            title: ChartTitle(
                                                                
                                                                textStyle: const TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                            legend: const Legend(
                                                                isVisible: true,
                                                                textStyle: TextStyle(
                                                                    color:
                                                                        Colors.white,
                                                                    fontSize: 18)),
                                                            tooltipBehavior:
                                                                TooltipBehavior(enable: true, color: Colors.black),
                                                            series: <CartesianSeries<_SalesData, String>>[
                                                            
                                                              LineSeries<_SalesData,
                                                                  String>(
                                                                color: Colors.yellow,
                                                                dataSource: data,
                                                                xValueMapper:
                                                                    (_SalesData sales,
                                                                            _) =>
                                                                        sales.year,
                                                                yValueMapper: (_SalesData
                                                                            sales,
                                                                        _) =>
                                                                    sales.Temperature,
                                                                name: 'Temperature',
                                                                dataLabelSettings:
                                                                    const DataLabelSettings(
                                                                        isVisible:
                                                                            true,
                                                                        color: Colors
                                                                            .black),
                                                              )
                                                            ])
                                                                                                            ]),
                                                          )),
                                                    ));
                                              });
                                        },
                                        child: ListTile(
                                          subtitle: Text('${TempMatrix[4][0]}°C',
                                              style: const TextStyle(
                                                  color: Colors.white, fontSize: 16)),
                                          leading: returnStatusImage(4),
                                          title: Text(
                                              '${Dayplusfour.substring(0, 3)}',
                                              style: const TextStyle(
                                                  color: Colors.white, fontSize: 16)),
                                          trailing: SingleChildScrollView(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            child: Row(
                                              mainAxisSize: MainAxisSize
                                                  .min, // Ensures the row only takes the minimum required space
                                              children: [
                                                // Add your widgets here
              
                                                Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        height: 40,
                                                        width: 40,
                                                        decoration: const BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    'lib/assets/heavy-rain.png'))),
                                                      ),
                                                      Text(
                                                        '${AVGPrec2[4].toInt()}%',
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                      )
                                                    ]),
              
                                                // Add spacing between widgets
                                                Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 16, right: 16),
                                                    child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            height: 35,
                                                            width: 35,
                                                            decoration: const BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        'lib/assets/clouddisplay.png'))),
                                                          ),
                                                          Text(
                                                              '${AVGCloud2[4].toInt()}%',
                                                              style: const TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 12))
                                                        ])),
                                                Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        height: 35,
                                                        width: 35,
                                                        decoration: const BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    'lib/assets/water2.png'))),
                                                      ),
                                                      Text('${HumiMatrix[4][0]}%',
                                                          style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 12))
                                                    ]),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: Divider(
                                          color: returnColorWidget(),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          data = [
                                            returnStats(1, 0, 0, 0, 0),
                                            returnStats(2, 5, 1, 5, 1),
                                            returnStats(3, 5, 2, 5, 2),
                                            returnStats(4, 5, 3, 5, 3),
                                            returnStats(5, 5, 4, 5, 4),
                                            returnStats(6, 5, 5, 5, 5),
                                            returnStats(7, 5, 6, 5, 6),
                                            returnStats(8, 5, 7, 5, 7),
                                            returnStats(9, 5, 8, 5, 8),
                                            returnStats(10, 5, 9, 5, 9),
                                            returnStats(11, 5, 10, 5, 10),
                                            returnStats(12, 5, 11, 5, 11)
                                          ];
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(29),
                                                            topRight:
                                                                Radius.circular(29)),
                                                    child: Container(
                                                      height: 1200,
                                                      decoration: const BoxDecoration(
                                                          gradient: LinearGradient(
                                                              colors: [
                                                            Color.fromARGB(
                                                                255, 27, 27, 27),
                                                            Color.fromARGB(
                                                                255, 31, 31, 31)
                                                          ],
                                                              begin:
                                                                  Alignment.topLeft,
                                                              end: Alignment
                                                                  .bottomRight)),
                                                      child: Container(
                                                          child: SingleChildScrollView(
                                                            child: Column(children: [
                                                                                                               SfCartesianChart(
                                                            onZoomStart:
                                                                (zoomingArgs) =>
                                                                    ZoomPanArgs(),
                                                            plotAreaBorderColor:
                                                                Colors.yellow,
                                                            plotAreaBackgroundColor:
                                                                Colors.grey[600],
                                                            primaryYAxis:
                                                                const CategoryAxis(
                                                              isVisible: false,
                                                            ),
                                                            primaryXAxis: const CategoryAxis(
                                                                labelStyle: TextStyle(
                                                                    color: Color.fromARGB(
                                                                        211, 255, 240, 240))),
                                                            title: ChartTitle(
                                                                text: '$Dayplusfive',
                                                                textStyle: const TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                            legend: const Legend(
                                                                isVisible: true,
                                                                textStyle: TextStyle(
                                                                    color:
                                                                        Colors.white,
                                                                    fontSize: 18)),
                                                            tooltipBehavior:
                                                                TooltipBehavior(enable: true, color: Colors.black),
                                                            series: <CartesianSeries<_SalesData, String>>[
                                                              LineSeries<_SalesData,
                                                                  String>(
                                                                color: Colors.blue,
                                                                dataSource: data,
                                                                xValueMapper:
                                                                    (_SalesData sales,
                                                                            _) =>
                                                                        sales.year,
                                                                yValueMapper:
                                                                    (_SalesData sales,
                                                                            _) =>
                                                                        sales.sales,
                                                                name:
                                                                    '$Precipitation',
                                                                dataLabelSettings:
                                                                    const DataLabelSettings(
                                                                        isVisible:
                                                                            true,
                                                                        color: Colors
                                                                            .black),
                                                              ),
                                                              
                                                            ]), SfCartesianChart(
                                                            onZoomStart:
                                                                (zoomingArgs) =>
                                                                    ZoomPanArgs(),
                                                            plotAreaBorderColor:
                                                                Colors.yellow,
                                                            plotAreaBackgroundColor:
                                                                Colors.grey[600],
                                                            primaryYAxis:
                                                                const CategoryAxis(
                                                              isVisible: false,
                                                            ),
                                                            primaryXAxis: const CategoryAxis(
                                                                labelStyle: TextStyle(
                                                                    color: Color.fromARGB(
                                                                        211, 255, 240, 240))),
                                                            title: ChartTitle(
                                                                
                                                                textStyle: const TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                            legend: const Legend(
                                                                isVisible: true,
                                                                textStyle: TextStyle(
                                                                    color:
                                                                        Colors.white,
                                                                    fontSize: 18)),
                                                            tooltipBehavior:
                                                                TooltipBehavior(enable: true, color: Colors.black),
                                                            series: <CartesianSeries<_SalesData, String>>[
                                                            
                                                              LineSeries<_SalesData,
                                                                  String>(
                                                                color: Colors.yellow,
                                                                dataSource: data,
                                                                xValueMapper:
                                                                    (_SalesData sales,
                                                                            _) =>
                                                                        sales.year,
                                                                yValueMapper: (_SalesData
                                                                            sales,
                                                                        _) =>
                                                                    sales.Temperature,
                                                                name: 'Temperature',
                                                                dataLabelSettings:
                                                                    const DataLabelSettings(
                                                                        isVisible:
                                                                            true,
                                                                        color: Colors
                                                                            .black),
                                                              )
                                                            ])
                                                                                                            ]),
                                                          )),
                                                    ));
                                              });
                                        },
                                        child: ListTile(
                                          subtitle: Text('${TempMatrix[5][0]}°C',
                                              style: const TextStyle(
                                                  color: Colors.white, fontSize: 16)),
                                          leading: returnStatusImage(5),
                                          title: Text(
                                              '${Dayplusfive.substring(0, 3)}',
                                              style: const TextStyle(
                                                  color: Colors.white, fontSize: 16)),
                                          trailing: SingleChildScrollView(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            child: Row(
                                              mainAxisSize: MainAxisSize
                                                  .min, // Ensures the row only takes the minimum required space
                                              children: [
                                                // Add your widgets here
              
                                                Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        height: 40,
                                                        width: 40,
                                                        decoration: const BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    'lib/assets/heavy-rain.png'))),
                                                      ),
                                                      Text(
                                                        '${AVGPrec2[5].toInt()}%',
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                      )
                                                    ]),
              
                                                // Add spacing between widgets
                                                Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 16, right: 16),
                                                    child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            height: 35,
                                                            width: 35,
                                                            decoration: const BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        'lib/assets/clouddisplay.png'))),
                                                          ),
                                                          Text(
                                                              '${AVGCloud2[5].toInt()}%',
                                                              style: const TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 12))
                                                        ])),
                                                Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        height: 35,
                                                        width: 35,
                                                        decoration: const BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    'lib/assets/water2.png'))),
                                                      ),
                                                      Text('${HumiMatrix[5][0]}%',
                                                          style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 12))
                                                    ]),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: Divider(
                                          color: returnColorWidget(),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          data = [
                                            returnStats(1, 0, 0, 0, 0),
                                            returnStats(2, 6, 1, 6, 1),
                                            returnStats(3, 6, 2, 6, 2),
                                            returnStats(4, 6, 3, 6, 3),
                                            returnStats(5, 6, 4, 6, 4),
                                            returnStats(6, 6, 5, 6, 5),
                                            returnStats(7, 6, 6, 6, 6),
                                            returnStats(8, 6, 7, 6, 7),
                                            returnStats(9, 6, 8, 6, 8),
                                            returnStats(10, 6, 9, 6, 9),
                                            returnStats(11, 6, 10, 6, 10),
                                            returnStats(12, 6, 11, 6, 11)
                                          ];
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(29),
                                                            topRight:
                                                                Radius.circular(29)),
                                                    child: Container(
                                                      height: 1200,
                                                      decoration: const BoxDecoration(
                                                          gradient: LinearGradient(
                                                              colors: [
                                                            Color.fromARGB(
                                                                255, 27, 27, 27),
                                                            Color.fromARGB(
                                                                255, 31, 31, 31)
                                                          ],
                                                              begin:
                                                                  Alignment.topLeft,
                                                              end: Alignment
                                                                  .bottomRight)),
                                                      child: Container(
                                                          child: SingleChildScrollView(
                                                            child: Column(children: [
                                                                                                               SfCartesianChart(
                                                            onZoomStart:
                                                                (zoomingArgs) =>
                                                                    ZoomPanArgs(),
                                                            plotAreaBorderColor:
                                                                Colors.yellow,
                                                            plotAreaBackgroundColor:
                                                                Colors.grey[600],
                                                            primaryYAxis:
                                                                const CategoryAxis(
                                                              isVisible: false,
                                                            ),
                                                            primaryXAxis: const CategoryAxis(
                                                                labelStyle: TextStyle(
                                                                    color: Color.fromARGB(
                                                                        211, 255, 240, 240))),
                                                            title: ChartTitle(
                                                                text: '$Dayplussix',
                                                                textStyle: const TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                            legend: const Legend(
                                                                isVisible: true,
                                                                textStyle: TextStyle(
                                                                    color:
                                                                        Colors.white,
                                                                    fontSize: 18)),
                                                            tooltipBehavior:
                                                                TooltipBehavior(enable: true, color: Colors.black),
                                                            series: <CartesianSeries<_SalesData, String>>[
                                                              LineSeries<_SalesData,
                                                                  String>(
                                                                color: Colors.blue,
                                                                dataSource: data,
                                                                xValueMapper:
                                                                    (_SalesData sales,
                                                                            _) =>
                                                                        sales.year,
                                                                yValueMapper:
                                                                    (_SalesData sales,
                                                                            _) =>
                                                                        sales.sales,
                                                                name:
                                                                    '$Precipitation',
                                                                dataLabelSettings:
                                                                    const DataLabelSettings(
                                                                        isVisible:
                                                                            true,
                                                                        color: Colors
                                                                            .black),
                                                              ),
                                                              
                                                            ]), SfCartesianChart(
                                                            onZoomStart:
                                                                (zoomingArgs) =>
                                                                    ZoomPanArgs(),
                                                            plotAreaBorderColor:
                                                                Colors.yellow,
                                                            plotAreaBackgroundColor:
                                                                Colors.grey[600],
                                                            primaryYAxis:
                                                                const CategoryAxis(
                                                              isVisible: false,
                                                            ),
                                                            primaryXAxis: const CategoryAxis(
                                                                labelStyle: TextStyle(
                                                                    color: Color.fromARGB(
                                                                        211, 255, 240, 240))),
                                                            title: ChartTitle(
                                                                
                                                                textStyle: const TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                            legend: const Legend(
                                                                isVisible: true,
                                                                textStyle: TextStyle(
                                                                    color:
                                                                        Colors.white,
                                                                    fontSize: 18)),
                                                            tooltipBehavior:
                                                                TooltipBehavior(enable: true, color: Colors.black),
                                                            series: <CartesianSeries<_SalesData, String>>[
                                                            
                                                              LineSeries<_SalesData,
                                                                  String>(
                                                                color: Colors.yellow,
                                                                dataSource: data,
                                                                xValueMapper:
                                                                    (_SalesData sales,
                                                                            _) =>
                                                                        sales.year,
                                                                yValueMapper: (_SalesData
                                                                            sales,
                                                                        _) =>
                                                                    sales.Temperature,
                                                                name: 'Temperature',
                                                                dataLabelSettings:
                                                                    const DataLabelSettings(
                                                                        isVisible:
                                                                            true,
                                                                        color: Colors
                                                                            .black),
                                                              )
                                                            ])
                                                                                                            ]),
                                                          )),
                                                    ));
                                              });
                                        },
                                        child: ListTile(
                                          subtitle: Text('${TempMatrix[6][0]}°C',
                                              style: const TextStyle(
                                                  color: Colors.white, fontSize: 16)),
                                          leading: returnStatusImage(6),
                                          title: Text('${Dayplussix.substring(0, 3)}',
                                              style: const TextStyle(
                                                  color: Colors.white, fontSize: 16)),
                                          trailing: SingleChildScrollView(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            child: Row(
                                              mainAxisSize: MainAxisSize
                                                  .min, // Ensures the row only takes the minimum required space
                                              children: [
                                                // Add your widgets here
              
                                                Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        height: 40,
                                                        width: 40,
                                                        decoration: const BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    'lib/assets/heavy-rain.png'))),
                                                      ),
                                                      Text(
                                                        '${AVGPrec2[6].toInt()}%',
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                      )
                                                    ]),
              
                                                // Add spacing between widgets
                                                Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 16, right: 16),
                                                    child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            height: 35,
                                                            width: 35,
                                                            decoration: const BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        'lib/assets/clouddisplay.png'))),
                                                          ),
                                                          Text(
                                                              '${AVGCloud2[6].toInt()}%',
                                                              style: const TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 12))
                                                        ])),
                                                Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        height: 35,
                                                        width: 35,
                                                        decoration: const BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    'lib/assets/water2.png'))),
                                                      ),
                                                      Text('${HumiMatrix[6][0]}%',
                                                          style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 12))
                                                    ]),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: Divider(
                                          color: returnColorWidget(),
                                        ),
                                      )
                                    ])
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: MyContainerOne(
                    height: 60,
                    width: 400,
                    color: returnColorWidget(),
                    child: Center(
              child: TextScroll(
                textAlign: TextAlign.center,
                '$AveragePrec ${AVGPrec2[0].toStringAsFixed(2)}%                                                   Wind Speed is at ${currentwindspeed}km/h                                                    Cloud Presence ${currentCloudNow}%                                                            ',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                ),
              ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 600,
                height: 200,
                child: AbsorbPointer(
                  absorbing: true,
                  child: GridView.count(
                    crossAxisCount: 2,
                    padding: EdgeInsets.zero, // Remove GridView padding
                    mainAxisSpacing: 4, // Remove main axis spacing
                    crossAxisSpacing: 4, // Remove cross axis spacing
                    children: [
              Padding(
                padding: const EdgeInsets.only(top: 18), // Remove Padding
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: MyContainerOne(
                    color: returnColorWidget(),
                    height: 400,
                    width: 400,
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('lib/assets/clouddisplay.png'),
                            ),
                          ),
                          width: 60,
                          height: 80,
                        ),
                        Text(
                          '$currentCloudNow%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 27,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18), // Remove Padding
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: MyContainerOne(
                    color: returnColorWidget(),
                    height: 400,
                    width: 400,
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('lib/assets/wind.png'),
                            ),
                          ),
                          height: 80,
                          width: 60,
                        ),
                        Text(
                          '${currentwindspeed}km/h',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 27,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  bottom: 8.0,
                 
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: MyContainerOne(
                    height: 80,
                    color: returnColorWidget(),
                    width: 450,
                    child: Center(
              child: ListTile(
                title: Text(
                  '${DewMatrix[0][4]}',
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  'Dewpoint',
                  style: TextStyle(color: Colors.white),
                ),
                leading: const Icon(
                  Icons.dew_point,
                  size: 50,
                  color: Colors.white,
                ),
              ),
                    ),
                  ),
                ),
              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SettingsPage()
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }

void showCustomDialog(BuildContext context, String title, String description, VoidCallback onPressed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title,style: const TextStyle(color: Colors.white,fontSize: 32)),
        content: Text(description,style: const TextStyle(color: Colors.white,fontSize: 24)),
        actions: <Widget>[
          
          TextButton(
            onPressed: (){Navigator.pop(context);},
            child: const Text('OK'),

          ),
          /*AbsorbPointer(absorbing:true,child:YoutubePlayer(
          controller: YoutubePlayerController(
            initialVideoId: '6dp-bvQ7RWo',
            flags: const YoutubePlayerFlags(
              autoPlay: true,
              mute: false,
            ),
          ),
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.blueAccent,
          progressColors: const ProgressBarColors(
            playedColor: Colors.blue,
            handleColor: Colors.blueAccent,
          ),
          
        ),)*/
      
    
        ],
        backgroundColor: returnColorWidget(),
      );
    },
  );
}



  dynamic returnImageWidget() {
    if (AVGCloud2[0] > 70) {
      return const AssetImage(
        'lib/assets/sky.jpg',
      );
    } else {
      return const AssetImage(
        'lib/assets/sky1.jpg',
      );
    }
  }

  dynamic returnColorWidget() {
    if (AVGCloud2[0] > 70) {
      return colornight = const Color.fromARGB(129, 105, 105, 105);
    } else {
      return colorDay = const Color.fromARGB(133, 50, 127, 190);
    }
  }

  dynamic returnStats(
      hourindex, precindexone, precindextwo, tempindexone, tempindextwo) {
    return _SalesData(
        '${hourindex}AM',
        PrecMatrix[precindexone][precindextwo].toDouble(),
        TempMatrix[tempindexone][tempindextwo].toDouble());
  }

  void returnCloud() {
    for (int dayflag = 0; dayflag <= 6; dayflag++) {
      for (int i = 0; i <= 23; i++) {
        AVGCloud = AVGCloud + CloudMatrix[dayflag][i];
      }
      realAVGCloud = (AVGCloud / 24);
      AVGCloud2[dayflag] = realAVGCloud;
      AVGCloud = 0;
    }
  }

  void returnPrec() {
    for (int dayflag = 0; dayflag <= 6; dayflag++) {
      for (int i = 0; i <= 23; i++) {
        AVGprec = AVGprec + PrecMatrix[dayflag][i];
      }
      realAVGPrec = (AVGprec / 24);
      AVGPrec2[dayflag] = realAVGPrec;
      AVGprec = 0;
    }
  }

  dynamic returnStatusImage(i) {
    if (AVGPrec2[i] > 40) {
      return Container(
        height: 35,
        width: 35,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/assets/heavy-rain.png'))),
      );
    } else if (AVGCloud2[i] > 60) {
      return Container(
        height: 35,
        width: 35,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/assets/clouddisplay.png'))),
      );
    } else {
      return Container(
        height: 35,
        width: 35,
        decoration: const BoxDecoration(
            image:
                DecorationImage(image: AssetImage('lib/assets/sun (2).png'))),
      );
    }
  }

  dynamic returnStatusMainImage(i) {
    if (AVGPrec2[i] > 40) {
      return Container(
        height: 100,
        width: 200,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/assets/heavy-rain.png'), scale: 2)),
      );
    } else if (AVGCloud2[i] > 60) {
      return Container(
        height: 100,
        width: 200,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/assets/clouddisplay.png'), scale: 2)),
      );
    } else {
      return Container(
        height: 100,
        width: 200,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/assets/sun (2).png'), scale: 2)),
      );
    }
  }

  dynamic returnStatusHourImage(i) {
    if (PrecMatrix[0][i] > 40) {
      return Container(
        height: 40,
        width: 60,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/assets/heavy-rain.png'),
                fit: BoxFit.contain)),
      );
    } else if (CloudMatrix[0][i] > 60) {
      return Container(
        height: 40,
        width: 60,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/assets/clouddisplay.png'),
                fit: BoxFit.contain)),
      );
    } else {
      return Container(
        height: 40,
        width: 60,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/assets/sun (2).png'),
                fit: BoxFit.contain)),
      );
    }
  }

  dynamic WidgetBuilder(i, y) {
    dynamic Widget = returnStatusHourImage(i);
    DateTime now = DateTime.now();

    // Add one hour to the current time
    DateTime oneHourLater = now.add(Duration(hours: i + 6));

    // Format the DateTime to display only the hour
    String currentHour = DateFormat('HH').format(now);
    String oneHourLaterFormatted = DateFormat('HH').format(oneHourLater);
    return Column(children: [
      Widget,
      Text(
        '${oneHourLaterFormatted}:00',
        style: const TextStyle(fontSize: 18, color: Colors.white),
      )
    ]);
  }
}

class DialogueMenu {
  static Future<void> show(BuildContext context, String title,
      List<String> options, Function(int) onSelected) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: options.asMap().entries.map((entry) {
                int index = entry.key;
                String option = entry.value;
                return ListTile(
                  title: Text(option),
                  onTap: () {
                    Navigator.of(context).pop();
                    onSelected(index);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 111, 173),
      body: Center(
        child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(255, 65, 138, 206),
              Color.fromARGB(255, 24, 111, 173),
            ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: Column(children: [
              Container(
                  decoration: const BoxDecoration(color: Colors.transparent),
                  height: 400,
                  width: 200,
                  child: ChoiceWidget()),
              GestureDetector(
                  onTap: _launchUrl,
                  child: Container(
                      height: 200,
                      width: 240,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('lib/assets/25231.png')))))
            ])),
      ),
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double _prefferedHeight = 56.0;
  final List<Color> _colors;

  GradientAppBar({required List<Color> colors}) : _colors = colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _colors,
          begin: Alignment.topRight,
          end: Alignment.topLeft,
        ),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent, // Make the app bar transparent
        elevation: 0, // Remove the shadow
        // Other properties of your AppBar
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_prefferedHeight);
}

class ChoiceWidget extends StatefulWidget {
  @override
  _ChoiceWidgetState createState() => _ChoiceWidgetState();
}

class _ChoiceWidgetState extends State<ChoiceWidget> {
  // default choice

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('$Language'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: ListTile(
              title: Text('$English'),
              leading: Radio(
                activeColor: Colors.blue,
                value: 0,
                groupValue: currentSelected,
                onChanged: (value) {
                  setState(() {
                    currentSelected = value;
                    currentSelected = value;
                    //saveData(currentSelected);
                    // apparentText = 'Apparent Temperature';
                    first = 'Monday';
                    second = 'Tuesday';
                    third = 'Wednesday';
                    fourth = 'Thursday';
                    fifth = 'Friday';
                    sixth = 'Saturday';
                    seventh = 'Sunday';
                    country = 'Japan';
                    month = 'March';
                    today = 'Today';
                    tomorrow = 'Tomorrow';
                    hour = 'hr';
                    Language = 'Language';
                    English = 'English';
                    Japanese = 'Japanese';
                    LiveTimeWidget(month: month);
                    /* SettingsLang = 'Settings';
        NotifyMes = 'Choose a language';
        AverageHum = 'Average Humidity';*/
                    AveragePrec = 'Average Precipitation';
                    /*AverageTemp = 'Average Temperature';
        Stats = 'Stats';*/
                    city = "Tokyo";
                    /* changeTime0 = "Change Time";
        selectTime0 = "Select a Time";
        okay0 = "Confirm";
        cancel0 = "Cancel";*/
                    Precipitation =
                        "Precipitation"; /*
        Temperature = "Temperature";
        Humidity = "Humidity";
        Show = "Show";
        textCloud = 'Cloud Cover:';
        ClearCondition = 'Clear';
        windText = 'Wind Speed';*/
                  });
                },
              ),
            ),
          ),
          ListTile(
            title: Text('$Japanese'),
            leading: Radio(
              activeColor: const Color.fromARGB(134, 0, 106, 192),
              value: 2,
              groupValue: currentSelected,
              onChanged: (value) {
                setState(() {
                  currentSelected = value;
                  currentSelected = value;
                  //saveData(currentSelected);
                  /* ClearCondition = '晴れ';
        apparentText = '体感温度'; */
                  today = '今日';
                  month = '四月';
                  Language = '言語';
                  English = '英語';
                  Japanese = '日本語';
                  LiveTimeWidget(month: month);
                  first = '月曜日';
                  second = '火曜日';
                  third = '水曜日';
                  fourth = '木曜日';
                  fifth = '金曜日';
                  sixth = '土曜日';
                  seventh = '日曜日';
                  country = '日本';
                  tomorrow = '明日';
                  hour = '時';
                  /* SettingsLang = '設定言語';
        NotifyMes = '言語を選択';
        AverageHum = '平均湿度';*/
                  AveragePrec = '平均降水量';
                  /* AverageTemp = '平均気温';
        Stats = '統計';*/
                  city = "東京";
                  /* changeTime0 = "時間を変更する";
        selectTime0 = "時間を選択してください ";
        okay0 = "確認する";
        cancel0 = "キャンセル";*/
                  Precipitation =
                      '降水量'; /*
        Temperature = "温度";
        Humidity = "湿度";
        Show = "表示";
        textCloud = '雲量';
        windText = '風速';*/
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales, this.Temperature);
  final double Temperature;
  final String year;
  final double sales;
}

/*Future<void> saveData(x) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('key', x);
}

// Reading data from SharedPreferences
Future<int?> fetchData2() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('key');
}
 

void checkLanguage() {
  if (fetchData2() == 0) {
first = 'Monday';
        second = 'Tuesday';
        third = 'Wednesday';
        fourth = 'Thursday';
        fifth = 'Friday';
        sixth = 'Saturday';
        seventh = 'Sunday';
        country = 'Japan';
        month = 'March';
        today = 'Today';
        tomorrow = 'Tomorrow';
        hour = 'hr';
        Language = 'Language';
        English = 'English';
        Japanese = 'Japanese';
         LiveTimeWidget(month: month);
       /* SettingsLang = 'Settings';
        NotifyMes = 'Choose a language';
        AverageHum = 'Average Humidity';*/
        AveragePrec = 'Average Precipitation';
      /*AverageTemp = 'Average Temperature';
        Stats = 'Stats';*/
        city = "Tokyo";
       /* changeTime0 = "Change Time";
        selectTime0 = "Select a Time";
        okay0 = "Confirm";
        cancel0 = "Cancel";*/
        Precipitation = "Precipitation";/*
        Temperature = "Temperature";
        Humidity = "Humidity";
        Show = "Show";
        textCloud = 'Cloud Cover:';
        ClearCondition = 'Clear';
        windText = 'Wind Speed';*/}
        else {
        /* ClearCondition = '晴れ';
        apparentText = '体感温度'; */
        today = '今日';
        month = '四月';
        Language = '言語';
        English = '英語';
        Japanese = '日本語';
        LiveTimeWidget(month: month);
        first = '月曜日';
        second = '火曜日';
        third = '水曜日';
        fourth = '木曜日';
        fifth = '金曜日';
        sixth = '土曜日';
        seventh = '日曜日';
        country = '日本';
        tomorrow = '明日';
        hour = '時';
       /* SettingsLang = '設定言語';
        NotifyMes = '言語を選択';
        AverageHum = '平均湿度';*/
        AveragePrec = '平均降水量';
       /* AverageTemp = '平均気温';
        Stats = '統計';*/
        city = "東京";
       /* changeTime0 = "時間を変更する";
        selectTime0 = "時間を選択してください ";
        okay0 = "確認する";
        cancel0 = "キャンセル";*/
        Precipitation = '降水量'; /*
        Temperature = "温度";
        Humidity = "湿度";
        Show = "表示";
        textCloud = '雲量';
        windText = '風速';*/
        }
        }*/