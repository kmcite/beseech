import 'package:flutter/material.dart';

class NavigationStack extends ChangeNotifier {
  NavigationStack(Widget home) : _stack = [home];

  final List<Widget> _stack;

  List<Widget> get pages => List.unmodifiable(_stack);

  void push(Widget page) {
    _stack.add(page);
    notifyListeners();
  }

  void pop() {
    if (_stack.length > 1) {
      _stack.removeLast();
      notifyListeners();
    }
  }

  void clearAndGo(Widget page) {
    _stack
      ..clear()
      ..add(page);
    notifyListeners();
  }
}

class AppDelegate extends RouterDelegate<Object>
    with PopNavigatorRouterDelegateMixin<Object>, ChangeNotifier {
  AppDelegate(this.stack) : navigatorKey = GlobalKey<NavigatorState>() {
    stack.addListener(notifyListeners);
  }

  final NavigationStack stack;
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    final pages = stack.pages;
    return Navigator(
      key: navigatorKey,
      pages: [
        for (var i = 0; i < pages.length; i++)
          MaterialPage(
            key: ValueKey('${pages[i].runtimeType}-$i'),
            child: pages[i],
          ),
      ],
      onDidRemovePage: (page) {
        if (stack.pages.length > 1) stack.pop();
      },
    );
  }

  @override
  Future<void> setNewRoutePath(Object configuration) async {}

  @override
  void dispose() {
    stack.removeListener(notifyListeners);
    super.dispose();
  }
}

class AppRouter {
  AppRouter({required Widget home}) : stack = NavigationStack(home) {
    delegate = AppDelegate(stack);
  }

  final NavigationStack stack;
  late final AppDelegate delegate;

  /// Delegate-only config (no URL parser/provider) — in-app stack navigation.
  late final RouterConfig<Object> config = RouterConfig(
    routerDelegate: delegate,
  );

  void push(Widget page) => stack.push(page);

  void pop() => stack.pop();

  void clearAndGo(Widget page) => stack.clearAndGo(page);
}

extension BeseechNavigation on BuildContext {
  AppRouter readRouter() {
    final inherited = dependOnInheritedWidgetOfExactType<_RouterScope>();
    return inherited!.router;
  }

  void pushPage(Widget page) => readRouter().push(page);

  void popPage() => readRouter().pop();
}

class _RouterScope extends InheritedWidget {
  const _RouterScope({required this.router, required super.child});

  final AppRouter router;

  @override
  bool updateShouldNotify(_RouterScope oldWidget) =>
      oldWidget.router != router;
}

Widget routerScope({required AppRouter router, required Widget child}) {
  return _RouterScope(router: router, child: child);
}
