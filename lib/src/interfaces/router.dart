import '../method.dart';

abstract class Router {
  void add(String path, Method method, Function handler);

  void get(String path, Function handler);

  void put(String path, Function handler);

  void post(String path, Function handler);

  void delete(String path, Function handler);
}
