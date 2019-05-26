import 'dart:convert';

import 'package:flutter/material.dart';
import 'landingPage.dart';

import 'models/models.dart';
import 'package:http/http.dart' as http;

import 'addProjectPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LandingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
