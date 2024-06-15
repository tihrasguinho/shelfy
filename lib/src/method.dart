sealed class Method {
  final String verb;

  const Method(this.verb);

  String call() => verb;

  List<Method> get methods => [
        const Get(),
        const Post(),
        const Put(),
        const Delete(),
        const Patch(),
        const Head(),
        const Options(),
        const Connect(),
        const Trace(),
      ];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Method && other.verb == verb;
  }

  @override
  int get hashCode => verb.hashCode;
}

final class Get extends Method {
  const Get() : super('GET');
}

final class Post extends Method {
  const Post() : super('POST');
}

final class Put extends Method {
  const Put() : super('PUT');
}

final class Delete extends Method {
  const Delete() : super('DELETE');
}

final class Patch extends Method {
  const Patch() : super('PATCH');
}

final class Head extends Method {
  const Head() : super('HEAD');
}

final class Options extends Method {
  const Options() : super('OPTIONS');
}

final class Connect extends Method {
  const Connect() : super('CONNECT');
}

final class Trace extends Method {
  const Trace() : super('TRACE');
}
