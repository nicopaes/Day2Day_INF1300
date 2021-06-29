import 'dart:ui';

import 'package:day_2_day/store/localization.dart';
import 'package:flutter/material.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

class Task {
  var setStarts = <DateTime>{};
  var setStops = <DateTime>{};
  int currentSessionDuration;
  int totalDuration;
  bool isActive;
  String id;

  String name;
  String description;
  String projectid;

  //bool inSync;

  final _foldingCellKey = GlobalKey<SimpleFoldingCellState>();
  bool showDetails = false;

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
    @required this.projectid,
    @required this.totalDuration,
    @required this.setStarts,
    @required this.setStops,
    @required this.isActive,
    this.showDetails = false,
    this.currentSessionDuration = 0,
    this.description = " ",
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    print(json['id']);
    print(json['setStarts']);
    return Task.fromInfo(
        name: json['name'],
        totalDuration: json['totalDuration'],
        id: json['id'],
        projectid: json['projectid'],
        setStarts: _convertFromJson(json['setStarts']),
        setStops: _convertFromJson(json['setStops']),
        isActive: _testIfActive(json['setStarts'], json['setStops']));
  }

  static Set<DateTime> _convertFromJson(List<dynamic> dynamicList) {
    Set<DateTime> retList = {};

    for (var item in dynamicList) {
      DateTime date = DateTime.tryParse(item);
      if (date != null) {
        retList.add(date);
      }
    }

    return retList;
  }

  static bool _testIfActive(List<dynamic> active, List<dynamic> inactive) {
    var liststart = _convertFromJson(active);
    var liststop = _convertFromJson(inactive);

    return liststart.length > liststop.length;
  }

  void start() {
    setStarts.add(DateTime.now());
    print("STARTTASK:: " + setStarts.last.toString());
  }

  void stop() {
    setStops.add(DateTime.now());
    print("STOPTASK:: " + setStops.last.toString());
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

  String _getTimeString(int currentTime) {
    final time = Duration(seconds: currentTime);

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

  void startTask() async {
    final response = await http.post(
        Uri.https('day2dayapitest1.herokuapp.com',
            '/projects/$projectid/tasks/$id/start'),
        headers: {
          "Accept": "application/json",
          "Access-Control_Allow_Origin": "*",
          "Access-Control-Allow-Methods": "GET, POST"
        });
    if (response.statusCode == 200) {
      print("Task started sucessfuly");
    }
  }

  void stopTask() async {
    final response = await http.post(
        Uri.https('day2dayapitest1.herokuapp.com',
            '/projects/$projectid/tasks/$id/stop'),
        headers: {
          "Accept": "application/json",
          "Access-Control_Allow_Origin": "*",
          "Access-Control-Allow-Methods": "GET, POST"
        });
    if (response.statusCode == 200) {
      print("Task stoped sucessfuly");
    }
  }

  Text _buildCurrentTimeLabel() {
    return isActive
        ? Text(
            _getTimeString(this.currentSessionDuration),
            style: TextStyle(
              fontFeatures: [FontFeature.tabularFigures()],
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
              color: Color(0xFF2e282a),
            ),
          )
        : Text("");
  }

  Text _buildTotalTimeLabel() {
    return Text(_getTimeString(totalDuration),
        style: TextStyle(
            fontFeatures: [FontFeature.tabularFigures()],
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
            color: Color(0xFF2e282a)));
  }

  IconButton _buildPlayPauseButton() {
    return IconButton(
        icon: (isActive) ? Icon(Icons.pause) : Icon(Icons.play_arrow),
        iconSize: 50.0,
        onPressed: () {}
        //   if (isActive != null) {
        //     widget.widgetTask.isActive = !widget.widgetTask.isActive;
        //     widget.onIsActiveStateChanged(widget.widgetTask.isActive);
        //   }
        // },
        );
  }

  Widget getWidget(BuildContext context, Localization currentL) {
    updateTotalDuration();
    return Container(
        color: Color(0xFF2e282a),
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onDoubleTap: () {
            this.showDetails = !this.showDetails;
          },
          child: SimpleFoldingCell.create(
            key: _foldingCellKey,
            frontWidget: _buildFrontWidget(currentL),
            innerWidget: _buildInnerWidget(currentL),
            cellSize: Size(MediaQuery.of(context).size.width, 140),
            padding: EdgeInsets.all(15),
            animationDuration: Duration(milliseconds: 300),
            borderRadius: 10,
            unfoldCell: isActive,
            onOpen: () {
              if (!isActive) {
                start();
                isActive = true;
                startTask();
              }
            },
            onClose: () {
              if (isActive) {
                isActive = false;
                stop();
                updateTotalDuration();
                stopTask();
              }
            },
          ),
        ));
  }

  Widget _buildFrontWidget(Localization currentL) {
    return Container(
      color: Color(0xFFffcd3c),
      alignment: Alignment.center,
      child: Stack(
        //STOPED WIDGET
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: GoogleFonts.aldrich(
                    color: Color(0xFF2e282a),
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                this.showDetails == true
                    ? Text(
                        description,
                        style: GoogleFonts.aldrich(
                          color: Color(0xFF2e282a),
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Container(width: 0, height: 0)
              ],
            ),
          ),
          Positioned(
            left: 10,
            top: 85,
            child: Text(
              currentL.getLocalString("taskInfo0"),
              style: GoogleFonts.aldrich(
                color: Color(0xFF2e282a),
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(left: 10, bottom: 10, child: _buildTotalTimeLabel()),
          Positioned(
            right: 10,
            bottom: 10,
            child: TextButton(
              onPressed: () => _foldingCellKey?.currentState?.toggleFold(),
              child: Text(
                currentL.getLocalString("taskInfo2"),
                style: GoogleFonts.aldrich(
                  color: Color(0xFF2e282a),
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: Size(80, 40),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInnerWidget(Localization currentL) {
    return Container(
      color: Color(0xFFecf2f9),
      padding: EdgeInsets.only(top: 10),
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
          Align(
            alignment: Alignment.center,
            child: Text(
              //DETAILED DESCRIPTION WHEN
              description,
              style: GoogleFonts.aldrich(
                color: Color(0xFF2e282a),
                fontSize: 40.0,
              ),
            ),
          ),
          Positioned(
            left: 10,
            top: 210,
            child: Text(
              currentL.getLocalString("taskInfo1"),
              style: GoogleFonts.aldrich(
                color: Color(0xFF2e282a),
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(left: 10, bottom: 10, child: _buildCurrentTimeLabel()),
          Positioned(
            right: 10,
            bottom: 10,
            child: TextButton(
              onPressed: () => _foldingCellKey?.currentState?.toggleFold(),
              child: Text(
                currentL.getLocalString("taskInfo3"),
                style: GoogleFonts.aldrich(
                  color: Color(0xFF2e282a),
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.amber.shade300,
                minimumSize: Size(80, 40),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
