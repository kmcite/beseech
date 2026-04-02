import 'dart:developer';

import 'package:fountain/fountain.dart';

class Logging<TState> extends Middleware<TState> {
  const Logging({
    this.logState = true,
  });

  static int _uniqueId = 1;

  final bool logState;

  @override
  Stream<TState> call(
    Context<TState> context,
    Event event,
    NextMiddleware<TState> next,
  ) async* {
    final executionId = _uniqueId++;
    final stopwatch = Stopwatch()..start();
    log('[$event]($executionId) Starting');
    await for (final state in next(context, event)) {
      yield state;
      if (logState) {
        log('[${event.runtimeType}]($executionId) State updated : $state');
      }
    }
    log('[$event]($executionId) Finished after ${stopwatch.elapsed}');
  }
}
