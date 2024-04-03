import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos/app/app.dart';
import 'package:todos/app/app_bloc_observer.dart';

void bootstrap() async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  final plugin = await SharedPreferences.getInstance();

  runZonedGuarded(
    () => runApp(App(plugin: plugin)),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
