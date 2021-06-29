import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:day_2_day/src/notification_service.dart';
import 'package:day_2_day/src/task.dart';
import 'package:day_2_day/store/localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class D2D_Project {
  var name;
  DateTime timeOfCreation;
  int totalSumSeconds;
  String id;

  var associatedTasks;
  bool hasActivetasks;

  D2D_Project(String newName) {
    this.name = newName;
    this.timeOfCreation = DateTime.now();
    this.totalSumSeconds = 0;
    this.associatedTasks = <Task>{};
  }

  D2D_Project.fromInfo(
      {@required this.name,
      @required this.timeOfCreation,
      @required this.totalSumSeconds,
      @required this.id,
      @required this.associatedTasks});

  factory D2D_Project.fromJson(Map<String, dynamic> json) {
    Set<Task> newTaskList = {};
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
    addTaskServerFetch(newTask);
  }

  Future<Task> addTaskServer(Task newTask) async {
    final response = await http.post(
        Uri.https('day2dayapitest1.herokuapp.com',
            '/projects/$id/tasks/${newTask.name}'),
        headers: {
          "Accept": "application/json",
          "Access-Control_Allow_Origin": "*",
          "Access-Control-Allow-Methods": "GET, POST"
        });
    if (response.statusCode == 200) {
      var firstPass = json.decode(response.body);
      var secondPass = json.decode(firstPass);
      Task t = new Task.fromJson(secondPass);
      print(t.id);
      return t;
    } else {
      return null;
    }
  }

  void addTaskServerFetch(Task newTask) {
    var future = addTaskServer(newTask);
    future.then((value) {
      if (value != null) {
        associatedTasks.add(value);
        print("Task created sucessfuly");
        NotificationService().showNotificationCustom(
            "Sucessfully created new Task",
            'New project was created on the server: ${newTask.name}');
      }
    });
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

  int _getTaskCount() {
    if (associatedTasks is Set<Task>) {
      return (associatedTasks as Set<Task>).length;
    } else if (associatedTasks is List<Task>) {
      return (associatedTasks as List<Task>).length;
    } else
      return 0;
  }

  Text _buildTotalTimeLabel() {
    return Text(_getTimeString(),
        style: TextStyle(
            fontFeatures: [FontFeature.tabularFigures()],
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
            color: Color(0xFF2e282a)));
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
        border: Border.all(width: 1), color: Colors.amber.shade900);
  }

  Widget getWidget(
      BuildContext context, String userName, Localization currentL) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
            color: hasActivetasks == false
                ? Colors.amber.shade300
                : Colors.amber.shade100,
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                name,
                style: GoogleFonts.aldrich(
                  color: Color(0xFF2e282a),
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              left: 10,
              bottom: 50,
              child: Text(
                //DETAILED DESCRIPTION WHEN
                currentL.getLocalString("projectInfo0") +
                    ": " +
                    _getTaskCount().toString(),
                style: GoogleFonts.aldrich(
                  color: Color(0xFF2e282a),
                  fontSize: 30.0,
                ),
              ),
            ),
            Positioned(
                left: 10,
                bottom: -5,
                child: Container(
                  color: Colors.amber.shade100,
                  width: 90,
                  height: 50,
                )),
            Positioned(
              left: 10,
              bottom: 25,
              child: Text(
                currentL.getLocalString("projectInfo1"),
                style: GoogleFonts.aldrich(
                  color: Color(0xFF2e282a),
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(left: 10, bottom: -5, child: _buildTotalTimeLabel()),
            Positioned(
              right: 10,
              bottom: -5,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/second',
                    arguments: [this, userName, currentL.locale]),
                style: ElevatedButton.styleFrom(primary: Color(0xFF2e282a)),
                child: Text(
                  currentL.getLocalString("projectInfo2"),
                  style: GoogleFonts.aldrich(
                    color: Colors.amber.shade200,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
