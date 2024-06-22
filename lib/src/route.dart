import 'method.dart';

class Route {
  final String path;
  final Method method;
  final Function handler;

  Route._(this.path, this.method, this.handler) {
    assert(() {
      if (path == '/') return true;

      if (!path.startsWith('/')) {
        throw Exception('$runtimeType Exception: path must start with /');
      }

      if (path.endsWith('/')) {
        throw Exception('$runtimeType Exception: path must not end with /');
      }

      return true;
    }());
  }

  factory Route(String path, Method method, Function handler) {
    final normalizedPath = switch (path != '/' && path.endsWith('/')) {
      true => path.substring(0, path.length - 1),
      false => path,
    };
    return Route._(normalizedPath, method, handler);
  }

  Route copyWith({String? path, Method? method, Function? handler}) {
    return Route._(
      path ?? this.path,
      method ?? this.method,
      handler ?? this.handler,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Route && other.path == path && other.method == method;
  }

  @override
  int get hashCode => path.hashCode ^ method.hashCode ^ handler.hashCode;
}
