import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todos/domain_layer/todos_repository.dart';

class MockTodosRepository extends Mock implements TodosRepository {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    TodosRepository? todosRepository,
  }) {
    return pumpWidget(
      RepositoryProvider.value(
        value: todosRepository ?? MockTodosRepository(),
        child: MaterialApp(
   
          home: Scaffold(body: widget),
        ),
      ),
    );
  }

  Future<void> pumpRoute(
    Route<dynamic> route, {
    TodosRepository? todosRepository,
  }) {
    return pumpApp(
      Navigator(onGenerateRoute: (_) => route),
      todosRepository: todosRepository,
    );
  }
}
