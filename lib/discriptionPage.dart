import 'package:flutter/material.dart';

class DiscriptionPage extends StatelessWidget {
  String title;
  String discription;
  DiscriptionPage(
      {this.title = "Component", this.discription = "insert description"});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            this.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
          ),
        ),
        body: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 20),
          ),
          Text("Description",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  decoration: TextDecoration.underline)),
          Text(
            discription,
            style: TextStyle(fontSize: 20),
          )
        ]));
  }
}
