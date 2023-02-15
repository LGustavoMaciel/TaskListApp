// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:flutter_sqlite_example/app/controller/list_store.dart';
import 'package:flutter_sqlite_example/app/models/task_model.dart';
import 'package:flutter_sqlite_example/app/routes/app_routes.dart';
import 'package:flutter_sqlite_example/app/ui/android_screens/home/widgets/custom_show_dialog.dart';
import 'package:flutter_sqlite_example/app/ui/widgets/custom_icon_button.dart';
import 'package:flutter_sqlite_example/app/ui/widgets/custom_text_field.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TaskModel> items = <TaskModel>[];
  List<TaskModel> _ultimaTarefaRemovida = <TaskModel>[];

  final TextEditingController textController = TextEditingController();

  late ListStore _listStore;

  @override
  initState() {
    _listStore = ListStore();
    _listStore.loadTask();
    super.initState();
  }

  _formatDate(String date) {
    initializeDateFormatting("pt_BR");
    var format = DateFormat("d/MM/y H:m:s");
    //var format = DateFormat.yMd("pt_BR");
    DateTime dateConvert = DateTime.parse(date);
    String dateFormat = format.format(dateConvert);
    return dateFormat;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: const EdgeInsets.fromLTRB(32, 0, 32, 32),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Lista de Tarefas',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 25,
                        fontFamily: "Lucida",
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.exit_to_app),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(
                          AppRoutes.LOGIN,
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 16,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: <Widget>[
                        Observer(
                          builder: (_) {
                            return CustomTextField(
                              controller: textController,
                              hint: 'Buscar ou criar tarefa',
                              onChanged: _listStore.setNewTodoTitle,
                              suffix: _listStore.isFormValid
                                  ? CustomIconButton(
                                      radius: 32,
                                      iconData: Icons.add,
                                      onTap: () async {
                                        await _listStore.addTask();
                                        _listStore.loadTask();
                                        textController.clear();
                                        _listStore.newTodoTitle = "";
                                        FocusScope.of(context).unfocus();
                                      },
                                    )
                                  : null,
                            );
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Expanded(
                          child: Observer(builder: (_) {
                            return _listStore.isListValid
                                ? ListView.separated(
                                    itemCount: _listStore.listModel.length,
                                    itemBuilder: (context, index) {
                                      return Dismissible(
                                        background: Container(
                                          color: Colors.red,
                                          padding: EdgeInsets.all(16),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                        ),
                                        direction: DismissDirection.startToEnd,
                                        confirmDismiss: (_) {
                                          return showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: Text('Tem Certeza?'),
                                              content: Text(
                                                'Deseja excluir a tarefa ${_listStore.listModel[index].name}?',
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('Não'),
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop(false);
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text('Sim'),
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop(true);
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        onDismissed: (_) {
                                          _ultimaTarefaRemovida = _listStore.listModel;
                                          _listStore.dellTask(_listStore.listModel[index].id!);
                                          _listStore.loadTask();

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Tarefa ${_listStore.listModel[index].name} excluida",
                                              ),
                                              duration: Duration(seconds: 2),
                                              action: SnackBarAction(
                                                label: 'DESFAZER',
                                                onPressed: () {
                                                  items.insert(index, _ultimaTarefaRemovida[index]);

                                                  _listStore.addTask(recover: _ultimaTarefaRemovida[index]);
                                                  _listStore.loadTask();
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                        key: UniqueKey(),
                                        child: Observer(builder: (_) {
                                          return ListTile(
                                            title: Text(
                                              _listStore.listModel[index].name,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            subtitle: Text(
                                              "${_formatDate(_listStore.listModel[index].date)}",
                                            ),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Stack(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        await showDialog(
                                                          context: context,
                                                          builder: (ctx) => CustomShowDialog(
                                                            task: _listStore.listModel[index],
                                                          ),
                                                        );
                                                        _listStore.loadTask();
                                                      },
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                      );
                                    },
                                    separatorBuilder: (_, __) {
                                      return Divider();
                                    },
                                  )
                                : Center(
                                    child: Wrap(children: [
                                      Center(child: Text("Sem tarefas criadas no momento!")),
                                      SizedBox(height: 25),
                                      Text("Comece a digitar para criar uma nova tarefa :)!"),
                                    ]),
                                  );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
