import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/components/weather_item.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/widgets/constants.dart';

class Detailpage extends StatefulWidget {
  final dailyForecastWeather;

  const Detailpage({Key? key, this.dailyForecastWeather}) : super(key: key);

  @override
  State<Detailpage> createState() => _DetailPageState();
}

class _DetailPageState extends State<Detailpage> {
  final Constants _constants = Constants();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    var weatherData = widget.dailyForecastWeather;

    Map getForecastWeather(int index) {
      int maxWindSpeed = weatherData[index]["day"]["maxwind_kph"].toInt();
      int avgHumidity = weatherData[index]["day"]["avghumidity"].toInt();
      int chanceOfRain =
          weatherData[index]["day"]["daily_chance_of_rain"].toInt();

      var parsedDate = DateTime.parse(weatherData[index]["date"]);
      var forecastDate = DateFormat('EEEE, d MMMM').format(parsedDate);

      String weatherName = weatherData[index]["day"]["condition"]["text"];
      String weatherIcon =
          weatherName.replaceAll(' ', '').toLowerCase() + ".png";

      int minTemperature = weatherData[index]["day"]["mintemp_c"].toInt();
      int maxTemperature = weatherData[index]["day"]["maxtemp_c"].toInt();

      var forecastData = {
        'maxWindSpeed': maxWindSpeed,
        'avgHumidity': avgHumidity,
        'chanceOfRain': chanceOfRain,
        'forecastDate': forecastDate,
        'weatherName': weatherName,
        'weatherIcon': weatherIcon,
        'minTemperature': minTemperature,
        'maxTemperature': maxTemperature
      };
      return forecastData;
    }

    return Scaffold(
      backgroundColor: _constants.primaryColor,
      appBar: AppBar(
        title: const Text('Forecasts'),
        centerTitle: true,
        backgroundColor: _constants.primaryColor,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                print("Settings Tapped");
              },
            ),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: size.height * .75,
              width: size.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50))),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -50,
                    right: 20,
                    left: 20,
                    child: Container(
                      height: 300,
                      width: size.width * .7,
                      decoration: BoxDecoration(
                        gradient: _constants.linearGradientTeal,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withOpacity(.1),
                            offset: const Offset(0, 25),
                            blurRadius: 3,
                            spreadRadius: -10,
                          )
                        ],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            child: Image.asset(
                                'assets/images/${getForecastWeather(0)["weatherIcon"]}'),
                            width: 100,
                          ),
                          Positioned(
                              top: 150,
                              left: 30,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  getForecastWeather(0)["weatherName"],
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              )),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: Container(
                              width: size.width * .8,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  WeatherItem( value:getForecastWeather(0)["maxWindSpeed"],  unit: "km/h",  imageUrl: "assets/images/windy.png",),
                                  WeatherItem(value: getForecastWeather(0)["avgHumidity"],unit: "%", imageUrl: "assets/images/humidity.png",),
                                  WeatherItem(value:getForecastWeather(0)["chanceOfRain"], unit: "%", imageUrl: "assets/images/lightrain.png",),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            right: 20,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getForecastWeather(0)["maxTemperature"].toString(),
                                  style: TextStyle(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()..shader = _constants.shader,
                                  ),
                                ),
                                Text(
                                  'o',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()..shader = _constants.shader,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 320,
                            left: 0,
                            child: SizedBox(
                              height: 400,
                              width: size.width * .9,
                              child: ListView(
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  Card(
                                    elevation: 3.0,
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:CrossAxisAlignment.center,
                                            children: [
                                              Text(getForecastWeather(0)["forecastDate"],
                                                style: const TextStyle(
                                                  color: Color(0xff6696f5),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:CrossAxisAlignment.start,
                                                    mainAxisAlignment:MainAxisAlignment.center,
                                                    children: [
                                                      Padding(
                                                        padding:const EdgeInsets.only(top: 8.0),
                                                        child: Text(getForecastWeather(0)["minTemperature"].toString(),
                                                          style: TextStyle(color: _constants.greyColor,fontSize: 30, fontWeight:FontWeight.w600,),
                                                        ),
                                                      ),
                                                      Text('o',
                                                        style: TextStyle(color: _constants.greyColor,fontSize: 22,fontWeight:FontWeight.w600,),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 30,),
                                                  Row(
                                                    crossAxisAlignment:CrossAxisAlignment.start,
                                                    mainAxisAlignment:MainAxisAlignment.center,
                                                    children: [
                                                      Padding(
                                                        padding:const EdgeInsets.only(top: 8.0),
                                                        child: Text(getForecastWeather(0)["maxTemperature"].toString(),
                                                          style: TextStyle(color: _constants.blackColor,fontSize: 30,fontWeight:FontWeight.w600,),
                                                        ),
                                                      ),
                                                      Text('o',
                                                        style: TextStyle(color: _constants.blackColor,fontSize: 22,fontWeight: FontWeight.w600,),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10,),
                                          Row(
                                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:MainAxisAlignment.center,
                                                children: [Image.asset('assets/images/' + getForecastWeather(0)["weatherIcon"],
                                                    width: 30,
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  Text(getForecastWeather(0)["weatherName"],
                                                    style: const TextStyle(fontSize: 16,color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:MainAxisAlignment.center,
                                                children: [
                                                  Text(getForecastWeather(0)["chanceOfRain"].toString() +"%",
                                                    style: const TextStyle(fontSize: 18,color: Colors.grey,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  Image.asset('assets/images/lightrain.png',width: 30,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Card(
                                    elevation: 3.0,
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:CrossAxisAlignment.center,
                                            children: [
                                              Text(getForecastWeather(1)["forecastDate"],
                                                style: const TextStyle(color: Color(0xff6696f5),fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:CrossAxisAlignment.start, 
                                                    mainAxisAlignment:MainAxisAlignment .center,
                                                    children: [
                                                      Padding(
                                                        padding:const EdgeInsets.only(top: 8.0),
                                                        child: Text(getForecastWeather(1)["minTemperature"].toString(),
                                                          style: TextStyle(color: _constants.greyColor,fontSize: 30,fontWeight:FontWeight.w600, ),
                                                        ),
                                                      ),
                                                      Text('o',
                                                        style: TextStyle(color: _constants.greyColor,fontSize: 22, fontWeight:FontWeight.w600,),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 30,),
                                                  Row(
                                                    crossAxisAlignment:CrossAxisAlignment.start,
                                                    mainAxisAlignment:MainAxisAlignment.center,
                                                    children: [
                                                      Padding(
                                                        padding:const EdgeInsets.only(top: 8.0),
                                                        child: Text(getForecastWeather(1)["maxTemperature"].toString(),
                                                          style: TextStyle(color: _constants.blackColor,fontSize: 30,fontWeight:FontWeight.w600,),
                                                        ),
                                                      ),
                                                      Text('o',
                                                        style: TextStyle(color: _constants.blackColor,fontSize: 22,fontWeight:FontWeight.w600,),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10,),
                                          Row(
                                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:MainAxisAlignment.center,
                                                children: [
                                                  Image.asset('assets/images/' +getForecastWeather(1)["weatherIcon"],width: 30,),
                                                  const SizedBox(width: 5),
                                                  Text(getForecastWeather(0)["weatherName"],
                                                    style: const TextStyle(fontSize: 16,color: Colors.grey,),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:MainAxisAlignment.center,
                                                children: [
                                                  Text(getForecastWeather(1)["chanceOfRain"].toString() +"%",
                                                    style: const TextStyle(fontSize: 18,color: Colors.grey,),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  Image.asset('assets/images/lightrain.png',width: 30,),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Card(
                                    elevation: 3.0,
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:CrossAxisAlignment.center,
                                            children: [
                                              Text(getForecastWeather(2)["forecastDate"],
                                                style: const TextStyle(color: Color(0xff6696f5),fontWeight: FontWeight.w600,),
                                              ),
                                              Row(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:CrossAxisAlignment.start,
                                                    mainAxisAlignment:MainAxisAlignment.center,
                                                    children: [
                                                      Padding(padding:const EdgeInsets.only(top: 8.0),
                                                        child: Text(getForecastWeather(2)["minTemperature"].toString(),
                                                          style: TextStyle(color: _constants.greyColor,fontSize: 30,fontWeight:FontWeight.w600,),
                                                        ),
                                                      ),
                                                      Text('o',
                                                        style: TextStyle(color: _constants.greyColor,fontSize: 22,fontWeight:FontWeight.w600,),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 30,),
                                                  Row(
                                                    crossAxisAlignment:CrossAxisAlignment.start,
                                                    mainAxisAlignment:MainAxisAlignment.center,
                                                    children: [
                                                      Padding(
                                                        padding:const EdgeInsets.only(top: 8.0),
                                                        child: Text(getForecastWeather(2)["maxTemperature"].toString(),
                                                          style: TextStyle(color: _constants.blackColor,fontSize: 30,fontWeight:FontWeight.w600,),
                                                        ),
                                                      ),
                                                      Text('o',
                                                        style: TextStyle(color: _constants.blackColor,fontSize: 22, fontWeight:FontWeight.w600,),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10, ),
                                          Row(
                                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:MainAxisAlignment.center,
                                                children: [
                                                  Image.asset('assets/images/' +getForecastWeather(2)["weatherIcon"],width: 30,
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  Text(getForecastWeather(2)["weatherName"],
                                                    style: const TextStyle(fontSize: 16,color: Colors.grey,),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:MainAxisAlignment.center,
                                                children: [
                                                  Text(getForecastWeather(2)["chanceOfRain"].toString() +"%",
                                                    style: const TextStyle(fontSize: 18, color: Colors.grey,),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  Image.asset('assets/images/lightrain.png', width: 30,),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
