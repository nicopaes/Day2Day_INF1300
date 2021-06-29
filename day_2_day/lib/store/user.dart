import 'package:mobx/mobx.dart';

part 'user.g.dart';

class User = _User with _$User;

abstract class _User with Store {
  @observable
  String currentUserName = "";
  @observable
  bool ready = false;

  @action
  void changeCurrentUser(String newUser) {
    currentUserName = newUser;
  }

  @action
  void changeToReady() {
    ready = true;
  }

  @action
  void changeToNotReady() {
    ready = false;
  }
}
