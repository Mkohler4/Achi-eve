
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class Profile{
  String _name;
  String password;
  

  Profile(this._name, this.password);

  String getName() => _name;
}

class Project{

  Graph graph;

  List<String> passwords = [];

  Project(this.graph, [this.passwords]);

  factory Project.fromJSON(Map<String, dynamic> json){
    Graph graph = Graph();
    List<String> pass = [];

    //add verticies to the graph
    List<dynamic> list = json["values"];

    //adds passwords to the list
    for(int i = 0; i < list[0].length; i++){
      pass.add(list[0][i].toString());
    }

    for (int i = 1; i < list.length; i++) {
      Component comp = Component(
        list[i][0],
        list[i][1] != "" ? int.parse(list[i][1]) : 0,
        desc: list[i][2],
        ownerPassword: list[i][4],
        done: list[i][3] == "1" ? true : false
      );

      graph.addNode(comp);
    }

    //add edges to the graph
    for (int i = 1; i < list.length; i++) {
      for (int j = 5; j < list[i].length; j++) {
        if(list[i][j] == "1" && graph.getComponent(i-1).getData().done != true)
          graph.addConnection(i - 1, j-5);
      }
    }

    return Project(graph, pass);
  }

  factory Project.fromFirebase(DocumentSnapshot doc){
    Graph graph = Graph();
    List<String> pass = [];

    Map<String, dynamic> map = doc.data;

    for(String password in map['passwords']){
      pass.add(password);
    }

    List<dynamic> vertecies = map['vertecies'];

    for(dynamic vertex in vertecies){
      Component comp = Component(
        vertex['name'],
        vertex['points'],
        desc: vertex['desc'],
        done: vertex['done'],
        ownerPassword: vertex['owner']
      );

      graph.addNode(comp);
    }

    for(int i = 0; i < vertecies.length; i++){
      for(int j = 0; j < vertecies.length; j++){
        if(vertecies[i]['edges'][j] == true) graph.addConnection(i, j);
      }
    }

    print(doc['passwords'][0]);


    return Project(graph, pass);
  }

  ///gets the finished progress for the project
  double getProgress(){
    double progress = 0;
    for (Component comp in getAll()) {
      if(comp.done == true)
        progress += comp.difficulty;
    }
    return progress;
  }

  ///gets the points for the project
  double getTotalProgress(){
    double max = 0;
    for (Component comp in getAll()) {
      max += comp.difficulty;
    }
    return max;
  }

  List<Component> getAll() {
    List<Component> list = graph.getComponents();
    // list.addAll(done);
    return list;
  }

  List<Component> ownerList(String password){
    List<Component> list = [];
    for (Component item in graph.getComponents()) {
      if(item.ownerPassword == password && item.done == false) list.add(item);
    }

    return list;
  }

  List<Component> openList(){
    List<Component> list = [];
    for (var i = 0; i < graph.getComponents().length; i++) {
      if(!graph.hasConnections(i) && graph.getComponent(i).getData().ownerPassword == "") list.add(graph.getComponent(i).getData());
    }
    return list;
  }

  List<Component> closedList(){
    List<Component> list = [];
    for (var i = 0; i < graph.getComponents().length; i++) {
      if(graph.hasConnections(i)) list.add(graph.getComponent(i).getData());
    }

    return list;
  }

  List<Component> takenList(String password){
    List<Component> list = [];
    for (Component item in graph.getComponents()) {
      if(item.ownerPassword != password && item.ownerPassword != "" && item.done == false) list.add(item);
    }

    return list;
  }

  ///returns diiferent string alues for the status of the task
  ///O - open
  ///Y - yours
  ///T - taken
  ///C - closed
  ///D - done
  String componentStatus(Component comp, String password){
    if(comp.done == true) return "D";
    else if(openList().contains(comp)) return "O";
    else if(ownerList(password).contains(comp)) return "Y";
    else if(takenList(password).contains(comp)) return "T";
    else return "C";
  }
  
}

class Component{
  String name;
  String desc;
  String ownerPassword;
  int difficulty;

  bool done;
  
  Component(this.name, this.difficulty, {this.ownerPassword = "", this.desc = "", this.done = false});

}

class Edge{
  
  List<Vertex> endPoints = [];

  Edge(Vertex u, Vertex v){
    endPoints.add(u);
    endPoints.add(v);
  }

}

class Vertex{
  Component _data;
  List<Edge> incoming = [];
  List<Edge> outgoing = [];

  Vertex(this._data);

  Component getData() => _data;

}

class Graph{
  final List<Edge> _edges = [];
  final List<Vertex> _vertecies = [];

  List<Component> getComponents(){
    List<Component> list = [];
    for (Vertex vertex in _vertecies) {
      list.add(vertex.getData());
    }
    return list;
  }

  List<Edge> getEdges() => _edges;

  void addNode(Component component){
    _vertecies.add(Vertex(component));
  }

  void removeNode(Component comp){
    List<Edge> removeEgdes = [];
    for(Edge edge in _edges){
      if(edge.endPoints[0].getData() == comp || edge.endPoints[1].getData() == comp)
        removeEgdes.add(edge);
    }
    for(Edge edge in removeEgdes){
      _edges.remove(edge);
    }

    List<Vertex> removeVertex = [];
    for(Vertex vertex in _vertecies){
      if(vertex.getData() == comp)
        removeVertex.add(vertex);
    }
    for(Vertex vertex in removeVertex){
      _vertecies.remove(vertex);
    }
  }

  void removeEdge(Edge e){
    _edges.remove(e);
  }

  void addConnection(int startIndex, int endIndex){
    Edge e = Edge(getComponent(startIndex), getComponent(endIndex));
    getComponent(startIndex).outgoing.add(e);
    getComponent(endIndex).incoming.add(e);
    _edges.add(e);
  }

  ///checks if anything is connected to the indexed component
  bool hasConnections(int index) => _vertecies[index].incoming.length > 0 ? true : false;

  Vertex getComponent(int index){
    return _vertecies[index];
  }

  int getVertexIndex(Vertex comp){
    for (int i = 0; i < _vertecies.length; i++) {
      if(_vertecies[i] == comp) return i;
    }
    return -1;
  }

  int getComponentIndex(Component comp){
    for (int i = 0; i < _vertecies.length; i++) {
      if(_vertecies[i].getData() == comp) return i;
    }
    return -1;
  }

  void printGraph(){
    print("Verticies:");
    for (Vertex vertex in _vertecies) {
      print(vertex.getData().name);
    }
    print("");
    print("Edges:");
    for (Edge edge in _edges) {
      print(edge.endPoints[0].getData().name + "->" + edge.endPoints[1].getData().name);
    }
    print("---------------");
    print("");
  }
}