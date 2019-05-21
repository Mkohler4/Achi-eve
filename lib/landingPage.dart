import 'package:flutter/material.dart';
import 'widget_workspace/iSelectedList.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ISelctedList(),
    );
  }
}
