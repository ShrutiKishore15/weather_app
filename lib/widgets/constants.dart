import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Constants{
  final primaryColor=Color.fromARGB(255, 32, 133, 128);
  final secondaryColor=const Color.fromARGB(255, 177, 196, 247);
  final tertiaryColor= Colors.blueAccent;
  final blackColor=Colors.black;
  final greyColor=const Color.fromARGB(255, 217, 211, 211);

  final Shader shader=const LinearGradient(
    colors: <Color>[Color.fromARGB(255, 183, 206, 235), Color.fromARGB(255, 33, 75, 133)]
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  final linearGradientBlue= const LinearGradient(
    begin:Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: <Color>[Color.fromARGB(255, 154, 198, 245), Color.fromARGB(255, 50, 111, 176)],
    stops: [0.0, 1.0]
  );

  final linearGradientTeal= const LinearGradient(
    begin:Alignment.bottomRight,
    end: Alignment.topLeft,
    colors: <Color>[Color.fromARGB(255, 137, 226, 224), Color.fromARGB(255, 37, 123, 123)],
    stops: [0.0, 1.0]
  );


}