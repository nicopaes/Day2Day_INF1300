# Day2Day_INF1300
## Relatorio Final

### Introdução

O Day 2 Day nasceu de 3 objetivos que, por um acaso, resolveram se manifestar em um momento fortuito quando decidi que era esse o projeto que eu iria executar na INF1300, com o Flutter.

> Um aplicativo de generenciamento de projeto proprio

Há alguns anos eu percebi uma certa aptidão para a gestão de pessoas e projetos, começando no grupo universitário hoje conhecido como <i>Prisma Game Lab</i> me vi o único que realmente queria gerir a parte de programação, e não muito depois o setor inteiro de projetos.

Não foi muito diferente na <i>Campus Studio</i>, minha ex-empresa que fui co-fundador e está atualmente incubada no <i>Instituto Genesis</i>. Realmente gerir pessoas, processos e projetos é uma dos fronts que quero seguir na minha carreira.

Já com mais de 4 anos nesse papel em diferentes lugares eu tive experiências com quase uma dezena de ferramentas, Trello, Favro, Jira, Monday ,Notion , Toggl, etc. Cada um me oferecendo alguma característica positiva diferente, e sempre foi obviamente meu desejo criar algo meu que juntasse essas boas características de cada um. Podemos dizer que esse é o começo de uma tentativa.

> Trabalhar com Flutter

Já tive algum contato com a ferramenta no passado, quando ela não passava de um primeiro protótipo do Google. Não foi uma experiência muito frutíferam, visto que na epoca nem a ferramenta nem minha proficiência como programador estavam muito apuradas, por assim dizer.

Então, pulei nessa chance, uma materia que me daria não só uma guia mais uma coisa essencial para o desenvolvimento de qualquer projeto, um <b>prazo</b>.

Sou grato pelo alinhamento de tantas situações diferentes.

> Chance de trabalhar full-stack

Como programador de jogo, primeiramente posso dizer que já trabalho "full-stack" há algum tempo. Pois, em um jogo complexo e num equipe pequena, sempre tentei me manter tanto nos aspectos de interface do usuário quanto na parte "backend" do gameplay em si.

Mas nunca tive uma oportunidade de trabalhar antes naquilo que muitos dizem como a experiência real "full-stack", um servidor backend e um frontend de interface do usuário.

Esse foi um desafio particular, não estava na ementa de disciplina o aluno construir os dois do zero, mas decidi que seria esse o momento, então tentei o meu máximo.

Não acho que isso deva ser considerado na avaliação final, pois a matéria não envolve isso. Mesmo assim posso dizer que estou orgulhoso do meu trabalho.

---

## Aspectos de Projeto

O Day2Day nasceu com uma proposta um pouco diferente do que ele foi entregue no fim da disciplina, ele nasceu como uma ferramento que iria focar no acompanhamento da saúde mental dos membros de uma equipe técnica em conjunto com os aspectos de gestão de tempo propriamente apresentados na proposta. 

Na medida que o desenvolvimento foi caminhando fui percebendo que para que os pontos de diferenciação fossem implementados, primeiro eu teria que executar bem as partes mais centrais.

Por isso fui pedir auxílio a minha equipe atual do <b>Studio Bravarda</b>, minha empresa de jogos atual que também fui co-fundador. Conversando com eles fui anotando as nossas necessidades como equipe e montei o esqueleto de um <i>MVP - Minimum Viable Product</i>, e segui o caminho para implementa-lo da melhor maneira possível.

Creio que cheguei em um resultado bem próximo do objetivo, tendo conseguido implementar de forma sólida os seguintes requisitos:

> Requisitos projetuais

- Criar um projeto e guarda-lo em um servidor
- Conseguir recuperar o projeto criado do servidor
- Criar tarefas com nome/descrição dentro desses projetos
- Conseguir recuperar essas tarefas do servidor
- Implementar um timer, um contador de tempo, para que seja possível ver o quanto foi trabalhado nessa tarefa
- Ter esse timer armazenado de forma eficiente no servidor

Justamente com isso precissei, claro, somar os requisitos da disciplina, selecionei 5 da lista de 8 apresentada:

> Requisitos da Disciplina

- Gerenciamento de um estado usando <b>MobX</b>
- Uso do Plugin Local Notifications
- O recebimento, assim como o envio de dados do/para o backstage server
- Internacionalização em pelo menos 2 línguas (BR/ENG)
- Uma nova característica não vista na disciplina: dentro desse item decidi duas características que gostaria de pontuar
- - A utilização de json para a criação de instâncias
- - A utilização da biblioteca <b>fl_chart</b> para a visualização de gráficos

Agora vou desenvolver um pouco mais os esses pontos e os aspectos técnicos do app em si.

---

## Aspectors Técnicos
#### Todos os Screenshots foram feitos num emulador Nexus 5X API 30 x86

### Tela de Welcome

Nessa tela montei um esqueleto de um sistema de login, ele não está funcional pois está muito fora da ementa da dsiciplina e do escopo do projeto em si.

![image](MD_IMGS\Code_4L6qZyjqNc.png)

Essa tela possui dois aspectos importantes para o projeto.
A parte do login é gerida por uma classe <b>User</b> que utiliza <b>Mobx</b> para gerar variáveis oberváveis por widgets.

<b>user.dart</b>
```
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

```

Essa @Action changeToReady, futuramente pode ser tornar async e mudar a váriável ready, que por sua vez pode ser observada pelo widget que controla o botão de login. No caso, essa mudança é automática assim que o usuário entra com qualquer string não vazia.

<b>welcomeUser_Screen.dart</b>
```
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
```

O wrapper Observer foi usado diversas vezes no projeto, mas foi importantíssimo para a parte de localização.


<b>localization.dart</b>
```
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
    ...
    },
    'pt': {
      'title1': 'Bem vindo',
      'enteruser1': 'Insira nome do usuário',
      'enteruser2': 'Nome de Usuário',
      'settings0': 'Configurações',
      'settings1': 'Lingua atual Português-Brasil',
    ...
```

A parte de localização foi feita por mim com base na lógica que outra biblioteca de localização usam. Como queria mais controle e não gostaria de algo muito verboso, decidi implementar também usando MobX.

O centro de tudo é variável locale e o Map<String, Map<String, String>> _localizedValues.
Toda a mudança nas variável locale faz com que certos Widgets de texto executem uma "query" por assim dizer nesse Map, fazendo com que a mudança de lingua aconteça basicamente em realtime.

<b>(gif somente disponível na versão não pdf no github)</b>

![alt Text](MD_IMGS\2o8zQBOT5C.gif)


<b>welcomeUser_Screen.dart l:141</b>
```
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
```

Esse padrão de "query" foi incorporado em <b>todos</b> os widgets de texto localizáveis no projeto. Alguns estão no momento sem a parte Observer, pois eles só são mostrados após a seleção de linguaguem nesse menu, posteriormente possa ser proveitoso mudar a lingua a qualquer momento.

A parte de backstage server se mistura com a utilização de notificações e a contrução de classes com json.

<b>Tela de projetos</b>

![image](MD_IMGS\qemu-system-x86_64_FeplRoSmWp.png)

Os dados são obtidos diretamente de um servidor, e com os json recebidos são construídas as instâncias de projetos e tarefas.

<b>oproject_screen.dart l:98</b>
```
Future<int> addProjectServer(D2D_Project newProj) async {
    final response = await http.post(
        Uri.https('day2dayapitest1.herokuapp.com', '/projects/${newProj.name}'),
        headers: {
          "Accept": "application/json",
          "Access-Control_Allow_Origin": "*",
          "Access-Control-Allow-Methods": "GET, POST"
        });
    if (response.statusCode == 200) {
      return 200;
    } else {
      return 404;
    }
  }

  void addProjectServerFetch(D2D_Project newProj) {
    var future = addProjectServer(newProj);
    future.then((value) {
      if (value == 200) {
        print("Project created sucessfuly");
        NotificationService().showNotificationCustom(
            "Sucessfully created new Project",
            'New project was created on the server: ${newProj.name}');
      }
    });
  } 
```

Como o servidor tem latência variada, pois é sediado nos estados unidos, eu notifico o usuário com uma notificação quando certas tarefas assíncronas terminam de ser executadas.

Temos 2 exemplos:

- Criação de um novo projeto

![image](MD_IMGS\qemu-system-x86_64_F9hZrb9KJH.png)

![image](MD_IMGS\w54hpW62IL.png)

- Criação de uma nova tarefa

![image](MD_IMGS\qemu-system-x86_64_GQtGH01t7b.png)

![image](MD_IMGS\fj2I7vUWvx.png)

Os dados são também recebidos com requests

<b>projet_screen.dart l:50</b>
```
Future<List<D2D_Project>> fetchTasks() async {
    final response = await http.get(
        Uri.https('day2dayapitest1.herokuapp.com', 'projects/get'),
        headers: {
          "Accept": "application/json",
          "Access-Control_Allow_Origin": "*",
          "Access-Control-Allow-Methods": "GET, POST"
        });
    if (response.statusCode == 200) {
      print(response.body);
      var firstPass = json.decode(response.body); //DECODE TWICE!??!?!?!?!
      Iterable iter = json.decode(firstPass)['Project'];
      print(iter);
      List<D2D_Project> newList = List<D2D_Project>.from(
          iter.map((model) => D2D_Project.fromJson(model)));
      return newList;
    } else {
      return [];
    }
  }
```

E usando json.decode, inexplicavelemente duas vezes, e factorys é possível criar instâncias usando o json recebido pelo servidor:

<b>project.dart l:31</b>
```
 D2D_Project.fromInfo(
      {@required this.name,
      @required this.timeOfCreation,
      @required this.totalSumSeconds,
      @required this.id,
      @required this.associatedTasks});

  factory D2D_Project.fromJson(Map<String, dynamic> json) {
    Set<Task> newTaskList = {};
    for (var t in json['associatedTasks']) {
      Task newT = Task.fromJson(t);
      print(newT.name);
      newTaskList.add(newT);
    }
    return D2D_Project.fromInfo(
        name: json['name'],
        id: json['id'],
        totalSumSeconds: json['totalSumSeconds'],
        associatedTasks: newTaskList,
        timeOfCreation: DateTime.parse(json['timeOfCreation']));
  }
```

A biblioteca fl_charts é usada parada então, gerar gráficos que em realtime dão ao usuário uma visualização rápida da duração de suas tarefas.

- Em segundos

![image](MD_IMGS\qemu-system-x86_64_mzqTkMuzHm.png)

- Em minutos

![image](MD_IMGS\qemu-system-x86_64_S1QQmykrAr.png)

Sua implementação está isolada no <b>task_chart.dart</b>

Tendo coberto o necessário, vale pontuar a excelente biblioteca [<i>FancyBottomNavigation</i>](https://pub.dev/packages/fancy_bottom_navigation)

Ela fez com que fosse possível a rápida navegação do Day2Day.

<b>GIF</b>

![alt text](MD_IMGS\5H4ep7xZvE.gif)

---

Qualquer pergunta, dúvida ou sugestão: nicolaspleme@gmail.com

## Obrigado!