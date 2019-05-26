import 'package:achieve/models/models.dart';
import 'package:flutter/material.dart';

import 'titledWidget.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AddProjectPage extends StatefulWidget {

  AddProjectPage(){}

  @override
  _AddProjectPageState createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {

  final _formKey = GlobalKey<FormState>();

  final Graph graph = Graph();
  final List<String> pass = [];

  String projectName;

  void addVertex(String name, String desc, int points){
    setState(() {
      graph.addNode(Component(
        name,
        points,
        desc: desc
      )); 
    });

    
  }

  void addEdge(Component start, Component end){
    setState(() {
      int startIndex = graph.getComponentIndex(start);
      int endIndex = graph.getComponentIndex(end);
      graph.addConnection(startIndex, endIndex);
    });
  }

  @override
  void initState() {
    projectName = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create a Project"),
        actions: <Widget>[
          MaterialButton(
            onPressed: (){
              if(_formKey.currentState.validate()){
                setState(() {
                  _formKey.currentState.save();
                });

                Project project = Project(graph, pass, projectName);

                project.uploadToFireBase();

                Navigator.pop(context);
              }
            },
            child: Text("Save", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
            color: Colors.blue,
            highlightColor: Colors.transparent,
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 15),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "The name of the project",
                ),
                validator: (String val){
                  if(val.isEmpty) return "Project name can not be empty";
                },
                onSaved: (String val){
                  projectName = val;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Center(child: Text("Verticies", style: TextStyle(color: Colors.black, fontSize: 30,),)),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: graph.getComponents().length,
            itemBuilder: (BuildContext context, i){
              Component comp = graph.getComponent(i).getData();
              return Card(
                child: ListTile(
                  title: Text(comp.name),
                  subtitle: comp.desc != "" ? Text(comp.desc) : null,
                  leading: Text(comp.difficulty.toString(), style: TextStyle(fontSize: 20),),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        graph.removeNode(comp);
                      });
                    },
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.blue,
            iconSize: 30,
            onPressed: (){
              showDialog(
                context: context,
                builder: (BuildContext context) => _AddVertexDialog(callBack: addVertex,)
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Center(child: Text("Edges:", style: TextStyle(color: Colors.black, fontSize: 30,),)),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: graph.getEdges().length,
            itemBuilder: (BuildContext context, i){
              Edge edge = graph.getEdges()[i];
              return Card(
                child: ListTile(
                  title: Text(edge.endPoints[0].getData().name.toString() + "  ->  " + edge.endPoints[1].getData().name.toString()),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        graph.removeEdge(edge);
                      });
                    },
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.blue,
            iconSize: 30,
            onPressed: (){
              showDialog(
                context: context,
                builder: (BuildContext context) => _AddEdgeDialog(components: graph.getComponents(), callBack: addEdge,)
              );
            },
          )
        ],
      ),
    );
  }
}

class _AddEdgeDialog extends StatefulWidget {

  final List<Component> components;
  final Function callBack;

  const _AddEdgeDialog({
    Key key,
    @required this.components,
    this.callBack
  }) : super(key: key);

  @override
  __AddEdgeDialogState createState() => __AddEdgeDialogState();
}

class __AddEdgeDialogState extends State<_AddEdgeDialog> {
  //TODO: make sure no duplicates
  Component comp1;
  Component comp2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    comp1 = null;
    comp2 = null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Add Edge"),
      actions: <Widget>[
        MaterialButton(
          child: Text("Cancel", style: TextStyle(color: Colors.red),),
          onPressed: () => Navigator.pop(context),
          color: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
        ),
        MaterialButton(
          child: Text("Save", style: TextStyle(color: 
            comp1 == null || comp2 == null || comp1 == comp2 ? Colors.grey : Colors.blue
          ),),
          onPressed: (){
            if(comp1 != null && comp2 != null && comp1 != comp2){
              if(this.widget.callBack != null) this.widget.callBack(comp1, comp2);
              Navigator.pop(context);
            }
          },
          color: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
        ),
      ],
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TitledWidget(
              "From:",
              widget: DropdownButton<Component>(
                value: comp1,
                items: this.widget.components.map<DropdownMenuItem<Component>>((Component value) {
                  return DropdownMenuItem<Component>(
                    value: value,
                    child: Text(value.name),
                  );
                }).toList(), 
                onChanged: (Component value) {
                  setState(() {
                    comp1 = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 20),
              child: TitledWidget(
                "To:",
                widget: DropdownButton<Component>(
                  value: comp2,
                  items: this.widget.components.map<DropdownMenuItem<Component>>((Component value) {
                    return DropdownMenuItem<Component>(
                      value: value,
                      child: Text(value.name),
                    );
                  }).toList(), 
                  onChanged: (Component value) {
                    setState(() {
                      comp2 = value;
                    });
                  },
                ),
              ),
            ),
            (comp1 != null && comp2 != null) && comp1 == comp2 ?
              Text("An edge cannot lead back to itself", style: TextStyle(color: Colors.red, fontSize: 13),) : Container()
          ],
        ),
      ),
    );
  }
}

class _AddVertexDialog extends StatefulWidget {
  
  final Function callBack;

  _AddVertexDialog({
    Key key,
    this.callBack
  }) : super(key: key);

  

  @override
  _AddVertexDialogState createState() => _AddVertexDialogState();
}

class _AddVertexDialogState extends State<_AddVertexDialog> {
  
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
            if(_formKey.currentState.validate()){
              _formKey.currentState.save();
              if(this.widget.callBack != null) this.widget.callBack(name, desc, pointSlider);
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
                  if(value.isEmpty) return 'Vertex name cannot be empty';
                  //TODO: made sure 2 components cannot be named the same
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