import '../method.dart';
import '../route.dart';

abstract class Router {
  List<Route> get routes;

  void add(String path, Method method, Function handler);

  void get(String path, Function handler);

  void put(String path, Function handler);

  void post(String path, Function handler);

  void delete(String path, Function handler);

  void bind(Router router) {
    for (final route in router.routes) {
      add(route.path, route.method, route.handler);
    }
  }
}
