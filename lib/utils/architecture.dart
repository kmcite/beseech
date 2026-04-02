import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

bool logging = true;

/* ======================
   Repository (SSOT)
   ====================== */

abstract class Repository extends ChangeNotifier {
  late final debugLabel = runtimeType.toString();

  @protected
  @mustCallSuper
  void notify([String? reason]) {
    if (logging && reason != null) log('notify: $reason', name: debugLabel);
    notifyListeners();
  }

  @override
  @mustCallSuper
  void dispose() {
    if (logging) log('dispose()', name: debugLabel);
    super.dispose();
  }
}

/* ======================
   Registry (DI)
   ====================== */

final repositories = <Type, Repository>{};
final services = <Type, Object>{};

void put<T extends Repository>(T instance) {
  repositories[T] = instance;
  if (logging) log('put()', name: '$T');
}

T repo<T extends Repository>() {
  final r = repositories[T] as T?;
  if (r == null) throw Exception('$T not found');
  return r;
}

T find<T extends Object>([T? instance]) {
  if (instance != null) {
    services[T] = instance;
    if (logging) log('find() register', name: '$T');
    return instance;
  } else {
    final found = services[T];
    if (found == null) throw Exception('$T not found');
    if (logging) log('find() fetch', name: '$T');
    return found as T;
  }
}

void disposeAll() {
  for (final r in repositories.values) {
    r.dispose();
  }
  repositories.clear();
  services.clear();
  if (logging) log('*** disposeAll ***');
}

/* ======================
   Bloc and ScopedBloc<P>
   ====================== */

abstract class Bloc extends ChangeNotifier {
  final Map<Repository, VoidCallback> _repoListeners = {};
  final Map<ValueListenable<Object?>, VoidCallback> _listenables = {};

  /// Subscribe to a singleton repository and re-render when it changes.
  T watch<T extends Repository>() {
    final r = repo<T>();
    if (!_repoListeners.containsKey(r)) {
      final cb = () => notifyListeners();
      r.addListener(cb);
      _repoListeners[r] = cb;
    }
    return r;
  }

  /// Subscribe to an external ValueListenable (optional ergonomics).
  T watchListenable<T>(ValueListenable<T> listenable) {
    final l = listenable as ValueListenable<Object?>;
    if (!_listenables.containsKey(l)) {
      final cb = () => notifyListeners();
      l.addListener(cb);
      _listenables[l] = cb;
    }
    return listenable.value;
  }

  @mustCallSuper
  void initState() {
    if (logging) log('initState()', name: runtimeType.toString());
  }

  @override
  @mustCallSuper
  void dispose() {
    _repoListeners.forEach((r, cb) => r.removeListener(cb));
    _repoListeners.clear();

    _listenables.forEach((l, cb) => l.removeListener(cb));
    _listenables.clear();

    if (logging) log('dispose()', name: runtimeType.toString());
    super.dispose();
  }
}

/// Parameter-scoped controller.
/// Holds the param, handles changes, and lets subclasses react to updates.
abstract class ScopedBloc<P> extends Bloc {
  P _param;
  ScopedBloc(P param) : _param = param;

  P get param => _param;

  /// Called after creation with the initial param.
  @override
  @mustCallSuper
  void initState() {
    super.initState();
    onParamReady(_param);
  }

  /// Update the param; subclasses can override onParamChanged to react.
  void setParam(P next) {
    if (_equals(_param, next)) return;
    final prev = _param;
    _param = next;
    onParamChanged(next, prev);
    notifyListeners();
  }

  /// Hook: initial param is ready (first build).
  @protected
  void onParamReady(P param) {}

  /// Hook: param changed.
  @protected
  void onParamChanged(P next, P prev) {}

  bool _equals(P a, P b) => a == b;
}

/* ======================
   Feature widgets (low boilerplate)
   ====================== */

/// Feature without params.
class Feature<B extends Bloc> extends StatefulWidget {
  final B Function() create;
  final Widget Function(BuildContext context, B bloc) builder;

  const Feature({
    super.key,
    required this.create,
    required this.builder,
  });

  @override
  State<Feature<B>> createState() => _FeatureState<B>();
}

class _FeatureState<B extends Bloc> extends State<Feature<B>> {
  late B bloc;
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    bloc = widget.create();
    _listener = () {
      if (mounted) setState(() {});
    };
    bloc.addListener(_listener);
    bloc.initState();
  }

  @override
  void dispose() {
    bloc.removeListener(_listener);
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, bloc);
}

// /// Feature with a parameter (family-like scoping via ScopedBloc<P>).
// class FeatureScoped<B extends ScopedBloc<P>, P> extends StatefulWidget {
//   final P param;
//   final B Function() create;
//   final Widget Function(BuildContext context, B bloc, P param) builder;

//   /// If true, reuse the bloc and call setParam on param change.
//   /// If false, recreate the bloc when param changes.
//   final bool reuseOnParamChange;

//   const FeatureScoped({
//     super.key,
//     required this.param,
//     required this.create,
//     required this.builder,
//     this.reuseOnParamChange = true,
//   });

//   @override
//   State<FeatureScoped<B, P>> createState() => _FeatureScopedState<B, P>();
// }

// class _FeatureScopedState<B extends ScopedBloc<P>, P>
//     extends State<FeatureScoped<B, P>> {
//   late B bloc;
//   late VoidCallback _listener;

//   @override
//   void initState() {
//     super.initState();
//     bloc = widget.create();
//     _listener = () {
//       if (mounted) setState(() {});
//     };
//     bloc.addListener(_listener);
//     bloc.initState();
//   }

//   @override
//   void didUpdateWidget(covariant FeatureScoped<B, P> oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.param != widget.param) {
//       if (widget.reuseOnParamChange) {
//         bloc.setParam(widget.param);
//       } else {
//         bloc.removeListener(_listener);
//         bloc.dispose();
//         bloc = widget.create();
//         bloc.addListener(_listener);
//         bloc.initState();
//       }
//     }
//   }

//   @override
//   void dispose() {
//     bloc.removeListener(_listener);
//     bloc.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) =>
//       widget.builder(context, bloc, widget.param);
// }

abstract class UI<B extends Bloc> extends StatefulWidget {
  const UI({super.key});
  B create();
  Widget build(BuildContext context, B bloc);

  @override
  State<UI<B>> createState() => _UIState<B>();
}

class _UIState<B extends Bloc> extends State<UI<B>> {
  late final B bloc;
  late final VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    bloc = widget.create();
    _listener = () {
      if (mounted) setState(() {});
    };
    bloc.addListener(_listener);
    bloc.initState();
  }

  @override
  void dispose() {
    bloc.removeListener(_listener);
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.build(context, bloc);
}

void AppRunner({
  required Future<void> Function() initialize,
  required UI<Bloc> app,
}) async {
  await initialize();
  runApp(app);
}
