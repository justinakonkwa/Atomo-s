import 'package:flutter/material.dart';

//page qui posside une class qui m'offret une ligne de separation
class Lign extends StatelessWidget {
  final double indent;
  final double endIndent;
  const Lign({Key? key, required this.indent, required this.endIndent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.only(left: indent, right: endIndent),
      height: 0.4,
      color: Theme.of(context).colorScheme.tertiary,
    );
  }
}
