import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool isVisible = true;

  // Function to toggle visibility
  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: Center(
        child: CircularProgressIndicator(),
      ),
      visible: isVisible,
    );
  }
}
