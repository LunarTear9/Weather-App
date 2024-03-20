import 'package:flutter/material.dart';

class MyContainerOne extends StatelessWidget {
  final double width;
  final double height;
  final dynamic child;
  const MyContainerOne({super.key,required this.height,required this.width,required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,width: width,
      child: child,
      color: Color.fromARGB(134, 0, 106, 192),
    );
  }
}