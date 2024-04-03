import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todos/data_layer/data_layer.dart';
import 'package:todos/domain_layer/todos_repository.dart';
import 'package:todos/feature_layer/feature_layer.dart';

class MockTodosRepository extends Mock implements TodosRepository {}

void main() {
  final mockTodo = Todo(
    id: '1',
    title: 'title 1',
    description: 'description 1',
  );

  group('StatsBloc', () {
    late TodosRepository todosRepository;
    late StatsBloc statsBloc;

    setUp(() {
      todosRepository = MockTodosRepository();
      statsBloc = StatsBloc(todosRepository: todosRepository);
      when(todosRepository.getTodos).thenAnswer((_) => const Stream.empty());
    });

    group('constructor', () {
      test('works properly', () {
        expect(() => statsBloc, returnsNormally);
      });

      test('has correct initial state', () {
        expect(statsBloc.state, equals(const StatsState()));
      });
    });

    group('StatsSubscriptionRequested', () {
      blocTest<StatsBloc, StatsState>(
        'starts listening to repository getTodos stream',
        build: () => statsBloc,
        act: (bloc) => bloc.add(const StatsSubscriptionRequested()),
        verify: (bloc) {
          verify(() => todosRepository.getTodos()).called(1);
        },
      );

      blocTest<StatsBloc, StatsState>(
        'emits state with updated status, completed todo and active todo count '
        'when repository getTodos stream emits new todos',
        setUp: () {
          when(
            todosRepository.getTodos,
          ).thenAnswer((_) => Stream.value([mockTodo]));
        },
        build: () => statsBloc,
        act: (bloc) => bloc.add(const StatsSubscriptionRequested()),
        expect: () => [
          const StatsState(status: StatsStatus.loading),
          const StatsState(
            status: StatsStatus.success,
            activeTodos: 1,
          ),
        ],
      );

      blocTest<StatsBloc, StatsState>(
        'emits state with failure status '
        'when repository getTodos stream emits error',
        setUp: () {
          when(
            () => todosRepository.getTodos(),
          ).thenAnswer((_) => Stream.error(Exception('oops')));
        },
        build: () => statsBloc,
        act: (bloc) => bloc.add(const StatsSubscriptionRequested()),
        expect: () => [
          const StatsState(status: StatsStatus.loading),
          const StatsState(status: StatsStatus.failure),
        ],
      );
    });
  });
}
