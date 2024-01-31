import 'package:crot_firestore/todo_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class TodoController extends GetxController {
  TextEditingController title = TextEditingController();
  TextEditingController updatedTitle = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController updatedDescription = TextEditingController();

  final uId = const Uuid();
  final db = FirebaseFirestore.instance;

  RxList<TodoModel> todoList = RxList<TodoModel>();

  void OnInit() {
    super.onInit();
    SmartDialog.showLoading();
    getTodo();
  }

  Future<void> addTodo() async {
    String id = uId.v4();
    var newTodo =
        TodoModel(id: id, title: title.text, description: description.text);
    SmartDialog.showLoading();
    await db.collection("todo").doc(id).set(newTodo.toJson());
    title.clear();
    SmartDialog.showToast('Berhasil tambah data');
    getTodo();
  }

  Future<void> getTodo() async {
    todoList.clear();
    await db.collection("todo").get().then((allTodo) {
      for (var todo in allTodo.docs) {
        todoList.add(
          TodoModel.fromJson(
            todo.data(),
          ),
        );
      }
    });
    await Future.delayed(const Duration(seconds: 2));
    SmartDialog.dismiss();
  }

  Future<void> deleteTodo(String id) async {
    SmartDialog.showLoading();
    await db.collection("todo").doc(id).delete();
    SmartDialog.showToast('Berhasil hapus data');
    getTodo();
  }

  Future<void> updateTodo(TodoModel todo) async {
    var updatedTodo = TodoModel(
        id: todo.id,
        title: updatedTitle.text,
        description: updatedDescription.text);
    SmartDialog.showLoading();
    await db.collection("todo").doc(todo.id).set(updatedTodo.toJson());
    SmartDialog.showToast('Berhasil update data');
    getTodo();
  }
}
