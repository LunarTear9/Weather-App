import 'package:flutter/material.dart';

class MyContainerOne extends StatelessWidget {
  final double width;
  final double height;
  final dynamic child;
  final dynamic color;
  const MyContainerOne({super.key,required this.height,required this.width,required this.child,required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,width: width,
      child: child,
      color: color,
    );
  }
}