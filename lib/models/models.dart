


class Profile{
  String _name;
  String password;

  Profile(this._name, this.password);

  String getName() => _name;
}

class Project{

  Graph _graph;

  Project(this._graph);

  factory Project.fromJSON(Map<String, dynamic> json){
    Graph graph = Graph();
    //TODO: graph binding logic
    return Project(graph);
  }

  List<Component> getAll() => _graph.getComponents();

  List<Component> ownerList(String password){
    List<Component> list = [];
    for (Component item in _graph._components) {
      if(item.ownerPassword == password) list.add(item);
    }

    return list;
  }

  List<Component> openList(){
    List<Component> list = [];
    for (var i = 0; i < _graph.getComponents().length; i++) {
      if(!_graph.hasConnections(i) && _graph.getComponent(i).ownerPassword == "") list.add(_graph.getComponent(i));
    }
    return list;
  }

  List<Component> closedList(){
    List<Component> list = [];
    for (var i = 0; i < _graph.getComponents().length; i++) {
      if(_graph.hasConnections(i)) list.add(_graph.getComponent(i));
    }

    return list;
  }

  List<Component> takenList(String password){
    List<Component> list = [];
    for (Component item in _graph._components) {
      if(item.ownerPassword != password && openList().contains(item)) list.add(item);
    }

    return list;
  }

}

class Component{
  String name;
  String desc;
  String ownerPassword;
  double percentage;
  
  Component(this.name, this.percentage, {this.ownerPassword = "", this.desc = ""});

}

class Graph{
  List<List<bool>> _adj;

  List<Component> _components;

  List<Component> getComponents() => _components;

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

  int getComponentIndex(Component comp){
    for (int i = 0; i < _components.length; i++) {
      if(_components[i] == comp) return i;
    }
    return -1;
  }
}