import 'package:flutter/material.dart';

class IconStatusIndicator extends StatefulWidget {
  final Icon widgetIcon;
  final dynamic variables;
  final String symbol = '';
  const IconStatusIndicator({super.key,required this.widgetIcon,required this.variables,symbol});

  @override
  State<IconStatusIndicator> createState() => _IconStatusIndicatorState();
}

class _IconStatusIndicatorState extends State<IconStatusIndicator> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}