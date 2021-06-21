import 'dart:ui';
import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  
  final Color activeColor;
  final Color inactiveColor;
  final String text;
  final bool active;


  const Tag({
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    @required this.text,
    this.active = true,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
        decoration: BoxDecoration(
          color: active ? activeColor : inactiveColor,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
    );
  }
}

