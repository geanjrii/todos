// ignore_for_file: avoid_redundant_argument_values

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todos/data_layer/data_layer.dart';
import 'package:todos/feature_layer/feature_layer.dart';

import '../../../helpers/helpers.dart';


class MockTodosOverviewBloc
    extends MockBloc<TodosOverviewEvent, TodosOverviewState>
    implements TodosOverviewBloc {}

extension on CommonFinders {
  Finder optionMenuItem({
    required String title,
    bool enabled = true,
  }) {
    return find.descendant(
      of: find.byWidgetPredicate(
        (w) => w is PopupMenuItem && w.enabled == enabled,
      ),
      matching: find.text(title),
    );
  }
}

extension on WidgetTester {
  Future<void> openPopup() async {
    await tap(find.byType(TodosOverviewOptionsButton));
    await pumpAndSettle();
  }
}

void main() {
  group('TodosOverviewOptionsButton', () {
    late TodosOverviewBloc todosOverviewBloc;

    setUp(() {
      todosOverviewBloc = MockTodosOverviewBloc();
      when(() => todosOverviewBloc.state).thenReturn(
        const TodosOverviewState(
          status: TodosOverviewStatus.success,
          todos: [],
        ),
      );
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: todosOverviewBloc,
        child: const TodosOverviewOptionsButton(),
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(
          () => const TodosOverviewOptionsButton(),
          returnsNormally,
        );
      });
    });

    group('internal PopupMenuButton', () {
      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(
          find.bySpecificType<PopupMenuButton<TodosOverviewOption>>(),
          findsOneWidget,
        );
        expect(
          find.byTooltip("Options"),
          findsOneWidget,
        );
      });

      group('mark all todos button', () {
        testWidgets('is disabled when there are no todos', (tester) async {
          when(() => todosOverviewBloc.state)
              .thenReturn(const TodosOverviewState(todos: []));
          await tester.pumpApp(buildSubject());
          await tester.openPopup();

          expect(
            find.optionMenuItem(
              title: "Mark all as incomplete",
              enabled: false,
            ),
            findsOneWidget,
          );
        });

        testWidgets(
          'renders mark all complete button '
          'when not all todos are marked completed',
          (tester) async {
            when(() => todosOverviewBloc.state).thenReturn(
              TodosOverviewState(
                todos: [
                  Todo(title: 'a', isCompleted: true),
                  Todo(title: 'b', isCompleted: false),
                ],
              ),
            );
            await tester.pumpApp(buildSubject());
            await tester.openPopup();

            expect(
              find.optionMenuItem(
                title: "Mark all as completed",
              ),
              findsOneWidget,
            );
          },
        );

        testWidgets(
          'renders mark all incomplete button '
          'when all todos are marked completed',
          (tester) async {
            when(() => todosOverviewBloc.state).thenReturn(
              TodosOverviewState(
                todos: [
                  Todo(title: 'a', isCompleted: true),
                  Todo(title: 'b', isCompleted: true),
                ],
              ),
            );
            await tester.pumpApp(buildSubject());
            await tester.openPopup();

            expect(
              find.optionMenuItem(
                title: "Mark all as incomplete",
              ),
              findsOneWidget,
            );
          },
        );

        testWidgets(
          'adds TodosOverviewToggleAllRequested '
          'to TodosOverviewBloc '
          'when tapped',
          (tester) async {
            when(() => todosOverviewBloc.state).thenReturn(
              TodosOverviewState(
                todos: [
                  Todo(title: 'a', isCompleted: true),
                  Todo(title: 'b', isCompleted: false),
                ],
              ),
            );
            await tester.pumpApp(buildSubject());
            await tester.openPopup();

            await tester.tap(
              find.optionMenuItem(
                title: "Mark all as completed",
              ),
            );

            verify(
              () => todosOverviewBloc
                  .add(const TodosOverviewToggleAllRequested()),
            ).called(1);
          },
        );
      });

      group('clear completed button', () {
        testWidgets(
          'is disabled when there are no completed todos',
          (tester) async {
            when(() => todosOverviewBloc.state)
                .thenReturn(const TodosOverviewState(todos: []));
            await tester.pumpApp(buildSubject());
            await tester.openPopup();

            expect(
              find.optionMenuItem(
                title: "Clear completed",
                enabled: false,
              ),
              findsOneWidget,
            );
          },
        );

        testWidgets(
          'renders clear completed button '
          'when there are completed todos',
          (tester) async {
            when(() => todosOverviewBloc.state).thenReturn(
              TodosOverviewState(
                todos: [
                  Todo(title: 'a', isCompleted: true),
                  Todo(title: 'b', isCompleted: false),
                ],
              ),
            );
            await tester.pumpApp(buildSubject());
            await tester.openPopup();

            expect(
              find.optionMenuItem(
                title: "Clear completed",
                enabled: true,
              ),
              findsOneWidget,
            );
          },
        );

        testWidgets(
          'adds TodosOverviewClearCompletedRequested '
          'to TodosOverviewBloc '
          'when tapped',
          (tester) async {
            when(() => todosOverviewBloc.state).thenReturn(
              TodosOverviewState(
                todos: [
                  Todo(title: 'a', isCompleted: true),
                  Todo(title: 'b', isCompleted: false),
                ],
              ),
            );
            await tester.pumpApp(buildSubject());
            await tester.openPopup();

            await tester.tap(
              find.optionMenuItem(
                title: "Clear completed",
              ),
            );

            verify(
              () => todosOverviewBloc
                  .add(const TodosOverviewClearCompletedRequested()),
            ).called(1);
          },
        );
      });
    });
  });
}
