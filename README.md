# Day2Day_INF1300
## Relatório

### Objetivos da Entrega:

1. Navegação entre telas: com pelo menos 4 namedRoutes;
2. Uso de ListTile  ou Card, contendo um icone/ imagem, e textos, e com reatividade onClick())
3. Uso de widgets Row/Column aninhados, ou Grid 
4. Uso de widgets Container alterando o layout de widgets child
5. Usar stageful widgets
5. Uso das classes Theme  e o TextTheme para customizar o look&feel do seu app 
6. Uso do widget GestureDetection ou SwipeDetector para redefinir uma gesture "do seu jeito" 
7. Fazer acesso HTTP a alguma free API para buscar alguma formação específica (*) e usar async/await e try-fetch para captar erros

### Relatório das Entregas
## 1. Navegação entre telas: com pelo menos 4 namedRoutes

As named routes estão separadas em uma classe só para melhor organização do código: 

*RouteGenerator* - no arquivo - *route_generator.dart*
```
switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => ProjectScreen());
      case '/second':
        if (args is D2D_Project) {
          return MaterialPageRoute(
              builder: (_) => TaskScreen(currentProject: args));
        }
        return _errorRoute();
        break;
      case '/activetasks':
        print(args);
        if (args is List<Task>) {
          return MaterialPageRoute(
              builder: (_) => ActiveTasksScreen(listactivetasks: args));
        }
        return _errorRoute();
```

Existe uma outras duas rotas de navegação para uma transição usando Hero: 

```
onTap: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return _AddTaskPopupCard(
              addTask: addTask,
            );
```
e
```
onTap: () {
            Navigator.of(context).push(HeroDialogRoute(builder: (context) {
              return _AddProjectPopupCard(
                addProj: addProj,
              );
```
## 2. Uso de ListTile  ou Card, contendo um icone/ imagem, e textos, e com reatividade onClick())
## 3. Uso de widgets Row/Column aninhados, ou Grid 
## 4. Uso de widgets Container alterando o layout de widgets child
## 7. Uso do widget GestureDetection ou SwipeDetector para redefinir uma gesture "do seu jeito" 

O uso de cards/Row/Column/Container está bem difundido pelo projeto e normalmente foram usados juntos.
Também utilizam de reatividade onPressed. 

Segue alguns exemplos:

![taaMpyNkUA](https://user-images.githubusercontent.com/17135028/117267431-a251dc80-ae2c-11eb-976b-24ef3fe880f0.png)

```
child: Card(
          shadowColor: Colors.cyan.shade100,
          color: Colors.amberAccent,
          child: Container(
              padding: EdgeInsets.all(30.0),
              margin: EdgeInsets.all(15.0),
              alignment: Alignment.centerLeft,
              color: Colors.black87,
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 80,
                    child: Container(
                        //color: Colors.red.shade200,
                        child: Column(
                      children: [
                        Container(
                          decoration: myBoxDecoration(),
                          child: AutoSizeText(
                            this.name,
                            textAlign: TextAlign.center,
                            minFontSize: 20,
                          ),
                        ),
                      ],
                    )),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      //color: Colors.green.shade200,
                      child: Row(
                        children: [
                          AutoSizeText("     Minutes: ", minFontSize: 18),
                          AutoSizeText(_getTimeString(), minFontSize: 18),
                        ],
                      ),
                    )
                  ],
                ),
              ]))),
    );
```
Neste card foi utilizado o *onDoubleTap* do Gesture Detector para mostrar mais ou menos detalhes.

![xBRCIAOUCi](https://user-images.githubusercontent.com/17135028/117267714-f230a380-ae2c-11eb-9678-4f9120f75009.png)
![pOX3ZJjqzV](https://user-images.githubusercontent.com/17135028/117269273-864f3a80-ae2e-11eb-9e0e-3280b90f2d34.png)


```
return Card(
        child: GestureDetector(
      onDoubleTap: () {
        cardDetails = !cardDetails;
      },
      child: Container(
          padding: EdgeInsets.all(15.0),
          margin: EdgeInsets.all(10.0),
          alignment: Alignment.centerLeft,
          color: widget.widgetTask.isActive
              ? Colors.amber.shade700
              : Colors.black26,
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Expanded(
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Material(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            //color: Colors.red.shade200,
                            child: Column(
                              children: [
                                AutoSizeText(
                                  widget.widgetTask.name,
                                  textAlign: TextAlign.center,
                                ),
                                _buildPlayPauseButton(),
                              ],
                            )))),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Material(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Container(
                          //color: Colors.green.shade100,
                          child: Row(
                            children: [
                              AutoSizeText("Current Session"),
                              _buildCurrentTimeLabel()
                            ],
                          ),
                        ),
                        Container(
                          //color: Colors.green.shade200,
                          child: Row(
                            children: [
                              AutoSizeText("Total Duration"),
                              _buildTotalTimeLabel()
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ]),
              cardDetails
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AutoSizeText(
                            "Description: ${widget.widgetTask.description}"),
                        AutoSizeText("UniqueID: ${widget.widgetTask.id}")
                      ],
                    )
                  : Container()
            ],
          )),
    ));
```
## 5. Usar stageful widgets

Stateful Widgets foram utilizados em abundância no projeto, visto que é necessário atualizar constamente os widgets para mostrar o tempo de cada tarefa.

```
class ProjectScreen extends StatefulWidget {
  final projects = <D2D_Project>{};

  ProjectScreen({Key key}) {
    projects.add(D2D_Project("REIGNS"));
    projects.elementAt(0).addTask(Task("REIGNS 1 ", "TESTE 1"));
    //
    projects.add(D2D_Project("TERRA PULSE"));
    projects.elementAt(1).addTask(Task("TP 1 ", "TESTE 2"));
  }

  @override
  ProjectShow createState() {
    return ProjectShow();
  }
}
```
O ProjectShow como estado instância um timer que rebuilda o widget a cada um segundo:

```
class ProjectShow extends State<ProjectScreen> {
...
...

 @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  ...
  ...
  ...
}
```

## 6. Uso das classes Theme  e o TextTheme para customizar o look&feel do seu app 

Não me conzidero nenhum designer, mas creio que as cores ficaram aceitáveis. Utilizei a configuração global e outras dentro dos próprios Containers.
Além das cores a font family foi alterada usando Google Fonts.

```
return MaterialApp(
      title: "Day2Day",
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.amber.shade300,
          accentColor: Colors.cyan[600],
          fontFamily: GoogleFonts.montserrat().fontFamily),
```

# 8. Fazer acesso HTTP a alguma free API para buscar alguma formação específica (*) e usar async/await e try-fetch para captar erros

Utilizei uma [API](https://github.com/nicopaes/haxe-task-web) contruída por mim exclusivamente para o projeto. Apesar de simples no primeiro momento, ela tem muito espaço para expansão.

Por equanto existe somente o GET de uma rota específica que retorna um Json com as informações dos projetos guardados no banco de dados.

```
https://day2dayapitest1.herokuapp.com/projects/get
```

O Json fica assim:

```
{
     "Project" : [
         {
             "_hxcls" : "Project"
            ,"name" : "Reigns"
            ,"id" : "3fd98ce3-3ce4-4136-84fc-de4caf27179d"
            ,"totalSumSeconds" : 0
            ,"timeOfCreation" : "2021-05-06 01:04:52"
            ,"associatedTasks" : [
                 {
                     "_hxcls" : "Task"
                    ,"name" : "This mf task"
                    ,"id" : "3fd98ce4-beb5-4085-b273-d101fee81d96"
                    ,"totalDuration" : 0
                    ,"setStarts" : [

                    ]
                    ,"setStops" : [

                    ]
                }
            ]
        }
    ]
}
```

E é recebido no Flutter nesse ponto:

```
Future<D2D_Project> futureProject;

  Future<List<D2D_Project>> fetchTasks() async {
    final response = await http.get(
        Uri.https('day2dayapitest1.herokuapp.com', 'projects/get'),
        headers: {
          "Accept": "application/json",
          "Access-Control_Allow_Origin": "*",
          "Access-Control-Allow-Methods": "GET, POST"
        });
    if (response.statusCode == 200) {
      print(response.body);
      var firstPass = json.decode(response.body); //DECODE TWICE!??!?!?!?!
      Iterable iter = json.decode(firstPass)['Project'];
      print(iter);
      List<D2D_Project> newList = List<D2D_Project>.from(
          iter.map((model) => D2D_Project.fromJson(model)));
      return newList;
    } else {
      return [];
    }
  }

  void refreshFetch() {
    var newProj = fetchTasks();
    newProj.then((proj) {
      for (var project in proj) {
        if (!widget.projects.contains(project)) {
          widget.projects.add(project);
        }
        print(project.name);
      }
      print(proj[0].name);
    });
  }
```

Após receber e decode o Json o app já constrói um objeto da classe D2D_Project, usando uma factory, e o adciona na lista.

```
//FACTORY
D2D_Project.fromInfo(
      {@required this.name,
      @required this.timeOfCreation,
      @required this.totalSumSeconds,
      @required this.id,
      @required this.associatedTasks});

  factory D2D_Project.fromJson(Map<String, dynamic> json) {
    List<Task> newTaskList = [];
    for (var t in json['associatedTasks']) {
      Task newT = Task.fromJson(t);
      print(newT.name);
      newTaskList.add(newT);
    }
    return D2D_Project.fromInfo(
        name: json['name'],
        id: json['id'],
        totalSumSeconds: json['totalSumSeconds'],
        associatedTasks: newTaskList,
        timeOfCreation: DateTime.parse(json['timeOfCreation']));
  }
```

