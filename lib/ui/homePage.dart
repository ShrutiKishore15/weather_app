// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:weather_app/components/weather_item.dart';
import 'package:weather_app/ui/detailPage.dart';
import 'package:weather_app/widgets/constants.dart';

class homePage extends StatefulWidget{
  const homePage({Key? key}): super(key: key);
  
  @override
  State<homePage> createState() => _HomePageState();
  
}

class _HomePageState extends State<homePage>{
  final TextEditingController _cityController= TextEditingController();
  final Constants _constants=Constants();

  static String API_KEY='2acc95ca1e614af9b87215041240708';
  String location='Mumbai';
  String weatherIcon='heavycloudy.png';
  int temperature=0;
  int humidity=0;
  int windSpeed=0;
  int cloud=0;
  String currentDate='';

  List hourlyWeatherForecast=[];
  List dailyWeatherForecast=[];
  
  Map<String, dynamic> weatherData={};


  String currentWeatherStatus='';

  String searchWeatherAPI="http://api.weatherapi.com/v1/forecast.json?key=$API_KEY&days=7&aqi=no&alerts=no&q=";

  static String getShortLocationName(String s){
    List<String> wordList=s.split(" ");
    if(wordList.isNotEmpty){
      if(wordList.length>1){
        return wordList[0]+' '+wordList[1];
      }else{
        return wordList[0];
      }
    }else{
      return " ";
    }
  }

  void fetchWeatherData(String searchText) async{
   try {
    final response = await http.get(Uri.parse(searchWeatherAPI + searchText));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      setState(() {
        weatherData = data;

        // Check and parse location data
        var locationData = weatherData["location"];
        if (locationData != null) {
          location = getShortLocationName(locationData["name"]);
          var parsedDate = DateTime.parse(locationData["localtime"].substring(0, 10));
          currentDate = DateFormat('MMMMEEEEd').format(parsedDate);
        }

        // Check and parse current weather data
        var currentWeather = weatherData["current"];
        if (currentWeather != null) {
          currentWeatherStatus = currentWeather["condition"]["text"];
          weatherIcon = currentWeatherStatus.replaceAll(' ', '').toLowerCase() + ".png";
          temperature = currentWeather["temp_c"].toInt();
          windSpeed = currentWeather["wind_kph"].toInt();
          humidity = currentWeather["humidity"].toInt();
          cloud = currentWeather["cloud"].toInt();
        }

        // Check and parse forecast data
        var forecastData = weatherData["forecast"];
        if (forecastData != null) {
          //print('Forecast data: $forecastData'); // Print the forecast data
          var forecastDays = forecastData["forecastday"];
          if (forecastDays != null) {
            //print('Forecast days data: $forecastDays'); // Print the forecast days data
            dailyWeatherForecast = forecastDays;
            if (dailyWeatherForecast.isNotEmpty) {
              hourlyWeatherForecast = dailyWeatherForecast[0]["hour"];
            }
          } else {
            //print('forecastday is null or empty');
            dailyWeatherForecast = [];
            hourlyWeatherForecast = [];
          }
        } else {
          //print('Forecast data is not available.');
          dailyWeatherForecast = [];
          hourlyWeatherForecast = [];
        }
      });
    } else {
      //print('Failed to load weather data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching weather data: $e');
  }
  }

  
  @override
  void initState(){
    fetchWeatherData(location);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body:Container(
        width:size.width,
        height: size.height,
        padding: const EdgeInsets.only(top: 60, left: 10, right: 10),
        color:_constants.primaryColor.withOpacity(.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: size.height * 0.7,
              decoration: BoxDecoration(
                gradient: _constants.linearGradientBlue,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color:_constants.primaryColor.withOpacity(.4),
                    spreadRadius: 5,
                    blurRadius:10,
                    offset: const Offset(0, 5),
                  )
                ]
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.menu, size: 35, color: Colors.white,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_history, size: 35, color: Colors.white,),
                          const SizedBox(width:3),
                          Text(
                            location, style: const TextStyle(color: Colors.white, fontSize: 16)),
                          IconButton(
                          onPressed:(){
                            _cityController.clear();
                            showMaterialModalBottomSheet(context: context, builder:(context)=>
                            SingleChildScrollView(
                              controller: ModalScrollController.of(context),
                              child: Container(
                                height: size.height*0.2,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width:70, 
                                      child: Divider(thickness: 3.5, color: _constants.primaryColor,),
                                    ),
                                    const SizedBox(height: 10),
                                    TextField(
                                      onChanged: (searchText){
                                        fetchWeatherData(searchText);
                                      },
                                      controller: _cityController,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.search, color: _constants.primaryColor,),
                                        suffixIcon: GestureDetector(onTap: ()=>_cityController.clear(),
                                        child: Icon(Icons.close, color: _constants.primaryColor,),),
                                        hintText: 'Search city e.g. London', 
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: _constants.primaryColor),
                                          borderRadius: BorderRadius.circular(10),
                                        )
                                      ),
                                    )
                                  ],
                                )
                              ),
                            ));
                          }, 
                          icon: const Icon(Icons.keyboard_arrow_down_outlined, color: Colors.white, size:20)),
                        ],),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset('assets/images/linkedinpic.jpg', width: 35, height: 35),

                      )
                    ],
                  ),
                  SizedBox(
                    height: 160,
                    child: Image.asset('assets/images/$weatherIcon')
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(padding: const EdgeInsets.only(top: 8.0),
                      child: Text(temperature.toString(), 
                      style: TextStyle(
                        fontSize: 80, fontWeight: FontWeight.bold,
                        foreground: Paint()..shader=_constants.shader ), 
                        )
                      ),
                      Text('o', 
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, foreground: Paint()..shader=_constants.shader),)
                    ],
                  ),
                  Text(currentWeatherStatus,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                  ),),
                   Text(currentDate,
                  style: const TextStyle(
                    color: Colors.white70,
                  ),),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20,),
                    child: const Divider(
                      color: Colors.white70,
                    ),
                  ), 
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WeatherItem(value: windSpeed.toInt(), imageUrl:'assets/images/windy.png', unit: 'Km/h'),
                        WeatherItem(value: humidity.toInt(), imageUrl:'assets/images/humidity.png', unit: 'Km/h'),
                        WeatherItem(value: cloud.toInt(), imageUrl:'assets/images/cloud.png', unit: 'Km/h')
                      ],
                    )
                  )
                ],
              ),
            ), 
            Container(
              padding: const EdgeInsets.only(top:10),
              height: size.height*0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Today', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      GestureDetector(
                        onTap: ()=>Navigator.push(context, 
                        MaterialPageRoute(builder: (_)=>Detailpage(dailyForecastWeather: dailyWeatherForecast,))),
                        child: Text('Forecasts', 
                        style: TextStyle(fontSize: 20, 
                        color: _constants.primaryColor, 
                        fontWeight: FontWeight.w900 )))
                      
                    ],
                  ),
                  const SizedBox(height: 8,),
                  // ElevatedButton(onPressed: (){print("");}, child: Text("click"))
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      itemCount: hourlyWeatherForecast.length,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index){
                        String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
                        String currentHour=currentTime.substring(0,2);
                        String forecastTime=hourlyWeatherForecast[index]["time"].substring(11, 16);
                        String forecastHour=hourlyWeatherForecast[index]["time"].substring(11, 13);
                        String forecastWeatherName=hourlyWeatherForecast[index]["condition"]["text"];
                        String forecastWeatherIcon=forecastWeatherName.replaceAll(' ', '').toLowerCase()+".png";
                        String forecastTemperature=hourlyWeatherForecast[index]["temp_c"].round().toString();
                        
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          margin: const EdgeInsets.only(right:20), 
                          width:65,
                          decoration: BoxDecoration(
                            color: currentHour==forecastHour?Colors.white70:_constants.primaryColor,
                            borderRadius: const BorderRadius.all(Radius.circular(50)),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 1),
                                blurRadius: 5,
                                color: _constants.primaryColor.withOpacity(.2),
                              )
                            ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(forecastTime, style: TextStyle(fontSize: 17, color: _constants.greyColor, fontWeight: FontWeight.bold),),
                                Image.asset('assets/images/$forecastWeatherIcon', width: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                   
                                    Padding(
                                      padding: const EdgeInsets.only(top:8),
                                      child: Text(forecastTemperature, style: TextStyle(fontSize: 17, foreground: Paint()..shader=_constants.shader, fontWeight: FontWeight.bold),)),
                                    Text('o', style: TextStyle(fontSize: 16, foreground: Paint()..shader=_constants.shader, fontWeight: FontWeight.bold),),
                                  ],
                                )
                              ],

                            ),
                        );

                      },
                    ),
                  )
                ],
              )
            )
          ],),
      )
    );
  }

}