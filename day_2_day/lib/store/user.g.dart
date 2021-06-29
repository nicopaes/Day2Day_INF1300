// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$User on _User, Store {
  final _$currentUserNameAtom = Atom(name: '_User.currentUserName');

  @override
  String get currentUserName {
    _$currentUserNameAtom.reportRead();
    return super.currentUserName;
  }

  @override
  set currentUserName(String value) {
    _$currentUserNameAtom.reportWrite(value, super.currentUserName, () {
      super.currentUserName = value;
    });
  }

  final _$readyAtom = Atom(name: '_User.ready');

  @override
  bool get ready {
    _$readyAtom.reportRead();
    return super.ready;
  }

  @override
  set ready(bool value) {
    _$readyAtom.reportWrite(value, super.ready, () {
      super.ready = value;
    });
  }

  final _$_UserActionController = ActionController(name: '_User');

  @override
  void changeCurrentUser(String newUser) {
    final _$actionInfo =
        _$_UserActionController.startAction(name: '_User.changeCurrentUser');
    try {
      return super.changeCurrentUser(newUser);
    } finally {
      _$_UserActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeToReady() {
    final _$actionInfo =
        _$_UserActionController.startAction(name: '_User.changeToReady');
    try {
      return super.changeToReady();
    } finally {
      _$_UserActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeToNotReady() {
    final _$actionInfo =
        _$_UserActionController.startAction(name: '_User.changeToNotReady');
    try {
      return super.changeToNotReady();
    } finally {
      _$_UserActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentUserName: ${currentUserName},
ready: ${ready}
    ''';
  }
}
