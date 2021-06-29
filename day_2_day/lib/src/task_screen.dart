import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:day_2_day/src/project.dart';
import 'package:day_2_day/src/task.dart';
import 'package:day_2_day/src/task_chart.dart';
import 'package:day_2_day/store/localization.dart';
import 'package:day_2_day/store/user.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_mobx/flutter_mobx.dart';

class TaskScreen extends StatefulWidget {
  final D2D_Project currentProject;
  final User user = User();
  final Localization localz = Localization();
  final TaskChart taskChart = TaskChart();

  TaskScreen(
      {Key key,
      @required this.currentProject,
      @required String userName,
      @required Locale currentL})
      : super(key: key) {
    localz.changeLanguage(currentL.languageCode, currentL.countryCode);
    user.changeCurrentUser(userName);
  }

  @override
  Body createState() {
    return Body(currentProject);
  }
}

class Body extends State<TaskScreen> {
  List<Widget> listArray = [];

  Timer timer;
  D2D_Project p;
  int currentPage = 0;

  bool _readyAddTask = false;

  GlobalKey bottomNavigationKey2 = GlobalKey();

  TextEditingController taskName = TextEditingController();
  TextEditingController taskDescription = TextEditingController();

  bool chartInMinutes = true;

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

  void _addTask(Task newTask) {
    widget.currentProject.addTask(newTask);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.currentProject.name),
      ),
      body: Center(child: _getPage(currentPage)),
      bottomNavigationBar: FancyBottomNavigation(
        key: bottomNavigationKey2,
        tabs: [
          TabData(
              iconData: Icons.list_alt_outlined,
              title: widget.localz.getLocalString("taskBottom0")),
          TabData(
              iconData: Icons.add_outlined,
              title: widget.localz.getLocalString("taskBottom1")),
          TabData(
              iconData: Icons.analytics_sharp,
              title: widget.localz.getLocalString("taskBottom2")),
        ],
        onTabChangedListener: (int position) {
          if (position == 2) {
            chartInMinutes = true;
          }
          if (position == 1) {
            _readyAddTask = false;
            taskDescription.text = "";
            taskName.text = "";
          }
          setState(() {
            currentPage = position;
          });
        },
      ),
    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        if (listArray.length > 0) listArray.clear();

        for (Task t in widget.currentProject.associatedTasks) {
          t.updateCurrentSessionDuration();
          listArray.add(t.getWidget(context, widget.localz));
        }
        return Container(
          child: new ListView.builder(
              clipBehavior: Clip.antiAlias,
              addRepaintBoundaries: false,
              scrollDirection: Axis.vertical,
              itemCount: listArray.length,
              //padding: const EdgeInsets.only(top: 10.0, bottom: 50.0),
              itemBuilder: (BuildContext ctxt, int index) {
                return listArray[index];
              }),
        );
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
                    widget.localz.getLocalString("taskAdd0"),
                    style: TextStyle(color: Color(0xFF2e282a)),
                    minFontSize: 30,
                  ),
                ),
              ),
              Container(
                  child: TextField(
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    controller: taskName,
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    onSubmitted: (string) {
                      if (string != "") {
                        _readyAddTask = true;
                        setState(() {});
                      } else {
                        _readyAddTask = false;
                        setState(() {});
                      }
                    },
                  ),
                  color: Colors.black26),
              Container(
                height: 50,
                child: Center(
                  child: AutoSizeText(
                    widget.localz.getLocalString("taskAdd1"),
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
                    controller: taskDescription,
                    maxLength: 200,
                    maxLines: 4,
                  ),
                  color: Colors.black26),
              Divider(
                height: 5,
              ),
              Expanded(
                child: Container(
                  child: _readyAddTask == true
                      ? Material(
                          shape: CircleBorder(),
                          child: IconButton(
                              iconSize: 40,
                              icon: Icon(Icons.add),
                              color: Colors.white,
                              onPressed: () {
                                _addTask(
                                  new Task(taskName.text, taskDescription.text),
                                );
                                final FancyBottomNavigationState fState2 =
                                    bottomNavigationKey2.currentState
                                        as FancyBottomNavigationState;
                                fState2.setPage(0);
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
        break;
      case 2:
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                      onPressed: () => chartInMinutes = false,
                      child: AutoSizeText(
                        "Sec",
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.amber.shade300)),
                )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                        onPressed: () => chartInMinutes = true,
                        child: AutoSizeText(
                          "Min",
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.amber.shade300)),
                  ),
                )
              ],
            ),
            Center(
              child: widget.taskChart.getWidget(
                  widget.currentProject.associatedTasks as Set<Task>,
                  chartInMinutes,
                  widget.localz),
            ),
          ],
        );
        break;
      default:
    }
  }
}
