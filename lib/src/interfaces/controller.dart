import 'package:shelfy/src/method.dart';

import '../route.dart';
import 'router.dart';

abstract class Controller extends Router {
  late final List<Route> _routes;
  late final String prefix;

  Controller(this.prefix) {
    assert(() {
      if (prefix.isEmpty) {
        throw Exception('$runtimeType Exception: prefix cannot be empty');
      }

      if (!prefix.startsWith('/')) {
        throw Exception('$runtimeType Exception: prefix must start with /');
      }

      if (prefix.endsWith('/')) {
        throw Exception('$runtimeType Exception: prefix must not end with /');
      }

      return true;
    }());
    _routes = [];
  }

  @override
  List<Route> get routes => _routes;

  @override
  void add(String path, Method method, Function handler) {
    return _routes.add(Route('$prefix$path', method, handler));
  }

  @override
  void get(String path, Function handler) {
    return add(path, Get(), handler);
  }

  @override
  void put(String path, Function handler) {
    return add(path, Put(), handler);
  }

  @override
  void post(String path, Function handler) {
    return add(path, Post(), handler);
  }

  @override
  void delete(String path, Function handler) {
    return add(path, Delete(), handler);
  }
}
