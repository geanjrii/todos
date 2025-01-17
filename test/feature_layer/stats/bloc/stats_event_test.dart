// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:todos/feature_layer/feature_layer.dart';

void main() {
  group('StatsEvent', () {
    group('StatsSubscriptionRequested', () {
      test('supports value equality', () {
        expect(
          StatsSubscriptionRequested(),
          equals(StatsSubscriptionRequested()),
        );
      });

      test('props are correct', () {
        expect(
          StatsSubscriptionRequested().props,
          equals(<Object?>[]),
        );
      });
    });
  });
}
