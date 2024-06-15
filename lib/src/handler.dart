import 'dart:async';

import 'package:shelf/shelf.dart';

typedef Handler = FutureOr<Response> Function(FutureOr<Response> Function(Request request) handler);
