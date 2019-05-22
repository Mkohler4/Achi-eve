import 'dart:convert';

import 'package:flutter/material.dart';
import 'discriptionPage.dart';
import 'models/models.dart';

import 'package:http/http.dart' as http;

class LandingPage extends StatefulWidget {
  bool isSelected1;
  bool isSelected2;
  LandingPage({this.isSelected1 = false, this.isSelected2 = false});
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  String userPassword;

  Project project;

  String spreadsheetID = "1UyYdOLiPKpJ_0qkSnWFzriqiVcu6CnfZQibdeKya-sM";
  String apiKey = "AIzaSyA8fqeR9BYGxm_AV1h3nZ0fhFt_XSuF9p0";

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

  Widget options(){
    return AlertDialog(
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text("Options", style: TextStyle(fontSize: 20),)),
            ),
            TextFormField(
              
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userPassword = json.decode("info.json")["name"];

    pullInfo(); //starts by pulling the ifo from the server
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(

        //APPBAR
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return options();
                  }
                );
              },
            )
          ],
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

        //DRAWER
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
          )
        ),

        //BODY
        body: Stack(children: <Widget>[
          TabBarView(
            children: [
              project.ownerList(userPassword).length != 0 && project != null ?
                ListView.builder(
                  itemCount: project != null ? project.ownerList(userPassword).length : 0,
                  itemBuilder: (context, int i) {
                    return new OwnerCard(
                      color: Colors.green,
                      percentage:  project.ownerList(userPassword)[i].difficulty,
                      title: project.ownerList(userPassword)[i].name,
                      name: project.ownerList(userPassword)[i].ownerPassword,
                    );
                  }
                ) :
              OwnerCard(color: Colors.white, title: "Nothing to show", percentage: 0, name: "",),

              project.openList().length != 0  && project != null ?
                ListView.builder(
                  itemCount: project != null ? project.openList().length : 0,
                  itemBuilder: (context, int i) {
                    return new OwnerCard(
                      color: Colors.yellow,
                      title: project.openList()[i].name,
                      name: project.openList()[i].ownerPassword,
                    );
                  }
                ) : 
                OwnerCard(color: Colors.white, title: "Nothing to show", percentage: 0, name: "",),

              project.getAll().length != 0  && project != null ? 
                ListView.builder(
                  
                  itemCount: project != null ? project.getAll().length : 0,
                  itemBuilder: (context, int i) {
                    String status = project.componentStatus(project.getAll()[i], userPassword); //task status determiner
                    return new OwnerCard(
                      color:status == "O" ? Colors.yellow : //open tasks
                            status == "Y" ? Colors.green : //owner tasks
                            status == "T" ? Colors.red : //taken tasks
                            Colors.grey, //closed takss
                      percentage: project.getAll()[i].difficulty,
                      title: project.getAll()[i].name,
                      name: project.getAll()[i].ownerPassword,
                    );
                  }
                ) : 
                OwnerCard(color: Colors.white, title: "Nothing to show", percentage: 0, name: "",)
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
  final int percentage;
  const OwnerCard({
    this.percentage = 0,
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
                  this.percentage != 0 ? this.percentage.toString() : "",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ))),
    );
  }
}
