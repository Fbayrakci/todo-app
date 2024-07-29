import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todoapp/data/todo.dart';
import 'package:todoapp/todo_bloc/todo_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  addTodo(Todo todo) {
    context.read<TodoBloc>().add(AddTodo(todo));
  }

  removeTodo(Todo todo) {
    context.read<TodoBloc>().add(RemoveTodo(todo));
  }

  alertTodo(int index) {
    context.read<TodoBloc>().add(AlterTodo(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                TextEditingController controller1 = TextEditingController();
                TextEditingController controller2 = TextEditingController();
                return AlertDialog(
                  title: const Text('Add task'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _TaskTitle(controller1: controller1),
                      _SizedBox.sizedBoxSmall,
                      _TaskDescription(controller2: controller2),
                    ],
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: TextButton(
                          onPressed: () {
                            if (controller1.text != "" && controller2.text != "") {
                              addTodo(Todo(title: controller1.text, subtitle: controller2.text));
                              controller1.text = '';
                              controller2.text = '';
                              Navigator.pop(context);
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Error"),
                                      content: const Text('Both fields are required.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  });
                            }
                          },
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Theme.of(context).colorScheme.primary),
                                  borderRadius: BorderRadius.circular(10)),
                              foregroundColor: Theme.of(context).colorScheme.primary),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: const Icon(
                              CupertinoIcons.check_mark,
                              color: Colors.green,
                            ),
                          )),
                    )
                  ],
                );
              });
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          CupertinoIcons.add,
          color: Colors.black,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        title: Text(
          'Todo App',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state.status == TodoStatus.success) {
              return ListView.builder(
                itemCount: state.todos.length,
                itemBuilder: (context, int i) {
                  return Card(
                    key: ValueKey(state.todos[i].title),
                    color: Theme.of(context).colorScheme.primary,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Slidable(
                      key: ValueKey(state.todos[i].title),
                      startActionPane: ActionPane(motion: const ScrollMotion(), children: [
                        SlidableAction(
                          onPressed: (_) {
                            removeTodo(state.todos[i]);
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        )
                      ]),
                      child: ListTile(
                        title: Text(state.todos[i].title),
                        subtitle: Text(state.todos[i].subtitle),
                        trailing: Checkbox(
                          value: state.todos[i].isDone,
                          activeColor: Colors.green,
                          onChanged: (value) {
                            alertTodo(i);
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state.status == TodoStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

class _TaskTitle extends StatelessWidget {
  const _TaskTitle({
    super.key,
    required this.controller1,
  });

  final TextEditingController controller1;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller1,
      cursorColor: Theme.of(context).colorScheme.onPrimary,
      decoration: InputDecoration(
        hintText: 'Task Title...',
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey)),
      ),
    );
  }
}

class _TaskDescription extends StatelessWidget {
  const _TaskDescription({
    super.key,
    required this.controller2,
  });

  final TextEditingController controller2;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller2,
      cursorColor: Theme.of(context).colorScheme.onPrimary,
      decoration: InputDecoration(
        hintText: 'Task Description...',
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey)),
      ),
    );
  }
}

class _SizedBox {
  static const sizedBoxSmall = SizedBox(
    height: 10,
  );
  static const sizedBoxMedium = SizedBox(
    height: 20,
  );
}
