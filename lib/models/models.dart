

import 'dart:math';

class Profile{
  String _name;

  Profile(this._name);

  String getName() => _name;
}

class Project{


  List<Component> ownerList(String name){
    List<Component> list = [];


    return list;
  }

  List<Component> openList(){
    List<Component> list = [];


    return list;
  }

  List<Component> closedList(){
    List<Component> list = [];


    return list;
  }

  List<Component> takenList(){
    List<Component> list = [];


    return list;
  }

}

class Component{
  String name;
  String desc;
  String owner;
  double percentage;
  
  Component(this.name, this.percentage, {this.owner = "", this.desc = ""});

}

class Graph{
  List<List<bool>> _adj;

  List<Component> _components;

  void addNode(Component component){
    _components.add(component);
    for (List<bool> list in _adj) {
      list.add(false);
    }
    _adj.add(List<bool>(_adj[0].length));
  }

  void addConnection(int startIndex, int endIndex){
    _adj[startIndex][endIndex] = true;
  }

  bool isConnection(int startIndex, int endIndex) => _adj[startIndex][endIndex];

  ///checks if anything is connected to the indexed component
  bool hasConnections(int index){
    for (List<bool> list in _adj) {
      if(list[index]) return true;
    }
    return false;
  }

  Component getComponent(int index){
    return _components[index];
  }
}