import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:day_2_day/src/notification_service.dart';
import 'package:day_2_day/store/localization.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:http/http.dart' as http;

import 'package:day_2_day/src/project.dart';
import 'package:day_2_day/src/task.dart';
import 'package:flutter/material.dart';

import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:day_2_day/store/user.dart';

class ProjectScreen extends StatefulWidget {
  final projects = <D2D_Project>{};
  final User user = User();
  final Localization localz = Localization();

  ProjectScreen({Key key, String userName, Locale currentL}) {
    // projects.add(D2D_Project("REIGNS"));
    // projects.elementAt(0).addTask(Task("REIGNS 1 ", "TESTE 1"));
    // //
    // projects.add(D2D_Project("TERRA PULSE"));
    // projects.elementAt(1).addTask(Task("TP 1 ", "TESTE 2"));
    //
    user.changeCurrentUser(userName);
    localz.changeLanguage(currentL.languageCode, currentL.countryCode);
  }

  @override
  ProjectShow createState() {
    return ProjectShow();
  }
}

class ProjectShow extends State<ProjectScreen> {
  Timer timer;
  Future<D2D_Project> futureProject;

  int currentPage = 0;
  bool _readyAddProject = false;

  GlobalKey bottomNavigationKey = GlobalKey();

  TextEditingController projectName = TextEditingController();
  TextEditingController projectDescription = TextEditingController();

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
      widget.projects.clear();
      for (var project in proj) {
        if (!widget.projects.contains(project)) {
          project.hasActivetasks = false;
          for (Task t in project.associatedTasks) {
            if (t.isActive) {
              project.hasActivetasks = true;
            }
          }
          widget.projects.add(project);
        }
        print(project.name);
      }
      print(proj[0].name);
      setState(() {});
    });
  }

  void _addProject(D2D_Project newProj) {
    widget.projects.add(newProj);
    setState(() {});
  }

  //day2dayapitest1.herokuapp.com/projects/get
  Future<int> addProjectServer(D2D_Project newProj) async {
    final response = await http.post(
        Uri.https('day2dayapitest1.herokuapp.com', '/projects/${newProj.name}'),
        headers: {
          "Accept": "application/json",
          "Access-Control_Allow_Origin": "*",
          "Access-Control-Allow-Methods": "GET, POST"
        });
    if (response.statusCode == 200) {
      return 200;
    } else {
      return 404;
    }
  }

  void addProjectServerFetch(D2D_Project newProj) {
    var future = addProjectServer(newProj);
    future.then((value) {
      if (value == 200) {
        print("Project created sucessfuly");
        NotificationService().showNotificationCustom(
            "Sucessfully created new Project",
            'New project was created on the server: ${newProj.name}');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    refreshFetch();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      _updateState();
    });
  }

  void _updateState() {
    if (currentPage == 0) {
      setState(() {});
    }
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
        title: Row(
          children: [
            Observer(builder: (_) {
              switch (currentPage) {
                case 0:
                  return Expanded(
                    child: AutoSizeText(
                      widget.localz.getLocalString("projectTitle") +
                          ": " +
                          "${widget.user.currentUserName}",
                      maxFontSize: 16,
                      minFontSize: 5,
                    ),
                  );
                  break;
                case 1:
                  return Expanded(
                    child: AutoSizeText(
                      widget.localz.getLocalString("projectAddTitle") +
                          " ${widget.user.currentUserName}",
                      maxFontSize: 16,
                      minFontSize: 1,
                    ),
                  );
                  break;
                case 2:
                  return Expanded(
                    child: AutoSizeText(
                      widget.localz.getLocalString("projectExit0") +
                          ": ${widget.user.currentUserName}",
                      maxFontSize: 16,
                      minFontSize: 1,
                    ),
                  );

                default:
                  return Container(
                    height: 0,
                    width: 0,
                  );
              }
            }),
            IconButton(
                icon: Icon(Icons.refresh), onPressed: () => refreshFetch())
          ],
        ),
        centerTitle: true,
      ),
      body: Center(child: _getPage(currentPage)),
      bottomNavigationBar: Observer(
        builder: (_) {
          widget.localz.locale;
          return FancyBottomNavigation(
            key: bottomNavigationKey,
            tabs: [
              TabData(
                  iconData: Icons.assignment_turned_in_outlined,
                  title: widget.localz.getLocalString("projectBottom0")),
              TabData(
                  iconData: Icons.add_sharp,
                  title: widget.localz.getLocalString("projectBottom1")),
              TabData(
                  iconData: Icons.exit_to_app,
                  title: widget.localz.getLocalString("projectBottom2")),
            ],
            onTabChangedListener: (int position) {
              setState(() {
                currentPage = position;
                if (position == 0) {
                  refreshFetch();
                }
                if (position == 1) {
                  _readyAddProject = false;
                  projectName.text = "";
                  projectDescription.text = "";
                }
              });
            },
          );
        },
      ),
    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return Column(children: [
          Expanded(
              child: SizedBox(
                  height: 300.0,
                  child: new ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: widget.projects.length,
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      itemBuilder: (BuildContext ctxt, int index) {
                        return widget.projects.elementAt(index).getWidget(
                            context,
                            widget.user.currentUserName,
                            widget.localz);
                      })))
        ]);
        break;
      case 1:
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: 200, maxHeight: 350),
          child: Container(
            //height: 300,
            decoration: BoxDecoration(
                color: Colors.amber.shade300,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Column(children: [
              Container(
                height: 50,
                child: Center(
                  child: AutoSizeText(
                    widget.localz.getLocalString("projectAdd0"),
                    style: TextStyle(color: Color(0xFF2e282a)),
                    minFontSize: 30,
                  ),
                ),
              ),
              Container(
                  child: TextField(
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    controller: projectName,
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    onSubmitted: (string) {
                      if (string != "") {
                        _readyAddProject = true;
                        setState(() {});
                      } else {
                        _readyAddProject = false;
                        setState(() {});
                      }
                    },
                  ),
                  color: Colors.black26),
              Container(
                height: 50,
                child: Center(
                  child: AutoSizeText(
                    widget.localz.getLocalString("projectAdd1"),
                    style: TextStyle(color: Color(0xFF2e282a)),
                    minFontSize: 30,
                  ),
                ),
              ),
              //const Divider(height: 5.0, color: Colors.white),
              Container(
                  height: 80,
                  child: TextField(
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    //style: TextStyle(color: Color(0xFF2e282a)),
                    controller: projectDescription,
                    maxLength: 200,
                    maxLines: 4,
                  ),
                  color: Colors.black26),
              Divider(
                height: 5,
              ),
              Expanded(
                child: Container(
                  child: _readyAddProject == true
                      ? Material(
                          shape: CircleBorder(),
                          child: IconButton(
                              iconSize: 40,
                              icon: Icon(Icons.add),
                              color: Colors.white,
                              onPressed: () {
                                D2D_Project newProj =
                                    new D2D_Project(projectName.text);
                                addProjectServerFetch(newProj);
                                _addProject(newProj);
                                // _addProject(
                                //   ,
                                //);
                                final FancyBottomNavigationState fState =
                                    bottomNavigationKey.currentState
                                        as FancyBottomNavigationState;
                                fState.setPage(0);
                              }),
                        )
                      : Container(
                          height: 0,
                        ),
                ),
              )
            ]),
          ),
        );
      case 2:
        return Center(
          child: Stack(
            children: [
              Positioned(
                  child: Container(
                decoration: BoxDecoration(
                    color: Colors.amber.shade300,
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                //color: Colors.amber.shade300,
                height: 50,
              )),
              Positioned(
                top: 0,
                left: 10,
                child: Row(
                  children: [
                    Container(
                      width: 0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/');
                        //                 .pushNamed('/activetasks', arguments: listtemp);
                      },
                      child: AutoSizeText(
                          widget.localz.getLocalString("projectExit0")),
                      style:
                          ElevatedButton.styleFrom(primary: Color(0xFF2e282a)),
                    )
                  ],
                ),
              )
            ],
          ),
        );
        break;
      default:
    }
  }
}
