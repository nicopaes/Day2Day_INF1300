import 'package:auto_size_text/auto_size_text.dart';
import 'package:day_2_day/src/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

class D2D_Project {
  var name;
  DateTime timeOfCreation;
  int totalSumSeconds;
  String id;

  var associatedTasks;

  D2D_Project(String newName) {
    this.name = newName;
    this.timeOfCreation = DateTime.now();
    this.totalSumSeconds = 0;
    this.associatedTasks = <Task>{};
    this.id = "";
  }

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

  void addTask(Task newTask) {
    if (!associatedTasks.contains(newTask)) {
      associatedTasks.add(newTask);
      print("Task added");
    } else {
      print("This Project already contains this task");
    }
  }

  void printTasks() {
    String p = "";
    for (var t in this.associatedTasks) {
      p += t.name;
    }
    print(p);
  }

  // ignore: unused_element
  void updateTotalSumMinutes() {
    int sum = 0;
    for (var t in associatedTasks) {
      t.updateTotalDuration();
      sum += t.totalDuration;
    }
    this.totalSumSeconds = sum;
  }

  String _getTimeString() {
    final time = Duration(seconds: this.totalSumSeconds);

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

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
        border: Border.all(width: 1), color: Colors.amber.shade900);
  }

  Widget getWidget(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed('/second', arguments: this),
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
  }
}
