import 'package:flutter/material.dart';

class CustomShapeBorder extends ContinuousRectangleBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    
    Path path = Path();

    path.lineTo( 0, rect.height * 2);
    path.quadraticBezierTo(rect.width * 0.01, rect.height * 1.4, rect.width * 0.1, rect.height * 1.4);
    path.lineTo(rect.width * 0.9, rect.height * 1.4);
    path.quadraticBezierTo(rect.width * 0.99, rect.height * 1.3, rect.width, rect.height * 2);

    path.lineTo( rect.width, 0 );
    
    return path;
  }
}