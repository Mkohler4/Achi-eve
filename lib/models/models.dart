
class Profile{
  String _name;
  String password;

  Profile(this._name, this.password);

  String getName() => _name;
}

class Project{

  Graph graph;

  Project(this.graph);

  factory Project.fromJSON(Map<String, dynamic> json){
    Graph graph = Graph();

    //add verticies to the graph
    List<dynamic> list = json["values"];

    for (int i = 0; i < list.length; i++) {
      graph.addNode(Component(list[i][0], 0));
    }

    //add edges to the graph
    for (int i = 0; i < list.length; i++) {
      for (int j = 1; j < list[i].length; j++) {
        if(list[i][j] == "1")
          graph.addConnection(i, j-1);
      }
    }

    // graph.printGraph();

    return Project(graph);
  }

  List<Component> getAll() => graph.getComponents();

  List<Component> ownerList(String password){
    List<Component> list = [];
    for (Component item in graph.getComponents()) {
      if(item.ownerPassword == password) list.add(item);
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

  void addNode(Component component){
    _vertecies.add(Vertex(component));
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

  int getComponentIndex(Vertex comp){
    for (int i = 0; i < _vertecies.length; i++) {
      if(_vertecies[i] == comp) return i;
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