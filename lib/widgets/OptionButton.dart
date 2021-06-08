import 'dart:ui';

import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  
  final IconData icon;
  final Color activeColor;
  final Color inactiveColor;
  final String text;
  final bool active;
  final Function onTap;


  const OptionButton({
    @required this.icon,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    @required this.text,
    this.active = true,
    @required this.onTap, 
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      child: Container(
        child: Column(
          children: [
            Icon(icon, color: active ? activeColor : inactiveColor,size: 35,),
            Text(text,style: TextStyle(color: active ? activeColor : inactiveColor),)
          ]
        )
      ),
      onTap: onTap,
    );
  }
}