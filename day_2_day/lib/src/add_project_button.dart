import 'package:day_2_day/src/hero_dialog_route.dart';
import 'package:day_2_day/src/project.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'custom_rect_tween.dart';
import 'task.dart';

const String _heroAddTask = "add-task-hero";

class AddProjectButton extends StatelessWidget {
  ///{@macro add_todo_button}
  const AddProjectButton({Key key, this.addProj}) : super(key: key);

  final Function(D2D_Project) addProj;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "Add new Project",
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(HeroDialogRoute(builder: (context) {
              return _AddProjectPopupCard(
                addProj: addProj,
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
              child: const Icon(
                Icons.add_rounded,
                size: 56,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddProjectPopupCard extends StatelessWidget {
  /// {@macro add_todo_popup_card}
  const _AddProjectPopupCard({Key key, this.addProj}) : super(key: key);

  final Function(D2D_Project) addProj;

  @override
  Widget build(BuildContext context) {
    var taskName = TextEditingController();

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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Project Title',
                        alignLabelWithHint: true,
                        border: InputBorder.none,
                      ),
                      cursorColor: Colors.white,
                      controller: taskName,
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),
                    TextButton(
                      onPressed: () {
                        addProj(D2D_Project(taskName.text));
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
