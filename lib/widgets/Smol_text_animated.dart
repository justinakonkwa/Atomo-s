// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

// class du widget qui possede le text en normal et la police normale pour la plus par des texts dans l'apps
// ignore: must_be_immutable
class SmolTextAnimated extends StatelessWidget {
  SmolTextAnimated({
    Key? key,
    this.color,
    required this.text,
  }) : super(key: key);
  final String? text;
  Color? color ;
  TextAlign? textAlign;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 18,
      child: Marquee(
        text:  text!,
        style: TextStyle(
          fontFamily: 'Montserrat',
          letterSpacing: 0,
          color: color,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.normal,
        ),
        scrollAxis: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        blankSpace: 50.0,
        velocity: 50.0,
        pauseAfterRound: const Duration(seconds: 5),
        startPadding: 0.0,
        accelerationDuration: const Duration(seconds: 1),
        accelerationCurve: Curves.linear,
        decelerationDuration: const Duration(milliseconds: 500),
        decelerationCurve: Curves.easeOut,
      ),
    );

  }
}