import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todoapp/screens/home_page.dart';
import 'package:todoapp/todo_bloc/todo_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
            primary: Colors.amber, onPrimary: Colors.black, onSecondary: Colors.white),
        useMaterial3: true,
      ),
      home: BlocProvider<TodoBloc>(
        create: (context) => TodoBloc()..add(TodoStarted()),
        child: const HomePage(),
      ),
    );
  }
}
