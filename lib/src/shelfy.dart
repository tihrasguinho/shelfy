import 'dart:async';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelfy/src/method.dart';

import 'interfaces/router.dart';
import 'route.dart';

class Shelfy extends Router {
  late final String _prefix;
  late final List<Route> _routes;
  late final List<Middleware> _middlewares;

  Shelfy({String prefix = ''}) {
    assert(() {
      if (prefix.isNotEmpty && !prefix.startsWith('/')) {
        throw Exception('$runtimeType Exception: prefix must start with /');
      }

      if (prefix.isNotEmpty && prefix.endsWith('/')) {
        throw Exception('$runtimeType Exception: prefix must not end with /');
      }

      return true;
    }());
    _prefix = prefix;
    _routes = [];
    _middlewares = [];
  }

  @override
  List<Route> get routes => _routes;

  @override
  void add(String path, Method method, Function handler) {
    return _routes.add(Route('$_prefix$path', method, handler));
  }

  @override
  void delete(String path, Function handler) {
    return add(path, Delete(), handler);
  }

  @override
  void get(String path, Function handler) {
    return add(path, Get(), handler);
  }

  @override
  void post(String path, Function handler) {
    return add(path, Post(), handler);
  }

  @override
  void put(String path, Function handler) {
    return add(path, Put(), handler);
  }

  void middleware(Middleware middleware) {
    return _middlewares.add(middleware);
  }

  FutureOr<Response> _handler(Request request) async {
    for (final route in _routes) {
      if (_pathsMatch(route, request)) {
        if (_methodsMatch(route, request)) {
          if (_routeHasParams(route)) {
            final params = _extractParams(route, request);
            return Function.apply(route.handler, [request, ...params.values]);
          } else {
            if (route.path == request.requestedUri.path) {
              return route.handler(request);
            }
          }
        }
      }
    }
    return Response.notFound('Not found');
  }

  Future<HttpServer> startServer({Object? address, int? port}) async {
    var handler = Pipeline();
    for (final middleware in _middlewares) {
      handler = handler.addMiddleware(middleware);
    }
    return io.serve(handler.addHandler(_handler), address ?? '0.0.0.0', port ?? 8080);
  }

  bool _pathsMatch(Route route, Request request) {
    if (request.requestedUri.path.split('/').length != route.path.split('/').length) {
      return false;
    }

    for (var i = 0; i < request.requestedUri.path.split('/').length; i++) {
      if (RegExp(r'\{.*\}').hasMatch(route.path.split('/')[i])) {
        continue;
      } else {
        if (request.requestedUri.path.split('/')[i] != route.path.split('/')[i]) {
          return false;
        }
      }
    }

    return true;
  }

  bool _methodsMatch(Route route, Request request) {
    return route.method() == request.method.toUpperCase();
  }

  bool _routeHasParams(Route route) {
    return route.path.contains(RegExp(r'\{.*\}'));
  }

  Map<String, String> _extractParams(Route route, Request request) {
    final params = <String, String>{};
    final parts = route.path.split('/');
    for (int i = 0; i < parts.length; i++) {
      final part = parts[i];
      if (RegExp(r'^{.*}$').hasMatch(part)) {
        params[part.substring(1, part.length - 1)] = request.requestedUri.path.split('/')[i];
      }
    }
    return params;
  }
}
