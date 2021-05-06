import 'dart:async';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:day_2_day/src/add_project_button.dart';
import 'package:day_2_day/src/project.dart';
import 'package:day_2_day/src/route_generator.dart';
import 'package:day_2_day/src/task.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'src/add_task_button.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';

enum test { t1, that }

void main() => runApp(const MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Day2Day",
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.amber.shade300,
          accentColor: Colors.cyan[600],
          fontFamily: GoogleFonts.montserrat().fontFamily),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

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

class ProjectShow extends State<ProjectScreen> {
  Timer timer;
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

  @override
  Widget build(BuildContext context) {
    for (var p in widget.projects) {
      p.updateTotalSumMinutes();
    }
    return Scaffold(
        appBar: AppBar(
          title: AutoSizeText("ALL PROJECTS"),
          centerTitle: true,
        ),
        body: Center(
            child: Column(children: [
          Expanded(
              child: SizedBox(
                  height: 300.0,
                  child: new ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: widget.projects.length,
                      padding: const EdgeInsets.only(top: 10.0),
                      itemBuilder: (BuildContext ctxt, int index) {
                        return widget.projects
                            .elementAt(index)
                            .getWidget(context);
                      }))),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AddProjectButton(addProj: (D2D_Project p) {
                widget.projects.add(p);
              }),
              Tooltip(
                message: 'Current Active Tasks',
                child: IconButton(
                    iconSize: 60,
                    icon: Icon(Icons.av_timer_outlined),
                    onPressed: () {
                      List<Task> listtemp = [];
                      for (var p in widget.projects) {
                        for (var t in p.associatedTasks) {
                          if (t.isActive) {
                            listtemp.add(t);
                          }
                        }
                      }
                      Navigator.of(context)
                          .pushNamed('/activetasks', arguments: listtemp);
                    }),
              ),
              Tooltip(
                message: 'Refresh',
                child: IconButton(
                    iconSize: 60,
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      refreshFetch();
                    }),
              ),
            ],
          ),
        ])));
  }
}

class TaskScreen extends StatefulWidget {
  TaskScreen({Key key, @required this.currentProject}) : super(key: key);
  final D2D_Project currentProject;

  @override
  Body createState() {
    return Body(currentProject);
  }
}

class Body extends State<TaskScreen> {
  List<Widget> listArray = [];

  Timer timer;
  D2D_Project p;

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

  Body(D2D_Project newProj) {
    this.p = newProj;
  }

  @override
  Widget build(BuildContext context) {
    if (listArray.length > 0) listArray.clear();

    for (var t in widget.currentProject.associatedTasks) {
      t.updateCurrentSessionDuration();
      listArray.add(
        new TaskWidget(
          widgetTask: t,
          onIsActiveStateChanged: (bool isActive) {
            if (isActive) {
              print("ACTIVE STATUS: ${t.name} STARTED");
              t.start();
            } else {
              print("ACTIVE STATUS: ${t.name} STOPED");
              t.stop();
              t.updateTotalDuration();
            }
          },
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.currentProject.name),
        ),
        body: Center(
            child: Column(
          children: [
            Expanded(
                child: SizedBox(
                    height: 300.0,
                    child: new ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: listArray.length,
                        padding: const EdgeInsets.only(top: 10.0),
                        itemBuilder: (BuildContext ctxt, int index) {
                          return listArray[index];
                        }))),
            AddTaskButton(
              addTask: (Task t) {
                print(t.name);
                widget.currentProject.addTask(t);
                setState(() {});
              },
            ),
          ],
        )));
  }
}

class TaskWidget extends StatefulWidget {
  final Task widgetTask;
  final ValueChanged<bool> onIsActiveStateChanged;

  const TaskWidget({
    Key key,
    @required this.widgetTask,
    this.onIsActiveStateChanged,
  }) : super(key: key);

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  bool cardDetails = false;

  IconButton _buildPlayPauseButton() {
    return IconButton(
      icon: (widget.widgetTask.isActive)
          ? Icon(Icons.pause)
          : Icon(Icons.play_arrow),
      iconSize: 50.0,
      onPressed: () {
        if (widget.widgetTask.isActive != null) {
          widget.widgetTask.isActive = !widget.widgetTask.isActive;
          widget.onIsActiveStateChanged(widget.widgetTask.isActive);
        }
      },
    );
  }

  String _getTimeString(int currentTime) {
    final time = Duration(seconds: currentTime);

    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    final minutes =
        twoDigits(time.inMinutes.remainder(Duration.minutesPerHour));
    final seconds =
        twoDigits(time.inSeconds.remainder(Duration.secondsPerMinute));

    final hours = time.inHours > 0 ? '${time.inHours}:' : '';
    return "$hours$minutes:$seconds";
  }

  Text _buildCurrentTimeLabel() {
    return Text(
      _getTimeString(widget.widgetTask.currentSessionDuration),
      style: TextStyle(
          fontFeatures: [FontFeature.tabularFigures()],
          fontWeight: FontWeight.bold,
          fontSize: 30.0),
    );
  }

  Text _buildTotalTimeLabel() {
    return Text(
      _getTimeString(widget.widgetTask.totalDuration),
      style: TextStyle(
          fontFeatures: [FontFeature.tabularFigures()],
          fontWeight: FontWeight.bold,
          fontSize: 30.0),
    );
  }

  @override
  Widget build(BuildContext context) {
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
  }
}
