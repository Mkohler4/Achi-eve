import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 50,
          title: Text("Projects", style: TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Icon(
            Icons.menu,
            color: Colors.black,
          ),
          bottom: TabBar(
            labelPadding: EdgeInsets.fromLTRB(100, 0, 100, 0),
            isScrollable: true,
            tabs: [
              Tab(
                  child: Text("Yours",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20))),
              Tab(
                  child: Text("Available",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20))),
              Tab(
                  child: Text("All",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20))),
            ],
          ),
        ),
      ),
    );
  }
}
