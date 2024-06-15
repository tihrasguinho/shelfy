import 'dart:convert';

import 'package:shelf/shelf.dart';

extension RequestExtension on Request {
  Future<Map<String, dynamic>?> bodyJson() async {
    if ((contentLength ?? 0) <= 0) return null;
    if (mimeType != 'application/json') return null;
    return jsonDecode(await readAsString());
  }
}
