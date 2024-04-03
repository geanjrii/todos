import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos/app/app.dart';
import 'package:todos/app/theme.dart';
import 'package:todos/feature_layer/feature_layer.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
  });

  group('App', () {
    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(App(plugin: sharedPreferences));
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('renders MaterialApp with correct themes', (tester) async {
      await tester.pumpWidget(App(plugin: sharedPreferences));

      expect(find.byType(MaterialApp), findsOneWidget);

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme, equals(FlutterTodosTheme.light));
      expect(materialApp.darkTheme, equals(FlutterTodosTheme.dark));
    });

    testWidgets('renders HomePage', (tester) async {
      await tester.pumpWidget(App(plugin: sharedPreferences));
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
