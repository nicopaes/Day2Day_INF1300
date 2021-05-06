import 'dart:async';

import 'package:day_2_day/src/task.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ActiveTasksScreen extends StatefulWidget {
  final List<Task> listactivetasks;
  ActiveTasksScreen({Key key, @required this.listactivetasks});
  @override
  ActiveTasksState createState() => ActiveTasksState();
}

class ActiveTasksState extends State<ActiveTasksScreen> {
  List<Widget> listArray = [];
  Timer timer;

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
    if (listArray.length > 0) listArray.clear();

    for (var t in widget.listactivetasks) {
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
          title: Text("All Active tasks"),
        ),
        body: Center(
            child: Column(children: [
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
          Tooltip(
            message: "Stop all active tasks",
            child: IconButton(
                icon: Icon(Icons.stop),
                iconSize: 50.0,
                onPressed: () {
                  for (var t in widget.listactivetasks) {
                    t.stop();
                  }
                  setState(() {});
                }),
          )
        ])));
  }
}
