// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_sqlite_example/app/controller/list_store.dart';
import 'package:flutter_sqlite_example/app/models/task_model.dart';

class CustomShowDialog extends StatelessWidget {
  final TextEditingController _editingController = TextEditingController();

  final TaskModel task;

  CustomShowDialog({Key? key, required this.task}) : super(key: key);

  final ListStore _listStore = ListStore();

  @override
  Widget build(BuildContext context) {
    _editingController.text = task.name;
    return Container(
      child: AlertDialog(
        title: const Text(
          "Editar Tarefa",
          style: TextStyle(
            color: Colors.deepPurpleAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _editingController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Tarefa",
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancelar",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              task.name = _editingController.text;
              await _listStore.updateTask(edit: task);
              Navigator.pop(context);
            },
            child: Text(
              "Atualizar",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
