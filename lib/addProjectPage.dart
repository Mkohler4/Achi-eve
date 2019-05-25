import 'package:achieve/models/models.dart';
import 'package:flutter/material.dart';

import 'titledWidget.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AddProjectPage extends StatefulWidget {

  Graph graph;
  List<String> pass;

  AddProjectPage(){
    graph = Graph();
    pass = [];
  }

  @override
  _AddProjectPageState createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {

  int count = 0;

  final _formKey = GlobalKey<FormState>();
  double pointSlider = 1;

  void addVertex(String name, String desc, int points){
    setState(() {
      this.widget.graph.addNode(Component(
        name,
        points,
        desc: desc
      )); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Text("Verticies:"),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: widget.graph.getComponents().length,
            itemBuilder: (BuildContext context, i){
              Component comp = widget.graph.getComponent(i).getData();
              return Text(comp.name);
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.blue,
            onPressed: (){
              showDialog(
                context: context,
                builder: (BuildContext context) => _AddVertex(callBack: addVertex,)
              );
            },
          )
        ],
      ),
    );
  }
}

class _AddVertex extends StatefulWidget {
  
  final Function callBack;

  _AddVertex({
    Key key,
    this.callBack
  }) : super(key: key);

  

  @override
  __AddVertexState createState() => __AddVertexState();
}

class __AddVertexState extends State<_AddVertex> {
  
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int pointSlider = 0;
  String name = "";
  String desc = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pointSlider = 1;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Vertex"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      actions: <Widget>[
        MaterialButton(
          child: Text("Cancel", style: TextStyle(color: Colors.red),),
          onPressed: () => Navigator.pop(context),
          color: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
        ),
        MaterialButton(
          child: Text("Save", style: TextStyle(color: Colors.blue),),
          onPressed: (){
            print("saved");
            if(_formKey.currentState.validate()){
              _formKey.currentState.save();
              this.widget.callBack(name, desc, pointSlider);
              Navigator.pop(context);
            }
          },
          color: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
        ),
      ],
      content: Container(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                onSaved: (String value){
                  name = value;
                },
                validator: (String value) {
                  return value.isEmpty ? 'Vertex name cannot be empty' : null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  onSaved: (String value){
                    desc = value;
                  },
                ),
              ),
              TitledWidget(
                "Points",
                headerStyle: TextStyle(color: Colors.black54),
                widget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("1", style: TextStyle(color: Colors.black54),),
                    Slider(
                      divisions: 10,
                      value: pointSlider.toDouble(),
                      onChanged: (double value) {
                        setState(() {
                          pointSlider = value.round();
                        });
                      },
                      max: 10,
                      min: 1,
                      label: pointSlider.toString(),
                    ),
                    Text("10", style: TextStyle(color: Colors.black54),),
                  ],
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}