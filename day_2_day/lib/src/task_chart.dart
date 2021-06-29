import 'dart:async';
import 'dart:math';
import 'package:day_2_day/src/task.dart';
import 'package:day_2_day/store/localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TaskChart {
  // List<Task> list_tasks;

  // taskcart() {
  //   list_tasks = tasks;
  // }
  Taskcart() {}

  BarChartData _getBarChartData(Set<Task> tasks, bool timeInMinutes) {
    List<BarChartGroupData> lgroupdata = [];
    for (var i = 0; i < tasks.length; i++) {
      Task t = tasks.elementAt(i);
      double totalDurationMinutes =
          ((t.totalDuration.toDouble() + t.currentSessionDuration.toDouble()) /
                  (timeInMinutes == true ? 60.0 : 1.0))
              .floorToDouble();

      lgroupdata.add(BarChartGroupData(x: i, barRods: [
        BarChartRodData(
            y: totalDurationMinutes,
            width: 20 / tasks.length,
            colors: [Colors.grey.shade800]),
      ]));
    }
    return BarChartData(
        barGroups: lgroupdata,
        alignment: BarChartAlignment.spaceAround,
        groupsSpace: 5,
        titlesData: FlTitlesData(
            bottomTitles: SideTitles(
                showTitles: tasks.length < 6,
                getTitles: (double value) {
                  return tasks.elementAt(value.toInt()).name;
                })));
  }

  Widget getWidget(
      Set<Task> tasks, bool timeInMinutes, Localization currrentL) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: Colors.amber.shade300,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    currrentL.getLocalString("chartsInfo0"),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    (timeInMinutes == true)
                        ? currrentL.getLocalString("chartsInfo1A")
                        : currrentL.getLocalString("chartsInfo1B"),
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 38,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: BarChart(_getBarChartData(tasks, timeInMinutes)),
                      //isPlaying ? randomData() : mainBarData(),
                      //swapAnimationDuration: animDuration,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
