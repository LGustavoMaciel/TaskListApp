import 'package:flutter_sqlite_example/app/models/task_model.dart';
import 'package:flutter_sqlite_example/app/repository/todo_repository.dart';
import 'package:mobx/mobx.dart';

part 'list_store.g.dart';

class ListStore = _ListStore with _$ListStore;

abstract class _ListStore with Store {
  late TodoRepository _todoRepository;

  _ListStore() {
    _todoRepository = TodoRepository();
  }

  @observable
  ObservableList<TaskModel> listModel = ObservableList<TaskModel>();

  @action
  Future<List<TaskModel>> loadTask() async {
    listModel = ObservableList<TaskModel>.of(await _todoRepository.getTasks());
    return listModel;
  }

  @observable
  ObservableList? tasks;

  @observable
  String newTodoTitle = "";

  @action
  void setNewTodoTitle(String value) => newTodoTitle = value;

  @action
  Future dellTask(int id) async {
    tasks = await _todoRepository.delete(id);
  }

  @computed
  bool get isFormValid => newTodoTitle.isNotEmpty;

  @computed
  bool get isListValid => listModel.isNotEmpty;

  @action
  addTask({TaskModel? recover, TaskModel? edit}) async {
    final repository = TodoRepository();
    tasks = ObservableList();
    if (recover == null && edit == null) {
      var data = await repository.create(
        TaskModel(
          name: newTodoTitle,
          date: DateTime.now().toString(),
        ),
      );
      tasks!.add(data);
    } else if (recover != null && edit == null) {
      var data = await repository.create(
        TaskModel(
          name: recover.name,
          date: recover.date,
        ),
      );
      tasks!.add(data);
    } else {
      tasks = await repository.update(
        TaskModel(
          id: edit!.id,
          name: edit.name,
          date: edit.date,
        ),
      );
    }
  }

  @action
  Future updateTask({TaskModel? edit}) async {
    tasks = await _todoRepository.update(edit!);
  }
}
