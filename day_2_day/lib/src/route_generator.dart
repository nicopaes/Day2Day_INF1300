import 'dart:core';

import 'package:day_2_day/src/active_tasks.dart';
import 'package:day_2_day/src/project.dart';
import 'package:day_2_day/src/project_screen.dart';
import 'package:day_2_day/src/task.dart';
import 'package:day_2_day/src/task_screen.dart';
import 'package:day_2_day/src/welcomeUser_Screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => WelcomeUserScreen());
        break;
      case '/project':
        if (args is List<Object>) {
          return MaterialPageRoute(
              builder: (_) => ProjectScreen(
                    userName: args[0],
                    currentL: args[1],
                  ));
        }
        return _errorRoute();
        break;
      case '/second':
        if (args is List<Object>) {
          return MaterialPageRoute(
              builder: (_) => TaskScreen(
                    currentProject: args[0],
                    userName: args[1],
                    currentL: args[2],
                  ));
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
