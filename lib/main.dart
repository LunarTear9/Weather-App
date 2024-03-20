import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:newweatherapp/TimeChanger.dart';
import 'package:newweatherapp/container.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
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
double realAVGPrec = 0;
double AVGprec = 0;
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
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 34),
    _SalesData('Apr', 32),
    _SalesData('May', 40),
    _SalesData('May', 40),
    _SalesData('May', 40)
  ];



void main() {
  runApp(const MaterialApp(home:MainHomeScreen(),debugShowCheckedModeBanner: false,));
  tzdata.initializeTimeZones();
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
  late List<double> hourlyTemperature;
  late List<int> precipitationperhour;
  late List<int> totalhumidity;
  int _selectedIndex = 0;
  bool loading = true;

  List<List<int>> CloudMatrix =
      List.generate(7, (index) => List<int>.filled(24, 0));
  List<List<double>> TempMatrix =
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
          'https://api.open-meteo.com/v1/forecast?latitude=$long.6854&longitude=$lat.7531&current=temperature_2m,apparent_temperature,precipitation,cloud_cover,relative_humidity_2m,wind_speed_10m&hourly=temperature_2m,relative_humidity_2m,precipitation_probability,cloud_cover'));

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
        loading = false; // Set loading to false when data fetching is complete
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
    
    return MaterialApp(
     debugShowCheckedModeBanner: false,
      home: Scaffold(
        
        bottomNavigationBar: CurvedNavigationBar(index:_selectedIndex,items: [const CurvedNavigationBarItem(child: const Icon(Icons.home),),const CurvedNavigationBarItem(child: Icon(Icons.settings))],height: 26,color: Colors.blue,onTap: (index) 
{
          setState(() {
            _selectedIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          });
        },
        ),
      
        body: PageView(

          
          scrollDirection: Axis.horizontal,
          
          onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
            
          });
        },
          controller: _pageController,
          children: [Center(
            child: Container(
              padding: const EdgeInsets.only(top: 20,left:20,right:20),
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/sky1.jpg',),fit: BoxFit.fill),
                
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 4,
                      height: 0,
                    ),
                    LiveTimeWidget(month: month),const SizedBox(width: 100,height: 10,),Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [ IconButton(onPressed: (){
                        //setState(() {
                        //  if (long == 35) {

                           // long = 39;
                          //  lat = 22;
                          //}
                          //else {

                        //   long = 35;
                        //   lat = 139;
                        //  }
                        //  fetchData();
                        //});
                      }, icon: const Icon(Icons.location_pin,size: 100,color: Colors.white) ),Text('$country ,$city',style: const TextStyle(color: Colors.white,fontSize: 32),)]),
          
                      
                    ),
                    Row(mainAxisSize:MainAxisSize.min,
                      children: [
                      Column(children: [
                        const Icon(
                          CupertinoIcons.thermometer,color: Colors.white,
                          size: 56,
                        ),
                        Text(
                          '${currentTemperatureNow}°C',
                          style: const TextStyle(fontSize: 23,color: Colors.white),
                        )
                      ]),
                      Padding(
                        padding: const EdgeInsets.only(left:40.0,right: 40.0),
                        child: Column(children: [
                          Container(height:55,width:55,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/heavy-rain3.png')))),
                          Text(
                            '${currentPrecipitationNow}%',
                            style: const TextStyle(fontSize: 23,color: Colors.white),
                          )
                        ]),
                      ),
                      Column(children: [
                         Container(height:55,width:50,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/water2.png'))),),
                        Text(
                          '${currentHumidityNow}%',
                          style: const TextStyle(fontSize: 23,color: Colors.white),
                        )
                      ])
                    ]),Visibility(child:const CircularProgressIndicator(),visible: loading),
                    // Add some spacing
                
                    const SizedBox(height: 20.0), // Add some spacing
                    ClipRRect(borderRadius: BorderRadius.circular(20),child:MyContainerOne(height: 80, width: 420,child: ListView(scrollDirection:Axis.horizontal,children: [Padding(
                      padding: const EdgeInsets.only(left:15.0,top:10.0),
                      child: Column(children: [
                           Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/heavy-rain2.png'))),),
                          Text(
                            '${PrecMatrix[0][0]}%',
                            style: const TextStyle(fontSize: 23,color: Colors.white),
                          )
                        ]),
                    ), Text('+1$hour',style: const TextStyle(color: Color.fromARGB(255, 0, 42, 77),fontWeight: FontWeight.bold),),Padding(
                      padding: const EdgeInsets.only(left:15.0,top:10.0),
                      child: Column(children: [
                           Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/heavy-rain2.png'))),),
                          Text(
                            '${PrecMatrix[0][2]}%',
                            style: const TextStyle(fontSize: 23,color: Colors.white),
                          )
                        ]),
                    ), Text('+2$hour',style: const TextStyle(color: Color.fromARGB(255, 0, 42, 77),fontWeight: FontWeight.bold),),Padding(
                      padding: const EdgeInsets.only(left:15.0,top:10.0),
                      child: Column(children: [
                           Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/heavy-rain2.png'))),),
                          Text(
                            '${PrecMatrix[0][3]}%',
                            style: const TextStyle(fontSize: 23,color: Colors.white),
                          )
                        ]),
                    ), Text('+3$hour',style: const TextStyle(color: Color.fromARGB(255, 0, 42, 77),fontWeight: FontWeight.bold),),Padding(
                      padding: const EdgeInsets.only(left:15.0,top:10.0),
                      child: Column(children: [
                           Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/heavy-rain2.png'))),),
                          Text(
                            '${PrecMatrix[0][4]}%',
                            style: const TextStyle(fontSize: 23,color: Colors.white),
                          )
                        ]),
                    ), Text('+4$hour',style: const TextStyle(color: Color.fromARGB(255, 0, 42, 77),fontWeight: FontWeight.bold),),Padding(
                      padding: const EdgeInsets.only(left:15.0,top:10.0),
                      child: Column(children: [
                           Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/heavy-rain2.png'))),),
                          Text(
                            '${PrecMatrix[0][5]}%',
                            style: const TextStyle(fontSize: 23,color: Colors.white),
                          )
                        ]),
                    ), Text('+5$hour',style: const TextStyle(color: Color.fromARGB(255, 0, 42, 77),fontWeight: FontWeight.bold),),Padding(
                      padding: const EdgeInsets.only(left:15.0,top:10.0),
                      child: Column(children: [
                           Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/heavy-rain2.png'))),),
                          Text(
                            '${PrecMatrix[0][6]}%',
                            style: const TextStyle(fontSize: 23,color: Colors.white),
                          )
                        ]),
                    ), Text('+6$hour',style: const TextStyle(color: Color.fromARGB(255, 0, 42, 77),fontWeight: FontWeight.bold),),Padding(
                      padding: const EdgeInsets.only(left:15.0,top:10.0),
                      child: Column(children: [
                           Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/heavy-rain2.png'))),),
                          Text(
                            '${PrecMatrix[0][7]}%',
                            style: const TextStyle(fontSize: 23,color: Colors.white),
                          )
                        ]),
                    ), Text('+7$hour',style: const TextStyle(color: Color.fromARGB(255, 0, 42, 77),fontWeight: FontWeight.bold),),Padding(
                      padding: const EdgeInsets.only(left:15.0,top:10.0),
                      child: Column(children: [
                           Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/heavy-rain2.png'))),),
                          Text(
                            '${PrecMatrix[0][8]}%',
                            style: const TextStyle(fontSize: 23,color: Colors.white),
                          )
                        ]),
                    ), Text('+8$hour',style: const TextStyle(color: Color.fromARGB(255, 0, 42, 77),fontWeight: FontWeight.bold),),Padding(
                      padding: const EdgeInsets.only(left:15.0,top:10.0),
                      child: Column(children: [
                           Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/heavy-rain2.png'))),),
                          Text(
                            '${PrecMatrix[0][9]}%',
                            style: const TextStyle(fontSize: 23,color: Colors.white),
                          )
                        ]),
                    ), Text('+9$hour',style: const TextStyle(color: Color.fromARGB(255, 0, 42, 77),fontWeight: FontWeight.bold),),Padding(
                      padding: const EdgeInsets.only(left:5.0,top:10.0),
                      child: Column(children: [
                           Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/heavy-rain2.png'))),),
                          Text(
                            '${PrecMatrix[0][10]}%',
                            style: const TextStyle(fontSize: 23,color: Colors.white),
                          )
                        ]),
                    ), Text('+10$hour',style: const TextStyle(color: Color.fromARGB(255, 0, 42, 77),fontWeight: FontWeight.bold,),),const Padding(
                      padding: EdgeInsets.only(top:10.0),
                      
                    ),]))),const Padding(
                      padding: EdgeInsets.symmetric(horizontal:16.0),
                      child: Divider(color: Color.fromARGB(255, 130, 215, 255),),
                    ),ClipRRect(borderRadius:BorderRadius.circular(20),child:Container(
                      height: 240,width: 400,
                      color: const Color.fromARGB(134, 0, 106, 192),child: ListView(padding: const EdgeInsets.all(8),
                        children: [Column(children: [const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Divider(color: Colors.blue),
                        ),InkWell(onTap: () {
                          data = [
    _SalesData('1AM', PrecMatrix[0][0].toDouble()),
    _SalesData('2AM', PrecMatrix[0][1].toDouble()),
    _SalesData('3AM', PrecMatrix[0][2].toDouble()),
    _SalesData('4AM', PrecMatrix[0][3].toDouble()),
    _SalesData('5AM', PrecMatrix[0][4].toDouble()),
    _SalesData('6AM', PrecMatrix[0][5].toDouble()),
    _SalesData('7AM', PrecMatrix[0][7].toDouble()),
    _SalesData('8AM', PrecMatrix[0][8].toDouble()),
    _SalesData('9AM', PrecMatrix[0][9].toDouble()),
    _SalesData('10AM', PrecMatrix[0][10].toDouble()),
    _SalesData('11AM', PrecMatrix[0][11].toDouble()),
    _SalesData('12PM', PrecMatrix[0][12].toDouble()),
   
    
  ];
                          showModalBottomSheet(context: context, builder: (BuildContext context) {return ClipRRect(borderRadius: const BorderRadius.only(topLeft: Radius.circular(29)   ,topRight: Radius.circular(29)),child:Container(child: Container(child: Column(children: [SfCartesianChart(onZoomStart:(zoomingArgs) => ZoomPanArgs(),plotAreaBorderColor: Colors.yellow,plotAreaBackgroundColor:  Colors.grey[600],primaryYAxis: CategoryAxis(isVisible: false,),primaryXAxis: CategoryAxis(labelStyle: TextStyle(color: Color.fromARGB(211, 255, 240, 240))),title: ChartTitle(text: '$StartingDay',textStyle: TextStyle(color: Colors.white)),legend: Legend(isVisible: true,textStyle: TextStyle(color: Colors.white,fontSize: 18)),tooltipBehavior: TooltipBehavior(enable: true,color: Colors.white),series: <CartesianSeries<_SalesData, String>>[LineSeries<_SalesData, String>(color: Colors.white,dataSource: data,xValueMapper: (_SalesData sales, _) => sales.year,yValueMapper: (_SalesData sales, _) => sales.sales,name: 'Precipitation',dataLabelSettings: DataLabelSettings(isVisible: true,color: Colors.white),)])])),height: 1200,decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color.fromARGB(255, 27, 27, 27),Color.fromARGB(255, 31, 31, 31)],begin: Alignment.topLeft,end: Alignment.bottomRight)),));});},
                          child: ListTile(
                                          subtitle: Text('$currentTemperatureNow°C', style: const TextStyle(color: Colors.white, fontSize: 16)),
                                          leading: returnStatusImage(0),
                                          title: Text('$today', style: const TextStyle(color: Colors.white, fontSize: 16)),
                                          trailing: SingleChildScrollView(physics: const NeverScrollableScrollPhysics(),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min, // Ensures the row only takes the minimum required space
                                              children: [
                          // Add your widgets here
                                               
                           Column(mainAxisSize: MainAxisSize.min,children: [Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/heavy-rain2.png'))),),Text('${AVGPrec2[0].toInt()}%',style: const TextStyle(color: Colors.white,fontSize: 12),)]),
                          
                          // Add spacing between widgets
                          Padding(padding: const EdgeInsets.only(left: 16,right: 16),child:Column(mainAxisSize: MainAxisSize.min,children: [Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/cloud.png'))),),Text('${AVGCloud2[0].toInt()}%',style: const TextStyle(color: Colors.white,fontSize: 12))])),
                          Column(mainAxisSize: MainAxisSize.min,children: [Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/water.png'))),),Text('$currentHumidityNow%',style: const TextStyle(color: Colors.white,fontSize: 12))]),
                          
                                              ],
                                            ),
                                          ),
                                        ),
                        )
                ,const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Divider(color: Colors.blue),
                        ),InkWell(onTap: () {
                          data = [
    _SalesData('1AM', PrecMatrix[1][0].toDouble()),
    _SalesData('2AM', PrecMatrix[1][1].toDouble()),
    _SalesData('3AM', PrecMatrix[1][2].toDouble()),
    _SalesData('4AM', PrecMatrix[1][3].toDouble()),
    _SalesData('5AM', PrecMatrix[1][4].toDouble()),
    _SalesData('6AM', PrecMatrix[1][5].toDouble()),
    _SalesData('7AM', PrecMatrix[1][7].toDouble()),
    _SalesData('8AM', PrecMatrix[1][8].toDouble()),
    _SalesData('9AM', PrecMatrix[1][9].toDouble()),
    _SalesData('10AM', PrecMatrix[1][10].toDouble()),
    _SalesData('11AM', PrecMatrix[1][11].toDouble()),
    _SalesData('12PM', PrecMatrix[1][12].toDouble()),
   
    
  ];
                          showModalBottomSheet(context: context, builder: (BuildContext context) {return ClipRRect(borderRadius: const BorderRadius.only(topLeft: Radius.circular(29)   ,topRight: Radius.circular(29)),child:Container(child: Container(child: Column(children: [SfCartesianChart(onZoomStart:(zoomingArgs) => ZoomPanArgs(),plotAreaBorderColor: Colors.yellow,plotAreaBackgroundColor:  Colors.grey[600],primaryYAxis: CategoryAxis(isVisible: false,),primaryXAxis: CategoryAxis(labelStyle: TextStyle(color: Color.fromARGB(211, 255, 240, 240))),title: ChartTitle(text: '$Dayplusone',textStyle: TextStyle(color: Colors.white)),legend: Legend(isVisible: true,textStyle: TextStyle(color: Colors.white,fontSize: 18)),tooltipBehavior: TooltipBehavior(enable: true,color: Colors.white),series: <CartesianSeries<_SalesData, String>>[LineSeries<_SalesData, String>(color: Colors.white,dataSource: data,xValueMapper: (_SalesData sales, _) => sales.year,yValueMapper: (_SalesData sales, _) => sales.sales,name: 'Precipitation',dataLabelSettings: DataLabelSettings(isVisible: true,color: Colors.white),)])])),height: 1200,decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color.fromARGB(255, 27, 27, 27),Color.fromARGB(255, 31, 31, 31)],begin: Alignment.topLeft,end: Alignment.bottomRight)),));});},
                          child: ListTile(
                                            subtitle: Text('${TempMatrix[1][0]}°C', style: const TextStyle(color: Colors.white, fontSize: 16)),
                                            leading: returnStatusImage(1),
                                            title: Text('$tomorrow', style: const TextStyle(color: Colors.white, fontSize: 16)),
                                            trailing: SingleChildScrollView(physics: const NeverScrollableScrollPhysics(),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min, // Ensures the row only takes the minimum required space
                                                children: [
                          // Add your widgets here
                                                 
                           Column(mainAxisSize: MainAxisSize.min,children: [Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/heavy-rain2.png'))),),Text('${AVGPrec2[1].toInt()}%',style: const TextStyle(color: Colors.white,fontSize: 12),)]),
                          
                          // Add spacing between widgets
                          Padding(padding: const EdgeInsets.only(left: 16,right: 16),child:Column(mainAxisSize: MainAxisSize.min,children: [Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/cloud.png'))),),Text('${AVGPrec2[1].toInt()}%',style: const TextStyle(color: Colors.white,fontSize: 12))])),
                          Column(mainAxisSize: MainAxisSize.min,children: [Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/water.png'))),),Text('${HumiMatrix[1][0]}%',style: const TextStyle(color: Colors.white,fontSize: 12))]),
                          
                                                ],
                                              ),
                                            ),
                                          ),
                        )
                ,const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Divider(color: Colors.blue),
                        ),InkWell(onTap: () {
                          data = [
    _SalesData('1AM', PrecMatrix[2][0].toDouble()),
    _SalesData('2AM', PrecMatrix[2][1].toDouble()),
    _SalesData('3AM', PrecMatrix[2][2].toDouble()),
    _SalesData('4AM', PrecMatrix[2][3].toDouble()),
    _SalesData('5AM', PrecMatrix[2][4].toDouble()),
    _SalesData('6AM', PrecMatrix[2][5].toDouble()),
    _SalesData('7AM', PrecMatrix[2][7].toDouble()),
    _SalesData('8AM', PrecMatrix[2][8].toDouble()),
    _SalesData('9AM', PrecMatrix[2][9].toDouble()),
    _SalesData('10AM', PrecMatrix[2][10].toDouble()),
    _SalesData('11AM', PrecMatrix[2][11].toDouble()),
    _SalesData('12PM', PrecMatrix[2][12].toDouble()),
   
    
  ];
                          showModalBottomSheet(context: context, builder: (BuildContext context) {return ClipRRect(borderRadius: const BorderRadius.only(topLeft: Radius.circular(29)   ,topRight: Radius.circular(29)),child:Container(child: Container(child: Column(children: [SfCartesianChart(onZoomStart:(zoomingArgs) => ZoomPanArgs(),plotAreaBorderColor: Colors.yellow,plotAreaBackgroundColor:  Colors.grey[600],primaryYAxis: CategoryAxis(isVisible: false,),primaryXAxis: CategoryAxis(labelStyle: TextStyle(color: Color.fromARGB(211, 255, 240, 240))),title: ChartTitle(text: '$Dayplustwo',textStyle: TextStyle(color: Colors.white)),legend: Legend(isVisible: true,textStyle: TextStyle(color: Colors.white,fontSize: 18)),tooltipBehavior: TooltipBehavior(enable: true,color: Colors.white),series: <CartesianSeries<_SalesData, String>>[LineSeries<_SalesData, String>(color: Colors.white,dataSource: data,xValueMapper: (_SalesData sales, _) => sales.year,yValueMapper: (_SalesData sales, _) => sales.sales,name: 'Precipitation',dataLabelSettings: DataLabelSettings(isVisible: true,color: Colors.white),)])])),height: 1200,decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color.fromARGB(255, 27, 27, 27),Color.fromARGB(255, 31, 31, 31)],begin: Alignment.topLeft,end: Alignment.bottomRight)),));});},
                          child: ListTile(
                                            subtitle: Text('${TempMatrix[2][0]}°C', style: const TextStyle(color: Colors.white, fontSize: 16)),
                                            leading: returnStatusImage(2),
                                            title: Text('${Dayplustwo.substring(0, 3)}', style: const TextStyle(color: Colors.white, fontSize: 16)),
                                            trailing: SingleChildScrollView(physics: const NeverScrollableScrollPhysics(),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min, // Ensures the row only takes the minimum required space
                                                children: [
                          // Add your widgets here
                                                 
                           Column(mainAxisSize: MainAxisSize.min,children: [Container(height:40,width:40,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/heavy-rain2.png'))),),Text('${AVGPrec2[2].toInt()}%',style: const TextStyle(color: Colors.white,fontSize: 12),)]),
                          
                          // Add spacing between widgets
                          Padding(padding: const EdgeInsets.only(left: 16,right: 16),child:Column(mainAxisSize: MainAxisSize.min,children: [Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/cloud.png'))),),Text('${AVGCloud2[2].toInt()}%',style: const TextStyle(color: Colors.white,fontSize: 12))])),
                          Column(mainAxisSize: MainAxisSize.min,children: [Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/water.png'))),),Text('${HumiMatrix[2][0]}%',style: const TextStyle(color: Colors.white,fontSize: 12))]),
                          
                                                ],
                                              ),
                                            ),
                                          ),
                        )
                ,const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Divider(color: Colors.blue),
                        ),InkWell(onTap: () {
                          data = [
    _SalesData('1AM', PrecMatrix[3][0].toDouble()),
    _SalesData('2AM', PrecMatrix[3][1].toDouble()),
    _SalesData('3AM', PrecMatrix[3][2].toDouble()),
    _SalesData('4AM', PrecMatrix[3][3].toDouble()),
    _SalesData('5AM', PrecMatrix[3][4].toDouble()),
    _SalesData('6AM', PrecMatrix[3][5].toDouble()),
    _SalesData('7AM', PrecMatrix[3][7].toDouble()),
    _SalesData('8AM', PrecMatrix[3][8].toDouble()),
    _SalesData('9AM', PrecMatrix[3][9].toDouble()),
    _SalesData('10AM', PrecMatrix[3][10].toDouble()),
    _SalesData('11AM', PrecMatrix[3][11].toDouble()),
    _SalesData('12PM', PrecMatrix[3][12].toDouble()),
   
    
  ];
                          showModalBottomSheet(context: context, builder: (BuildContext context) {return ClipRRect(borderRadius: const BorderRadius.only(topLeft: Radius.circular(29)   ,topRight: Radius.circular(29)),child:Container(child: Container(child: Column(children: [SfCartesianChart(onZoomStart:(zoomingArgs) => ZoomPanArgs(),plotAreaBorderColor: Colors.yellow,plotAreaBackgroundColor:  Colors.grey[600],primaryYAxis: CategoryAxis(isVisible: false,),primaryXAxis: CategoryAxis(labelStyle: TextStyle(color: Color.fromARGB(211, 255, 240, 240))),title: ChartTitle(text: '$Dayplusthree',textStyle: TextStyle(color: Colors.white)),legend: Legend(isVisible: true,textStyle: TextStyle(color: Colors.white,fontSize: 18)),tooltipBehavior: TooltipBehavior(enable: true,color: Colors.white),series: <CartesianSeries<_SalesData, String>>[LineSeries<_SalesData, String>(color: Colors.white,dataSource: data,xValueMapper: (_SalesData sales, _) => sales.year,yValueMapper: (_SalesData sales, _) => sales.sales,name: 'Precipitation',dataLabelSettings: DataLabelSettings(isVisible: true,color: Colors.white),)])])),height: 1200,decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color.fromARGB(255, 27, 27, 27),Color.fromARGB(255, 31, 31, 31)],begin: Alignment.topLeft,end: Alignment.bottomRight)),));});},
                          child: ListTile(
                                            subtitle: Text('${TempMatrix[3][0]}°C', style: const TextStyle(color: Colors.white, fontSize: 16)),
                                            leading: returnStatusImage(3),
                                            title: Text('${Dayplusthree.substring(0,3)}', style: const TextStyle(color: Colors.white, fontSize: 16)),
                                            trailing: SingleChildScrollView(physics: const NeverScrollableScrollPhysics(),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min, // Ensures the row only takes the minimum required space
                                                children: [
                          // Add your widgets here
                                                 
                           Column(mainAxisSize: MainAxisSize.min,children: [Container(height:40,width:40,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/heavy-rain2.png'))),),Text('${AVGPrec2[3].toInt()}%',style: const TextStyle(color: Colors.white,fontSize: 12),)]),
                          
                          // Add spacing between widgets
                          Padding(padding: const EdgeInsets.only(left: 16,right: 16),child:Column(mainAxisSize: MainAxisSize.min,children: [Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/cloud.png'))),),Text('${AVGCloud2[3].toInt()}%',style: const TextStyle(color: Colors.white,fontSize: 12))])),
                          Column(mainAxisSize: MainAxisSize.min,children: [Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/water.png'))),),Text('${HumiMatrix[3][0]}%',style: const TextStyle(color: Colors.white,fontSize: 12))]),
                          
                                                ],
                                              ),
                                            ),
                                          ),
                        )
                ,const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Divider(color: Colors.blue),
                        ),InkWell(onTap: () {
                          data = [
    _SalesData('1AM', PrecMatrix[4][0].toDouble()),
    _SalesData('2AM', PrecMatrix[4][1].toDouble()),
    _SalesData('3AM', PrecMatrix[4][2].toDouble()),
    _SalesData('4AM', PrecMatrix[4][3].toDouble()),
    _SalesData('5AM', PrecMatrix[4][4].toDouble()),
    _SalesData('6AM', PrecMatrix[4][5].toDouble()),
    _SalesData('7AM', PrecMatrix[4][7].toDouble()),
    _SalesData('8AM', PrecMatrix[4][8].toDouble()),
    _SalesData('9AM', PrecMatrix[4][9].toDouble()),
    _SalesData('10AM', PrecMatrix[4][10].toDouble()),
    _SalesData('11AM', PrecMatrix[4][11].toDouble()),
    _SalesData('12PM', PrecMatrix[4][12].toDouble()),
   
    
  ];
                          showModalBottomSheet(context: context, builder: (BuildContext context) {return ClipRRect(borderRadius: const BorderRadius.only(topLeft: Radius.circular(29)   ,topRight: Radius.circular(29)),child:Container(child: Container(child: Column(children: [SfCartesianChart(onZoomStart:(zoomingArgs) => ZoomPanArgs(),plotAreaBorderColor: Colors.yellow,plotAreaBackgroundColor:  Colors.grey[600],primaryYAxis: CategoryAxis(isVisible: false,),primaryXAxis: CategoryAxis(labelStyle: TextStyle(color: Color.fromARGB(211, 255, 240, 240))),title: ChartTitle(text: '$Dayplusfour',textStyle: TextStyle(color: Colors.white)),legend: Legend(isVisible: true,textStyle: TextStyle(color: Colors.white,fontSize: 18)),tooltipBehavior: TooltipBehavior(enable: true,color: Colors.white),series: <CartesianSeries<_SalesData, String>>[LineSeries<_SalesData, String>(color: Colors.white,dataSource: data,xValueMapper: (_SalesData sales, _) => sales.year,yValueMapper: (_SalesData sales, _) => sales.sales,name: 'Precipitation',dataLabelSettings: DataLabelSettings(isVisible: true,color: Colors.white),)])])),height: 1200,decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color.fromARGB(255, 27, 27, 27),Color.fromARGB(255, 31, 31, 31)],begin: Alignment.topLeft,end: Alignment.bottomRight)),));});},
                          child: ListTile(
                                            subtitle: Text('${TempMatrix[4][0]}°C', style: const TextStyle(color: Colors.white, fontSize: 16)),
                                            leading: returnStatusImage(4),
                                            title: Text('${Dayplusfour.substring(0,3)}', style: const TextStyle(color: Colors.white, fontSize: 16)),
                                            trailing: SingleChildScrollView(physics: const NeverScrollableScrollPhysics(),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min, // Ensures the row only takes the minimum required space
                                                children: [
                          // Add your widgets here
                                                 
                           Column(mainAxisSize: MainAxisSize.min,children: [Container(height:40,width:40,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/heavy-rain2.png'))),),Text('${AVGPrec2[4].toInt()}%',style: const TextStyle(color: Colors.white,fontSize: 12),)]),
                          
                          // Add spacing between widgets
                          Padding(padding: const EdgeInsets.only(left: 16,right: 16),child:Column(mainAxisSize: MainAxisSize.min,children: [Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/cloud.png'))),),Text('${AVGCloud2[4].toInt()}%',style: const TextStyle(color: Colors.white,fontSize: 12))])),
                          Column(mainAxisSize: MainAxisSize.min,children: [Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/water.png'))),),Text('${HumiMatrix[4][0]}%',style: const TextStyle(color: Colors.white,fontSize: 12))]),
                          
                                                ],
                                              ),
                                            ),
                                          ),
                        )
                ,const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Divider(color: Colors.blue),
                        ),InkWell(onTap: () {
                          data = [
    _SalesData('1AM', PrecMatrix[5][0].toDouble()),
    _SalesData('2AM', PrecMatrix[5][1].toDouble()),
    _SalesData('3AM', PrecMatrix[5][2].toDouble()),
    _SalesData('4AM', PrecMatrix[5][3].toDouble()),
    _SalesData('5AM', PrecMatrix[5][4].toDouble()),
    _SalesData('6AM', PrecMatrix[5][5].toDouble()),
    _SalesData('7AM', PrecMatrix[5][7].toDouble()),
    _SalesData('8AM', PrecMatrix[5][8].toDouble()),
    _SalesData('9AM', PrecMatrix[5][9].toDouble()),
    _SalesData('10AM', PrecMatrix[5][10].toDouble()),
    _SalesData('11AM', PrecMatrix[5][11].toDouble()),
    _SalesData('12PM', PrecMatrix[5][12].toDouble()),
   
    
  ];
                          showModalBottomSheet(context: context, builder: (BuildContext context) {return ClipRRect(borderRadius: const BorderRadius.only(topLeft: Radius.circular(29)   ,topRight: Radius.circular(29)),child:Container(child: Container(child: Column(children: [SfCartesianChart(onZoomStart:(zoomingArgs) => ZoomPanArgs(),plotAreaBorderColor: Colors.yellow,plotAreaBackgroundColor:  Colors.grey[600],primaryYAxis: CategoryAxis(isVisible: false,),primaryXAxis: CategoryAxis(labelStyle: TextStyle(color: Color.fromARGB(211, 255, 240, 240))),title: ChartTitle(text: '$Dayplusfive',textStyle: TextStyle(color: Colors.white)),legend: Legend(isVisible: true,textStyle: TextStyle(color: Colors.white,fontSize: 18)),tooltipBehavior: TooltipBehavior(enable: true,color: Colors.white),series: <CartesianSeries<_SalesData, String>>[LineSeries<_SalesData, String>(color: Colors.white,dataSource: data,xValueMapper: (_SalesData sales, _) => sales.year,yValueMapper: (_SalesData sales, _) => sales.sales,name: 'Precipitation',dataLabelSettings: DataLabelSettings(isVisible: true,color: Colors.white),)])])),height: 1200,decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color.fromARGB(255, 27, 27, 27),Color.fromARGB(255, 31, 31, 31)],begin: Alignment.topLeft,end: Alignment.bottomRight)),));});},
                          child: ListTile(
                                            subtitle: Text('${TempMatrix[5][0]}°C', style: const TextStyle(color: Colors.white, fontSize: 16)),
                                            leading: returnStatusImage(5),
                                            title: Text('${Dayplusfive.substring(0, 3)}', style: const TextStyle(color: Colors.white, fontSize: 16)),
                                            trailing: SingleChildScrollView(physics: const NeverScrollableScrollPhysics(),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min, // Ensures the row only takes the minimum required space
                                                children: [
                          // Add your widgets here
                                                 
                           Column(mainAxisSize: MainAxisSize.min,children: [Container(height:40,width:40,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/heavy-rain2.png'))),),Text('${AVGPrec2[5].toInt()}%',style: const TextStyle(color: Colors.white,fontSize: 12),)]),
                          
                          // Add spacing between widgets
                          Padding(padding: const EdgeInsets.only(left: 16,right: 16),child:Column(mainAxisSize: MainAxisSize.min,children: [Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/cloud.png'))),),Text('${AVGCloud2[5].toInt()}%',style: const TextStyle(color: Colors.white,fontSize: 12))])),
                          Column(mainAxisSize: MainAxisSize.min,children: [Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/water.png'))),),Text('${HumiMatrix[5][0]}%',style: const TextStyle(color: Colors.white,fontSize: 12))]),
                          
                                                ],
                                              ),
                                            ),
                                          ),
                        )
                ,const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Divider(color: Colors.blue),
                        ),InkWell(onTap: () {
                          data = [
    _SalesData('1AM', PrecMatrix[6][0].toDouble()),
    _SalesData('2AM', PrecMatrix[6][1].toDouble()),
    _SalesData('3AM', PrecMatrix[6][2].toDouble()),
    _SalesData('4AM', PrecMatrix[6][3].toDouble()),
    _SalesData('5AM', PrecMatrix[6][4].toDouble()),
    _SalesData('6AM', PrecMatrix[6][5].toDouble()),
    _SalesData('7AM', PrecMatrix[6][7].toDouble()),
    _SalesData('8AM', PrecMatrix[6][8].toDouble()),
    _SalesData('9AM', PrecMatrix[6][9].toDouble()),
    _SalesData('10AM', PrecMatrix[6][10].toDouble()),
    _SalesData('11AM', PrecMatrix[6][11].toDouble()),
    _SalesData('12PM', PrecMatrix[6][12].toDouble()),
   
    
  ];
                          showModalBottomSheet(context: context, builder: (BuildContext context) {return ClipRRect(borderRadius: const BorderRadius.only(topLeft: Radius.circular(29)   ,topRight: Radius.circular(29)),child:Container(child: Container(child: Column(children: [SfCartesianChart(onZoomStart:(zoomingArgs) => ZoomPanArgs(),plotAreaBorderColor: Colors.yellow,plotAreaBackgroundColor:  Colors.grey[600],primaryYAxis: CategoryAxis(isVisible: false,),primaryXAxis: CategoryAxis(labelStyle: TextStyle(color: Color.fromARGB(211, 255, 240, 240))),title: ChartTitle(text: '$Dayplussix',textStyle: TextStyle(color: Colors.white)),legend: Legend(isVisible: true,textStyle: TextStyle(color: Colors.white,fontSize: 18)),tooltipBehavior: TooltipBehavior(enable: true,color: Colors.white),series: <CartesianSeries<_SalesData, String>>[LineSeries<_SalesData, String>(color: Colors.white,dataSource: data,xValueMapper: (_SalesData sales, _) => sales.year,yValueMapper: (_SalesData sales, _) => sales.sales,name: 'Precipitation',dataLabelSettings: DataLabelSettings(isVisible: true,color: Colors.white),)])])),height: 1200,decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color.fromARGB(255, 27, 27, 27),Color.fromARGB(255, 31, 31, 31)],begin: Alignment.topLeft,end: Alignment.bottomRight)),));});},
                          child: ListTile(
                                            subtitle: Text('${TempMatrix[6][0]}°C', style: const TextStyle(color: Colors.white, fontSize: 16)),
                                            leading: returnStatusImage(6),
                                            title: Text('${Dayplussix.substring(0,3)}', style: const TextStyle(color: Colors.white, fontSize: 16)),
                                            trailing: SingleChildScrollView(physics: const NeverScrollableScrollPhysics(),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min, // Ensures the row only takes the minimum required space
                                                children: [
                          // Add your widgets here
                                                 
                           Column(mainAxisSize: MainAxisSize.min,children: [Container(height:40,width:40,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/heavy-rain2.png'))),),Text('${AVGPrec2[6].toInt()}%',style: const TextStyle(color: Colors.white,fontSize: 12),)]),
                          
                          // Add spacing between widgets
                          Padding(padding: const EdgeInsets.only(left: 16,right: 16),child:Column(mainAxisSize: MainAxisSize.min,children: [Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/cloud.png'))),),Text('${AVGCloud2[6].toInt()}%',style: const TextStyle(color: Colors.white,fontSize: 12))])),
                          Column(mainAxisSize: MainAxisSize.min,children: [Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/water.png'))),),Text('${HumiMatrix[6][0]}%',style: const TextStyle(color: Colors.white,fontSize: 12))]),
                          
                                                ],
                                              ),
                                            ),
                                          ),
                        )
                ,const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Divider(color: Colors.blue),
                        )])],
                      ),
                    ),),Padding(
                      padding: const EdgeInsets.only(top:10.0),
                      child: ClipRRect(borderRadius:BorderRadius.circular(20),child:MyContainerOne(height: 60, width: 400,child: Center(child: TextScroll(textAlign:TextAlign.center,'$AveragePrec ${AVGPrec2[0]}%                                                                                                                              ',style: const TextStyle(color: Colors.white,fontSize: 23))))),
                    )
                  ],
                ),
              ),
            ),
          ),SettingsPage()],
        ),
      ),
    );

    
  }

  void returnCloud() {
  for (int dayflag = 0; dayflag <= 6; dayflag++){
    for (int i = 0; i <= 23; i++) {
      AVGCloud = AVGCloud + CloudMatrix[dayflag][i];
      
    }
    realAVGCloud = (AVGCloud / 24);
    AVGCloud2[dayflag] = realAVGCloud;
    AVGCloud = 0;
  }
}
void returnPrec() {
  for (int dayflag = 0; dayflag <= 6; dayflag++){
    for (int i = 0; i <= 23; i++) {
      AVGprec = AVGprec + PrecMatrix[dayflag][i];
      
    }
    realAVGPrec = (AVGprec / 24);
    AVGPrec2[dayflag] = realAVGPrec;
    AVGprec = 0;
  }
}

dynamic returnStatusImage(i) {
if (AVGCloud2[i] > 40){

return Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/cloud.png'))),);

}
else if (AVGPrec2[i] > 30) {

  return Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/heavy-rain2.png'))),);
}
else {

  return Container(height:35,width:35,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/sun.png'))),);
}



}


}

class DialogueMenu {
  static Future<void> show(BuildContext context, String title, List<String> options, Function(int) onSelected) async {
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
        child: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color.fromARGB(255, 65, 138, 206),
                  Color.fromARGB(255, 24, 111, 173),],begin: Alignment.topRight,end: Alignment.bottomLeft)),
      
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          
       child: Column(children: [Container(decoration: const BoxDecoration(color: Colors.transparent),height:400,width:200,child: ChoiceWidget()),GestureDetector(onTap: _launchUrl,child: Container(height:200,width:240,decoration: BoxDecoration(image: DecorationImage(image: AssetImage('lib/assets/25231.png')))))]) ),
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
            padding: const EdgeInsets.only(top:18.0),
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
        cancel0 = "Cancel";
        Precipitation = "Precipitation";
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
              activeColor: Color.fromARGB(134, 0, 106, 192),
              value: 2,
              groupValue: currentSelected,
              onChanged: (value) {
                setState(() {
                  currentSelected = value;
                 currentSelected = value;
                /* ClearCondition = '晴れ';
        apparentText = '体感温度'; */
        today = '今日';
        month = '三月';
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
        cancel0 = "キャンセル";
        Precipitation = "降水量";
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
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}