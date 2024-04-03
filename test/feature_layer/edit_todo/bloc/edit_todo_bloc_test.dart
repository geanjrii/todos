import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todos/data_layer/data_layer.dart';
import 'package:todos/domain_layer/todos_repository.dart';
import 'package:todos/feature_layer/feature_layer.dart';

class MockTodosRepository extends Mock implements TodosRepository {}

class FakeTodo extends Fake implements Todo {}

void main() {
  group('EditTodoBloc', () {
    late TodosRepository todosRepository;
    late EditTodoBloc editTodoBloc;

    setUpAll(() {
      registerFallbackValue(FakeTodo());
    });

    setUp(() {
      todosRepository = MockTodosRepository();
      editTodoBloc = EditTodoBloc(
        todosRepository: todosRepository,
        initialTodo: null,
      );
    });

    group('constructor', () {
      test('works properly', () {
        expect(() => editTodoBloc, returnsNormally);
      });

      test('has correct initial state', () {
        expect(editTodoBloc.state, equals(const EditTodoState()));
      });
    });

    group('EditTodoTitleChanged', () {
      blocTest<EditTodoBloc, EditTodoState>(
        'emits new state with updated title',
        build: () => editTodoBloc,
        act: (bloc) => bloc.add(const EditTodoTitleChanged('newtitle')),
        expect: () => const [
          EditTodoState(title: 'newtitle'),
        ],
      );
    });

    group('EditTodoDescriptionChanged', () {
      blocTest<EditTodoBloc, EditTodoState>(
        'emits new state with updated description',
        build: () => editTodoBloc,
        act: (bloc) =>
            bloc.add(const EditTodoDescriptionChanged('newdescription')),
        expect: () => const [
          EditTodoState(description: 'newdescription'),
        ],
      );
    });

    group('EditTodoSubmitted', () {
      blocTest<EditTodoBloc, EditTodoState>(
        'attempts to save new todo to repository '
        'if no initial todo was provided',
        setUp: () {
          when(() => todosRepository.saveTodo(any())).thenAnswer((_) async {});
        },
        build: () => editTodoBloc,
        seed: () => const EditTodoState(
          title: 'title',
          description: 'description',
        ),
        act: (bloc) => bloc.add(const EditTodoSubmitted()),
        expect: () => const [
          EditTodoState(
            status: EditTodoStatus.loading,
            title: 'title',
            description: 'description',
          ),
          EditTodoState(
            status: EditTodoStatus.success,
            title: 'title',
            description: 'description',
          ),
        ],
        verify: (bloc) {
          verify(
            () => todosRepository.saveTodo(
              any(
                that: isA<Todo>()
                    .having((t) => t.title, 'title', equals('title'))
                    .having(
                      (t) => t.description,
                      'description',
                      equals('description'),
                    ),
              ),
            ),
          ).called(1);
        },
      );

      blocTest<EditTodoBloc, EditTodoState>(
        'attempts to save updated todo to repository '
        'if an initial todo was provided',
        setUp: () {
          when(() => todosRepository.saveTodo(any())).thenAnswer((_) async {});
        },
        build: () => editTodoBloc,
        seed: () => EditTodoState(
          initialTodo: Todo(
            id: 'initial-id',
            title: 'initial-title',
          ),
          title: 'title',
          description: 'description',
        ),
        act: (bloc) => bloc.add(const EditTodoSubmitted()),
        expect: () => [
          EditTodoState(
            status: EditTodoStatus.loading,
            initialTodo: Todo(
              id: 'initial-id',
              title: 'initial-title',
            ),
            title: 'title',
            description: 'description',
          ),
          EditTodoState(
            status: EditTodoStatus.success,
            initialTodo: Todo(
              id: 'initial-id',
              title: 'initial-title',
            ),
            title: 'title',
            description: 'description',
          ),
        ],
        verify: (bloc) {
          verify(
            () => todosRepository.saveTodo(
              any(
                that: isA<Todo>()
                    .having((t) => t.id, 'id', equals('initial-id'))
                    .having((t) => t.title, 'title', equals('title'))
                    .having(
                      (t) => t.description,
                      'description',
                      equals('description'),
                    ),
              ),
            ),
          );
        },
      );

      blocTest<EditTodoBloc, EditTodoState>(
        'emits new state with error if save to repository fails',
        setUp: () {
          when(() => todosRepository.saveTodo(any()))
              .thenThrow(Exception('oops'));
        },
        build: () => editTodoBloc,
        seed: () => const EditTodoState(
          title: 'title',
          description: 'description',
        ),
        act: (bloc) => bloc.add(const EditTodoSubmitted()),
        expect: () => const [
          EditTodoState(
            status: EditTodoStatus.loading,
            title: 'title',
            description: 'description',
          ),
          EditTodoState(
            status: EditTodoStatus.failure,
            title: 'title',
            description: 'description',
          ),
        ],
      );
    });
  });
}
