import 'package:achieve/models/models.dart';
import 'package:flutter/material.dart';

class DiscriptionPage extends StatelessWidget {
  final String title;
  final String discription;

  final Component component;
  final Project project;
  final String status;

  DiscriptionPage({this.title = "Component", this.discription = "insert description", @required this.component, @required this.project, @required this.status});

  factory DiscriptionPage.fromComponent(Component comp, Project project, String pass){
    return DiscriptionPage(
      title: comp.name,
      discription: comp.desc,
      component: comp,
      project: project,
      status: pass,
    );
  }

  //the buttons that appear in a discription page depending on component status
  Widget descButtons(){
    if(component == null || project == null) return null;
    else{
      return Center(
        child: status == "O" ? RaisedButton(
          onPressed: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Take Task", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),),
          ),
          color: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(color: Colors.green[300], width: 2),
          ),
        ) :
        status == "Y" ? Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("Finish", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),),
              ),
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: BorderSide(color: Colors.blue[300], width: 2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: RaisedButton(
                onPressed: () {},
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text("Stop working on Task", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                ),
                color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),

                ),
              ),
            )
          ],
        ) :
        status == "T" ? Text("Taken by: ${component.ownerPassword}") :
        status == "D" ? Text("Completed by: ${component.ownerPassword}") :
        Text("Closed"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            this.title.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
          ),
        ),
        body: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20),
            child: Center(
              child: Text("Description",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      decoration: TextDecoration.underline)),
            ),
          ),
          Center(
            child: Text(
              discription,
              style: TextStyle(fontSize: 20,),
            ),
          ),
          Expanded(child: Container(), flex: 1,),
          Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: descButtons(),
          )
        ]));
  }
}
