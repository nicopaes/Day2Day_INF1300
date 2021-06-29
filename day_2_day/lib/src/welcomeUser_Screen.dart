import 'package:auto_size_text/auto_size_text.dart';
import 'package:day_2_day/src/notification_service.dart';
import 'package:day_2_day/store/localization.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:day_2_day/store/user.dart';

class WelcomeUserScreen extends StatefulWidget {
  @override
  _WelcomeUserScreenState createState() => _WelcomeUserScreenState();
}

class _WelcomeUserScreenState extends State<WelcomeUserScreen> {
  int count = 0;
  final User user = User();
  final Localization localz = Localization();
  int currentPage = 0;

  void checkUser() {
    print(user.currentUserName);
    if (user.currentUserName != "") {
      user.changeToReady();
    }
  }

  @override
  Widget build(BuildContext context) {
    user.changeToNotReady();

    var userNameEnter = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Observer(
                builder: (_) => Text(localz.getLocalString("title1")))),
      ),
      body: _getPage(currentPage),
      bottomNavigationBar: Observer(
        builder: (_) {
          localz.locale;
          return FancyBottomNavigation(
            tabs: [
              TabData(iconData: Icons.login, title: "Login"),
              TabData(
                  iconData: Icons.settings,
                  title: localz.getLocalString("settings0")),
            ],
            onTabChangedListener: (int position) {
              setState(() {
                currentPage = position;
              });
            },
          );
        },
      ),
    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        var userNameEnter = TextEditingController();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_clock, size: 120.0),
            Observer(builder: (_) {
              localz.locale.languageCode;
              return Text(localz.getLocalString("enteruser1"));
            }),
            Container(
              height: 25.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Observer(builder: (_) {
                  //Oberve
                  localz.locale.languageCode;
                  //
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.amber.shade300,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: TextField(
                        decoration: InputDecoration(
                            hintText: localz.getLocalString("enteruser2"),
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black)),
                        textAlign: TextAlign.center,
                        cursorColor: Colors.white,
                        controller: userNameEnter,
                        style: TextStyle(color: Colors.black),
                        onSubmitted: (string) {
                          user.changeCurrentUser(string);
                          checkUser();
                          //NotificationService().showNotification();
                        }),
                  );
                }),
                Observer(builder: (_) {
                  if (user.ready == true) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.amber.shade400,
                          textStyle: TextStyle(color: Colors.black)),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/project',
                            arguments: [user.currentUserName, localz.locale]);
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    );
                  } else {
                    return Container(width: 0, height: 0);
                  }
                })
              ],
            ),
          ],
        );
        break;
      case 1:
        return Center(
          child: Stack(
            children: [
              Positioned(
                  child: Container(
                decoration: BoxDecoration(
                    color: Colors.amber.shade300,
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                height: 100,
              )),
              Positioned(
                  top: 15,
                  left: 10,
                  child: Observer(
                    builder: (_) {
                      localz.locale;
                      return AutoSizeText(
                        localz.getLocalString("settings1"),
                        minFontSize: 20,
                        style: TextStyle(color: Color(0xFF2e282a)),
                      );
                    },
                  )),
              Positioned(
                top: 50,
                left: 10,
                child: Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          localz.changeLanguage('en', "US");
                        },
                        child: const Text('English'),
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFF2e282a))),
                    Container(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        localz.changeLanguage('pt', "BR");
                      },
                      child: const Text('Português'),
                      style:
                          ElevatedButton.styleFrom(primary: Color(0xFF2e282a)),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      default:
    }
  }
}
