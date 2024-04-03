import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos/app/theme.dart';
import 'package:todos/data_layer/data_layer.dart';
import 'package:todos/domain_layer/todos_repository.dart';
import 'package:todos/feature_layer/feature_layer.dart';

class App extends StatelessWidget {
  const App({super.key, required this.plugin});

  final SharedPreferences plugin;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => TodosRepository(
        todosApi: LocalStorageTodosApi(plugin: plugin),
      ),
      child: MaterialApp(
        theme: FlutterTodosTheme.light,
        darkTheme: FlutterTodosTheme.dark,
        home: const HomePage(),
      ),
    );
  }
}
