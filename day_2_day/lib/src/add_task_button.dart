import 'package:day_2_day/src/hero_dialog_route.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'custom_rect_tween.dart';
import 'task.dart';

const String _heroAddTask = "add-task-hero";

class AddTaskButton extends StatelessWidget {
  ///{@macro add_todo_button}
  const AddTaskButton({Key key, this.addTask}) : super(key: key);

  final Function(Task) addTask;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return _AddTaskPopupCard(
              addTask: addTask,
            );
          }));
        },
        child: Hero(
          tag: _heroAddTask,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: const Icon(
              Icons.add_rounded,
              size: 56,
            ),
          ),
        ),
      ),
    );
  }
}

class _AddTaskPopupCard extends StatelessWidget {
  /// {@macro add_todo_popup_card}
  const _AddTaskPopupCard({Key key, this.addTask}) : super(key: key);

  final Function(Task) addTask;

  @override
  Widget build(BuildContext context) {
    var taskName = TextEditingController();
    var taskDescript = TextEditingController();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: _heroAddTask,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Task title',
                        border: InputBorder.none,
                      ),
                      cursorColor: Colors.white,
                      controller: taskName,
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Task Description',
                        border: InputBorder.none,
                      ),
                      cursorColor: Colors.white,
                      maxLines: 6,
                      controller: taskDescript,
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),
                    TextButton(
                      onPressed: () {
                        addTask(Task(taskName.text, taskDescript.text));
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
