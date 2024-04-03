import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todos/feature_layer/feature_layer.dart';

void main() {
  group('HomeCubit', () {
    group('constructor', () {
      test('works properly', () {
        expect(() => HomeCubit(), returnsNormally);
      });

      test('has correct initial state', () {
        expect(HomeCubit().state, equals(const HomeState()));
      });
    });

    group('setTab', () {
      blocTest<HomeCubit, HomeState>(
        'sets tab to given value',
        build: HomeCubit.new,
        act: (cubit) => cubit.setTab(HomeTab.stats),
        expect: () => [
          const HomeState(tab: HomeTab.stats),
        ],
      );
    });
  });
}
