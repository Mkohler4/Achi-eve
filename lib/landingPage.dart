import 'package:flutter/material.dart';
import 'discriptionPage.dart';

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
          title: Text("Projects",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 23)),
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
        body: Stack(children: <Widget>[
          TabBarView(
            children: [
              ListView.builder(
                  itemCount: 8,
                  itemBuilder: (context, int i) {
                    return new OwnerCard(
                      color: Colors.green,
                      percentage: "76%",
                    );
                  }),
              ListView.builder(
                  itemCount: 8,
                  itemBuilder: (context, int i) {
                    return new OwnerCard(
                      color: Colors.yellow,
                    );
                  }),
              ListView.builder(
                  itemCount: 8,
                  itemBuilder: (context, int i) {
                    return new OwnerCard(
                      color: Colors.red,
                      percentage: "56%",
                    );
                  }),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Card(
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 4.0,
                  color: Colors.black,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 1, bottom: 14, left: 100, right: 300),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

class OwnerCard extends StatelessWidget {
  final String title;
  final String name;
  final Color color;
  final String percentage;
  const OwnerCard({
    this.percentage = "0%",
    this.color = Colors.red,
    this.title = "Components",
    this.name = "Markus Kohler",
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DiscriptionPage()),
        );
      },
      child: Card(
          margin: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 4.0,
          color: this.color,
          child: Padding(
              padding: EdgeInsets.all(25.0),
              child: ListTile(
                leading: FlutterLogo(
                  size: 50,
                ),
                title: Text(title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                subtitle: Text(name,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF666A6D))),
                trailing: Text(
                  this.percentage,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ))),
    );
  }
}
