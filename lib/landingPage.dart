import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  bool isSelected1;
  bool isSelected2;
  LandingPage({this.isSelected1 = false, this.isSelected2 = false});
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
          iconTheme: new IconThemeData(color: Colors.black),
          title: Text("Projects", style: TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: TabBar(
            labelPadding: EdgeInsets.fromLTRB(52, 0, 52, 0),
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
        drawer: Drawer(
            child: ListView(
          children: <Widget>[
            ListTile(
              selected: true,
              title: Text(
                "Website",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {},
            ),
            ListTile(
              selected: false,
              title: Text(
                "Appliciation",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {},
            ),
          ],
        )),
        body: TabBarView(
          children: [
            Icon(
              Icons.directions_car,
              color: Colors.black,
            ),
            Icon(
              Icons.directions_transit,
              color: Colors.black,
            ),
            Icon(
              Icons.directions_bike,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
