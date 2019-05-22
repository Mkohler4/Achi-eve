
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
      graph.addNode(
        Component(
          list[i][0],
          list[i][1] != "" ? int.parse(list[i][1]) : 0,
          desc: list[i][2],
          ownerPassword: list[i][3] 
        )
      );
    }

    //add edges to the graph
    for (int i = 1; i < list.length; i++) {
      for (int j = 4; j < list[i].length; j++) {
        if(list[i][j] == "1")
          graph.addConnection(i - 1, j-4);
      }
    }

    // graph.printGraph();

    return Project(graph, pass);
  }

  List<Component> getAll() => graph.getComponents();

  List<Component> ownerList(String password){
    List<Component> list = [];
    print(password);
    for (Component item in graph.getComponents()) {
      if(item.ownerPassword == password) list.add(item);
      print(item.ownerPassword);
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

  ///returns diiferent string alues for the status of the task
  ///O - open
  ///Y - yours
  ///T - taken
  ///C - closed
  String componentStatus(Component comp, String password){
    if(openList().contains(comp)) return "O";
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
  
  Component(this.name, this.difficulty, {this.ownerPassword = "", this.desc = ""});

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