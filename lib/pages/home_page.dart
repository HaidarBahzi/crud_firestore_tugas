import 'package:crot_firestore/todo_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TodoController todoController = Get.put(TodoController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("CRUD FIREBASE"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      SmartDialog.show(builder: (_) {
                        return Container(
                            height: 180,
                            width: 180,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: todoController.title,
                                  decoration: InputDecoration(
                                      hintText: 'Masukkan Nama Barang',
                                      hintStyle: TextStyle(color: Colors.grey)),
                                ),
                                TextFormField(
                                  controller: todoController.description,
                                  decoration: InputDecoration(
                                      hintText: 'Masukkan Deskripsi Barang',
                                      hintStyle: TextStyle(color: Colors.grey)),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      SmartDialog.dismiss();
                                      todoController.addTodo();
                                    },
                                    child: Text('Submit'))
                              ],
                            ));
                      });
                    },
                    child: Text('Add Data')),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              children: [Text("LIST BARANG")],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Obx(
                () => ListView(
                  children: todoController.todoList
                      .map((e) => Padding(
                            padding: const EdgeInsets.all(8),
                            child: ListTile(
                              tileColor: Colors.white,
                              onTap: () {},
                              title: Text(e.title!),
                              subtitle: Text(e.description!),
                              trailing: SizedBox(
                                  width: 100,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              todoController.deleteTodo(e.id!);
                                            },
                                            child: Icon(Icons.delete)),
                                        SizedBox(width: 10),
                                        InkWell(
                                          onTap: () {
                                            todoController.updatedTitle.text =
                                                e.title!;

                                            todoController.updatedDescription
                                                .text = e.description!;

                                            SmartDialog.show(builder: (_) {
                                              return Container(
                                                height: 180,
                                                child: Column(
                                                  children: [
                                                    TextFormField(
                                                      controller: todoController
                                                          .updatedTitle,
                                                    ),
                                                    TextFormField(
                                                      controller: todoController
                                                          .updatedDescription,
                                                    ),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          SmartDialog.dismiss();
                                                          todoController
                                                              .updateTodo(e);
                                                        },
                                                        child: Text('Edit'))
                                                  ],
                                                ),
                                              );
                                            });
                                          },
                                          child: Icon(Icons.edit),
                                        )
                                      ])),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
