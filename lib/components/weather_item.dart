import 'package:flutter/material.dart';

class WeatherItem extends StatelessWidget{
  final int value;
  final String unit;
  final String imageUrl;
  const WeatherItem({
    Key? key, required this.value, required this.imageUrl, required this.unit
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.transparent, 
            borderRadius: BorderRadius.circular(15)
          ),
          child: Image.asset(imageUrl),
        ), 
        SizedBox(height: 8,),
        Text(
          value.toString()+unit, 
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          )
        )
      ],
    );
  }
  
}