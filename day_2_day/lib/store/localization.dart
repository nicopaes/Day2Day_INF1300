import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'localization.g.dart';

class Localization = _Localization with _$Localization;

abstract class _Localization with Store {
  @observable
  Locale locale = Locale('en', 'US');

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title1': 'Welcome',
      'enteruser1': 'Enter user name',
      'enteruser2': 'User name',
      'settings0': 'Settings',
      'settings1': 'Current Language is English',
      'projectInfo0': 'Tasks',
      'projectInfo1': 'Total time',
      'projectInfo2': 'ENTER',
      'projectTitle': 'ALL PROJECTS',
      'projectAddTitle': 'Add Project as',
      'projectAdd0': 'Project Name',
      'projectAdd1': 'Project Description',
      'projectBottom0': 'Projects',
      'projectBottom1': 'Add Project',
      'projectBottom2': 'Log out',
      'projectExit0': 'Log out',
      'taskInfo0': 'Total time',
      'taskInfo1': 'Current time',
      'taskInfo2': 'START',
      'taskInfo3': 'STOP',
      'taskBottom0': 'Tasks',
      'taskBottom1': 'Add Task',
      'taskBottom2': 'Relatórios',
      'taskAdd0': 'Task name',
      'taskAdd1': 'Task description',
      'chartsInfo0': 'Task Duration',
      'chartsInfo1A': 'Time in minutes',
      'chartsInfo1B': 'Time in seconds',
    },
    'pt': {
      'title1': 'Bem vindo',
      'enteruser1': 'Insira nome do usuário',
      'enteruser2': 'Nome de Usuário',
      'settings0': 'Configurações',
      'settings1': 'Lingua atual Português-Brasil',
      'projectInfo0': 'Tarefas',
      'projectInfo1': 'Tempo total',
      'projectInfo2': 'ENTRAR',
      'projectTitle': 'TODOS OS PROJETOS',
      'projectAddTitle': 'Adicionar Projeto como',
      'projectAdd0': 'Nome do Projeto',
      'projectAdd1': 'Descrição do Projeto',
      'projectBottom0': 'Projetos',
      'projectBottom1': 'Adicionar',
      'projectBottom2': 'Sair',
      'projectExit0': 'Sair',
      'taskInfo0': 'Tempo total',
      'taskInfo1': 'Tempo atual',
      'taskInfo2': 'INICIAR',
      'taskInfo3': 'PARAR',
      'taskBottom0': 'Tarefas',
      'taskBottom1': 'Adicionar',
      'taskBottom2': 'Relatórios',
      'taskAdd0': 'Nome da Tarefa',
      'taskAdd1': 'Descrição da Tarefa',
      'chartsInfo0': 'Duração das Tarefas',
      'chartsInfo1A': 'Tempo em minutos',
      'chartsInfo1B': 'Tempo em segundos',
    }
  };

  @action
  void changeLanguage(String languageCode, String country) {
    locale = Locale(languageCode, country);
  }

  String getLocalString(String key) {
    if (_localizedValues.containsKey(locale.languageCode)) {
      if (_localizedValues[locale.languageCode].containsKey(key)) {
        return _localizedValues[locale.languageCode][key];
      } else {
        return "Erro localization";
      }
    } else {
      return "Erro localization";
    }
  }
}
