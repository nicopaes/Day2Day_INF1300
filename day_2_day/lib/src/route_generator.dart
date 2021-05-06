import 'dart:core';

import 'package:day_2_day/main.dart';
import 'package:day_2_day/src/active_tasks.dart';
import 'package:day_2_day/src/project.dart';
import 'package:day_2_day/src/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
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
        break;
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("ERROR"),
        ),
        body: Center(
          child: Text("ERROR"),
        ),
      );
    });
  }
}
