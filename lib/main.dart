import 'dart:convert';

import 'package:flutter/material.dart';
import 'landingPage.dart';

import 'models/models.dart';
import 'package:http/http.dart' as http;

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
      // home: Test(),
    );
  }
}

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  Project project;

  String spreadsheetID = "1UyYdOLiPKpJ_0qkSnWFzriqiVcu6CnfZQibdeKya-sM";
  String apiKey = "AIzaSyA8fqeR9BYGxm_AV1h3nZ0fhFt_XSuF9p0";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pullInfo();
  }

  Future<void> pullInfo() async{
    final response =
        await http.get("https://sheets.googleapis.com/v4/spreadsheets/${spreadsheetID}/values/Sheet1?key=${apiKey}");

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      setState(() {
        project = Project.fromJSON(json.decode(response.body));
      });
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          child: ListView.builder(
            itemCount: project == null ? 0 : project.getAll().length,
            itemBuilder: (context, i){
              return Card(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(project != null ? project.getAll()[i].name : ""),
                  )
                )
              );
            }
          )
        ),
      ),
    );
  }
}
