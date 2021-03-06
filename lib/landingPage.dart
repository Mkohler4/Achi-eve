import 'dart:convert';

import 'package:flutter/material.dart';

import 'discriptionPage.dart';
import 'models/models.dart';
import 'percentBar.dart';
import 'addProjectPage.dart';

import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class LandingPage extends StatefulWidget {
  bool isSelected1;
  bool isSelected2;
  LandingPage({this.isSelected1 = false, this.isSelected2 = false});
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  String userPassword = "ibte";

  Project project;

  String spreadsheetID = "1UyYdOLiPKpJ_0qkSnWFzriqiVcu6CnfZQibdeKya-sM";
  String apiKey = "AIzaSyA8fqeR9BYGxm_AV1h3nZ0fhFt_XSuF9p0";

  Future<void> pullInfo(String hash) async{    
    await Firestore.instance.collection("Project").document(hash).get().then((DocumentSnapshot doc){
      setState(() {
        project = Project.fromFirebase(doc); 
      });
    });     
  }

  void updatePassword(String val){
    setState(() {
      userPassword = val;
    });
  }


  @override
  void initState() {
    super.initState();

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
                  builder: (BuildContext context) => _OptionsAlert(callBack: updatePassword, title: "Name",)
                );
              },
            )
          ],
          iconTheme: new IconThemeData(color: Colors.black),
          title: GestureDetector(
            onTap: (){
              showDialog(
                context: context,
                builder: (BuildContext context) => _OptionsAlert(callBack: pullInfo, title: "Project Hash",)
              );
            },
            child: Text(project != null ? project.name.toUpperCase() : "Project",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 23)),
          ),
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
          child: Center(
            child: MaterialButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddProjectPage()));
              },
              child: Text("Add New Project", style: TextStyle(color: Colors.white, fontSize: 20),),
              color: Colors.blue,
            ),
          )
        ),

        //BODY
        body: Stack(children: <Widget>[
          TabBarView(
            children: [
              project != null ?
                project.ownerList(userPassword).length != 0 ?
                  ListView.builder(
                    itemCount: project != null ? project.ownerList(userPassword).length : 0,
                    itemBuilder: (context, int i) {
                      return OwnerCard.fromComponent(project.ownerList(userPassword)[i], project, userPassword);
                    }
                  ) :
                OwnerCard(color: Colors.white, title: "Nothing to show", points: 0, name: "",) : OwnerCard(color: Colors.white, title: "Nothing to show", points: 0, name: "",),

              project != null ?
                project.openList().length != 0 ?
                  ListView.builder(
                    itemCount: project != null ? project.openList().length : 0,
                    itemBuilder: (context, int i) {
                      return OwnerCard.fromComponent(project.openList()[i], project, userPassword);
                    }
                  ) : 
                  OwnerCard(color: Colors.white, title: "Nothing to show", points: 0, name: "",) : OwnerCard(color: Colors.white, title: "Nothing to show", points: 0, name: "",),

              project != null ?
                project.getAll().length != 0  && project != null ? 
                  ListView.builder(
                    
                    itemCount: project != null ? project.getAll().length : 0,
                    itemBuilder: (context, int i) {
                      return OwnerCard.fromComponent(project.getAll()[i], project, userPassword);
                    }
                  ) : 
                  OwnerCard(color: Colors.white, title: "Nothing to show", points: 0, name: "",) : OwnerCard(color: Colors.white, title: "Nothing to show", points: 0, name: "",),
            ],
          ),

          //PROGRESS BAR
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0, left: 15, right: 15),
                child: SegmentedPercentBar(
                  height: 30,
                  percentages: project != null ? [project.getProgress()/project.getTotalProgress()] : [0],
                  progressColors: [Colors.blue],
                  borderColor: Colors.black,
                  backgroundColor: Colors.transparent,
                  borderRadius: 25,
                  borderWidth: 1,
                )
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
  final int points;

  final Component component;
  
  const OwnerCard({
    this.component,
    this.points = 0,
    this.color = Colors.red,
    this.title = "Components",
    this.name = "Markus Kohler",
    Key key,
  }) : super(key: key);

  factory OwnerCard.fromComponent(Component comp, Project project, String password){
    String status = project.componentStatus(comp, password); //task status determiner
    return OwnerCard(
      component: comp,
      points: comp.difficulty,
      color:status == "O" ? Colors.yellow : //open tasks
            status == "Y" ? Colors.green : //owner tasks
            status == "T" ? Colors.red : //taken tasks
            status == "D" ? Colors.blue :
            Colors.grey, //closed takss
      name: comp.ownerPassword,
      title: comp.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DiscriptionPage(title: component.name, discription: component.desc,)),
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
                  this.points != 0 ? this.points.toString() : "",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ))),
    );
  }
}

class _OptionsAlert extends StatefulWidget {

  final Function callBack;
  final String title;

  _OptionsAlert({
    @required this.callBack,
    this.title = "",
    Key key,
  }) : super(key: key);

  @override
  _OptionsAlertState createState() => _OptionsAlertState();
}

class _OptionsAlertState extends State<_OptionsAlert> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: <Widget>[
        MaterialButton(
          child: Text("Save", style: TextStyle(color: Colors.blue),),
          onPressed: (){
            print("saved");
            if(_formKey.currentState.validate()){
              _formKey.currentState.save();
              Navigator.pop(context);
            }
          },
          color: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text("Options", style: TextStyle(fontSize: 20),)),
          ),
          Form(
            key: _formKey,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: this.widget.title,
                hintText: "Rename"
              ),
              validator: (String val){
                if(val.isEmpty) return "Name cannot be empty";
              },
              onSaved: (String val){
                widget.callBack(val);
              },
            ),
          )
        ],
      ),
    );
  }
}