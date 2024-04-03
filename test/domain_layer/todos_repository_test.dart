// ignore_for_file: prefer_const_constructors
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:todos/data_layer/todos_api/model/todo.dart';
import 'package:todos/data_layer/todos_api/todos_api.dart';
import 'package:todos/domain_layer/todos_repository.dart';

class MockTodosApi extends Mock implements TodosApi {}

class FakeTodo extends Fake implements Todo {}

void main() {
  group('TodosRepository', () {
    late TodosApi mockApi;

    final mockTodos = [
      Todo(
        id: '1',
        title: 'title 1',
        description: 'description 1',
      ),
      Todo(
        id: '2',
        title: 'title 2',
        description: 'description 2',
      ),
      Todo(
        id: '3',
        title: 'title 3',
        description: 'description 3',
        isCompleted: true,
      ),
    ];

    setUpAll(() {
      registerFallbackValue(FakeTodo());
    });

    setUp(() {
      mockApi = MockTodosApi();
      when(() => mockApi.getTodos()).thenAnswer((_) => Stream.value(mockTodos));
      when(() => mockApi.saveTodo(any())).thenAnswer((_) async {});
      when(() => mockApi.deleteTodo(any())).thenAnswer((_) async {});
      when(
        () => mockApi.clearCompleted(),
      ).thenAnswer(
          (_) async => mockTodos.where((todo) => todo.isCompleted).length);
      when(
        () => mockApi.completeAll(isCompleted: any(named: 'isCompleted')),
      ).thenAnswer((_) async => 0);
    });

    TodosRepository createSubject() => TodosRepository(todosApi: mockApi);

    group('constructor', () {
      test('works properly', () {
        expect(createSubject, returnsNormally);
      });
    });

    group('getTodos', () {
      test('makes correct api request', () {
        final subject = createSubject();

        expect(
          subject.getTodos(),
          isNot(throwsA(anything)),
        );

        verify(() => mockApi.getTodos()).called(1);
      });

      test('returns stream of current list todos', () {
        expect(createSubject().getTodos(), emits(mockTodos));
      });
    });

    group('saveTodo', () {
      test('makes correct api request', () {
        final newTodo = Todo(
          id: '4',
          title: 'title 4',
          description: 'description 4',
        );

        final subject = createSubject();

        expect(subject.saveTodo(newTodo), completes);

        verify(() => mockApi.saveTodo(newTodo)).called(1);
      });
    });

    group('deleteTodo', () {
      test('makes correct api request', () {
        final subject = createSubject();

        expect(subject.deleteTodo(mockTodos[0].id), completes);

        verify(() => mockApi.deleteTodo(mockTodos[0].id)).called(1);
      });
    });

    group('clearCompleted', () {
      test('makes correct request', () {
        final subject = createSubject();

        expect(subject.clearCompleted(), completes);

        verify(() => mockApi.clearCompleted()).called(1);
      });
    });

    group('completeAll', () {
      test('makes correct request', () {
        final subject = createSubject();

        expect(subject.completeAll(isCompleted: true), completes);

        verify(() => mockApi.completeAll(isCompleted: true)).called(1);
      });
    });
  });
}
