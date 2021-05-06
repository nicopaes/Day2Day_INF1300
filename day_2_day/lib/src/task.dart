import 'package:flutter/material.dart';

class Task {
  var setStarts = <DateTime>{};
  var setStops = <DateTime>{};
  int currentSessionDuration;
  int totalDuration;
  bool isActive;
  String id;

  String name;
  String description;

  Task(String newName, String newDescript) {
    this.name = newName;
    this.description = newDescript;
    this.currentSessionDuration = 0;
    this.totalDuration = 0;
    this.isActive = false;
    this.id = "11111111";
  }

  Task.fromInfo({
    @required this.name,
    @required this.id,
    @required this.totalDuration,
    this.isActive = false,
    this.currentSessionDuration = 0,
    this.description = " ",
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    print(json['id']);
    return Task.fromInfo(
        name: json['name'],
        totalDuration: json['totalDuration'],
        id: json['id']);
  }

  void start() {
    setStarts.add(DateTime.now());
    print(setStarts.last);
  }

  void stop() {
    setStops.add(DateTime.now());
    print(setStops.last);
    if (this.isActive) {
      this.isActive = false;
    }
  }

  void updateTotalDuration() {
    int totalSum = 0;
    for (var i = 0; i < this.setStops.length; i++) {
      Duration sub = setStops.elementAt(i).difference(setStarts.elementAt(i));
      totalSum += sub.inSeconds;
    }
    this.totalDuration = totalSum;
  }

  void updateCurrentSessionDuration() {
    this.currentSessionDuration = isActive
        ? setStarts.length > 0
            ? DateTime.now().difference(setStarts.last).inSeconds
            : 0
        : 0;
  }

  double convertTotalDurationToMinutes() {
    return this.totalDuration / 60.0;
  }
}
