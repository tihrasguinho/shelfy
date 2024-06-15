import 'dart:convert';

import 'package:shelf/shelf.dart' as shelf;

class Response extends shelf.Response {
  Response(
    super.statusCode, {
    super.body,
    super.headers,
    super.context,
    super.encoding,
  });

  factory Response.json(
    int statusCode, {
    Map<String, dynamic>? body,
    Map<String, Object>? headers,
    Map<String, Object>? context,
    Encoding? encoding,
  }) {
    return Response(
      statusCode,
      body: switch (body != null) {
        true => jsonEncode(body),
        false => null,
      },
      headers: {
        'Content-Type': 'application/json',
        ...?headers,
      },
      context: context,
      encoding: encoding ?? utf8,
    );
  }

  factory Response.stream(
    int statusCode, {
    Stream<List<int>>? body,
    Map<String, Object>? headers,
    Map<String, Object>? context,
    Encoding? encoding,
  }) {
    return Response(
      statusCode,
      body: body,
      headers: {
        'Content-Type': 'application/octet-stream',
        ...?headers,
      },
      context: context,
      encoding: encoding,
    );
  }

  factory Response.bytes(
    int statusCode, {
    List<int>? body,
    Map<String, Object>? headers,
    Map<String, Object>? context,
    Encoding? encoding,
  }) {
    return Response(
      statusCode,
      body: body,
      headers: {
        'Content-Type': 'application/octet-stream',
        ...?headers,
      },
      context: context,
      encoding: encoding,
    );
  }
}
